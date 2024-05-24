#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct MagnitudeOutputCurrentLimiter <: OutputCurrentLimiter
        I_max::Float64
        ext::Dict{String, Any}
    end

Parameters of Magnitude (Circular) Current Controller Limiter. Regulates only the magnitude of the inverter output current.

# Arguments
- `I_max::Float64`: Maximum limit on current controller input current in pu ([`DEVICE_BASE`](@ref per_unit)), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
"""
mutable struct MagnitudeOutputCurrentLimiter <: OutputCurrentLimiter
    "Maximum limit on current controller input current in pu ([`DEVICE_BASE`](@ref per_unit))"
    I_max::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
end


function MagnitudeOutputCurrentLimiter(; I_max, ext=Dict{String, Any}(), )
    MagnitudeOutputCurrentLimiter(I_max, ext, )
end

# Constructor for demo purposes; non-functional.
function MagnitudeOutputCurrentLimiter(::Nothing)
    MagnitudeOutputCurrentLimiter(;
        I_max=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`MagnitudeOutputCurrentLimiter`](@ref) `I_max`."""
get_I_max(value::MagnitudeOutputCurrentLimiter) = value.I_max
"""Get [`MagnitudeOutputCurrentLimiter`](@ref) `ext`."""
get_ext(value::MagnitudeOutputCurrentLimiter) = value.ext

"""Set [`MagnitudeOutputCurrentLimiter`](@ref) `I_max`."""
set_I_max!(value::MagnitudeOutputCurrentLimiter, val) = value.I_max = val
"""Set [`MagnitudeOutputCurrentLimiter`](@ref) `ext`."""
set_ext!(value::MagnitudeOutputCurrentLimiter, val) = value.ext = val
