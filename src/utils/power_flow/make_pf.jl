macro _fn(expr::Expr)
    @assert expr.head in (:function, :->)
    name = gensym()
    args = expr.args[1]
    args = typeof(args) == Symbol ? [args] : args.args
    body = expr.args[2]
    @eval $name($(args...)) = $body
    name
end

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
    make_pf_fast(sys)

Create the objects needed to solve an powerflow case using NLsolve.jl solvers. Returns
an anonymous function with the powerflow equations, initial conditions and a dict to link the
solutions to the original system. Only supports systems with a single generator per bus and
currently doesn't support distributes slack buses and doesn't enforce reactive power limits.

## Example
```julia
pf!, x0, res_ref = make_pf_fast(sys)
res = NLsolve.nlsolve(pf!, x0)
```

# Arguments
    * `sys`::System : a PowerSystems.jl system

"""
function make_pf_fast(system)
    buses = sort(collect(get_components(Bus, system)), by = x -> get_number(x))
    bus_count = length(buses)
    #assumes the ordering in YBus is the same as in the buses.
    Yb = Ybus(system)

    #internally allocate matrices
    internal = quote
        V = Vector{ComplexF64}(undef, $bus_count)
        Vc = Vector{ComplexF64}(undef, $bus_count)
        P_bal = Vector{Float64}(undef, $bus_count)
        Q_bal = Vector{Float64}(undef, $bus_count)
    end

    var_count = 1
    res_dict = Dict{String, Vector{Tuple{Symbol, Int}}}()
    x0 = Array{Float64}(undef, bus_count*2)

    for (ix, b) in enumerate(buses)
        #Gets relevant data about the generators
        bus_number = get_number(b)
        bus_angle = get_angle(b)
        bus_voltage = get_voltage(b)
        generator = nothing
        for gen in get_components(Generator, system)
            if gen.bus == b
                !isnothing(generator) && throw(DataFormatError("There is more than one generator connected to Bus $b.name"))
                generator = gen
            end
        end
        if isnothing(generator)
            total_gen = (0.0, 0.0)
        else
            total_gen = (get_activepower(generator),get_reactivepower(generator))
        end
        # get load data
        total_load = _get_load_data(system, b)
        #Make symbols for the variables names w.r.t bus names
        Vm_name = Symbol("Vm_", bus_number)
        ang_name = Symbol("θ_", bus_number)
        if b.bustype == REF::BusType
            P_name = Symbol("P_", bus_number)
            Q_name = Symbol("Q_", bus_number)
            net_p_load = :(-$(total_load[1]))
            net_q_load = :(-$(total_load[2]))
            push!(internal.args, :($Vm_name = $(bus_voltage)))
            push!(internal.args, :($ang_name = $(bus_angle)))
            var_ref1 = (:activepower, var_count)
            x0[var_count] = total_gen[1]
            push!(internal.args, :($P_name = x[$(var_count)])); var_count += 1
            var_ref2 = (:reactivepower, var_count)
            x0[var_count] = total_gen[2]
            push!(internal.args, :($Q_name = x[$(var_count)])); var_count += 1
            push!(internal.args, :(P_bal[$ix] = $P_name + $net_p_load))
            push!(internal.args, :(Q_bal[$ix] = $Q_name + $net_q_load))
            push!(internal.args, :(V[$ix] = $Vm_name*(cos($ang_name)+sin($ang_name)*1im)))
            push!(internal.args, :(Vc[$ix] = conj(V[$ix])))
            # Reference for the results Dict
            res_dict[b.name] = [var_ref1, var_ref2]
        elseif b.bustype == PV::BusType
            Q_name = Symbol("Q_", bus_number)
            net_p_load = :($(total_gen[1]) - $(total_load[1]))
            net_q_load = :(-$(total_load[2]))
            push!(internal.args, :($Vm_name = $(bus_voltage)))
            var_ref1 = (:reactivepower, var_count)
            x0[var_count] = total_gen[2]
            push!(internal.args, :($Q_name = x[$(var_count)])); var_count += 1
            var_ref2 = (:angle, var_count)
            x0[var_count] = bus_angle
            push!(internal.args, :($ang_name = x[$(var_count)])); var_count += 1
            push!(internal.args, :(P_bal[$ix] = $net_p_load))
            push!(internal.args, :(Q_bal[$ix] = $Q_name + $net_q_load))
            push!(internal.args, :(V[$ix] = $Vm_name*(cos($ang_name)+sin($ang_name)*1im)))
            push!(internal.args, :(Vc[$ix] = conj(V[$ix])))
            # Reference for the results Dict
            res_dict[b.name] = [var_ref1, var_ref2]
        elseif b.bustype == PQ::BusType
            net_p_load = :($(total_gen[1]) - $(total_load[1]))
            net_q_load = :($(total_gen[2]) - $(total_load[2]))
            var_ref1 = (:voltage, var_count)
            x0[var_count] = bus_voltage
            push!(internal.args, :($Vm_name = x[$(var_count)])); var_count += 1
            var_ref2 = (:angle, var_count)
            x0[var_count] = bus_angle
            push!(internal.args, :($ang_name = x[$(var_count)])); var_count += 1
            push!(internal.args, :(P_bal[$ix] = $net_p_load))
            push!(internal.args, :(Q_bal[$ix] = $net_q_load))
            push!(internal.args, :(V[$ix] = $Vm_name*(cos($ang_name)+sin($ang_name)*1im)))
            push!(internal.args, :(Vc[$ix] = conj(V[$ix])))
            # Reference for the results Dict
            res_dict[b.name] = [var_ref1, var_ref2]
        end
    end

    balance_eqs = quote  end

    res_count = 1
    for (ix_f, bf) in enumerate(buses)
        p_exp = :(-1*P_bal[$ix_f])
        q_exp = :(-1*Q_bal[$ix_f])
        for (ix_t, bt) in enumerate(buses)
            iszero(Yb[bf,bt]) && continue
            p_exp = :(real(V[$ix_f]*Vc[$ix_t]*$(conj(Yb[bf,bt]))) + $p_exp)
            q_exp = :(imag(V[$ix_f]*Vc[$ix_t]*$(conj(Yb[bf,bt]))) + $q_exp)
        end
        push!(balance_eqs.args, :(res[$res_count] = $p_exp)); res_count += 1
        push!(balance_eqs.args, :(res[$res_count] = $q_exp)); res_count += 1
    end
    @assert res_count == var_count

    ret = quote
        f! =  @_fn (res, x) -> begin
                         $internal
                         $balance_eqs
                         end
        (f!, $x0, $res_dict)
    end

    res = eval(ret)

    return res

end


"""
    make_pf(sys)

Create the objects needed to solve an powerflow case using NLsolve.jl solvers. Returns
an anonymous function with the powerflow equations, initial conditions and a dict to link the
solutions to the original system. Only supports systems with a single generator per bus and
currently doesn't support distributes slack buses and doesn't enforce reactive power limits.

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
    MAPPING    = fill(0, N_BUS * 2)
    P_GEN_BUS  = fill(0.0, N_BUS)
    Q_GEN_BUS  = fill(0.0, N_BUS)
    P_LOAD_BUS = fill(0.0, N_BUS)
    Q_LOAD_BUS = fill(0.0, N_BUS)

    BUSES = [b for b in enumerate(buses)]

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
            MAPPING[2 * ix - 1]          = state_variable_count
            MAPPING[2 * ix]              = state_variable_count + 1
            state_variable_count += 2
        elseif b.bustype == PV::BusType
            x0[state_variable_count]     = Q_GEN_BUS[ix]
            x0[state_variable_count + 1] = bus_angle
            MAPPING[2 * ix - 1]          = state_variable_count
            MAPPING[2 * ix]              = state_variable_count + 1
            state_variable_count += 2
        elseif b.bustype == PQ::BusType
            x0[state_variable_count]     = bus_voltage
            x0[state_variable_count + 1] = bus_angle
            MAPPING[2 * ix - 1]          = state_variable_count
            MAPPING[2 * ix]              = state_variable_count + 1
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
                P_net[ix] = X[MAPPING[2 * ix - 1]] - P_LOAD_BUS[ix]
                Q_net[ix] = X[MAPPING[2 * ix]] - Q_LOAD_BUS[ix]
                Vm[ix]    = bus_voltage
                θ[ix]     = bus_angle
            elseif b.bustype == PV::BusType
                # When bustype == PV Bus, state variables are Reactive Power Generated and Voltage Angle
                P_net[ix] = P_GEN_BUS[ix] - P_LOAD_BUS[ix]
                Q_net[ix] = X[MAPPING[2 * ix - 1]] - Q_LOAD_BUS[ix]
                Vm[ix]    = bus_voltage
                θ[ix]     = X[MAPPING[2 * ix]]
            elseif b.bustype == PQ::BusType
                # When bustype == PQ Bus, state variables are Voltage Magnitude and Voltage Angle
                P_net[ix] = P_GEN_BUS[ix] - P_LOAD_BUS[ix]
                Q_net[ix] = Q_GEN_BUS[ix] - Q_LOAD_BUS[ix]
                Vm[ix]    = X[MAPPING[2 * ix - 1]]
                θ[ix]     = X[MAPPING[2 * ix]]
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
