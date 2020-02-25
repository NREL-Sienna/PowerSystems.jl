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
- `op_cost::TwoPartCost`
- `services::Vector{Service}`: Services that this device contributes to
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
    op_cost::TwoPartCost
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function InterruptibleLoad(; name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, services, ext, forecasts, )
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
"""Get InterruptibleLoad ext."""
get_ext(value::InterruptibleLoad) = value.ext

InfrastructureSystems.get_forecasts(value::InterruptibleLoad) = value.forecasts
"""Get InterruptibleLoad internal."""
get_internal(value::InterruptibleLoad) = value.internal
