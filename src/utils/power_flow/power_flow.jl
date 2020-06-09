"""
    flow_val(b::TapTransformer)

Calculates the From - To comp[lex power flow (Flow injected at the bus) of branch of type
TapTransformer

"""
function flow_val(b::TapTransformer)
    Y_t = 1 / (PowerSystems.get_r(b) + PowerSystems.get_x(b) * 1im)
    c = 1 / PowerSystems.get_tap(b)
    arc = PowerSystems.get_arc(b)
    V_from = arc.from.voltage * (cos(arc.from.angle) + sin(arc.from.angle) * 1im)
    V_to = arc.to.voltage * (cos(arc.to.angle) + sin(arc.to.angle) * 1im)
    I = (V_from * Y_t * c^2) - (V_to * Y_t * c)
    flow = V_from * conj(I)
    return flow
end

"""
    flow_val(b::TapTransformer)

Calculates the From - To complex power flow (Flow injected at the bus) of branch of type
Line

"""
function flow_val(b::Line)
    Y_t = (1 / (PowerSystems.get_r(b) + PowerSystems.get_x(b) * 1im))
    arc = PowerSystems.get_arc(b)
    V_from = arc.from.voltage * (cos(arc.from.angle) + sin(arc.from.angle) * 1im)
    V_to = arc.to.voltage * (cos(arc.to.angle) + sin(arc.to.angle) * 1im)
    I = V_from * (Y_t + (1im * PowerSystems.get_b(b).from)) - V_to * Y_t
    flow = V_from * conj(I)
    return flow
end

"""
    flow_val(b::TapTransformer)

Calculates the From - To complex power flow (Flow injected at the bus) of branch of type
Transformer2W

"""
function flow_val(b::Transformer2W)
    Y_t = 1 / (PowerSystems.get_r(b) + PowerSystems.get_x(b) * 1im)
    arc = PowerSystems.get_arc(b)
    V_from = arc.from.voltage * (cos(arc.from.angle) + sin(arc.from.angle) * 1im)
    V_to = arc.to.voltage * (cos(arc.to.angle) + sin(arc.to.angle) * 1im)
    I = V_from * (Y_t + (1im * PowerSystems.get_primaryshunt(b))) - V_to * Y_t
    flow = V_from * conj(I)
    return flow
end

function flow_val(b::PhaseShiftingTransformer)
    error("Systems with PhaseShiftingTransformer not supported yet")
    return
end

function _update_branch_flow!(sys::System)
    for b in get_components(ACBranch, sys)
        S_flow = flow_val(b)
        b.activepower_flow = real(S_flow)
        b.reactivepower_flow = imag(S_flow)
    end
end

function _write_pf_sol!(sys::System, nl_result)
    result = round.(nl_result.zero; digits = 7)
    buses = enumerate(sort(collect(get_components(Bus, sys)), by = x -> get_number(x)))

    for (ix, bus) in buses
        if bus.bustype == BusTypes.REF
            P_gen = result[2 * ix - 1]
            Q_gen = result[2 * ix]
            injection = get_components(StaticInjection, sys)
            devices = [d for d in injection if d.bus == bus && !isa(d, ElectricLoad)]
            generator = devices[1]
            generator.activepower = P_gen
            generator.reactivepower = Q_gen
        elseif bus.bustype == BusTypes.PV
            Q_gen = result[2 * ix - 1]
            θ = result[2 * ix]
            injection_components = get_components(Generator, sys)
            devices = [d for d in injection_components if d.bus == bus]
            if length(devices) == 1
                generator = devices[1]
                generator.reactivepower = Q_gen
            end
            bus.angle = θ
        elseif bus.bustype == BusTypes.PQ
            Vm = result[2 * ix - 1]
            θ = result[2 * ix]
            bus.voltage = Vm
            bus.angle = θ
        end
    end

    _update_branch_flow!(sys)

    return
end

# TODO: Apply actions according to load type
function _get_load_data(sys::System, b::Bus)
    activepower = 0.0
    reactivepower = 0.0
    for l in get_components(ElectricLoad, sys)
        if !isa(l, FixedAdmittance) && (l.bus == b)
            activepower += get_activepower(l)
            reactivepower += get_reactivepower(l)
        elseif isa(l, FixedAdmittance) && (l.bus == b)
            # Assume v rated = 1.0
            activepower += real(get_Y(l))
            reactivepower += imag(get_Y(l))
        end
    end
    return activepower, reactivepower
end

"""
    solve_powerflow!(system, solve_function, args...)

Solves a the power flow into the system and writes the solution into the relevant structs.
Updates generators active and reactive power setpoints and branches active and reactive
power flows (calculated in the From - To direction) (see
[`flow_val`](@ref))

Requires loading NLsolve.jl to run. Internally it uses the make_pf (see
[`make_pf`](@ref)) to create the problem and solve it. As a result it doesn't enforce
reactivepower limits.

Supports passing NLsolve kwargs in the args. By default shows the solver trace.

Arguments available for `nlsolve`:

* `method` : See NLSolve.jl documentation for available solvers
* `xtol`: norm difference in `x` between two successive iterates under which
  convergence is declared. Default: `0.0`.
* `ftol`: infinite norm of residuals under which convergence is declared.
  Default: `1e-8`.
* `iterations`: maximum number of iterations. Default: `1_000`.
* `store_trace`: should a trace of the optimization algorithm's state be
  stored? Default: `false`.
* `show_trace`: should a trace of the optimization algorithm's state be shown
  on `STDOUT`? Default: `false`.
* `extended_trace`: should additifonal algorithm internals be added to the state
  trace? Default: `false`.


## Examples
```julia
using NLsolve
solve_powerflow!(sys, nlsolve)
# Passing NLsolve arguments
solve_powerflow!(sys, nlsolve, method = :newton)

```

"""
function solve_powerflow!(system::System, nlsolve; args...)
    buses = sort(collect(get_components(Bus, system)), by = x -> get_number(x))
    N_BUS = length(buses)

    # assumes the ordering in YBus is the same as in the buses.
    tempYb = Ybus(get_components(ACBranch, system), buses)
    a = collect(1:N_BUS)
    Yb = Ybus(tempYb.data, (a, a), (_make_ax_ref(a), _make_ax_ref(a))).data
    I, J, V = SparseArrays.findnz(Yb)
    neighbors = [Set{Int}([i]) for i in 1:N_BUS]
    for nz in eachindex(V)
        push!(neighbors[I[nz]], J[nz])
        push!(neighbors[J[nz]], I[nz])
    end
    x0 = zeros(N_BUS * 2)

    # Use vectors to cache data for closure
    # These should be read only
    P_GEN_BUS = fill(0.0, N_BUS)
    Q_GEN_BUS = fill(0.0, N_BUS)
    P_LOAD_BUS = fill(0.0, N_BUS)
    Q_LOAD_BUS = fill(0.0, N_BUS)
    P_net = fill(0.0, N_BUS)
    Q_net = fill(0.0, N_BUS)
    Vm = fill(0.0, N_BUS)
    θ = fill(0.0, N_BUS)

    state_variable_count = 1
    sources = get_components(StaticInjection, system, d -> !isa(d, ElectricLoad))

    for (ix, b) in enumerate(buses)
        bus_number = get_number(b)::Int
        bus_angle = get_angle(b)::Float64
        bus_voltage = get_voltage(b)::Float64
        P_GEN_BUS[ix] = 0.0
        Q_GEN_BUS[ix] = 0.0
        get_ext(b)["neighbors"] = neighbors[ix]
        for gen in sources
            if gen.bus == b
                P_GEN_BUS[ix] += get_activepower(gen)
                Q_GEN_BUS[ix] += get_reactivepower(gen)
            end
        end

        P_LOAD_BUS[ix], Q_LOAD_BUS[ix] = _get_load_data(system, b)

        if b.bustype == BusTypes.REF
            injection_components = get_components(StaticInjection, system, d -> d.bus == b)
            isempty(injection_components) &&
                throw(IS.ConflictingInputsError("The slack bus does not have any injection component. Power Flow can not proceed"))
            Vm[ix] = get_voltage(b)::Float64
            θ[ix] = get_angle(b)::Float64
            x0[state_variable_count] = P_GEN_BUS[ix]
            x0[state_variable_count + 1] = Q_GEN_BUS[ix]
            state_variable_count += 2
        elseif b.bustype == BusTypes.PV
            Vm[ix] = get_voltage(b)::Float64
            x0[state_variable_count] = Q_GEN_BUS[ix]
            x0[state_variable_count + 1] = bus_angle
            state_variable_count += 2
        elseif b.bustype == BusTypes.PQ
            x0[state_variable_count] = bus_voltage
            x0[state_variable_count + 1] = bus_angle
            state_variable_count += 2
        else
            throw(ArgumentError("Bustype not recognized"))
        end
    end

    @assert state_variable_count - 1 == N_BUS * 2
    bus_types = get_bustype.(buses)

    function pf!(F::Vector{Float64}, X::Vector{Float64})
        for (ix, b) in enumerate(bus_types)
            if b == BusTypes.REF
                # When bustype == REFERENCE Bus, state variables are Active and Reactive Power Generated
                P_net[ix] = X[2 * ix - 1] - P_LOAD_BUS[ix]
                Q_net[ix] = X[2 * ix] - Q_LOAD_BUS[ix]
            elseif b == BusTypes.PV
                # When bustype == PV Bus, state variables are Reactive Power Generated and Voltage Angle
                P_net[ix] = P_GEN_BUS[ix] - P_LOAD_BUS[ix]
                Q_net[ix] = X[2 * ix - 1] - Q_LOAD_BUS[ix]
                θ[ix] = X[2 * ix]
            elseif b == BusTypes.PQ
                # When bustype == PQ Bus, state variables are Voltage Magnitude and Voltage Angle
                P_net[ix] = P_GEN_BUS[ix] - P_LOAD_BUS[ix]
                Q_net[ix] = Q_GEN_BUS[ix] - Q_LOAD_BUS[ix]
                Vm[ix] = X[2 * ix - 1]
                θ[ix] = X[2 * ix]
            end
        end

        # F is active and reactive power balance equations at all buses
        for ix_f in a
            S_re = -P_net[ix_f]
            S_im = -Q_net[ix_f]
            for ix_t in neighbors[ix_f]
                gb = real(Yb[ix_f, ix_t])
                bb = imag(Yb[ix_f, ix_t])
                S_re +=
                    Vm[ix_f] *
                    Vm[ix_t] *
                    (gb * cos(θ[ix_f] - θ[ix_t]) + bb * sin(θ[ix_f] - θ[ix_t]))
                S_im +=
                    Vm[ix_f] *
                    Vm[ix_t] *
                    (gb * sin(θ[ix_f] - θ[ix_t]) - bb * cos(θ[ix_f] - θ[ix_t]))
            end
            F[2 * ix_f - 1] = S_re
            F[2 * ix_f] = S_im
        end
    end

    res = nlsolve(pf!, x0; args...)
    @info(res)
    if res.f_converged
        PowerSystems._write_pf_sol!(system, res)
        @info("PowerFlow solve converged, the results have been stored in the system")
        return res.f_converged
    end
    @error("The powerflow solver returned convergence = $(res.f_converged)")
    return res.f_converged
end
