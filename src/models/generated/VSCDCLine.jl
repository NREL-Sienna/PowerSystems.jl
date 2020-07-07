#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct VSCDCLine <: DCBranch
        name::String
        available::Bool
        active_power_flow::Float64
        arc::Arc
        rectifier_tap_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        rectifier_xrc::Float64
        rectifier_firing_angle::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        inverter_tap_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        inverter_xrc::Float64
        inverter_firing_angle::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        services::Vector{Service}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

As implemented in Milano's Book, Page 397.

# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow::Float64`
- `arc::Arc`
- `rectifier_tap_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`
- `rectifier_xrc::Float64`
- `rectifier_firing_angle::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`
- `inverter_tap_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`
- `inverter_xrc::Float64`
- `inverter_firing_angle::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct VSCDCLine <: DCBranch
    name::String
    available::Bool
    active_power_flow::Float64
    arc::Arc
    rectifier_tap_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    rectifier_xrc::Float64
    rectifier_firing_angle::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    inverter_tap_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    inverter_xrc::Float64
    inverter_firing_angle::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function VSCDCLine(name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    VSCDCLine(name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function VSCDCLine(; name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    VSCDCLine(name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function VSCDCLine(::Nothing)
    VSCDCLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        rectifier_tap_limits=(min=0.0, max=0.0),
        rectifier_xrc=0.0,
        rectifier_firing_angle=(min=0.0, max=0.0),
        inverter_tap_limits=(min=0.0, max=0.0),
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
"""Get VSCDCLine active_power_flow."""
get_active_power_flow(value::VSCDCLine) = get_value(Float64, value, :active_power_flow)
"""Get VSCDCLine arc."""
get_arc(value::VSCDCLine) = value.arc
"""Get VSCDCLine rectifier_tap_limits."""
get_rectifier_tap_limits(value::VSCDCLine) = value.rectifier_tap_limits
"""Get VSCDCLine rectifier_xrc."""
get_rectifier_xrc(value::VSCDCLine) = value.rectifier_xrc
"""Get VSCDCLine rectifier_firing_angle."""
get_rectifier_firing_angle(value::VSCDCLine) = value.rectifier_firing_angle
"""Get VSCDCLine inverter_tap_limits."""
get_inverter_tap_limits(value::VSCDCLine) = value.inverter_tap_limits
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


InfrastructureSystems.set_name!(value::VSCDCLine, val::String) = value.name = val
"""Set VSCDCLine available."""
set_available!(value::VSCDCLine, val::Bool) = value.available = val
"""Set VSCDCLine active_power_flow."""
set_active_power_flow!(value::VSCDCLine, val::Float64) = value.active_power_flow = val
"""Set VSCDCLine arc."""
set_arc!(value::VSCDCLine, val::Arc) = value.arc = val
"""Set VSCDCLine rectifier_tap_limits."""
set_rectifier_tap_limits!(value::VSCDCLine, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.rectifier_tap_limits = val
"""Set VSCDCLine rectifier_xrc."""
set_rectifier_xrc!(value::VSCDCLine, val::Float64) = value.rectifier_xrc = val
"""Set VSCDCLine rectifier_firing_angle."""
set_rectifier_firing_angle!(value::VSCDCLine, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.rectifier_firing_angle = val
"""Set VSCDCLine inverter_tap_limits."""
set_inverter_tap_limits!(value::VSCDCLine, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.inverter_tap_limits = val
"""Set VSCDCLine inverter_xrc."""
set_inverter_xrc!(value::VSCDCLine, val::Float64) = value.inverter_xrc = val
"""Set VSCDCLine inverter_firing_angle."""
set_inverter_firing_angle!(value::VSCDCLine, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.inverter_firing_angle = val
"""Set VSCDCLine services."""
set_services!(value::VSCDCLine, val::Vector{Service}) = value.services = val
"""Set VSCDCLine ext."""
set_ext!(value::VSCDCLine, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::VSCDCLine, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set VSCDCLine internal."""
set_internal!(value::VSCDCLine, val::InfrastructureSystemsInternal) = value.internal = val
