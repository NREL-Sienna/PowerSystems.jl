#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AverageConverter <: Converter
        rated_voltage::Float64
        rated_current::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of an average converter model

# Arguments
- `rated_voltage::Float64`: rated voltage, validation range: `(0, nothing)`
- `rated_current::Float64`: rated VA, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int`: AverageConverter has no states
"""
mutable struct AverageConverter <: Converter
    "rated voltage"
    rated_voltage::Float64
    "rated VA"
    rated_current::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    "AverageConverter has no states"
    n_states::Int
end

function AverageConverter(rated_voltage, rated_current, ext=Dict{String, Any}(), )
    AverageConverter(rated_voltage, rated_current, ext, Vector{Symbol}(), 0, )
end

function AverageConverter(; rated_voltage, rated_current, ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, )
    AverageConverter(rated_voltage, rated_current, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function AverageConverter(::Nothing)
    AverageConverter(;
        rated_voltage=0,
        rated_current=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`AverageConverter`](@ref) `rated_voltage`."""
get_rated_voltage(value::AverageConverter) = value.rated_voltage
"""Get [`AverageConverter`](@ref) `rated_current`."""
get_rated_current(value::AverageConverter) = value.rated_current
"""Get [`AverageConverter`](@ref) `ext`."""
get_ext(value::AverageConverter) = value.ext
"""Get [`AverageConverter`](@ref) `states`."""
get_states(value::AverageConverter) = value.states
"""Get [`AverageConverter`](@ref) `n_states`."""
get_n_states(value::AverageConverter) = value.n_states

"""Set [`AverageConverter`](@ref) `rated_voltage`."""
set_rated_voltage!(value::AverageConverter, val) = value.rated_voltage = val
"""Set [`AverageConverter`](@ref) `rated_current`."""
set_rated_current!(value::AverageConverter, val) = value.rated_current = val
"""Set [`AverageConverter`](@ref) `ext`."""
set_ext!(value::AverageConverter, val) = value.ext = val

