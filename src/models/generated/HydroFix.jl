#=
This file is auto-generated. Do not edit.
=#


mutable struct HydroFix <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    internal::PowerSystems.PowerSystemInternal
end

function HydroFix(name, available, bus, tech, )
    HydroFix(name, available, bus, tech, PowerSystemInternal())
end

function HydroFix(; name, available, bus, tech, )
    HydroFix(name, available, bus, tech, )
end

# Constructor for demo purposes; non-functional.

function HydroFix(::Nothing)
    HydroFix(;
        name="init",
        available=false,
        bus=Bus(nothing),
        tech=TechHydro(nothing),
    )
end

"""Get HydroFix name."""
get_name(value::HydroFix) = value.name
"""Get HydroFix available."""
get_available(value::HydroFix) = value.available
"""Get HydroFix bus."""
get_bus(value::HydroFix) = value.bus
"""Get HydroFix tech."""
get_tech(value::HydroFix) = value.tech
"""Get HydroFix internal."""
get_internal(value::HydroFix) = value.internal
