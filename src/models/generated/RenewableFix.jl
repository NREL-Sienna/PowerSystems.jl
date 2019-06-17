#=
This file is auto-generated. Do not edit.
=#


mutable struct RenewableFix <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    tech::TechRenewable
    internal::PowerSystems.PowerSystemInternal
end

function RenewableFix(name, available, bus, tech, )
    RenewableFix(name, available, bus, tech, PowerSystemInternal())
end

function RenewableFix(; name, available, bus, tech, )
    RenewableFix(name, available, bus, tech, )
end

# Constructor for demo purposes; non-functional.

function RenewableFix(::Nothing)
    RenewableFix(;
        name="init",
        available=false,
        bus=Bus(nothing),
        tech=TechRenewable(nothing),
    )
end

"""Get RenewableFix name."""
get_name(value::RenewableFix) = value.name
"""Get RenewableFix available."""
get_available(value::RenewableFix) = value.available
"""Get RenewableFix bus."""
get_bus(value::RenewableFix) = value.bus
"""Get RenewableFix tech."""
get_tech(value::RenewableFix) = value.tech
"""Get RenewableFix internal."""
get_internal(value::RenewableFix) = value.internal
