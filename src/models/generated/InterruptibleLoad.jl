#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct InterruptibleLoad <: ControllableLoad
        name::String
        available::Bool
        bus::Bus
        model::LoadModel
        activepower::Float64
        reactivepower::Float64
        maxactivepower::Float64
        maxreactivepower::Float64
        op_cost::TwoPartCost
        _forecasts::InfrastructureSystems.Forecasts
        ext::Union{Nothing, Dict{String, Any}}
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `model::LoadModel`
- `activepower::Float64`
- `reactivepower::Float64`
- `maxactivepower::Float64`
- `maxreactivepower::Float64`
- `op_cost::TwoPartCost`
- `_forecasts::InfrastructureSystems.Forecasts`
- `ext::Union{Nothing, Dict{String, Any}}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct InterruptibleLoad <: ControllableLoad
    name::String
    available::Bool
    bus::Bus
    model::LoadModel
    activepower::Float64
    reactivepower::Float64
    maxactivepower::Float64
    maxreactivepower::Float64
    op_cost::TwoPartCost
    _forecasts::InfrastructureSystems.Forecasts
    ext::Union{Nothing, Dict{String, Any}}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, _forecasts, ext, InfrastructureSystemsInternal())
end

function InterruptibleLoad(; name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, _forecasts, ext, )
end


function InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, ; ext=nothing)
    _forecasts=InfrastructureSystems.Forecasts()
    InterruptibleLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, op_cost, _forecasts, ext, InfrastructureSystemsInternal())
end

# Constructor for demo purposes; non-functional.

function InterruptibleLoad(::Nothing)
    InterruptibleLoad(;
        name="init",
        available=false,
        bus=Bus(nothing),
        model=ConstantPower::LoadModel,
        activepower=0.0,
        reactivepower=0.0,
        maxactivepower=0.0,
        maxreactivepower=0.0,
        op_cost=TwoPartCost(nothing),
        _forecasts=InfrastructureSystems.Forecasts(),
        ext=nothing,
    )
end

"""Get InterruptibleLoad name."""
get_name(value::InterruptibleLoad) = value.name
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
"""Get InterruptibleLoad _forecasts."""
get__forecasts(value::InterruptibleLoad) = value._forecasts
"""Get InterruptibleLoad ext."""
get_ext(value::InterruptibleLoad) = value.ext
"""Get InterruptibleLoad internal."""
get_internal(value::InterruptibleLoad) = value.internal
