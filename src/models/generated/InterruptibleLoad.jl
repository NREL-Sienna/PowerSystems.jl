#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct InterruptibleLoad <: ControllableLoad
        name::String
        available::Bool
        bus::Bus
        model::LoadModels.LoadModel
        activepower::Float64
        reactivepower::Float64
        maxactivepower::Float64
        maxreactivepower::Float64
        op_cost::TwoPartCost
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
- `activepower::Float64`
- `reactivepower::Float64`
- `maxactivepower::Float64`
- `maxreactivepower::Float64`
- `op_cost::TwoPartCost`: Operation Cost of Generation [TwoPartCost](@ref)
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
    activepower::Float64
    reactivepower::Float64
    maxactivepower::Float64
    maxreactivepower::Float64
    "Operation Cost of Generation [TwoPartCost](@ref)"
    op_cost::TwoPartCost
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

function InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function InterruptibleLoad(; name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, services, dynamic_injector, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function InterruptibleLoad(::Nothing)
    InterruptibleLoad(;
        name="init",
        available=false,
        bus=Bus(nothing),
        model=LoadModels.ConstantPower,
        activepower=0.0,
        reactivepower=0.0,
        maxactivepower=0.0,
        maxreactivepower=0.0,
        op_cost=TwoPartCost(nothing),
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
"""Get InterruptibleLoad activepower."""
get_activepower(value::InterruptibleLoad) = value.activepower
"""Get InterruptibleLoad reactivepower."""
get_reactivepower(value::InterruptibleLoad) = value.reactivepower
"""Get InterruptibleLoad maxactivepower."""
get_maxactivepower(value::InterruptibleLoad) = value.maxactivepower
"""Get InterruptibleLoad maxreactivepower."""
get_maxreactivepower(value::InterruptibleLoad) = value.maxreactivepower
"""Get InterruptibleLoad op_cost."""
get_op_cost(value::InterruptibleLoad) = value.op_cost
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
"""Set InterruptibleLoad activepower."""
set_activepower!(value::InterruptibleLoad, val::Float64) = value.activepower = val
"""Set InterruptibleLoad reactivepower."""
set_reactivepower!(value::InterruptibleLoad, val::Float64) = value.reactivepower = val
"""Set InterruptibleLoad maxactivepower."""
set_maxactivepower!(value::InterruptibleLoad, val::Float64) = value.maxactivepower = val
"""Set InterruptibleLoad maxreactivepower."""
set_maxreactivepower!(value::InterruptibleLoad, val::Float64) = value.maxreactivepower = val
"""Set InterruptibleLoad op_cost."""
set_op_cost!(value::InterruptibleLoad, val::TwoPartCost) = value.op_cost = val
"""Set InterruptibleLoad services."""
set_services!(value::InterruptibleLoad, val::Vector{Service}) = value.services = val
"""Set InterruptibleLoad ext."""
set_ext!(value::InterruptibleLoad, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::InterruptibleLoad, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set InterruptibleLoad internal."""
set_internal!(value::InterruptibleLoad, val::InfrastructureSystemsInternal) = value.internal = val
