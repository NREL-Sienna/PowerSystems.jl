#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AverageConverter <: Converter
        v_rated::Float64
        s_rated::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
    end

Parameters of an average converter model

# Arguments
- `v_rated::Float64`: rated voltage, validation range: (0, nothing)
- `s_rated::Float64`: rated VA, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
"""
mutable struct AverageConverter <: Converter
    "rated voltage"
    v_rated::Float64
    "rated VA"
    s_rated::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
end

function AverageConverter(v_rated, s_rated, ext=Dict{String, Any}(), )
    AverageConverter(v_rated, s_rated, ext, Vector{Symbol}(), 0, )
end

function AverageConverter(; v_rated, s_rated, ext=Dict{String, Any}(), )
    AverageConverter(v_rated, s_rated, ext, )
end

# Constructor for demo purposes; non-functional.
function AverageConverter(::Nothing)
    AverageConverter(;
        v_rated=0,
        s_rated=0,
        ext=Dict{String, Any}(),
    )
end

"""Get AverageConverter v_rated."""
get_v_rated(value::AverageConverter) = value.v_rated
"""Get AverageConverter s_rated."""
get_s_rated(value::AverageConverter) = value.s_rated
"""Get AverageConverter ext."""
get_ext(value::AverageConverter) = value.ext
"""Get AverageConverter states."""
get_states(value::AverageConverter) = value.states
"""Get AverageConverter n_states."""
get_n_states(value::AverageConverter) = value.n_states

"""Set AverageConverter v_rated."""
set_v_rated!(value::AverageConverter, val::Float64) = value.v_rated = val
"""Set AverageConverter s_rated."""
set_s_rated!(value::AverageConverter, val::Float64) = value.s_rated = val
"""Set AverageConverter ext."""
set_ext!(value::AverageConverter, val::Dict{String, Any}) = value.ext = val
"""Set AverageConverter states."""
set_states!(value::AverageConverter, val::Vector{Symbol}) = value.states = val
"""Set AverageConverter n_states."""
set_n_states!(value::AverageConverter, val::Int64) = value.n_states = val
