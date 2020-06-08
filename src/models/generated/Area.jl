#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Area <: AggregationTopology
        name::String
        maxactivepower::Float64
        maxreactivepower::Float64
        load_response::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

A collection of buses for control purposes.

# Arguments
- `name::String`
- `maxactivepower::Float64`
- `maxreactivepower::Float64`
- `load_response::Float64`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Area <: AggregationTopology
    name::String
    maxactivepower::Float64
    maxreactivepower::Float64
    load_response::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Area(name, maxactivepower=0.0, maxreactivepower=0.0, load_response=0.0, forecasts=InfrastructureSystems.Forecasts(), )
    Area(name, maxactivepower, maxreactivepower, load_response, forecasts, InfrastructureSystemsInternal(), )
end

function Area(; name, maxactivepower=0.0, maxreactivepower=0.0, load_response=0.0, forecasts=InfrastructureSystems.Forecasts(), )
    Area(name, maxactivepower, maxreactivepower, load_response, forecasts, )
end

# Constructor for demo purposes; non-functional.
function Area(::Nothing)
    Area(;
        name="init",
        maxactivepower=0.0,
        maxreactivepower=0.0,
        load_response=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::Area) = value.name
"""Get Area maxactivepower."""
get_maxactivepower(value::Area) = value.maxactivepower
"""Get Area maxreactivepower."""
get_maxreactivepower(value::Area) = value.maxreactivepower
"""Get Area load_response."""
get_load_response(value::Area) = value.load_response

InfrastructureSystems.get_forecasts(value::Area) = value.forecasts
"""Get Area internal."""
get_internal(value::Area) = value.internal


InfrastructureSystems.set_name!(value::Area, val::String) = value.name = val
"""Set Area maxactivepower."""
set_maxactivepower!(value::Area, val::Float64) = value.maxactivepower = val
"""Set Area maxreactivepower."""
set_maxreactivepower!(value::Area, val::Float64) = value.maxreactivepower = val
"""Set Area load_response."""
set_load_response!(value::Area, val::Float64) = value.load_response = val

InfrastructureSystems.set_forecasts!(value::Area, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set Area internal."""
set_internal!(value::Area, val::InfrastructureSystemsInternal) = value.internal = val
