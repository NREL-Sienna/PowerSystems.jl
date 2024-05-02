#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct LoadZone <: AggregationTopology
        name::String
        peak_active_power::Float64
        peak_reactive_power::Float64
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end

A collection of buses for electricity price analysis.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `peak_active_power::Float64`
- `peak_reactive_power::Float64`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data).
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct LoadZone <: AggregationTopology
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    peak_active_power::Float64
    peak_reactive_power::Float64
    "Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data)."
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "container for supplemental attributes"
    supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function LoadZone(name, peak_active_power, peak_reactive_power, time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    LoadZone(name, peak_active_power, peak_reactive_power, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function LoadZone(; name, peak_active_power, peak_reactive_power, time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    LoadZone(name, peak_active_power, peak_reactive_power, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function LoadZone(::Nothing)
    LoadZone(;
        name="init",
        peak_active_power=0.0,
        peak_reactive_power=0.0,
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`LoadZone`](@ref) `name`."""
get_name(value::LoadZone) = value.name
"""Get [`LoadZone`](@ref) `peak_active_power`."""
get_peak_active_power(value::LoadZone) = get_value(value, value.peak_active_power)
"""Get [`LoadZone`](@ref) `peak_reactive_power`."""
get_peak_reactive_power(value::LoadZone) = get_value(value, value.peak_reactive_power)
"""Get [`LoadZone`](@ref) `time_series_container`."""
get_time_series_container(value::LoadZone) = value.time_series_container
"""Get [`LoadZone`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::LoadZone) = value.supplemental_attributes_container
"""Get [`LoadZone`](@ref) `internal`."""
get_internal(value::LoadZone) = value.internal

"""Set [`LoadZone`](@ref) `peak_active_power`."""
set_peak_active_power!(value::LoadZone, val) = value.peak_active_power = set_value(value, val)
"""Set [`LoadZone`](@ref) `peak_reactive_power`."""
set_peak_reactive_power!(value::LoadZone, val) = value.peak_reactive_power = set_value(value, val)
"""Set [`LoadZone`](@ref) `time_series_container`."""
set_time_series_container!(value::LoadZone, val) = value.time_series_container = val
"""Set [`LoadZone`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::LoadZone, val) = value.supplemental_attributes_container = val
