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

function OuterControl(;
    active_power,
    reactive_power,
    ext = Dict{String, Any}(),
    states = nothing,
    n_states = nothing,
)
    if states === nothing
        @assert n_states === nothing
        return OuterControl(active_power, reactive_power, ext)
    end
    @assert n_states !== nothing
    return OuterControl(active_power, reactive_power, ext, states, n_states)
end

function IS.deserialize(::Type{T}, data::Dict) where {T <: OuterControl}
    @debug "deserialize OuterControl" T data
    vals = Dict{Symbol, Any}()
    for (field_name, field_type) in zip(fieldnames(OuterControl), fieldtypes(OuterControl))
        val = data[string(field_name)]
        if field_name === :active_power
            vals[field_name] = deserialize(T.parameters[1], val)
        elseif field_name === :reactive_power
            vals[field_name] = deserialize(T.parameters[2], val)
        elseif field_name === :states
            vals[field_name] = [Symbol(x) for x in val]
        else
            vals[field_name] = deserialize(field_type, val)
        end
    end

    return OuterControl(; vals...)
end

get_active_power(value::OuterControl) = value.active_power
get_reactive_power(value::OuterControl) = value.reactive_power
get_ext(value::OuterControl) = value.ext
get_states(value::OuterControl) = value.states
get_n_states(value::OuterControl) = value.n_states
