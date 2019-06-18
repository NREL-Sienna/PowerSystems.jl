#=
This file is auto-generated. Do not edit.
=#


mutable struct FixedAdmittance <: ElectricLoad
    name::String
    available::Bool
    bus::Bus
    Y::Complex{Float64}
    internal::PowerSystems.PowerSystemInternal
end

function FixedAdmittance(name, available, bus, Y, )
    FixedAdmittance(name, available, bus, Y, PowerSystemInternal())
end

function FixedAdmittance(; name, available, bus, Y, )
    FixedAdmittance(name, available, bus, Y, )
end

# Constructor for demo purposes; non-functional.

function FixedAdmittance(::Nothing)
    FixedAdmittance(;
        name="init",
        available=false,
        bus=Bus(nothing),
        Y=0.0,
    )
end

"""Get FixedAdmittance name."""
get_name(value::FixedAdmittance) = value.name
"""Get FixedAdmittance available."""
get_available(value::FixedAdmittance) = value.available
"""Get FixedAdmittance bus."""
get_bus(value::FixedAdmittance) = value.bus
"""Get FixedAdmittance Y."""
get_Y(value::FixedAdmittance) = value.Y
"""Get FixedAdmittance internal."""
get_internal(value::FixedAdmittance) = value.internal
