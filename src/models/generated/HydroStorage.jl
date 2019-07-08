#=
This file is auto-generated. Do not edit.
=#


mutable struct HydroStorage <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    cost::TwoPartCost
    storagecapacity::Float64
    internal::PowerSystems.PowerSystemInternal
end

function HydroStorage(name, available, bus, tech, cost, storagecapacity, )
    HydroStorage(name, available, bus, tech, cost, storagecapacity, PowerSystemInternal())
end

function HydroStorage(; name, available, bus, tech, cost, storagecapacity, )
    HydroStorage(name, available, bus, tech, cost, storagecapacity, )
end

# Constructor for demo purposes; non-functional.

function HydroStorage(::Nothing)
    HydroStorage(;
        name="init",
        available=false,
        bus=Bus(nothing),
        tech=TechHydro(nothing),
        op_cost=TwoPartCost(nothing),
        storagecapacity=0.0,
    )
end

"""Get HydroStorage name."""
get_name(value::HydroStorage) = value.name
"""Get HydroStorage available."""
get_available(value::HydroStorage) = value.available
"""Get HydroStorage bus."""
get_bus(value::HydroStorage) = value.bus
"""Get HydroStorage tech."""
get_tech(value::HydroStorage) = value.tech
"""Get HydroStorage cost."""
get_cost(value::HydroStorage) = value.cost
"""Get HydroStorage storagecapacity."""
get_storagecapacity(value::HydroStorage) = value.storagecapacity
"""Get HydroStorage internal."""
get_internal(value::HydroStorage) = value.internal
