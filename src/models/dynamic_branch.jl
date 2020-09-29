"""
Extends the branch type to add the information required for dynamic modeling of branches. Includes the fields for the states and the number of states


# Arguments
- `branch::ACBranch`
"""
mutable struct DynamicBranch <: ACBranch
    branch::ACBranch
    n_states::Int
    states::Vector{Symbol}
    internal::IS.InfrastructureSystemsInternal

    function DynamicBranch(branch, n_states, states, internal)
        @assert length(states) == n_states
        new(branch, n_states, states, internal)
    end
end

const DEFAULT_DYNAMIC_BRANCH_STATES = [:Il_R, :Il_I]

function DynamicBranch(
    branch::T;
    internal = IS.InfrastructureSystemsInternal(),
) where {T <: ACBranch}
    states = DEFAULT_DYNAMIC_BRANCH_STATES
    n_states = length(states)
    DynamicBranch(branch, n_states, states, internal)
end

function DynamicBranch(;
    branch,
    n_states = length(DEFAULT_DYNAMIC_BRANCH_STATES),
    states = DEFAULT_DYNAMIC_BRANCH_STATES,
    internal = IS.InfrastructureSystemsInternal(),
)
    DynamicBranch(branch, n_states, states, internal)
end

function DynamicBranch(::Nothing)
    DynamicBranch(Line(nothing))
end

const BRANCH_TYPE_KEY = "__branch_type"

function IS.serialize(component::T) where {T <: DynamicBranch}
    data = Dict{String, Any}()
    for name in fieldnames(T)
        val = getfield(component, name)
        if name === :branch
            # The device is not attached to the system, so serialize it and save the type.
            data[BRANCH_TYPE_KEY] = string(typeof(val))
        end
        data[string(name)] = serialize_uuid_handling(val)
    end

    return data
end

function IS.deserialize(
    ::Type{T},
    data::Dict,
    component_cache::Dict,
) where {T <: DynamicBranch}
    @debug T data
    vals = Dict{Symbol, Any}()
    for (field_name, field_type) in zip(fieldnames(T), fieldtypes(T))
        val = data[string(field_name)]
        if field_name === :branch
            type = get_component_type(data[BRANCH_TYPE_KEY])
            vals[field_name] = deserialize(type, val, component_cache)
        else
            vals[field_name] =
                deserialize_uuid_handling(field_type, field_name, val, component_cache)
        end
    end

    return DynamicBranch(; vals...)
end

"Get branch"
get_branch(value::DynamicBranch) = value.branch
"Get n_states"
get_n_states(value::DynamicBranch) = value.n_states
"Get states"
get_states(value::DynamicBranch) = value.states
"""Get DynamicBranch internal."""
get_internal(value::DynamicBranch) = value.internal

IS.get_name(value::DynamicBranch) = IS.get_name(value.branch)
"""Get DynamicBranch available."""
get_available(value::DynamicBranch) = get_available(value.branch)
"""Get DynamicBranch active_power_flow."""
get_active_power_flow(value::DynamicBranch) = get_active_power(value.branch)
"""Get DynamicBranch reactive_power_flow."""
get_reactive_power_flow(value::DynamicBranch) = get_reactive_power(value.branch)
"""Get DynamicBranch arc."""
get_arc(value::DynamicBranch) = get_arc(value.branch)
"""Get DynamicBranch r."""
get_r(value::DynamicBranch) = get_r(value.branch)
"""Get DynamicBranch x."""
get_x(value::DynamicBranch) = get_x(value.branch)
"""Get DynamicBranch b."""
get_b(value::DynamicBranch) = get_b(value.branch)
"""Get DynamicBranch rate."""
get_rate(value::DynamicBranch) = get_rate(value.branch)
"""Get DynamicBranch angle_limits."""
get_angle_limits(value::DynamicBranch) = get_angle_limits(value.branch)
"""Get DynamicBranch services."""
get_services(value::DynamicBranch) = get_services(value.branch)
"""Get DynamicBranch ext."""
get_ext(value::DynamicBranch) = get_ext(value.branch)

IS.set_name!(value::DynamicBranch, val::String) = IS.set_name!(value.branch, val)
"""Set DynamicBranch available."""
set_available!(value::DynamicBranch, val::Bool) = set_available!(value.branch, val)
"""Set DynamicBranch active_power_flow."""
set_active_power_flow!(value::DynamicBranch, val::Float64) =
    set_active_power_flow!(value.branch, val)
"""Set DynamicBranch reactive_power_flow."""
set_reactive_power_flow!(value::DynamicBranch, val::Float64) =
    set_reactive_power_flow!(value.branch, val)
"""Set DynamicBranch arc."""
set_arc!(value::DynamicBranch, val::Arc) = set_arc!(value.branch, val)
"""Set DynamicBranch r."""
set_r!(value::DynamicBranch, val::Float64) = set_r!(value.branch, val)
"""Set DynamicBranch x."""
set_x!(value::DynamicBranch, val::Float64) = set_x!(value.branch, val)
"""Set DynamicBranch b."""
set_b!(value::DynamicBranch, val) = set_b!(value.branch, val)
"""Set DynamicBranch rate."""
set_rate!(value::DynamicBranch, val::Float64) = set_rate!(value.branch, val)
"""Set DynamicBranch angle_limits."""
set_angle_limits!(
    value::DynamicBranch,
    val::NamedTuple{(:min, :max), Tuple{Float64, Float64}},
) = set_angle_limits!(value.branch, val)
"""Set DynamicBranch services."""
set_services!(value::DynamicBranch, val::Vector{Service}) = set_services!(value.branch, val)
"""Set DynamicBranch ext."""
set_ext!(value::DynamicBranch, val::Dict{String, Any}) = set_ext!(value.branch, val)

"""Set DynamicBranch internal."""
set_internal!(value::DynamicBranch, val::InfrastructureSystemsInternal) =
    value.internal = val
"Set branch"
set_branch!(value::DynamicBranch, val::ACBranch) = value.branch = val
"Set n_states"
set_n_states!(value::DynamicBranch, val::Int) = value.n_states = val
"Set states"
set_states!(value::DynamicBranch, val::Vector{Symbol}) = value.states = val
