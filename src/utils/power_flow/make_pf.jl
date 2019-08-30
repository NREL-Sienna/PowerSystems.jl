#TODO: Apply actions according to load type
function _get_load_data(sys::System, b::Bus)
    activepower = 0.0
    reactivepower = 0.0
    for l in get_components(ElectricLoad, sys)
        if !isa(l,FixedAdmittance) && (l.bus == b)
            activepower += get_activepower(l)
            reactivepower += get_reactivepower(l)
        end
    end
    return activepower, reactivepower
end

"""
    make_pf(sys)

Create the objects needed to solve an powerflow case using NLsolve.jl solvers. Returns
an anonymous function with the powerflow equations, initial conditions and a dict to link the
solutions to the original system. Only supports systems with a single generator per bus and
currently doesn't support distributed slack buses and doesn't enforce reactive power limits.

## Example
```julia
pf!, x0 = make_pf(sys)
res = NLsolve.nlsolve(pf!, x0)
```

# Arguments
    * `sys`::System : a PowerSystems.jl system

"""
function make_pf(system)
    buses = sort(collect(get_components(Bus, system)), by = x -> get_number(x))
    N_BUS = length(buses)

    # assumes the ordering in YBus is the same as in the buses.
    Yb = Ybus(system)
    x0 = zeros(N_BUS * 2)

    # Use vectors to cache data for closure
    # These should be read only
    P_GEN_BUS  = fill(0.0, N_BUS)
    Q_GEN_BUS  = fill(0.0, N_BUS)
    P_LOAD_BUS = fill(0.0, N_BUS)
    Q_LOAD_BUS = fill(0.0, N_BUS)

    BUSES = (b for b in enumerate(buses))

    state_variable_count = 1

    for (ix, b) in BUSES
        bus_number = get_number(b)::Int
        bus_angle = get_angle(b)::Float64
        bus_voltage = get_voltage(b)::Float64
        generator = nothing
        for gen in get_components(Generator, system)
            if gen.bus == b
                !isnothing(generator) && throw(DataFormatError("There is more than one generator connected to Bus $b.name"))
                generator = gen
            end
        end
        P_GEN_BUS[ix] = isnothing(generator) ? 0.0 : get_activepower(generator)
        Q_GEN_BUS[ix] = isnothing(generator) ? 0.0 : get_reactivepower(generator)
        P_LOAD_BUS[ix], Q_LOAD_BUS[ix] = _get_load_data(system, b)

        if b.bustype == REF::BusType
            x0[state_variable_count]     = P_GEN_BUS[ix]
            x0[state_variable_count + 1] = Q_GEN_BUS[ix]
            state_variable_count += 2
        elseif b.bustype == PV::BusType
            x0[state_variable_count]     = Q_GEN_BUS[ix]
            x0[state_variable_count + 1] = bus_angle
            state_variable_count += 2
        elseif b.bustype == PQ::BusType
            x0[state_variable_count]     = bus_voltage
            x0[state_variable_count + 1] = bus_angle
            state_variable_count += 2
        end
    end

    @assert state_variable_count - 1 == N_BUS * 2

    function pf!(F, X)

        P_net = Vector{Float64}(undef, N_BUS)
        Q_net = Vector{Float64}(undef, N_BUS)
        Vm = Vector{Float64}(undef, N_BUS)
        θ = Vector{Float64}(undef, N_BUS)

        for (ix, b) in BUSES
            bus_voltage = get_voltage(b)
            bus_angle = get_angle(b)
            if b.bustype == REF::BusType
                # When bustype == REFERENCE Bus, state variables are Active and Reactive Power Generated
                P_net[ix] = X[2 * ix - 1] - P_LOAD_BUS[ix]
                Q_net[ix] = X[2 * ix] - Q_LOAD_BUS[ix]
                Vm[ix]    = bus_voltage
                θ[ix]     = bus_angle
            elseif b.bustype == PV::BusType
                # When bustype == PV Bus, state variables are Reactive Power Generated and Voltage Angle
                P_net[ix] = P_GEN_BUS[ix] - P_LOAD_BUS[ix]
                Q_net[ix] = X[2 * ix - 1] - Q_LOAD_BUS[ix]
                Vm[ix]    = bus_voltage
                θ[ix]     = X[2 * ix]
            elseif b.bustype == PQ::BusType
                # When bustype == PQ Bus, state variables are Voltage Magnitude and Voltage Angle
                P_net[ix] = P_GEN_BUS[ix] - P_LOAD_BUS[ix]
                Q_net[ix] = Q_GEN_BUS[ix] - Q_LOAD_BUS[ix]
                Vm[ix]    = X[2 * ix - 1]
                θ[ix]     = X[2 * ix]
            end
        end

        # F is active and reactive power balance equations at all buses
        state_count = 1
        for (ix_f, bf) in BUSES
            S = -P_net[ix_f] + -Q_net[ix_f]im
            V_f = Vm[ix_f] * ( cos(θ[ix_f]) + sin(θ[ix_f])im )
            for (ix_t, bt) in BUSES
                iszero(Yb[ix_f, ix_t]::ComplexF64) && continue
                V_t = Vm[ix_t] * ( cos(θ[ix_t]) + sin(θ[ix_t])im )
                S += V_f * conj(V_t) * conj(Yb[ix_f, ix_t]::ComplexF64)
            end
            F[state_count] = real(S)
            F[state_count + 1] = imag(S)
            state_count += 2
        end

        return F

    end

    return ( pf!, x0 )
end
