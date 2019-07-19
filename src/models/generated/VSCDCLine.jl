#=
This file is auto-generated. Do not edit.
=#

"""As implemented in Milano&#39;s Book, Page 397"""
mutable struct VSCDCLine <: DCBranch
    name::String
    available::Bool
    activepower_flow::Float64
    arch::Arch
    rectifier_taplimits::Min_Max
    rectifier_xrc::Float64
    rectifier_firingangle::Min_Max
    inverter_taplimits::Min_Max
    inverter_xrc::Float64
    inverter_firingangle::Min_Max
    internal::PowerSystems.PowerSystemInternal
end

function VSCDCLine(name, available, activepower_flow, arch, rectifier_taplimits, rectifier_xrc, rectifier_firingangle, inverter_taplimits, inverter_xrc, inverter_firingangle, )
    VSCDCLine(name, available, activepower_flow, arch, rectifier_taplimits, rectifier_xrc, rectifier_firingangle, inverter_taplimits, inverter_xrc, inverter_firingangle, PowerSystemInternal())
end

function VSCDCLine(; name, available, activepower_flow, arch, rectifier_taplimits, rectifier_xrc, rectifier_firingangle, inverter_taplimits, inverter_xrc, inverter_firingangle, )
    VSCDCLine(name, available, activepower_flow, arch, rectifier_taplimits, rectifier_xrc, rectifier_firingangle, inverter_taplimits, inverter_xrc, inverter_firingangle, )
end

# Constructor for demo purposes; non-functional.

function VSCDCLine(::Nothing)
    VSCDCLine(;
        name="init",
        available=false,
        activepower_flow=0.0,
        arch=Arch(Bus(nothing), Bus(nothing)),
        rectifier_taplimits=(min=0.0, max=0.0),
        rectifier_xrc=0.0,
        rectifier_firingangle=(min=0.0, max=0.0),
        inverter_taplimits=(min=0.0, max=0.0),
        inverter_xrc=0.0,
        inverter_firingangle=(min=0.0, max=0.0),
    )
end

"""Get VSCDCLine name."""
get_name(value::VSCDCLine) = value.name
"""Get VSCDCLine available."""
get_available(value::VSCDCLine) = value.available
"""Get VSCDCLine activepower_flow."""
get_activepower_flow(value::VSCDCLine) = value.activepower_flow
"""Get VSCDCLine arch."""
get_arch(value::VSCDCLine) = value.arch
"""Get VSCDCLine rectifier_taplimits."""
get_rectifier_taplimits(value::VSCDCLine) = value.rectifier_taplimits
"""Get VSCDCLine rectifier_xrc."""
get_rectifier_xrc(value::VSCDCLine) = value.rectifier_xrc
"""Get VSCDCLine rectifier_firingangle."""
get_rectifier_firingangle(value::VSCDCLine) = value.rectifier_firingangle
"""Get VSCDCLine inverter_taplimits."""
get_inverter_taplimits(value::VSCDCLine) = value.inverter_taplimits
"""Get VSCDCLine inverter_xrc."""
get_inverter_xrc(value::VSCDCLine) = value.inverter_xrc
"""Get VSCDCLine inverter_firingangle."""
get_inverter_firingangle(value::VSCDCLine) = value.inverter_firingangle
"""Get VSCDCLine internal."""
get_internal(value::VSCDCLine) = value.internal
