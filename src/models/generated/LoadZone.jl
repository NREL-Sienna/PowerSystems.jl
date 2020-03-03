#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct LoadZone <: AggregationTopology
        name::String
        maxactivepower::Float64
        maxreactivepower::Float64
        services::Vector{Service}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `maxactivepower::Float64`
- `maxreactivepower::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct LoadZone <: AggregationTopology
    name::String
    maxactivepower::Float64
    maxreactivepower::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function LoadZone(name, maxactivepower, maxreactivepower, services=Device[], forecasts=InfrastructureSystems.Forecasts(), )
    LoadZone(name, maxactivepower, maxreactivepower, services, forecasts, InfrastructureSystemsInternal(), )
end

function LoadZone(; name, maxactivepower, maxreactivepower, services=Device[], forecasts=InfrastructureSystems.Forecasts(), )
    LoadZone(name, maxactivepower, maxreactivepower, services, forecasts, )
end

# Constructor for demo purposes; non-functional.
function LoadZone(::Nothing)
    LoadZone(;
        name="init",
        maxactivepower=0.0,
        maxreactivepower=0.0,
        services=Device[],
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::LoadZone) = value.name
"""Get LoadZone maxactivepower."""
get_maxactivepower(value::LoadZone) = value.maxactivepower
"""Get LoadZone maxreactivepower."""
get_maxreactivepower(value::LoadZone) = value.maxreactivepower
"""Get LoadZone services."""
get_services(value::LoadZone) = value.services

InfrastructureSystems.get_forecasts(value::LoadZone) = value.forecasts
"""Get LoadZone internal."""
get_internal(value::LoadZone) = value.internal
