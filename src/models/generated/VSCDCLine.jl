#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct VSCDCLine <: DCBranch
        name::String
        available::Bool
        activepower_flow::Float64
        arc::Arc
        rectifier_taplimits::Min_Max
        rectifier_xrc::Float64
        rectifier_firing_angle::Min_Max
        inverter_taplimits::Min_Max
        inverter_xrc::Float64
        inverter_firing_angle::Min_Max
        services::Vector{Service}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

As implemented in Milano's Book, Page 397.

# Arguments
- `name::String`
- `available::Bool`
- `activepower_flow::Float64`
- `arc::Arc`
- `rectifier_taplimits::Min_Max`
- `rectifier_xrc::Float64`
- `rectifier_firing_angle::Min_Max`
- `inverter_taplimits::Min_Max`
- `inverter_xrc::Float64`
- `inverter_firing_angle::Min_Max`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct VSCDCLine <: DCBranch
    name::String
    available::Bool
    activepower_flow::Float64
    arc::Arc
    rectifier_taplimits::Min_Max
    rectifier_xrc::Float64
    rectifier_firing_angle::Min_Max
    inverter_taplimits::Min_Max
    inverter_xrc::Float64
    inverter_firing_angle::Min_Max
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function VSCDCLine(name, available, activepower_flow, arc, rectifier_taplimits, rectifier_xrc, rectifier_firing_angle, inverter_taplimits, inverter_xrc, inverter_firing_angle, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    VSCDCLine(name, available, activepower_flow, arc, rectifier_taplimits, rectifier_xrc, rectifier_firing_angle, inverter_taplimits, inverter_xrc, inverter_firing_angle, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function VSCDCLine(; name, available, activepower_flow, arc, rectifier_taplimits, rectifier_xrc, rectifier_firing_angle, inverter_taplimits, inverter_xrc, inverter_firing_angle, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    VSCDCLine(name, available, activepower_flow, arc, rectifier_taplimits, rectifier_xrc, rectifier_firing_angle, inverter_taplimits, inverter_xrc, inverter_firing_angle, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function VSCDCLine(::Nothing)
    VSCDCLine(;
        name="init",
        available=false,
        activepower_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        rectifier_taplimits=(min=0.0, max=0.0),
        rectifier_xrc=0.0,
        rectifier_firing_angle=(min=0.0, max=0.0),
        inverter_taplimits=(min=0.0, max=0.0),
        inverter_xrc=0.0,
        inverter_firing_angle=(min=0.0, max=0.0),
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::VSCDCLine) = value.name
"""Get VSCDCLine available."""
get_available(value::VSCDCLine) = value.available
"""Get VSCDCLine activepower_flow."""
get_activepower_flow(value::VSCDCLine) = value.activepower_flow
"""Get VSCDCLine arc."""
get_arc(value::VSCDCLine) = value.arc
"""Get VSCDCLine rectifier_taplimits."""
get_rectifier_taplimits(value::VSCDCLine) = value.rectifier_taplimits
"""Get VSCDCLine rectifier_xrc."""
get_rectifier_xrc(value::VSCDCLine) = value.rectifier_xrc
"""Get VSCDCLine rectifier_firing_angle."""
get_rectifier_firing_angle(value::VSCDCLine) = value.rectifier_firing_angle
"""Get VSCDCLine inverter_taplimits."""
get_inverter_taplimits(value::VSCDCLine) = value.inverter_taplimits
"""Get VSCDCLine inverter_xrc."""
get_inverter_xrc(value::VSCDCLine) = value.inverter_xrc
"""Get VSCDCLine inverter_firing_angle."""
get_inverter_firing_angle(value::VSCDCLine) = value.inverter_firing_angle
"""Get VSCDCLine services."""
get_services(value::VSCDCLine) = value.services
"""Get VSCDCLine ext."""
get_ext(value::VSCDCLine) = value.ext

InfrastructureSystems.get_forecasts(value::VSCDCLine) = value.forecasts
"""Get VSCDCLine internal."""
get_internal(value::VSCDCLine) = value.internal


InfrastructureSystems.set_name(value::VSCDCLine, val) = value.name = val
"""Set VSCDCLine available."""
set_available(value::VSCDCLine, val) = value.available = val
"""Set VSCDCLine activepower_flow."""
set_activepower_flow(value::VSCDCLine, val) = value.activepower_flow = val
"""Set VSCDCLine arc."""
set_arc(value::VSCDCLine, val) = value.arc = val
"""Set VSCDCLine rectifier_taplimits."""
set_rectifier_taplimits(value::VSCDCLine, val) = value.rectifier_taplimits = val
"""Set VSCDCLine rectifier_xrc."""
set_rectifier_xrc(value::VSCDCLine, val) = value.rectifier_xrc = val
"""Set VSCDCLine rectifier_firing_angle."""
set_rectifier_firing_angle(value::VSCDCLine, val) = value.rectifier_firing_angle = val
"""Set VSCDCLine inverter_taplimits."""
set_inverter_taplimits(value::VSCDCLine, val) = value.inverter_taplimits = val
"""Set VSCDCLine inverter_xrc."""
set_inverter_xrc(value::VSCDCLine, val) = value.inverter_xrc = val
"""Set VSCDCLine inverter_firing_angle."""
set_inverter_firing_angle(value::VSCDCLine, val) = value.inverter_firing_angle = val
"""Set VSCDCLine services."""
set_services(value::VSCDCLine, val) = value.services = val
"""Set VSCDCLine ext."""
set_ext(value::VSCDCLine, val) = value.ext = val

InfrastructureSystems.set_forecasts(value::VSCDCLine, val) = value.forecasts = val
"""Set VSCDCLine internal."""
set_internal(value::VSCDCLine, val) = value.internal = val
