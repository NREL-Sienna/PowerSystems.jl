#=
This file is auto-generated. Do not edit.
=#


mutable struct RenewableDispatch <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechRenewable
    op_cost::TwoPartCost
    internal::PowerSystemInternal
end

function RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, )
    RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, PowerSystemInternal())
end

function RenewableDispatch(; name, available, bus, activepower, reactivepower, tech, op_cost, )
    RenewableDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, )
end

# Constructor for demo purposes; non-functional.

function RenewableDispatch(::Nothing)
    RenewableDispatch(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechRenewable(nothing),
        op_cost=TwoPartCost(nothing),
    )
end

"""Get RenewableDispatch name."""
get_name(value::RenewableDispatch) = value.name
"""Get RenewableDispatch available."""
get_available(value::RenewableDispatch) = value.available
"""Get RenewableDispatch bus."""
get_bus(value::RenewableDispatch) = value.bus
"""Get RenewableDispatch activepower."""
get_activepower(value::RenewableDispatch) = value.activepower
"""Get RenewableDispatch reactivepower."""
get_reactivepower(value::RenewableDispatch) = value.reactivepower
"""Get RenewableDispatch tech."""
get_tech(value::RenewableDispatch) = value.tech
"""Get RenewableDispatch op_cost."""
get_op_cost(value::RenewableDispatch) = value.op_cost
"""Get RenewableDispatch internal."""
get_internal(value::RenewableDispatch) = value.internal
