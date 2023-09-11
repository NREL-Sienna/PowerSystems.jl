#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct InstantaneousCurrentLimiter <: InverterLimiter
        Id_max::Float64
        Iq_max::Float64
        ext::Dict{String, Any}
    end

Parameters of Instantaneous (Square) Current Controller Limiter

# Arguments
- `Id_max::Float64`: Maximum limit on d-axis current controller input current (device base), validation range: `(0, nothing)`
- `Iq_max::Float64`: Maximum limit on d-axis current controller input current (device base), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
"""
mutable struct InstantaneousCurrentLimiter <: InverterLimiter
    "Maximum limit on d-axis current controller input current (device base)"
    Id_max::Float64
    "Maximum limit on d-axis current controller input current (device base)"
    Iq_max::Float64
    ext::Dict{String, Any}
end


function InstantaneousCurrentLimiter(; Id_max, Iq_max, ext=Dict{String, Any}(), )
    InstantaneousCurrentLimiter(Id_max, Iq_max, ext, )
end

# Constructor for demo purposes; non-functional.
function InstantaneousCurrentLimiter(::Nothing)
    InstantaneousCurrentLimiter(;
        Id_max=0,
        Iq_max=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`InstantaneousCurrentLimiter`](@ref) `Id_max`."""
get_Id_max(value::InstantaneousCurrentLimiter) = value.Id_max
"""Get [`InstantaneousCurrentLimiter`](@ref) `Iq_max`."""
get_Iq_max(value::InstantaneousCurrentLimiter) = value.Iq_max
"""Get [`InstantaneousCurrentLimiter`](@ref) `ext`."""
get_ext(value::InstantaneousCurrentLimiter) = value.ext

"""Set [`InstantaneousCurrentLimiter`](@ref) `Id_max`."""
set_Id_max!(value::InstantaneousCurrentLimiter, val) = value.Id_max = val
"""Set [`InstantaneousCurrentLimiter`](@ref) `Iq_max`."""
set_Iq_max!(value::InstantaneousCurrentLimiter, val) = value.Iq_max = val
"""Set [`InstantaneousCurrentLimiter`](@ref) `ext`."""
set_ext!(value::InstantaneousCurrentLimiter, val) = value.ext = val
