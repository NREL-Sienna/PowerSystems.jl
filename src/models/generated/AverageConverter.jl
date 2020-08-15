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
- `rated_voltage::Float64`: rated voltage, validation range: (0, nothing)
- `rated_current::Float64`: rated VA, validation range: (0, nothing)
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

function AverageConverter(; rated_voltage, rated_current, ext=Dict{String, Any}(), )
    AverageConverter(rated_voltage, rated_current, ext, )
end

# Constructor for demo purposes; non-functional.
function AverageConverter(::Nothing)
    AverageConverter(;
        rated_voltage=0,
        rated_current=0,
        ext=Dict{String, Any}(),
    )
end

"""Get AverageConverter rated_voltage."""
get_rated_voltage(value::AverageConverter) = value.rated_voltage
"""Get AverageConverter rated_current."""
get_rated_current(value::AverageConverter) = value.rated_current
"""Get AverageConverter ext."""
get_ext(value::AverageConverter) = value.ext
"""Get AverageConverter states."""
get_states(value::AverageConverter) = value.states
"""Get AverageConverter n_states."""
get_n_states(value::AverageConverter) = value.n_states

"""Set AverageConverter rated_voltage."""
set_rated_voltage!(value::AverageConverter, val::Float64) = value.rated_voltage = val
"""Set AverageConverter rated_current."""
set_rated_current!(value::AverageConverter, val::Float64) = value.rated_current = val
"""Set AverageConverter ext."""
set_ext!(value::AverageConverter, val::Dict{String, Any}) = value.ext = val
"""Set AverageConverter states."""
set_states!(value::AverageConverter, val::Vector{Symbol}) = value.states = val
"""Set AverageConverter n_states."""
set_n_states!(value::AverageConverter, val::Int) = value.n_states = val
