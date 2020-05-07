#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct LoadZone <: AggregationTopology
        name::String
        maxactivepower::Float64
        maxreactivepower::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

A collection of buses for electricity price analysis.

# Arguments
- `name::String`
- `maxactivepower::Float64`
- `maxreactivepower::Float64`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct LoadZone <: AggregationTopology
    name::String
    maxactivepower::Float64
    maxreactivepower::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function LoadZone(name, maxactivepower, maxreactivepower, forecasts=InfrastructureSystems.Forecasts(), )
    LoadZone(name, maxactivepower, maxreactivepower, forecasts, InfrastructureSystemsInternal(), )
end

function LoadZone(; name, maxactivepower, maxreactivepower, forecasts=InfrastructureSystems.Forecasts(), )
    LoadZone(name, maxactivepower, maxreactivepower, forecasts, )
end

# Constructor for demo purposes; non-functional.
function LoadZone(::Nothing)
    LoadZone(;
        name="init",
        maxactivepower=0.0,
        maxreactivepower=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::LoadZone) = value.name
"""Get LoadZone maxactivepower."""
get_maxactivepower(value::LoadZone) = value.maxactivepower
"""Get LoadZone maxreactivepower."""
get_maxreactivepower(value::LoadZone) = value.maxreactivepower

InfrastructureSystems.get_forecasts(value::LoadZone) = value.forecasts
"""Get LoadZone internal."""
get_internal(value::LoadZone) = value.internal


InfrastructureSystems.set_name(value::LoadZone, val) = value.name = val
"""Set LoadZone maxactivepower."""
set_maxactivepower(value::LoadZone, val) = value.maxactivepower = val
"""Set LoadZone maxreactivepower."""
set_maxreactivepower(value::LoadZone, val) = value.maxreactivepower = val

InfrastructureSystems.set_forecasts(value::LoadZone, val) = value.forecasts = val
"""Set LoadZone internal."""
set_internal(value::LoadZone, val) = value.internal = val
