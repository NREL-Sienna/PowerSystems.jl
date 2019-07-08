#=
This file is auto-generated. Do not edit.
=#


mutable struct HydroDispatch <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    op_cost::TwoPartCost
    internal::PowerSystems.PowerSystemInternal
end

function HydroDispatch(name, available, bus, tech, op_cost, )
    HydroDispatch(name, available, bus, tech, op_cost, PowerSystemInternal())
end

function HydroDispatch(; name, available, bus, tech, op_cost, )
    HydroDispatch(name, available, bus, tech, op_cost, )
end

# Constructor for demo purposes; non-functional.

function HydroDispatch(::Nothing)
    HydroDispatch(;
        name="init",
        available=false,
        bus=Bus(nothing),
        tech=TechHydro(nothing),
        op_cost=TwoPartCost(nothing),
    )
end

"""Get HydroDispatch name."""
get_name(value::HydroDispatch) = value.name
"""Get HydroDispatch available."""
get_available(value::HydroDispatch) = value.available
"""Get HydroDispatch bus."""
get_bus(value::HydroDispatch) = value.bus
"""Get HydroDispatch tech."""
get_tech(value::HydroDispatch) = value.tech
"""Get HydroDispatch op_cost."""
get_op_cost(value::HydroDispatch) = value.op_cost
"""Get HydroDispatch internal."""
get_internal(value::HydroDispatch) = value.internal
