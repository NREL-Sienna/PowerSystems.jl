#=
This file is auto-generated. Do not edit.
=#

"""Data Structure for thermal generation technologies."""
mutable struct ThermalStandard <: ThermalGen
    name::String
    available::Bool
    bus::Bus
    reactivepower::Float64
    activepower::Float64
    tech::Union{Nothing, TechThermal}
    op_cost::ThreePartCost
    internal::PowerSystemInternal
end

function ThermalStandard(name, available, bus, reactivepower, activepower, tech, op_cost, )
    ThermalStandard(name, available, bus, reactivepower, activepower, tech, op_cost, PowerSystemInternal())
end

function ThermalStandard(; name, available, bus, reactivepower, activepower, tech, op_cost, )
    ThermalStandard(name, available, bus, reactivepower, activepower, tech, op_cost, )
end

# Constructor for demo purposes; non-functional.

function ThermalStandard(::Nothing)
    ThermalStandard(;
        name="init",
        available=false,
        bus=Bus(nothing),
        reactivepower=0.0,
        activepower=0.0,
        tech=TechThermal(nothing),
        op_cost=ThreePartCost(nothing),
    )
end

"""Get ThermalStandard name."""
get_name(value::ThermalStandard) = value.name
"""Get ThermalStandard available."""
get_available(value::ThermalStandard) = value.available
"""Get ThermalStandard bus."""
get_bus(value::ThermalStandard) = value.bus
"""Get ThermalStandard reactivepower."""
get_reactivepower(value::ThermalStandard) = value.reactivepower
"""Get ThermalStandard activepower."""
get_activepower(value::ThermalStandard) = value.activepower
"""Get ThermalStandard tech."""
get_tech(value::ThermalStandard) = value.tech
"""Get ThermalStandard op_cost."""
get_op_cost(value::ThermalStandard) = value.op_cost
"""Get ThermalStandard internal."""
get_internal(value::ThermalStandard) = value.internal
