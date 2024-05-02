#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct InterruptiblePowerLoad <: ControllableLoad
        name::String
        available::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        max_active_power::Float64
        max_reactive_power::Float64
        base_power::Float64
        operation_cost::TwoPartCost
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon.
- `bus::ACBus`: Bus that this component is connected to
- `active_power::Float64`
- `reactive_power::Float64`
- `max_active_power::Float64`
- `max_reactive_power::Float64`
- `base_power::Float64`: Base power of the unit (MVA), validation range: `(0, nothing)`, action if invalid: `warn`
- `operation_cost::TwoPartCost`: Operation Cost of Generation [`TwoPartCost`](@ref)
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data).
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct InterruptiblePowerLoad <: ControllableLoad
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon."
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    active_power::Float64
    reactive_power::Float64
    max_active_power::Float64
    max_reactive_power::Float64
    "Base power of the unit (MVA)"
    base_power::Float64
    "Operation Cost of Generation [`TwoPartCost`](@ref)"
    operation_cost::TwoPartCost
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data)."
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "container for supplemental attributes"
    supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function InterruptiblePowerLoad(name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    InterruptiblePowerLoad(name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services, dynamic_injector, ext, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function InterruptiblePowerLoad(; name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    InterruptiblePowerLoad(name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services, dynamic_injector, ext, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function InterruptiblePowerLoad(::Nothing)
    InterruptiblePowerLoad(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        max_active_power=0.0,
        max_reactive_power=0.0,
        base_power=0.0,
        operation_cost=TwoPartCost(nothing),
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`InterruptiblePowerLoad`](@ref) `name`."""
get_name(value::InterruptiblePowerLoad) = value.name
"""Get [`InterruptiblePowerLoad`](@ref) `available`."""
get_available(value::InterruptiblePowerLoad) = value.available
"""Get [`InterruptiblePowerLoad`](@ref) `bus`."""
get_bus(value::InterruptiblePowerLoad) = value.bus
"""Get [`InterruptiblePowerLoad`](@ref) `active_power`."""
get_active_power(value::InterruptiblePowerLoad) = get_value(value, value.active_power)
"""Get [`InterruptiblePowerLoad`](@ref) `reactive_power`."""
get_reactive_power(value::InterruptiblePowerLoad) = get_value(value, value.reactive_power)
"""Get [`InterruptiblePowerLoad`](@ref) `max_active_power`."""
get_max_active_power(value::InterruptiblePowerLoad) = get_value(value, value.max_active_power)
"""Get [`InterruptiblePowerLoad`](@ref) `max_reactive_power`."""
get_max_reactive_power(value::InterruptiblePowerLoad) = get_value(value, value.max_reactive_power)
"""Get [`InterruptiblePowerLoad`](@ref) `base_power`."""
get_base_power(value::InterruptiblePowerLoad) = value.base_power
"""Get [`InterruptiblePowerLoad`](@ref) `operation_cost`."""
get_operation_cost(value::InterruptiblePowerLoad) = value.operation_cost
"""Get [`InterruptiblePowerLoad`](@ref) `services`."""
get_services(value::InterruptiblePowerLoad) = value.services
"""Get [`InterruptiblePowerLoad`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::InterruptiblePowerLoad) = value.dynamic_injector
"""Get [`InterruptiblePowerLoad`](@ref) `ext`."""
get_ext(value::InterruptiblePowerLoad) = value.ext
"""Get [`InterruptiblePowerLoad`](@ref) `time_series_container`."""
get_time_series_container(value::InterruptiblePowerLoad) = value.time_series_container
"""Get [`InterruptiblePowerLoad`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::InterruptiblePowerLoad) = value.supplemental_attributes_container
"""Get [`InterruptiblePowerLoad`](@ref) `internal`."""
get_internal(value::InterruptiblePowerLoad) = value.internal

"""Set [`InterruptiblePowerLoad`](@ref) `available`."""
set_available!(value::InterruptiblePowerLoad, val) = value.available = val
"""Set [`InterruptiblePowerLoad`](@ref) `bus`."""
set_bus!(value::InterruptiblePowerLoad, val) = value.bus = val
"""Set [`InterruptiblePowerLoad`](@ref) `active_power`."""
set_active_power!(value::InterruptiblePowerLoad, val) = value.active_power = set_value(value, val)
"""Set [`InterruptiblePowerLoad`](@ref) `reactive_power`."""
set_reactive_power!(value::InterruptiblePowerLoad, val) = value.reactive_power = set_value(value, val)
"""Set [`InterruptiblePowerLoad`](@ref) `max_active_power`."""
set_max_active_power!(value::InterruptiblePowerLoad, val) = value.max_active_power = set_value(value, val)
"""Set [`InterruptiblePowerLoad`](@ref) `max_reactive_power`."""
set_max_reactive_power!(value::InterruptiblePowerLoad, val) = value.max_reactive_power = set_value(value, val)
"""Set [`InterruptiblePowerLoad`](@ref) `base_power`."""
set_base_power!(value::InterruptiblePowerLoad, val) = value.base_power = val
"""Set [`InterruptiblePowerLoad`](@ref) `operation_cost`."""
set_operation_cost!(value::InterruptiblePowerLoad, val) = value.operation_cost = val
"""Set [`InterruptiblePowerLoad`](@ref) `services`."""
set_services!(value::InterruptiblePowerLoad, val) = value.services = val
"""Set [`InterruptiblePowerLoad`](@ref) `ext`."""
set_ext!(value::InterruptiblePowerLoad, val) = value.ext = val
"""Set [`InterruptiblePowerLoad`](@ref) `time_series_container`."""
set_time_series_container!(value::InterruptiblePowerLoad, val) = value.time_series_container = val
"""Set [`InterruptiblePowerLoad`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::InterruptiblePowerLoad, val) = value.supplemental_attributes_container = val
