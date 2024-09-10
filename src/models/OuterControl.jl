"""
    mutable struct OuterControl{
        A <: ActivePowerControl,
        R <: ReactivePowerControl
    } <: DynamicInverterComponent
        active_power_control::A
        reactive_power_control::R
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
    active_power_control::A
    reactive_power_control::R
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int
end

function OuterControl(
    active_power_control::A,
    reactive_power_control::R,
    ext = Dict{String, Any}(),
) where {A <: ActivePowerControl, R <: ReactivePowerControl}
    return OuterControl(
        active_power_control,
        reactive_power_control,
        ext,
        vcat(active_power_control.states, reactive_power_control.states),
        active_power_control.n_states + reactive_power_control.n_states,
    )
end

function OuterControl(;
    active_power_control,
    reactive_power_control,
    ext = Dict{String, Any}(),
    states = nothing,
    n_states = nothing,
)
    if states === nothing
        @assert n_states === nothing
        return OuterControl(active_power_control, reactive_power_control, ext)
    end
    @assert n_states !== nothing
    return OuterControl(active_power_control, reactive_power_control, ext, states, n_states)
end

"""Get Active Power Control from OuterControl."""
get_active_power_control(value::OuterControl) = value.active_power_control
"""Get Reactive Power Control from OuterControl."""
get_reactive_power_control(value::OuterControl) = value.reactive_power_control
"""Get `ext` from OuterControl."""
get_ext(value::OuterControl) = value.ext
"""Get `states` from OuterControl."""
get_states(value::OuterControl) = value.states
"""Get `n_states` from OuterControl."""
get_n_states(value::OuterControl) = value.n_states
