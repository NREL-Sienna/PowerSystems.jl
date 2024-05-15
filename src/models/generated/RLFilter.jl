#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct RLFilter <: Filter
        rf::Float64
        lf::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of RL series filter in algebraic representation

# Arguments
- `rf::Float64`: Series resistance in p.u. of converter filter to the grid, validation range: `(0, nothing)`
- `lf::Float64`: Series inductance in p.u. of converter filter to the grid, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `states::Vector{Symbol}`: (**Do not modify.**) RLFilter has zero states
- `n_states::Int`: (**Do not modify.**) RLFilter has zero states
"""
mutable struct RLFilter <: Filter
    "Series resistance in p.u. of converter filter to the grid"
    rf::Float64
    "Series inductance in p.u. of converter filter to the grid"
    lf::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) RLFilter has zero states"
    states::Vector{Symbol}
    "(**Do not modify.**) RLFilter has zero states"
    n_states::Int
end

function RLFilter(rf, lf, ext=Dict{String, Any}(), )
    RLFilter(rf, lf, ext, Vector{Symbol}(), 0, )
end

function RLFilter(; rf, lf, ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, )
    RLFilter(rf, lf, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function RLFilter(::Nothing)
    RLFilter(;
        rf=0,
        lf=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`RLFilter`](@ref) `rf`."""
get_rf(value::RLFilter) = value.rf
"""Get [`RLFilter`](@ref) `lf`."""
get_lf(value::RLFilter) = value.lf
"""Get [`RLFilter`](@ref) `ext`."""
get_ext(value::RLFilter) = value.ext
"""Get [`RLFilter`](@ref) `states`."""
get_states(value::RLFilter) = value.states
"""Get [`RLFilter`](@ref) `n_states`."""
get_n_states(value::RLFilter) = value.n_states

"""Set [`RLFilter`](@ref) `rf`."""
set_rf!(value::RLFilter, val) = value.rf = val
"""Set [`RLFilter`](@ref) `lf`."""
set_lf!(value::RLFilter, val) = value.lf = val
"""Set [`RLFilter`](@ref) `ext`."""
set_ext!(value::RLFilter, val) = value.ext = val
