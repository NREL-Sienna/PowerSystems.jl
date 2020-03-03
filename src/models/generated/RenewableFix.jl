#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RenewableFix <: RenewableGen
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        tech::TechRenewable
        services::Vector{Service}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for fixed renewable generation technologies.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`
- `reactivepower::Float64`
- `tech::TechRenewable`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RenewableFix <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechRenewable
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function RenewableFix(name, available, bus, activepower, reactivepower, tech, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableFix(name, available, bus, activepower, reactivepower, tech, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function RenewableFix(; name, available, bus, activepower, reactivepower, tech, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableFix(name, available, bus, activepower, reactivepower, tech, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function RenewableFix(::Nothing)
    RenewableFix(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechRenewable(nothing),
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::RenewableFix) = value.name
"""Get RenewableFix available."""
get_available(value::RenewableFix) = value.available
"""Get RenewableFix bus."""
get_bus(value::RenewableFix) = value.bus
"""Get RenewableFix activepower."""
get_activepower(value::RenewableFix) = value.activepower
"""Get RenewableFix reactivepower."""
get_reactivepower(value::RenewableFix) = value.reactivepower
"""Get RenewableFix tech."""
get_tech(value::RenewableFix) = value.tech
"""Get RenewableFix services."""
get_services(value::RenewableFix) = value.services
"""Get RenewableFix ext."""
get_ext(value::RenewableFix) = value.ext

InfrastructureSystems.get_forecasts(value::RenewableFix) = value.forecasts
"""Get RenewableFix internal."""
get_internal(value::RenewableFix) = value.internal
