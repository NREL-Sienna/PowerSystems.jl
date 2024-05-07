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
        operation_cost::Union{LoadCost, MarketBidCost}
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
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
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `operation_cost::Union{LoadCost, MarketBidCost}`: Operation Cost of Generation [`OperationalCost`](@ref)
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
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
    "Operation Cost of Generation [`OperationalCost`](@ref)"
    operation_cost::Union{LoadCost, MarketBidCost}
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function InterruptiblePowerLoad(name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    InterruptiblePowerLoad(name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function InterruptiblePowerLoad(; name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    InterruptiblePowerLoad(name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services, dynamic_injector, ext, internal, )
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
        operation_cost=LoadCost(nothing),
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
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
