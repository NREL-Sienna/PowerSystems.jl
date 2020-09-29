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
- `R_th::Float64`: Source Thevenin resistance, validation range: `(0, nothing)`
- `X_th::Float64`: Source Thevenin reactance, validation range: `(0, nothing)`
- `internal_voltage::Float64`: Internal Voltage, validation range: `(0, nothing)`
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

function Source(; name, available, bus, active_power, reactive_power, R_th, X_th, internal_voltage=1.0, internal_angle=0.0, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    Source(name, available, bus, active_power, reactive_power, R_th, X_th, internal_voltage, internal_angle, services, ext, internal, )
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
"""Get [`Source`](@ref) `available`."""
get_available(value::Source) = value.available
"""Get [`Source`](@ref) `bus`."""
get_bus(value::Source) = value.bus
"""Get [`Source`](@ref) `active_power`."""
get_active_power(value::Source) = value.active_power
"""Get [`Source`](@ref) `reactive_power`."""
get_reactive_power(value::Source) = value.reactive_power
"""Get [`Source`](@ref) `R_th`."""
get_R_th(value::Source) = value.R_th
"""Get [`Source`](@ref) `X_th`."""
get_X_th(value::Source) = value.X_th
"""Get [`Source`](@ref) `internal_voltage`."""
get_internal_voltage(value::Source) = value.internal_voltage
"""Get [`Source`](@ref) `internal_angle`."""
get_internal_angle(value::Source) = value.internal_angle
"""Get [`Source`](@ref) `services`."""
get_services(value::Source) = value.services
"""Get [`Source`](@ref) `ext`."""
get_ext(value::Source) = value.ext
"""Get [`Source`](@ref) `internal`."""
get_internal(value::Source) = value.internal


InfrastructureSystems.set_name!(value::Source, val) = value.name = val
"""Set [`Source`](@ref) `available`."""
set_available!(value::Source, val) = value.available = val
"""Set [`Source`](@ref) `bus`."""
set_bus!(value::Source, val) = value.bus = val
"""Set [`Source`](@ref) `active_power`."""
set_active_power!(value::Source, val) = value.active_power = val
"""Set [`Source`](@ref) `reactive_power`."""
set_reactive_power!(value::Source, val) = value.reactive_power = val
"""Set [`Source`](@ref) `R_th`."""
set_R_th!(value::Source, val) = value.R_th = val
"""Set [`Source`](@ref) `X_th`."""
set_X_th!(value::Source, val) = value.X_th = val
"""Set [`Source`](@ref) `internal_voltage`."""
set_internal_voltage!(value::Source, val) = value.internal_voltage = val
"""Set [`Source`](@ref) `internal_angle`."""
set_internal_angle!(value::Source, val) = value.internal_angle = val
"""Set [`Source`](@ref) `services`."""
set_services!(value::Source, val) = value.services = val
"""Set [`Source`](@ref) `ext`."""
set_ext!(value::Source, val) = value.ext = val
"""Set [`Source`](@ref) `internal`."""
set_internal!(value::Source, val) = value.internal = val

