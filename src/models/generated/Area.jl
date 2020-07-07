#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Area <: AggregationTopology
        name::String
        max_activepower::Float64
        max_reactivepower::Float64
        load_response::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

A collection of buses for control purposes.

# Arguments
- `name::String`
- `max_activepower::Float64`
- `max_reactivepower::Float64`
- `load_response::Float64`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Area <: AggregationTopology
    name::String
    max_activepower::Float64
    max_reactivepower::Float64
    load_response::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Area(name, max_activepower=0.0, max_reactivepower=0.0, load_response=0.0, forecasts=InfrastructureSystems.Forecasts(), )
    Area(name, max_activepower, max_reactivepower, load_response, forecasts, InfrastructureSystemsInternal(), )
end

function Area(; name, max_activepower=0.0, max_reactivepower=0.0, load_response=0.0, forecasts=InfrastructureSystems.Forecasts(), )
    Area(name, max_activepower, max_reactivepower, load_response, forecasts, )
end

# Constructor for demo purposes; non-functional.
function Area(::Nothing)
    Area(;
        name="init",
        max_activepower=0.0,
        max_reactivepower=0.0,
        load_response=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::Area) = value.name
"""Get Area max_activepower."""
get_max_activepower(value::Area) = value.max_activepower
"""Get Area max_reactivepower."""
get_max_reactivepower(value::Area) = value.max_reactivepower
"""Get Area load_response."""
get_load_response(value::Area) = value.load_response

InfrastructureSystems.get_forecasts(value::Area) = value.forecasts
"""Get Area internal."""
get_internal(value::Area) = value.internal


InfrastructureSystems.set_name!(value::Area, val::String) = value.name = val
"""Set Area max_activepower."""
set_max_activepower!(value::Area, val::Float64) = value.max_activepower = val
"""Set Area max_reactivepower."""
set_max_reactivepower!(value::Area, val::Float64) = value.max_reactivepower = val
"""Set Area load_response."""
set_load_response!(value::Area, val::Float64) = value.load_response = val

InfrastructureSystems.set_forecasts!(value::Area, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set Area internal."""
set_internal!(value::Area, val::InfrastructureSystemsInternal) = value.internal = val
