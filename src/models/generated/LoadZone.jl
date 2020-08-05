#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct LoadZone <: AggregationTopology
        name::String
        peak_active_power::Float64
        peak_reactive_power::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

A collection of buses for electricity price analysis.

# Arguments
- `name::String`
- `peak_active_power::Float64`
- `peak_reactive_power::Float64`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct LoadZone <: AggregationTopology
    name::String
    peak_active_power::Float64
    peak_reactive_power::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function LoadZone(name, peak_active_power, peak_reactive_power, forecasts=InfrastructureSystems.Forecasts(), )
    LoadZone(name, peak_active_power, peak_reactive_power, forecasts, InfrastructureSystemsInternal(), )
end

function LoadZone(; name, peak_active_power, peak_reactive_power, forecasts=InfrastructureSystems.Forecasts(), )
    LoadZone(name, peak_active_power, peak_reactive_power, forecasts, )
end

# Constructor for demo purposes; non-functional.
function LoadZone(::Nothing)
    LoadZone(;
        name="init",
        peak_active_power=0.0,
        peak_reactive_power=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::LoadZone) = value.name
"""Get LoadZone peak_active_power."""
get_peak_active_power(value::LoadZone) = value.peak_active_power
"""Get LoadZone peak_reactive_power."""
get_peak_reactive_power(value::LoadZone) = value.peak_reactive_power

InfrastructureSystems.get_forecasts(value::LoadZone) = value.forecasts
"""Get LoadZone internal."""
get_internal(value::LoadZone) = value.internal


InfrastructureSystems.set_name!(value::LoadZone, val) = value.name = val
"""Set LoadZone peak_active_power."""
set_peak_active_power!(value::LoadZone, val) = value.peak_active_power = val
"""Set LoadZone peak_reactive_power."""
set_peak_reactive_power!(value::LoadZone, val) = value.peak_reactive_power = val

InfrastructureSystems.set_forecasts!(value::LoadZone, val) = value.forecasts = val
"""Set LoadZone internal."""
set_internal!(value::LoadZone, val) = value.internal = val
