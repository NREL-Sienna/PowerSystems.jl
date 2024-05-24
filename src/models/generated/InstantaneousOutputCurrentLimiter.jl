#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct InstantaneousOutputCurrentLimiter <: OutputCurrentLimiter
        Id_max::Float64
        Iq_max::Float64
        ext::Dict{String, Any}
    end

Parameters of Instantaneous (Square) Current Controller Limiter. Regulates inverter output current on the d and q axis separately.

# Arguments
- `Id_max::Float64`: Maximum limit on d-axis current controller input current in pu ([`DEVICE_BASE`](@ref per_unit)), validation range: `(0, nothing)`
- `Iq_max::Float64`: Maximum limit on d-axis current controller input current in pu ([`DEVICE_BASE`](@ref per_unit)), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
"""
mutable struct InstantaneousOutputCurrentLimiter <: OutputCurrentLimiter
    "Maximum limit on d-axis current controller input current in pu ([`DEVICE_BASE`](@ref per_unit))"
    Id_max::Float64
    "Maximum limit on d-axis current controller input current in pu ([`DEVICE_BASE`](@ref per_unit))"
    Iq_max::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
end


function InstantaneousOutputCurrentLimiter(; Id_max, Iq_max, ext=Dict{String, Any}(), )
    InstantaneousOutputCurrentLimiter(Id_max, Iq_max, ext, )
end

# Constructor for demo purposes; non-functional.
function InstantaneousOutputCurrentLimiter(::Nothing)
    InstantaneousOutputCurrentLimiter(;
        Id_max=0,
        Iq_max=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`InstantaneousOutputCurrentLimiter`](@ref) `Id_max`."""
get_Id_max(value::InstantaneousOutputCurrentLimiter) = value.Id_max
"""Get [`InstantaneousOutputCurrentLimiter`](@ref) `Iq_max`."""
get_Iq_max(value::InstantaneousOutputCurrentLimiter) = value.Iq_max
"""Get [`InstantaneousOutputCurrentLimiter`](@ref) `ext`."""
get_ext(value::InstantaneousOutputCurrentLimiter) = value.ext

"""Set [`InstantaneousOutputCurrentLimiter`](@ref) `Id_max`."""
set_Id_max!(value::InstantaneousOutputCurrentLimiter, val) = value.Id_max = val
"""Set [`InstantaneousOutputCurrentLimiter`](@ref) `Iq_max`."""
set_Iq_max!(value::InstantaneousOutputCurrentLimiter, val) = value.Iq_max = val
"""Set [`InstantaneousOutputCurrentLimiter`](@ref) `ext`."""
set_ext!(value::InstantaneousOutputCurrentLimiter, val) = value.ext = val
