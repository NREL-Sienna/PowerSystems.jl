#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct LoadZone <: AggregationTopology
        name::String
        peak_active_power::Float64
        peak_reactive_power::Float64
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

A collection of buses for electricity price analysis.

# Arguments
- `name::String`
- `peak_active_power::Float64`
- `peak_reactive_power::Float64`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct LoadZone <: AggregationTopology
    name::String
    peak_active_power::Float64
    peak_reactive_power::Float64
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function LoadZone(name, peak_active_power, peak_reactive_power, time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    LoadZone(name, peak_active_power, peak_reactive_power, time_series_container, InfrastructureSystemsInternal(), )
end

function LoadZone(; name, peak_active_power, peak_reactive_power, time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    LoadZone(name, peak_active_power, peak_reactive_power, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function LoadZone(::Nothing)
    LoadZone(;
        name="init",
        peak_active_power=0.0,
        peak_reactive_power=0.0,
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end


InfrastructureSystems.get_name(value::LoadZone) = value.name
"""Get [`LoadZone`](@ref) `peak_active_power`."""
get_peak_active_power(value::LoadZone) = value.peak_active_power
"""Get [`LoadZone`](@ref) `peak_reactive_power`."""
get_peak_reactive_power(value::LoadZone) = value.peak_reactive_power

InfrastructureSystems.get_time_series_container(value::LoadZone) = value.time_series_container
"""Get [`LoadZone`](@ref) `internal`."""
get_internal(value::LoadZone) = value.internal


InfrastructureSystems.set_name!(value::LoadZone, val) = value.name = val
"""Set [`LoadZone`](@ref) `peak_active_power`."""
set_peak_active_power!(value::LoadZone, val) = value.peak_active_power = val
"""Set [`LoadZone`](@ref) `peak_reactive_power`."""
set_peak_reactive_power!(value::LoadZone, val) = value.peak_reactive_power = val

InfrastructureSystems.set_time_series_container!(value::LoadZone, val) = value.time_series_container = val

