#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct MagnitudeCurrentLimiter <: InverterLimiter
        I_max::Float64
        ext::Dict{String, Any}
    end

Parameters of Magnitude (Circular) Current Controller Limiter

# Arguments
- `I_max::Float64`: Maximum limit on current controller input current (device base), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
"""
mutable struct MagnitudeCurrentLimiter <: InverterLimiter
    "Maximum limit on current controller input current (device base)"
    I_max::Float64
    ext::Dict{String, Any}
end


function MagnitudeCurrentLimiter(; I_max, ext=Dict{String, Any}(), )
    MagnitudeCurrentLimiter(I_max, ext, )
end

# Constructor for demo purposes; non-functional.
function MagnitudeCurrentLimiter(::Nothing)
    MagnitudeCurrentLimiter(;
        I_max=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`MagnitudeCurrentLimiter`](@ref) `I_max`."""
get_I_max(value::MagnitudeCurrentLimiter) = value.I_max
"""Get [`MagnitudeCurrentLimiter`](@ref) `ext`."""
get_ext(value::MagnitudeCurrentLimiter) = value.ext

"""Set [`MagnitudeCurrentLimiter`](@ref) `I_max`."""
set_I_max!(value::MagnitudeCurrentLimiter, val) = value.I_max = val
"""Set [`MagnitudeCurrentLimiter`](@ref) `ext`."""
set_ext!(value::MagnitudeCurrentLimiter, val) = value.ext = val
