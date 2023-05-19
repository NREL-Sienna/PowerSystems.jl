#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TransmissonInterface <: Service
        name::String
        active_power_flow_limits::MinMax
        direction_mapping::Dict{String, Int}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

A collection of branches that make up an interface or corridor for the transfer of power.

# Arguments
- `name::String`
- `active_power_flow_limits::MinMax`
- `direction_mapping::Dict{String, Int}`: Map to set of multiplier to the flow in the line for cases when the line has a reverse direction with respect to the interface
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TransmissonInterface <: Service
    name::String
    active_power_flow_limits::MinMax
    "Map to set of multiplier to the flow in the line for cases when the line has a reverse direction with respect to the interface"
    direction_mapping::Dict{String, Int}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TransmissonInterface(name, active_power_flow_limits, direction_mapping=Dict{String, Int}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    TransmissonInterface(name, active_power_flow_limits, direction_mapping, time_series_container, InfrastructureSystemsInternal(), )
end

function TransmissonInterface(; name, active_power_flow_limits, direction_mapping=Dict{String, Int}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    TransmissonInterface(name, active_power_flow_limits, direction_mapping, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function TransmissonInterface(::Nothing)
    TransmissonInterface(;
        name="init",
        active_power_flow_limits=(min=0.0, max=0.0),
        direction_mapping=Dict{String, Int}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`TransmissonInterface`](@ref) `name`."""
get_name(value::TransmissonInterface) = value.name
"""Get [`TransmissonInterface`](@ref) `active_power_flow_limits`."""
get_active_power_flow_limits(value::TransmissonInterface) = get_value(value, value.active_power_flow_limits)
"""Get [`TransmissonInterface`](@ref) `direction_mapping`."""
get_direction_mapping(value::TransmissonInterface) = value.direction_mapping
"""Get [`TransmissonInterface`](@ref) `time_series_container`."""
get_time_series_container(value::TransmissonInterface) = value.time_series_container
"""Get [`TransmissonInterface`](@ref) `internal`."""
get_internal(value::TransmissonInterface) = value.internal

"""Set [`TransmissonInterface`](@ref) `active_power_flow_limits`."""
set_active_power_flow_limits!(value::TransmissonInterface, val) = value.active_power_flow_limits = set_value(value, val)
"""Set [`TransmissonInterface`](@ref) `direction_mapping`."""
set_direction_mapping!(value::TransmissonInterface, val) = value.direction_mapping = val
"""Set [`TransmissonInterface`](@ref) `time_series_container`."""
set_time_series_container!(value::TransmissonInterface, val) = value.time_series_container = val
