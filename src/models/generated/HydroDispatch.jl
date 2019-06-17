#=
This file is auto-generated. Do not edit.
=#


struct HydroDispatch <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    econ::Union{Nothing, EconHydro}
    internal::PowerSystems.PowerSystemInternal
end

function HydroDispatch(name, available, bus, tech, econ, )
    HydroDispatch(name, available, bus, tech, econ, PowerSystemInternal())
end

function HydroDispatch(; name, available, bus, tech, econ, )
    HydroDispatch(name, available, bus, tech, econ, )
end

# Constructor for demo purposes; non-functional.

function HydroDispatch(::Nothing)
    HydroDispatch(;
        name="init",
        available=false,
        bus=Bus(nothing),
        tech=TechHydro(nothing),
        econ=EconHydro(nothing),
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
"""Get HydroDispatch econ."""
get_econ(value::HydroDispatch) = value.econ
"""Get HydroDispatch internal."""
get_internal(value::HydroDispatch) = value.internal
