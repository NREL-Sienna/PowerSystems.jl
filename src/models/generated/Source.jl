#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Source <: StaticInjection
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        X_th::Float64
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

This struct acts as an infinity bus.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`
- `reactivepower::Float64`
- `X_th::Float64`: Source Thevenin impedance, validation range: (0, nothing)
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Source <: StaticInjection
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    "Source Thevenin impedance"
    X_th::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Source(name, available, bus, activepower, reactivepower, X_th, services=Device[], ext=Dict{String, Any}(), )
    Source(name, available, bus, activepower, reactivepower, X_th, services, ext, InfrastructureSystemsInternal(), )
end

function Source(; name, available, bus, activepower, reactivepower, X_th, services=Device[], ext=Dict{String, Any}(), )
    Source(name, available, bus, activepower, reactivepower, X_th, services, ext, )
end

# Constructor for demo purposes; non-functional.
function Source(::Nothing)
    Source(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        X_th=0,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end


InfrastructureSystems.get_name(value::Source) = value.name
"""Get Source available."""
get_available(value::Source) = value.available
"""Get Source bus."""
get_bus(value::Source) = value.bus
"""Get Source activepower."""
get_activepower(value::Source) = value.activepower
"""Get Source reactivepower."""
get_reactivepower(value::Source) = value.reactivepower
"""Get Source X_th."""
get_X_th(value::Source) = value.X_th
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
"""Set Source activepower."""
set_activepower!(value::Source, val::Float64) = value.activepower = val
"""Set Source reactivepower."""
set_reactivepower!(value::Source, val::Float64) = value.reactivepower = val
"""Set Source X_th."""
set_X_th!(value::Source, val::Float64) = value.X_th = val
"""Set Source services."""
set_services!(value::Source, val::Vector{Service}) = value.services = val
"""Set Source ext."""
set_ext!(value::Source, val::Dict{String, Any}) = value.ext = val
"""Set Source internal."""
set_internal!(value::Source, val::InfrastructureSystemsInternal) = value.internal = val
