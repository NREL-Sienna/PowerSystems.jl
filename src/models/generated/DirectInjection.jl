#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct DirectInjection <: Filter
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Direct Injection Filter

# Arguments
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: DirectInjection has zero states
- `n_states::Int`: DirectInjection has zero states
"""
mutable struct DirectInjection <: Filter
    ext::Dict{String, Any}
    "DirectInjection has zero states"
    states::Vector{Symbol}
    "DirectInjection has zero states"
    n_states::Int
end


function DirectInjection(; ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, )
    DirectInjection(ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function DirectInjection(::Nothing)
    DirectInjection(;
        ext=Dict{String, Any}(),
    )
end

"""Get [`DirectInjection`](@ref) `ext`."""
get_ext(value::DirectInjection) = value.ext
"""Get [`DirectInjection`](@ref) `states`."""
get_states(value::DirectInjection) = value.states
"""Get [`DirectInjection`](@ref) `n_states`."""
get_n_states(value::DirectInjection) = value.n_states

"""Set [`DirectInjection`](@ref) `ext`."""
set_ext!(value::DirectInjection, val) = value.ext = val

