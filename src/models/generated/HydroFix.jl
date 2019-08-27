#=
This file is auto-generated. Do not edit.
=#


mutable struct HydroFix <: HydroGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechHydro
    internal::PowerSystemInternal
end

function HydroFix(name, available, bus, activepower, reactivepower, tech, )
    HydroFix(name, available, bus, activepower, reactivepower, tech, PowerSystemInternal())
end

function HydroFix(; name, available, bus, activepower, reactivepower, tech, )
    HydroFix(name, available, bus, activepower, reactivepower, tech, )
end

# Constructor for demo purposes; non-functional.

function HydroFix(::Nothing)
    HydroFix(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechHydro(nothing),
    )
end

"""Get HydroFix name."""
get_name(value::HydroFix) = value.name
"""Get HydroFix available."""
get_available(value::HydroFix) = value.available
"""Get HydroFix bus."""
get_bus(value::HydroFix) = value.bus
"""Get HydroFix activepower."""
get_activepower(value::HydroFix) = value.activepower
"""Get HydroFix reactivepower."""
get_reactivepower(value::HydroFix) = value.reactivepower
"""Get HydroFix tech."""
get_tech(value::HydroFix) = value.tech
"""Get HydroFix internal."""
get_internal(value::HydroFix) = value.internal
