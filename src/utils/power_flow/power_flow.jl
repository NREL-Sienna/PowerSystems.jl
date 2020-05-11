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

"""
    solve_powerflow!(sys, solve_function, args...)

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
function solve_powerflow!(sys, nlsolve; args...)
    pf!, x0 = PowerSystems.make_pf(sys)
    res = nlsolve(pf!, x0; args...)
    @info(res)
    if res.f_converged
        PowerSystems._write_pf_sol!(sys, res)
        @info("PowerFlow solve converged, the results have been stored in the system")
        return res.f_converged
    end
    @error("The powerflow solver returned convergence = $(res.f_converged)")
    return res.f_converged
end
