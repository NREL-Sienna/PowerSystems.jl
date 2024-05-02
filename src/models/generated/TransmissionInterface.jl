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
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end

A collection of branches that make up an interface or corridor for the transfer of power.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon.
- `active_power_flow_limits::MinMax`
- `violation_penalty::Float64`: Penalty for violating the flow limits in the interface
- `direction_mapping::Dict{String, Int}`: Map to set of multiplier to the flow in the line for cases when the line has a reverse direction with respect to the interface
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data).
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct TransmissionInterface <: Service
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon."
    available::Bool
    active_power_flow_limits::MinMax
    "Penalty for violating the flow limits in the interface"
    violation_penalty::Float64
    "Map to set of multiplier to the flow in the line for cases when the line has a reverse direction with respect to the interface"
    direction_mapping::Dict{String, Int}
    "Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data)."
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "container for supplemental attributes"
    supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function TransmissionInterface(name, available, active_power_flow_limits, violation_penalty=INFINITE_COST, direction_mapping=Dict{String, Int}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    TransmissionInterface(name, available, active_power_flow_limits, violation_penalty, direction_mapping, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function TransmissionInterface(; name, available, active_power_flow_limits, violation_penalty=INFINITE_COST, direction_mapping=Dict{String, Int}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    TransmissionInterface(name, available, active_power_flow_limits, violation_penalty, direction_mapping, time_series_container, supplemental_attributes_container, internal, )
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
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
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
"""Get [`TransmissionInterface`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::TransmissionInterface) = value.supplemental_attributes_container
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
"""Set [`TransmissionInterface`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::TransmissionInterface, val) = value.supplemental_attributes_container = val
