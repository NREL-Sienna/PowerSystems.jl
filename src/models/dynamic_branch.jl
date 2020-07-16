mutable struct DynamicBranch <: ACBranch
    branch::ACBranch
    n_states::Int64
    states::Vector{Symbol}
    internal::IS.InfrastructureSystemsInternal

    function DynamicBranch(
        branch::T;
        internal = IS.InfrastructureSystemsInternal(),
    ) where {T <: ACBranch}
        IS.@forward((DynamicBranch, :branch), T)
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
