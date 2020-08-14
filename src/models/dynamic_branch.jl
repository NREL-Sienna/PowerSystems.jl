```
Extends the branch type to add the information required for dynamic modeling of branches. Includes the fields for the states and the number of states
```
mutable struct DynamicBranch <: ACBranch
    branch::ACBranch
    n_states::Int64
    states::Vector{Symbol}
    internal::IS.InfrastructureSystemsInternal

    function DynamicBranch(
        branch::T;
        internal = IS.InfrastructureSystemsInternal(),
    ) where {T <: ACBranch}
        n_states = 2
        states = [
            :Il_R
            :Il_I
        ]
        new(branch, n_states, states, internal)
    end
end

function DynamicBranch(; branch)
    DynamicBranch(branch)
end

function DynamicBranch(::Nothing)
    DynamicBranch(Line(nothing))
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
set_n_states!(value::DynamicBranch, val::Int64) = value.n_states = val
"Set states"
set_states!(value::DynamicBranch, val::Vector{Symbol}) = value.states = val

function JSON2.write(io::IO, dynamic_branch::DynamicBranch)
    return JSON2.write(io, encode_for_json(dynamic_branch))
end

function JSON2.write(dynamic_branch::DynamicBranch)
    return JSON2.write(encode_for_json(dynamic_branch))
end

function encode_for_json(dynamic_branch::DynamicBranch)
    # This requires custom code because the composed branch is defined as an abstract type.
    # Record the concrete type of the instance in the JSON so that the deserialization
    # code knows how to construct it.
    fields = fieldnames(DynamicBranch)
    final_fields = Vector{Symbol}()
    vals = []

    for field in fields
        push!(vals, getfield(dynamic_branch, field))
        push!(final_fields, field)
    end

    push!(final_fields, :branch_type)
    push!(vals, typeof(dynamic_branch.branch))

    return NamedTuple{Tuple(final_fields)}(vals)
end

function IS.convert_type(::Type{DynamicBranch}, data::NamedTuple, component_cache::Dict)
    branch_type = get_component_type(Symbol(data.branch_type))
    # Note: The arcs inside the raw JSON branch have bus UUIDs which need to be read from
    # component_cache.
    branch = IS.convert_type(branch_type, data.branch, component_cache)
    internal = IS.convert_type(IS.InfrastructureSystemsInternal, data.internal)
    return DynamicBranch(branch; internal = internal)
end
