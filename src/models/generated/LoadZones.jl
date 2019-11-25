#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct LoadZones <: Topology
        number::Int64
        name::String
        buses::Vector{Bus}
        maxactivepower::Float64
        maxreactivepower::Float64
        services::Vector{Service}
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `number::Int64`
- `name::String`
- `buses::Vector{Bus}`
- `maxactivepower::Float64`
- `maxreactivepower::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct LoadZones <: Topology
    number::Int64
    name::String
    buses::Vector{Bus}
    maxactivepower::Float64
    maxreactivepower::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function LoadZones(number, name, buses, maxactivepower, maxreactivepower, services=Device[], _forecasts=InfrastructureSystems.Forecasts(), )
    LoadZones(number, name, buses, maxactivepower, maxreactivepower, services, _forecasts, InfrastructureSystemsInternal(), )
end

function LoadZones(; number, name, buses, maxactivepower, maxreactivepower, services=Device[], _forecasts=InfrastructureSystems.Forecasts(), )
    LoadZones(number, name, buses, maxactivepower, maxreactivepower, services, _forecasts, )
end

# Constructor for demo purposes; non-functional.
function LoadZones(::Nothing)
    LoadZones(;
        number=0,
        name="init",
        buses=[Bus(nothing)],
        maxactivepower=0.0,
        maxreactivepower=0.0,
        services=Device[],
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get LoadZones number."""
get_number(value::LoadZones) = value.number
"""Get LoadZones name."""
get_name(value::LoadZones) = value.name
"""Get LoadZones buses."""
get_buses(value::LoadZones) = value.buses
"""Get LoadZones maxactivepower."""
get_maxactivepower(value::LoadZones) = value.maxactivepower
"""Get LoadZones maxreactivepower."""
get_maxreactivepower(value::LoadZones) = value.maxreactivepower
"""Get LoadZones services."""
get_services(value::LoadZones) = value.services
"""Get LoadZones _forecasts."""
get__forecasts(value::LoadZones) = value._forecasts
"""Get LoadZones internal."""
get_internal(value::LoadZones) = value.internal
