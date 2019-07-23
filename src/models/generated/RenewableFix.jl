#=
This file is auto-generated. Do not edit.
=#


mutable struct RenewableFix <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechRenewable
    internal::PowerSystemInternal
end

function RenewableFix(name, available, bus, activepower, reactivepower, tech, )
    RenewableFix(name, available, bus, activepower, reactivepower, tech, PowerSystemInternal())
end

function RenewableFix(; name, available, bus, activepower, reactivepower, tech, )
    RenewableFix(name, available, bus, activepower, reactivepower, tech, )
end

# Constructor for demo purposes; non-functional.

function RenewableFix(::Nothing)
    RenewableFix(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechRenewable(nothing),
    )
end

"""Get RenewableFix name."""
get_name(value::RenewableFix) = value.name
"""Get RenewableFix available."""
get_available(value::RenewableFix) = value.available
"""Get RenewableFix bus."""
get_bus(value::RenewableFix) = value.bus
"""Get RenewableFix activepower."""
get_activepower(value::RenewableFix) = value.activepower
"""Get RenewableFix reactivepower."""
get_reactivepower(value::RenewableFix) = value.reactivepower
"""Get RenewableFix tech."""
get_tech(value::RenewableFix) = value.tech
"""Get RenewableFix internal."""
get_internal(value::RenewableFix) = value.internal
