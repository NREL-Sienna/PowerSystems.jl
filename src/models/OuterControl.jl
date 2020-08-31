"""
    mutable struct OuterControl{
        A <: ActivePowerControl,
        R <: ReactivePowerControl
    } <: DynamicInverterComponent
        active_power::A
        reactive_power::R
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end
Parameters of a Outer-Loop controller using a active power controller and a reactive power droop controller.

# Arguments
- `A <: ActivePowerControl`: Active power controller (typically droop or virtual inertia).
- `R <: ReactivePowerControl`: Reactive power controller (typically droop).
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: Vector of states (will depend on the components).
- `n_states::Int`: Number of states (will depend on the components).
"""
mutable struct OuterControl{A <: ActivePowerControl, R <: ReactivePowerControl} <:
               DynamicInverterComponent
    active_power::A
    reactive_power::R
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int
end

function OuterControl(
    active_power::A,
    reactive_power::R,
    ext = Dict{String, Any}(),
) where {A <: ActivePowerControl, R <: ReactivePowerControl}
    OuterControl(
        active_power,
        reactive_power,
        ext,
        vcat(active_power.states, reactive_power.states),
        active_power.n_states + reactive_power.n_states,
    )
end

function OuterControl(; active_power, reactive_power, ext = Dict{String, Any}())
    OuterControl(active_power, reactive_power, ext)
end

get_active_power(value::OuterControl) = value.active_power
get_reactive_power(value::OuterControl) = value.reactive_power
get_ext(value::OuterControl) = value.ext
get_states(value::OuterControl) = value.states
get_n_states(value::OuterControl) = value.n_states
