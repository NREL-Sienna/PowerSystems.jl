#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Area <: AggregationTopology
        name::String
        maxactivepower::Float64
        maxreactivepower::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

A collection of buses for control purposes.

# Arguments
- `name::String`
- `maxactivepower::Float64`
- `maxreactivepower::Float64`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Area <: AggregationTopology
    name::String
    maxactivepower::Float64
    maxreactivepower::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Area(name, maxactivepower=0.0, maxreactivepower=0.0, forecasts=InfrastructureSystems.Forecasts(), )
    Area(name, maxactivepower, maxreactivepower, forecasts, InfrastructureSystemsInternal(), )
end

function Area(; name, maxactivepower=0.0, maxreactivepower=0.0, forecasts=InfrastructureSystems.Forecasts(), )
    Area(name, maxactivepower, maxreactivepower, forecasts, )
end

# Constructor for demo purposes; non-functional.
function Area(::Nothing)
    Area(;
        name="init",
        maxactivepower=0.0,
        maxreactivepower=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::Area) = value.name
"""Get Area maxactivepower."""
get_maxactivepower(value::Area) = value.maxactivepower
"""Get Area maxreactivepower."""
get_maxreactivepower(value::Area) = value.maxreactivepower

InfrastructureSystems.get_forecasts(value::Area) = value.forecasts
"""Get Area internal."""
get_internal(value::Area) = value.internal
