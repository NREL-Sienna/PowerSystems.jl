#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct Area <: AggregationTopology
        name::String
        peak_active_power::Float64
        peak_reactive_power::Float64
        load_response::Float64
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end

A collection of buses for control purposes.

# Arguments
- `name::String`
- `peak_active_power::Float64`
- `peak_reactive_power::Float64`
- `load_response::Float64`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Area <: AggregationTopology
    name::String
    peak_active_power::Float64
    peak_reactive_power::Float64
    load_response::Float64
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "container for supplemental attributes"
    supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Area(name, peak_active_power=0.0, peak_reactive_power=0.0, load_response=0.0, time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    Area(name, peak_active_power, peak_reactive_power, load_response, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function Area(; name, peak_active_power=0.0, peak_reactive_power=0.0, load_response=0.0, time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    Area(name, peak_active_power, peak_reactive_power, load_response, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function Area(::Nothing)
    Area(;
        name="init",
        peak_active_power=0.0,
        peak_reactive_power=0.0,
        load_response=0.0,
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`Area`](@ref) `name`."""
get_name(value::Area) = value.name
"""Get [`Area`](@ref) `peak_active_power`."""
get_peak_active_power(value::Area) = get_value(value, value.peak_active_power)
"""Get [`Area`](@ref) `peak_reactive_power`."""
get_peak_reactive_power(value::Area) = get_value(value, value.peak_reactive_power)
"""Get [`Area`](@ref) `load_response`."""
get_load_response(value::Area) = value.load_response
"""Get [`Area`](@ref) `time_series_container`."""
get_time_series_container(value::Area) = value.time_series_container
"""Get [`Area`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::Area) = value.supplemental_attributes_container
"""Get [`Area`](@ref) `internal`."""
get_internal(value::Area) = value.internal

"""Set [`Area`](@ref) `peak_active_power`."""
set_peak_active_power!(value::Area, val) = value.peak_active_power = set_value(value, val)
"""Set [`Area`](@ref) `peak_reactive_power`."""
set_peak_reactive_power!(value::Area, val) = value.peak_reactive_power = set_value(value, val)
"""Set [`Area`](@ref) `load_response`."""
set_load_response!(value::Area, val) = value.load_response = val
"""Set [`Area`](@ref) `time_series_container`."""
set_time_series_container!(value::Area, val) = value.time_series_container = val
"""Set [`Area`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::Area, val) = value.supplemental_attributes_container = val
