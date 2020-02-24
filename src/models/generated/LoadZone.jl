#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct LoadZone <: AggregationTopology
        name::String
        maxactivepower::Float64
        maxreactivepower::Float64
        services::Vector{Service}
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `maxactivepower::Float64`
- `maxreactivepower::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct LoadZone <: AggregationTopology
    name::String
    maxactivepower::Float64
    maxreactivepower::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function LoadZone(name, maxactivepower, maxreactivepower, services=Device[], _forecasts=InfrastructureSystems.Forecasts(), )
    LoadZone(name, maxactivepower, maxreactivepower, services, _forecasts, InfrastructureSystemsInternal(), )
end

function LoadZone(; name, maxactivepower, maxreactivepower, services=Device[], _forecasts=InfrastructureSystems.Forecasts(), )
    LoadZone(name, maxactivepower, maxreactivepower, services, _forecasts, )
end

# Constructor for demo purposes; non-functional.
function LoadZone(::Nothing)
    LoadZone(;
        name="init",
        maxactivepower=0.0,
        maxreactivepower=0.0,
        services=Device[],
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get LoadZone name."""
InfrastructureSystems.get_name(value::LoadZone) = value.name
"""Get LoadZone maxactivepower."""
get_maxactivepower(value::LoadZone) = value.maxactivepower
"""Get LoadZone maxreactivepower."""
get_maxreactivepower(value::LoadZone) = value.maxreactivepower
"""Get LoadZone services."""
get_services(value::LoadZone) = value.services
"""Get LoadZone _forecasts."""
get__forecasts(value::LoadZone) = value._forecasts
"""Get LoadZone internal."""
get_internal(value::LoadZone) = value.internal
