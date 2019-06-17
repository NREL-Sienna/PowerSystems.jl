#=
This file is auto-generated. Do not edit.
=#


struct RenewableDispatch <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    tech::TechRenewable
    econ::Union{Nothing, EconRenewable}
    internal::PowerSystems.PowerSystemInternal
end

function RenewableDispatch(name, available, bus, tech, econ, )
    RenewableDispatch(name, available, bus, tech, econ, PowerSystemInternal())
end

function RenewableDispatch(; name, available, bus, tech, econ, )
    RenewableDispatch(name, available, bus, tech, econ, )
end

# Constructor for demo purposes; non-functional.

function RenewableDispatch(::Nothing)
    RenewableDispatch(;
        name="init",
        available=false,
        bus=Bus(nothing),
        tech=TechRenewable(nothing),
        econ=EconRenewable(nothing),
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
"""Get RenewableDispatch econ."""
get_econ(value::RenewableDispatch) = value.econ
"""Get RenewableDispatch internal."""
get_internal(value::RenewableDispatch) = value.internal
