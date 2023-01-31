#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct InterconnectingConverter <: StaticInjection
        name::String
        available::Bool
        acbus::ACBus
        dcbus::DCBus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        active_power_limits::MinMax
        base_power::Float64
        operation_cost::OperationalCost
        efficiency::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

Interconnecting Power Converter (IPC) for transforming power from an ACBus to a DCBus

# Arguments
- `name::String`
- `available::Bool`
- `acbus::ACBus`
- `dcbus::DCBus`
- `active_power::Float64`: Active Power on the DCSide
- `reactive_power::Float64`, validation range: `reactive_power_limits`, action if invalid: `warn`
- `rating::Float64`: Thermal limited MVA Power Output of the converter. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `active_power_limits::MinMax`
- `base_power::Float64`: Base power of the converter in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `operation_cost::OperationalCost`: Operation Cost of Generation [`OperationalCost`](@ref)
- `efficiency::Float64`: Conversion efficiency from AC Power to DC Power
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct InterconnectingConverter <: StaticInjection
    name::String
    available::Bool
    acbus::ACBus
    dcbus::DCBus
    "Active Power on the DCSide"
    active_power::Float64
    reactive_power::Float64
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
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function InterconnectingConverter(name, available, acbus, dcbus, active_power, reactive_power, rating, active_power_limits, base_power, operation_cost=TwoPartCost(0.0, 0.0), efficiency=1.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    InterconnectingConverter(name, available, acbus, dcbus, active_power, reactive_power, rating, active_power_limits, base_power, operation_cost, efficiency, services, dynamic_injector, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function InterconnectingConverter(; name, available, acbus, dcbus, active_power, reactive_power, rating, active_power_limits, base_power, operation_cost=TwoPartCost(0.0, 0.0), efficiency=1.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    InterconnectingConverter(name, available, acbus, dcbus, active_power, reactive_power, rating, active_power_limits, base_power, operation_cost, efficiency, services, dynamic_injector, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function InterconnectingConverter(::Nothing)
    InterconnectingConverter(;
        name="init",
        available=false,
        acbus=ACBus(nothing),
        dcbus=DCBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        active_power_limits=(min=0.0, max=0.0),
        base_power=0.0,
        operation_cost=TwoPartCost(nothing),
        efficiency=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`InterconnectingConverter`](@ref) `name`."""
get_name(value::InterconnectingConverter) = value.name
"""Get [`InterconnectingConverter`](@ref) `available`."""
get_available(value::InterconnectingConverter) = value.available
"""Get [`InterconnectingConverter`](@ref) `acbus`."""
get_acbus(value::InterconnectingConverter) = value.acbus
"""Get [`InterconnectingConverter`](@ref) `dcbus`."""
get_dcbus(value::InterconnectingConverter) = value.dcbus
"""Get [`InterconnectingConverter`](@ref) `active_power`."""
get_active_power(value::InterconnectingConverter) = get_value(value, value.active_power)
"""Get [`InterconnectingConverter`](@ref) `reactive_power`."""
get_reactive_power(value::InterconnectingConverter) = get_value(value, value.reactive_power)
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
"""Get [`InterconnectingConverter`](@ref) `internal`."""
get_internal(value::InterconnectingConverter) = value.internal

"""Set [`InterconnectingConverter`](@ref) `available`."""
set_available!(value::InterconnectingConverter, val) = value.available = val
"""Set [`InterconnectingConverter`](@ref) `acbus`."""
set_acbus!(value::InterconnectingConverter, val) = value.acbus = val
"""Set [`InterconnectingConverter`](@ref) `dcbus`."""
set_dcbus!(value::InterconnectingConverter, val) = value.dcbus = val
"""Set [`InterconnectingConverter`](@ref) `active_power`."""
set_active_power!(value::InterconnectingConverter, val) = value.active_power = set_value(value, val)
"""Set [`InterconnectingConverter`](@ref) `reactive_power`."""
set_reactive_power!(value::InterconnectingConverter, val) = value.reactive_power = set_value(value, val)
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
