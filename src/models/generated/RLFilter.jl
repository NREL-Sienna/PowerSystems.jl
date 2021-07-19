#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RLFilter <: Filter
        rf::Float64
        lg::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of RL series filter in algebraic representation

# Arguments
- `rf::Float64`: Series resistance in p.u. of converter filter to the grid, validation range: `(0, nothing)`
- `lg::Float64`: Series inductance in p.u. of converter filter to the grid, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: RLFilter has zero states
- `n_states::Int`: RLFilter has zero states
"""
mutable struct RLFilter <: Filter
    "Series resistance in p.u. of converter filter to the grid"
    rf::Float64
    "Series inductance in p.u. of converter filter to the grid"
    lg::Float64
    ext::Dict{String, Any}
    "RLFilter has zero states"
    states::Vector{Symbol}
    "RLFilter has zero states"
    n_states::Int
end

function RLFilter(rf, lg, ext=Dict{String, Any}(), )
    RLFilter(rf, lg, ext, Vector{Symbol}(), 0, )
end

function RLFilter(; rf, lg, ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, )
    RLFilter(rf, lg, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function RLFilter(::Nothing)
    RLFilter(;
        rf=0,
        lg=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`RLFilter`](@ref) `rf`."""
get_rf(value::RLFilter) = value.rf
"""Get [`RLFilter`](@ref) `lg`."""
get_lg(value::RLFilter) = value.lg
"""Get [`RLFilter`](@ref) `ext`."""
get_ext(value::RLFilter) = value.ext
"""Get [`RLFilter`](@ref) `states`."""
get_states(value::RLFilter) = value.states
"""Get [`RLFilter`](@ref) `n_states`."""
get_n_states(value::RLFilter) = value.n_states

"""Set [`RLFilter`](@ref) `rf`."""
set_rf!(value::RLFilter, val) = value.rf = val
"""Set [`RLFilter`](@ref) `lg`."""
set_lg!(value::RLFilter, val) = value.lg = val
"""Set [`RLFilter`](@ref) `ext`."""
set_ext!(value::RLFilter, val) = value.ext = val

