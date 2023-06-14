#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TransmissionInterface <: Service
        name::String
        available::Bool
        active_power_flow_limits::MinMax
        violation_penalty::Float64
        direction_mapping::Dict{String, Int}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

A collection of branches that make up an interface or corridor for the transfer of power.

# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow_limits::MinMax`
- `violation_penalty::Float64`: Penalty for violating the flow limits in the interface
- `direction_mapping::Dict{String, Int}`: Map to set of multiplier to the flow in the line for cases when the line has a reverse direction with respect to the interface
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TransmissionInterface <: Service
    name::String
    available::Bool
    active_power_flow_limits::MinMax
    "Penalty for violating the flow limits in the interface"
    violation_penalty::Float64
    "Map to set of multiplier to the flow in the line for cases when the line has a reverse direction with respect to the interface"
    direction_mapping::Dict{String, Int}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TransmissionInterface(name, available, active_power_flow_limits, violation_penalty=INFINITE_COST, direction_mapping=Dict{String, Int}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    TransmissionInterface(name, available, active_power_flow_limits, violation_penalty, direction_mapping, time_series_container, InfrastructureSystemsInternal(), )
end

function TransmissionInterface(; name, available, active_power_flow_limits, violation_penalty=INFINITE_COST, direction_mapping=Dict{String, Int}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    TransmissionInterface(name, available, active_power_flow_limits, violation_penalty, direction_mapping, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function TransmissionInterface(::Nothing)
    TransmissionInterface(;
        name="init",
        available=false,
        active_power_flow_limits=(min=0.0, max=0.0),
        violation_penalty=0.0,
        direction_mapping=Dict{String, Int}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`TransmissionInterface`](@ref) `name`."""
get_name(value::TransmissionInterface) = value.name
"""Get [`TransmissionInterface`](@ref) `available`."""
get_available(value::TransmissionInterface) = value.available
"""Get [`TransmissionInterface`](@ref) `active_power_flow_limits`."""
get_active_power_flow_limits(value::TransmissionInterface) = get_value(value, value.active_power_flow_limits)
"""Get [`TransmissionInterface`](@ref) `violation_penalty`."""
get_violation_penalty(value::TransmissionInterface) = value.violation_penalty
"""Get [`TransmissionInterface`](@ref) `direction_mapping`."""
get_direction_mapping(value::TransmissionInterface) = value.direction_mapping
"""Get [`TransmissionInterface`](@ref) `time_series_container`."""
get_time_series_container(value::TransmissionInterface) = value.time_series_container
"""Get [`TransmissionInterface`](@ref) `internal`."""
get_internal(value::TransmissionInterface) = value.internal

"""Set [`TransmissionInterface`](@ref) `available`."""
set_available!(value::TransmissionInterface, val) = value.available = val
"""Set [`TransmissionInterface`](@ref) `active_power_flow_limits`."""
set_active_power_flow_limits!(value::TransmissionInterface, val) = value.active_power_flow_limits = set_value(value, val)
"""Set [`TransmissionInterface`](@ref) `violation_penalty`."""
set_violation_penalty!(value::TransmissionInterface, val) = value.violation_penalty = val
"""Set [`TransmissionInterface`](@ref) `direction_mapping`."""
set_direction_mapping!(value::TransmissionInterface, val) = value.direction_mapping = val
"""Set [`TransmissionInterface`](@ref) `time_series_container`."""
set_time_series_container!(value::TransmissionInterface, val) = value.time_series_container = val
