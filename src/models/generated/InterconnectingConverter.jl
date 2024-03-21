#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct InterconnectingConverter <: StaticInjection
        name::String
        available::Bool
        bus::ACBus
        dc_bus::DCBus
        active_power::Float64
        rating::Float64
        active_power_limits::MinMax
        base_power::Float64
        operation_cost::OperationalCost
        efficiency::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end

Interconnecting Power Converter (IPC) for transforming power from an ACBus to a DCBus

# Arguments
- `name::String`
- `available::Bool`
- `bus::ACBus`
- `dc_bus::DCBus`
- `active_power::Float64`: Active Power on the DCSide, validation range: `active_power_limits`, action if invalid: `warn`
- `rating::Float64`: Thermal limited MVA Power Output of the converter. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `active_power_limits::MinMax`
- `base_power::Float64`: Base power of the converter in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `operation_cost::OperationalCost`: Operation Cost of Generation [`OperationalCost`](@ref)
- `efficiency::Float64`: Conversion efficiency from AC Power to DC Power
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct InterconnectingConverter <: StaticInjection
    name::String
    available::Bool
    bus::ACBus
    dc_bus::DCBus
    "Active Power on the DCSide"
    active_power::Float64
    "Thermal limited MVA Power Output of the converter. <= Capacity"
    rating::Float64
    active_power_limits::MinMax
    "Base power of the converter in MVA"
    base_power::Float64
    "Operation Cost of Generation [`OperationalCost`](@ref)"
    operation_cost::OperationalCost
    "Conversion efficiency from AC Power to DC Power"
    efficiency::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "container for supplemental attributes"
    supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function InterconnectingConverter(name, available, bus, dc_bus, active_power, rating, active_power_limits, base_power, operation_cost=LoadCost(nothing), efficiency=1.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    InterconnectingConverter(name, available, bus, dc_bus, active_power, rating, active_power_limits, base_power, operation_cost, efficiency, services, dynamic_injector, ext, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function InterconnectingConverter(; name, available, bus, dc_bus, active_power, rating, active_power_limits, base_power, operation_cost=LoadCost(nothing), efficiency=1.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    InterconnectingConverter(name, available, bus, dc_bus, active_power, rating, active_power_limits, base_power, operation_cost, efficiency, services, dynamic_injector, ext, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function InterconnectingConverter(::Nothing)
    InterconnectingConverter(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        dc_bus=DCBus(nothing),
        active_power=0.0,
        rating=0.0,
        active_power_limits=(min=0.0, max=0.0),
        base_power=0.0,
        operation_cost=LoadCost(nothing),
        efficiency=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`InterconnectingConverter`](@ref) `name`."""
get_name(value::InterconnectingConverter) = value.name
"""Get [`InterconnectingConverter`](@ref) `available`."""
get_available(value::InterconnectingConverter) = value.available
"""Get [`InterconnectingConverter`](@ref) `bus`."""
get_bus(value::InterconnectingConverter) = value.bus
"""Get [`InterconnectingConverter`](@ref) `dc_bus`."""
get_dc_bus(value::InterconnectingConverter) = value.dc_bus
"""Get [`InterconnectingConverter`](@ref) `active_power`."""
get_active_power(value::InterconnectingConverter) = get_value(value, value.active_power)
"""Get [`InterconnectingConverter`](@ref) `rating`."""
get_rating(value::InterconnectingConverter) = get_value(value, value.rating)
"""Get [`InterconnectingConverter`](@ref) `active_power_limits`."""
get_active_power_limits(value::InterconnectingConverter) = get_value(value, value.active_power_limits)
"""Get [`InterconnectingConverter`](@ref) `base_power`."""
get_base_power(value::InterconnectingConverter) = value.base_power
"""Get [`InterconnectingConverter`](@ref) `operation_cost`."""
get_operation_cost(value::InterconnectingConverter) = value.operation_cost
"""Get [`InterconnectingConverter`](@ref) `efficiency`."""
get_efficiency(value::InterconnectingConverter) = value.efficiency
"""Get [`InterconnectingConverter`](@ref) `services`."""
get_services(value::InterconnectingConverter) = value.services
"""Get [`InterconnectingConverter`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::InterconnectingConverter) = value.dynamic_injector
"""Get [`InterconnectingConverter`](@ref) `ext`."""
get_ext(value::InterconnectingConverter) = value.ext
"""Get [`InterconnectingConverter`](@ref) `time_series_container`."""
get_time_series_container(value::InterconnectingConverter) = value.time_series_container
"""Get [`InterconnectingConverter`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::InterconnectingConverter) = value.supplemental_attributes_container
"""Get [`InterconnectingConverter`](@ref) `internal`."""
get_internal(value::InterconnectingConverter) = value.internal

"""Set [`InterconnectingConverter`](@ref) `available`."""
set_available!(value::InterconnectingConverter, val) = value.available = val
"""Set [`InterconnectingConverter`](@ref) `bus`."""
set_bus!(value::InterconnectingConverter, val) = value.bus = val
"""Set [`InterconnectingConverter`](@ref) `dc_bus`."""
set_dc_bus!(value::InterconnectingConverter, val) = value.dc_bus = val
"""Set [`InterconnectingConverter`](@ref) `active_power`."""
set_active_power!(value::InterconnectingConverter, val) = value.active_power = set_value(value, val)
"""Set [`InterconnectingConverter`](@ref) `rating`."""
set_rating!(value::InterconnectingConverter, val) = value.rating = set_value(value, val)
"""Set [`InterconnectingConverter`](@ref) `active_power_limits`."""
set_active_power_limits!(value::InterconnectingConverter, val) = value.active_power_limits = set_value(value, val)
"""Set [`InterconnectingConverter`](@ref) `base_power`."""
set_base_power!(value::InterconnectingConverter, val) = value.base_power = val
"""Set [`InterconnectingConverter`](@ref) `operation_cost`."""
set_operation_cost!(value::InterconnectingConverter, val) = value.operation_cost = val
"""Set [`InterconnectingConverter`](@ref) `efficiency`."""
set_efficiency!(value::InterconnectingConverter, val) = value.efficiency = val
"""Set [`InterconnectingConverter`](@ref) `services`."""
set_services!(value::InterconnectingConverter, val) = value.services = val
"""Set [`InterconnectingConverter`](@ref) `ext`."""
set_ext!(value::InterconnectingConverter, val) = value.ext = val
"""Set [`InterconnectingConverter`](@ref) `time_series_container`."""
set_time_series_container!(value::InterconnectingConverter, val) = value.time_series_container = val
"""Set [`InterconnectingConverter`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::InterconnectingConverter, val) = value.supplemental_attributes_container = val
