#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct LoadZone <: AggregationTopology
        name::String
        peak_activepower::Float64
        peak_reactivepower::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

A collection of buses for electricity price analysis.

# Arguments
- `name::String`
- `peak_activepower::Float64`
- `peak_reactivepower::Float64`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct LoadZone <: AggregationTopology
    name::String
    peak_activepower::Float64
    peak_reactivepower::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function LoadZone(name, peak_activepower, peak_reactivepower, forecasts=InfrastructureSystems.Forecasts(), )
    LoadZone(name, peak_activepower, peak_reactivepower, forecasts, InfrastructureSystemsInternal(), )
end

function LoadZone(; name, peak_activepower, peak_reactivepower, forecasts=InfrastructureSystems.Forecasts(), )
    LoadZone(name, peak_activepower, peak_reactivepower, forecasts, )
end

# Constructor for demo purposes; non-functional.
function LoadZone(::Nothing)
    LoadZone(;
        name="init",
        peak_activepower=0.0,
        peak_reactivepower=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::LoadZone) = value.name
"""Get LoadZone peak_activepower."""
get_peak_activepower(value::LoadZone) = value.peak_activepower
"""Get LoadZone peak_reactivepower."""
get_peak_reactivepower(value::LoadZone) = value.peak_reactivepower

InfrastructureSystems.get_forecasts(value::LoadZone) = value.forecasts
"""Get LoadZone internal."""
get_internal(value::LoadZone) = value.internal


InfrastructureSystems.set_name!(value::LoadZone, val::String) = value.name = val
"""Set LoadZone peak_activepower."""
set_peak_activepower!(value::LoadZone, val::Float64) = value.peak_activepower = val
"""Set LoadZone peak_reactivepower."""
set_peak_reactivepower!(value::LoadZone, val::Float64) = value.peak_reactivepower = val

InfrastructureSystems.set_forecasts!(value::LoadZone, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set LoadZone internal."""
set_internal!(value::LoadZone, val::InfrastructureSystemsInternal) = value.internal = val
