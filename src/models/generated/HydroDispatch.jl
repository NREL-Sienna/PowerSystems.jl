#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HydroDispatch <: HydroGen
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        tech::TechHydro
        services::Vector{Service}
        ext::Dict{String, Any}
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`
- `reactivepower::Float64`, validation range: tech.reactivepowerlimits, action if invalid: warn
- `tech::TechHydro`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroDispatch <: HydroGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechHydro
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HydroDispatch(name, available, bus, activepower, reactivepower, tech, services=Device[], ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    HydroDispatch(name, available, bus, activepower, reactivepower, tech, services, ext, _forecasts, InfrastructureSystemsInternal(), )
end

function HydroDispatch(; name, available, bus, activepower, reactivepower, tech, services=Device[], ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    HydroDispatch(name, available, bus, activepower, reactivepower, tech, services, ext, _forecasts, )
end

# Constructor for demo purposes; non-functional.
function HydroDispatch(::Nothing)
    HydroDispatch(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechHydro(nothing),
        services=Device[],
        ext=Dict{String, Any}(),
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get HydroDispatch name."""
get_name(value::HydroDispatch) = value.name
"""Get HydroDispatch available."""
get_available(value::HydroDispatch) = value.available
"""Get HydroDispatch bus."""
get_bus(value::HydroDispatch) = value.bus
"""Get HydroDispatch activepower."""
get_activepower(value::HydroDispatch) = value.activepower
"""Get HydroDispatch reactivepower."""
get_reactivepower(value::HydroDispatch) = value.reactivepower
"""Get HydroDispatch tech."""
get_tech(value::HydroDispatch) = value.tech
"""Get HydroDispatch services."""
get_services(value::HydroDispatch) = value.services
"""Get HydroDispatch ext."""
get_ext(value::HydroDispatch) = value.ext
"""Get HydroDispatch _forecasts."""
get__forecasts(value::HydroDispatch) = value._forecasts
"""Get HydroDispatch internal."""
get_internal(value::HydroDispatch) = value.internal
