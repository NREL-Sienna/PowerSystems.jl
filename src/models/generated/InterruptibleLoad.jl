#=
This file is auto-generated. Do not edit.
=#


mutable struct InterruptibleLoad <: ControllableLoad
    name::String
    available::Bool
    activepower::Float64
    reactivepower::Float64
    bus::Bus
    model::String  # [Z, I, P]
    maxactivepower::Float64
    maxreactivepower::Float64
    op_cost::TwoPartCost
    internal::PowerSystems.PowerSystemInternal
end

function InterruptibleLoad(name, available, activepower, reactivepower, bus, model, maxactivepower, maxreactivepower, op_cost, )
    InterruptibleLoad(name, available, activepower, reactivepower, bus, model, maxactivepower, maxreactivepower, op_cost, PowerSystemInternal())
end

function InterruptibleLoad(; name, available, activepower, reactivepower, bus, model, maxactivepower, maxreactivepower, op_cost, )
    InterruptibleLoad(name, available, activepower, reactivepower, bus, model, maxactivepower, maxreactivepower, op_cost, )
end

# Constructor for demo purposes; non-functional.

function InterruptibleLoad(::Nothing)
    InterruptibleLoad(;
        name="init",
        available=false,
        activepower=0.0,
        reactivepower=0.0,
        bus=Bus(nothing),
        model="0",
        maxactivepower=0,
        maxreactivepower=0,
        op_cost=TwoPartCost(nothing),
    )
end

"""Get InterruptibleLoad name."""
get_name(value::InterruptibleLoad) = value.name
"""Get InterruptibleLoad available."""
get_available(value::InterruptibleLoad) = value.available
"""Get InterruptibleLoad activepower."""
get_activepower(value::InterruptibleLoad) = value.activepower
"""Get InterruptibleLoad reactivepower."""
get_reactivepower(value::InterruptibleLoad) = value.reactivepower
"""Get InterruptibleLoad bus."""
get_bus(value::InterruptibleLoad) = value.bus
"""Get InterruptibleLoad model."""
get_model(value::InterruptibleLoad) = value.model
"""Get InterruptibleLoad maxactivepower."""
get_maxactivepower(value::InterruptibleLoad) = value.maxactivepower
"""Get InterruptibleLoad maxreactivepower."""
get_maxreactivepower(value::InterruptibleLoad) = value.maxreactivepower
"""Get InterruptibleLoad op_cost."""
get_op_cost(value::InterruptibleLoad) = value.op_cost
"""Get InterruptibleLoad internal."""
get_internal(value::InterruptibleLoad) = value.internal
