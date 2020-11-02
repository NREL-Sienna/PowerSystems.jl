#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct InterruptibleLoad <: ControllableLoad
        name::String
        available::Bool
        bus::Bus
        model::LoadModels.LoadModel
        active_power::Float64
        reactive_power::Float64
        max_active_power::Float64
        max_reactive_power::Float64
        base_power::Float64
        operation_cost::TwoPartCost
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `model::LoadModels.LoadModel`
- `active_power::Float64`
- `reactive_power::Float64`
- `max_active_power::Float64`
- `max_reactive_power::Float64`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, validation range: `(0, nothing)`, action if invalid: `warn`
- `operation_cost::TwoPartCost`: Operation Cost of Generation [`TwoPartCost`](@ref)
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct InterruptibleLoad <: ControllableLoad
    name::String
    available::Bool
    bus::Bus
    model::LoadModels.LoadModel
    active_power::Float64
    reactive_power::Float64
    max_active_power::Float64
    max_reactive_power::Float64
    "Base power of the unit in MVA"
    base_power::Float64
    "Operation Cost of Generation [`TwoPartCost`](@ref)"
    operation_cost::TwoPartCost
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function InterruptibleLoad(name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    InterruptibleLoad(name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function InterruptibleLoad(; name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), internal=InfrastructureSystemsInternal(), )
    InterruptibleLoad(name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, base_power, operation_cost, services, dynamic_injector, ext, forecasts, internal, )
end

# Constructor for demo purposes; non-functional.
function InterruptibleLoad(::Nothing)
    InterruptibleLoad(;
        name="init",
        available=false,
        bus=Bus(nothing),
        model=LoadModels.ConstantPower,
        active_power=0.0,
        reactive_power=0.0,
        max_active_power=0.0,
        max_reactive_power=0.0,
        base_power=0.0,
        operation_cost=TwoPartCost(nothing),
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::InterruptibleLoad) = value.name
"""Get [`InterruptibleLoad`](@ref) `available`."""
get_available(value::InterruptibleLoad) = value.available
"""Get [`InterruptibleLoad`](@ref) `bus`."""
get_bus(value::InterruptibleLoad) = value.bus
"""Get [`InterruptibleLoad`](@ref) `model`."""
get_model(value::InterruptibleLoad) = value.model
"""Get [`InterruptibleLoad`](@ref) `active_power`."""
get_active_power(value::InterruptibleLoad) = get_value(value, value.active_power)
"""Get [`InterruptibleLoad`](@ref) `reactive_power`."""
get_reactive_power(value::InterruptibleLoad) = get_value(value, value.reactive_power)
"""Get [`InterruptibleLoad`](@ref) `max_active_power`."""
get_max_active_power(value::InterruptibleLoad) = get_value(value, value.max_active_power)
"""Get [`InterruptibleLoad`](@ref) `max_reactive_power`."""
get_max_reactive_power(value::InterruptibleLoad) = get_value(value, value.max_reactive_power)
"""Get [`InterruptibleLoad`](@ref) `base_power`."""
get_base_power(value::InterruptibleLoad) = value.base_power
"""Get [`InterruptibleLoad`](@ref) `operation_cost`."""
get_operation_cost(value::InterruptibleLoad) = value.operation_cost
"""Get [`InterruptibleLoad`](@ref) `services`."""
get_services(value::InterruptibleLoad) = value.services
"""Get [`InterruptibleLoad`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::InterruptibleLoad) = value.dynamic_injector
"""Get [`InterruptibleLoad`](@ref) `ext`."""
get_ext(value::InterruptibleLoad) = value.ext

InfrastructureSystems.get_forecasts(value::InterruptibleLoad) = value.forecasts
"""Get [`InterruptibleLoad`](@ref) `internal`."""
get_internal(value::InterruptibleLoad) = value.internal


InfrastructureSystems.set_name!(value::InterruptibleLoad, val) = value.name = val
"""Set [`InterruptibleLoad`](@ref) `available`."""
set_available!(value::InterruptibleLoad, val) = value.available = val
"""Set [`InterruptibleLoad`](@ref) `bus`."""
set_bus!(value::InterruptibleLoad, val) = value.bus = val
"""Set [`InterruptibleLoad`](@ref) `model`."""
set_model!(value::InterruptibleLoad, val) = value.model = val
"""Set [`InterruptibleLoad`](@ref) `active_power`."""
set_active_power!(value::InterruptibleLoad, val) = value.active_power = val
"""Set [`InterruptibleLoad`](@ref) `reactive_power`."""
set_reactive_power!(value::InterruptibleLoad, val) = value.reactive_power = val
"""Set [`InterruptibleLoad`](@ref) `max_active_power`."""
set_max_active_power!(value::InterruptibleLoad, val) = value.max_active_power = val
"""Set [`InterruptibleLoad`](@ref) `max_reactive_power`."""
set_max_reactive_power!(value::InterruptibleLoad, val) = value.max_reactive_power = val
"""Set [`InterruptibleLoad`](@ref) `base_power`."""
set_base_power!(value::InterruptibleLoad, val) = value.base_power = val
"""Set [`InterruptibleLoad`](@ref) `operation_cost`."""
set_operation_cost!(value::InterruptibleLoad, val) = value.operation_cost = val
"""Set [`InterruptibleLoad`](@ref) `services`."""
set_services!(value::InterruptibleLoad, val) = value.services = val
"""Set [`InterruptibleLoad`](@ref) `ext`."""
set_ext!(value::InterruptibleLoad, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::InterruptibleLoad, val) = value.forecasts = val
"""Set [`InterruptibleLoad`](@ref) `internal`."""
set_internal!(value::InterruptibleLoad, val) = value.internal = val

