#=
This file is auto-generated. Do not edit.
=#


mutable struct RenewableDispatch <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    tech::TechRenewable
    op_cost::TwoPartCost
    internal::PowerSystems.PowerSystemInternal
end

function RenewableDispatch(name, available, bus, tech, op_cost, )
    RenewableDispatch(name, available, bus, tech, op_cost, PowerSystemInternal())
end

function RenewableDispatch(; name, available, bus, tech, op_cost, )
    RenewableDispatch(name, available, bus, tech, op_cost, )
end

# Constructor for demo purposes; non-functional.

function RenewableDispatch(::Nothing)
    RenewableDispatch(;
        name="init",
        available=false,
        bus=Bus(nothing),
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
"""Get RenewableDispatch tech."""
get_tech(value::RenewableDispatch) = value.tech
"""Get RenewableDispatch op_cost."""
get_op_cost(value::RenewableDispatch) = value.op_cost
"""Get RenewableDispatch internal."""
get_internal(value::RenewableDispatch) = value.internal
