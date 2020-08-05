#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Source <: StaticInjection
        name::String
        available::Bool
        bus::Bus
        active_power::Float64
        reactive_power::Float64
        R_th::Float64
        X_th::Float64
        internal_voltage::Float64
        internal_angle::Float64
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

This struct acts as an infinity bus.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `active_power::Float64`
- `reactive_power::Float64`
- `R_th::Float64`: Source Thevenin resistance, validation range: (0, nothing)
- `X_th::Float64`: Source Thevenin reactance, validation range: (0, nothing)
- `internal_voltage::Float64`: Internal Voltage, validation range: (0, nothing)
- `internal_angle::Float64`: Internal Angle
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Source <: StaticInjection
    name::String
    available::Bool
    bus::Bus
    active_power::Float64
    reactive_power::Float64
    "Source Thevenin resistance"
    R_th::Float64
    "Source Thevenin reactance"
    X_th::Float64
    "Internal Voltage"
    internal_voltage::Float64
    "Internal Angle"
    internal_angle::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Source(name, available, bus, active_power, reactive_power, R_th, X_th, internal_voltage=1.0, internal_angle=0.0, services=Device[], ext=Dict{String, Any}(), )
    Source(name, available, bus, active_power, reactive_power, R_th, X_th, internal_voltage, internal_angle, services, ext, InfrastructureSystemsInternal(), )
end

function Source(; name, available, bus, active_power, reactive_power, R_th, X_th, internal_voltage=1.0, internal_angle=0.0, services=Device[], ext=Dict{String, Any}(), )
    Source(name, available, bus, active_power, reactive_power, R_th, X_th, internal_voltage, internal_angle, services, ext, )
end

# Constructor for demo purposes; non-functional.
function Source(::Nothing)
    Source(;
        name="init",
        available=false,
        bus=Bus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        R_th=0,
        X_th=0,
        internal_voltage=0,
        internal_angle=0,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end


InfrastructureSystems.get_name(value::Source) = value.name
"""Get Source available."""
get_available(value::Source) = value.available
"""Get Source bus."""
get_bus(value::Source) = value.bus
"""Get Source active_power."""
get_active_power(value::Source) = value.active_power
"""Get Source reactive_power."""
get_reactive_power(value::Source) = value.reactive_power
"""Get Source R_th."""
get_R_th(value::Source) = value.R_th
"""Get Source X_th."""
get_X_th(value::Source) = value.X_th
"""Get Source internal_voltage."""
get_internal_voltage(value::Source) = value.internal_voltage
"""Get Source internal_angle."""
get_internal_angle(value::Source) = value.internal_angle
"""Get Source services."""
get_services(value::Source) = value.services
"""Get Source ext."""
get_ext(value::Source) = value.ext
"""Get Source internal."""
get_internal(value::Source) = value.internal


InfrastructureSystems.set_name!(value::Source, val::String) = value.name = val
"""Set Source available."""
set_available!(value::Source, val::Bool) = value.available = val
"""Set Source bus."""
set_bus!(value::Source, val::Bus) = value.bus = val
"""Set Source active_power."""
set_active_power!(value::Source, val::Float64) = value.active_power = val
"""Set Source reactive_power."""
set_reactive_power!(value::Source, val::Float64) = value.reactive_power = val
"""Set Source R_th."""
set_R_th!(value::Source, val::Float64) = value.R_th = val
"""Set Source X_th."""
set_X_th!(value::Source, val::Float64) = value.X_th = val
"""Set Source internal_voltage."""
set_internal_voltage!(value::Source, val::Float64) = value.internal_voltage = val
"""Set Source internal_angle."""
set_internal_angle!(value::Source, val::Float64) = value.internal_angle = val
"""Set Source services."""
set_services!(value::Source, val::Vector{Service}) = value.services = val
"""Set Source ext."""
set_ext!(value::Source, val::Dict{String, Any}) = value.ext = val
"""Set Source internal."""
set_internal!(value::Source, val::InfrastructureSystemsInternal) = value.internal = val
