#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HydroFix <: HydroGen
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
- `reactivepower::Float64`
- `tech::TechHydro`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroFix <: HydroGen
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

function HydroFix(name, available, bus, activepower, reactivepower, tech, services=Device[], ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    HydroFix(name, available, bus, activepower, reactivepower, tech, services, ext, _forecasts, InfrastructureSystemsInternal(), )
end

function HydroFix(; name, available, bus, activepower, reactivepower, tech, services=Device[], ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    HydroFix(name, available, bus, activepower, reactivepower, tech, services, ext, _forecasts, )
end

# Constructor for demo purposes; non-functional.
function HydroFix(::Nothing)
    HydroFix(;
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

"""Get HydroFix name."""
get_name(value::HydroFix) = value.name
"""Get HydroFix available."""
get_available(value::HydroFix) = value.available
"""Get HydroFix bus."""
get_bus(value::HydroFix) = value.bus
"""Get HydroFix activepower."""
get_activepower(value::HydroFix) = value.activepower
"""Get HydroFix reactivepower."""
get_reactivepower(value::HydroFix) = value.reactivepower
"""Get HydroFix tech."""
get_tech(value::HydroFix) = value.tech
"""Get HydroFix services."""
get_services(value::HydroFix) = value.services
"""Get HydroFix ext."""
get_ext(value::HydroFix) = value.ext
"""Get HydroFix _forecasts."""
get__forecasts(value::HydroFix) = value._forecasts
"""Get HydroFix internal."""
get_internal(value::HydroFix) = value.internal
