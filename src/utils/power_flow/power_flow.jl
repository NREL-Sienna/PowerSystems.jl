function _update_slack_bus(bus::Bus, sys::System, result::Vector{Float64}, v::Vector{Tuple{Symbol,Int64}})
    injection_components = get_components(Generator, sys)
    devices = [d for d in injection_components if d.bus == bus]
    generator = devices[1]
    for field in v
        setfield!(generator, field[1], result[field[2]])
    end

     return
 end

 function _update_PQ_bus(bus::Bus, sys::System, result::Vector{Float64}, v::Vector{Tuple{Symbol,Int64}})
    for field in v
        setfield!(bus, field[1], result[field[2]])
    end

     return
 end

 function _update_PV_bus(bus::Bus, sys::System, result::Vector{Float64}, v::Vector{Tuple{Symbol,Int64}})
    injection_components = get_components(Generator, sys)
    devices = [d for d in injection_components if d.bus == bus]
    generator = devices[1]
    for field in v
        field[1] == :reactivepower && setfield!(generator, field[1], result[field[2]])
        field[1] == :angle && setfield!(bus, field[1], result[field[2]])
    end

     return
 end

 """
    flow_val(b::TapTransformer)

Calculates the From - To comp[lex power flow (Flow injected at the bus) of branch of type
TapTransformer

"""
 function flow_val(b::TapTransformer)
    Y_t = 1 / (PowerSystems.get_r(b) + PowerSystems.get_x(b) * 1im)
    c = 1 / PowerSystems.get_tap(b)
    arc = PowerSystems.get_arc(b)
    V_from = arc.from.voltage*(cos(arc.from.angle)+sin(arc.from.angle)*1im)
    V_to = arc.to.voltage*(cos(arc.to.angle)+sin(arc.to.angle)*1im)
    I = (V_from * Y_t * c^2) - (V_to * Y_t * c)
    flow = V_from*conj(I)
    return flow
end

"""
    flow_val(b::TapTransformer)

Calculates the From - To comp[lex power flow (Flow injected at the bus) of branch of type
Line

"""
function flow_val(b::Line)
    Y_t = (1 / (PowerSystems.get_r(b) + PowerSystems.get_x(b) * 1im))
    arc = PowerSystems.get_arc(b)
    V_from = arc.from.voltage*(cos(arc.from.angle)+sin(arc.from.angle)*1im)
    V_to = arc.to.voltage*(cos(arc.to.angle)+sin(arc.to.angle)*1im)
    I = V_from*(Y_t + (1im * PowerSystems.get_b(b).from)) - V_to*Y_t
    flow = V_from*conj(I)
    return flow
end

"""
    flow_val(b::TapTransformer)

Calculates the From - To comp[lex power flow (Flow injected at the bus) of branch of type
Transformer2W

"""
function flow_val(b::Transformer2W)
    Y_t = 1 / (PowerSystems.get_r(b) + PowerSystems.get_x(b) * 1im)
    arc = PowerSystems.get_arc(b)
    V_from = arc.from.voltage*(cos(arc.from.angle)+sin(arc.from.angle)*1im)
    V_to = arc.to.voltage*(cos(arc.to.angle)+sin(arc.to.angle)*1im)
    I = V_from*(Y_t + (1im * PowerSystems.get_primaryshunt(b))) - V_to*Y_t
    flow = V_from*conj(I)
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

function _write_pf_sol!(sys::System, nl_result, result_ref::Dict{String, Vector{Tuple{Symbol, Int}}})
    result = nl_result.zero
    for (k,v) in result_ref
        bus = get_component(Bus, sys, k)
        if bus.bustype == PowerSystems.REF
            _update_slack_bus(bus, sys, result, v)
        elseif bus.bustype == PowerSystems.PQ
            _update_PQ_bus(bus, sys, result, v)
        elseif bus.bustype == PowerSystems.PV
            _update_PV_bus(bus, sys, result, v)
        end
    end

    _update_branch_flow!(sys)

    return
end

"""
    @solve_powerflow!(sys, args...)

Solves a the power flow into the system and writes the solution into the relevant structs.
Updates generators active and reactive power setpoints and branches active and reactive
power flows (calculated in the From - To direction) (see
[@flow_val](@ref))

Requires loading NLsolve.jl to run. Internally it uses the make_pf_fast (see
[make_pf_fast](@ref)) to create the problem and solve it. As a result it doesn't enforce
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
@solve_powerflow!(sys)
# Passing NLsolve arguments
@rsolve_powerflow!(sys, method = :Newton)

```

"""

macro solve_powerflow!(sys, args...)
    vals = filter((x) ->  x == :NLsolve, names(Main,imported=true))
    isempty(vals) && error("NLsolve is not loaded, run \"import NLsolve\"")
    par = Expr(:kw)
    show_trace_in_params = false
    for kwarg in args
        k, v = kwarg.args
        if k == :show_trace
            show_trace_in_params = true
        end
        push!(par.args, k, v)
    end
    !(show_trace_in_params) && push!(par.args, :show_trace, true)
    eval_code =
        esc(quote
            pf!, x0, res_ref = PowerSystems.make_pf_fast($sys)
            res = NLsolve.nlsolve(pf!, x0; $par)
            show(res)
            PowerSystems._write_pf_sol!($sys, res, res_ref)
    end)
    return eval_code
end
