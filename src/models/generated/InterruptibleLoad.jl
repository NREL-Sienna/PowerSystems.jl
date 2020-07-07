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

function InterruptibleLoad(name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, operation_cost, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    InterruptibleLoad(name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, operation_cost, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function InterruptibleLoad(; name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, operation_cost, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    InterruptibleLoad(name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, operation_cost, services, dynamic_injector, ext, forecasts, )
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
        operation_cost=TwoPartCost(nothing),
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::InterruptibleLoad) = value.name
"""Get InterruptibleLoad available."""
get_available(value::InterruptibleLoad) = value.available
"""Get InterruptibleLoad bus."""
get_bus(value::InterruptibleLoad) = value.bus
"""Get InterruptibleLoad model."""
get_model(value::InterruptibleLoad) = value.model
"""Get InterruptibleLoad active_power."""
get_active_power(value::InterruptibleLoad) = get_value(value, :active_power)
"""Get InterruptibleLoad reactive_power."""
get_reactive_power(value::InterruptibleLoad) = get_value(value, :reactive_power)
"""Get InterruptibleLoad max_active_power."""
get_max_active_power(value::InterruptibleLoad) = get_value(value, :max_active_power)
"""Get InterruptibleLoad max_reactive_power."""
get_max_reactive_power(value::InterruptibleLoad) = get_value(value, :max_reactive_power)
"""Get InterruptibleLoad operation_cost."""
get_operation_cost(value::InterruptibleLoad) = value.operation_cost
"""Get InterruptibleLoad services."""
get_services(value::InterruptibleLoad) = value.services
"""Get InterruptibleLoad dynamic_injector."""
get_dynamic_injector(value::InterruptibleLoad) = value.dynamic_injector
"""Get InterruptibleLoad ext."""
get_ext(value::InterruptibleLoad) = value.ext

InfrastructureSystems.get_forecasts(value::InterruptibleLoad) = value.forecasts
"""Get InterruptibleLoad internal."""
get_internal(value::InterruptibleLoad) = value.internal


InfrastructureSystems.set_name!(value::InterruptibleLoad, val::String) = value.name = val
"""Set InterruptibleLoad available."""
set_available!(value::InterruptibleLoad, val::Bool) = value.available = val
"""Set InterruptibleLoad bus."""
set_bus!(value::InterruptibleLoad, val::Bus) = value.bus = val
"""Set InterruptibleLoad model."""
set_model!(value::InterruptibleLoad, val::LoadModels.LoadModel) = value.model = val
"""Set InterruptibleLoad active_power."""
set_active_power!(value::InterruptibleLoad, val::Float64) = value.active_power = val
"""Set InterruptibleLoad reactive_power."""
set_reactive_power!(value::InterruptibleLoad, val::Float64) = value.reactive_power = val
"""Set InterruptibleLoad max_active_power."""
set_max_active_power!(value::InterruptibleLoad, val::Float64) = value.max_active_power = val
"""Set InterruptibleLoad max_reactive_power."""
set_max_reactive_power!(value::InterruptibleLoad, val::Float64) = value.max_reactive_power = val
"""Set InterruptibleLoad operation_cost."""
set_operation_cost!(value::InterruptibleLoad, val::TwoPartCost) = value.operation_cost = val
"""Set InterruptibleLoad services."""
set_services!(value::InterruptibleLoad, val::Vector{Service}) = value.services = val
"""Set InterruptibleLoad ext."""
set_ext!(value::InterruptibleLoad, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::InterruptibleLoad, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set InterruptibleLoad internal."""
set_internal!(value::InterruptibleLoad, val::InfrastructureSystemsInternal) = value.internal = val
