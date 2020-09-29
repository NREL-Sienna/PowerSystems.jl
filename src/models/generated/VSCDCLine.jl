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

function VSCDCLine(; name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), internal=InfrastructureSystemsInternal(), )
    VSCDCLine(name, available, active_power_flow, arc, rectifier_tap_limits, rectifier_xrc, rectifier_firing_angle, inverter_tap_limits, inverter_xrc, inverter_firing_angle, services, ext, forecasts, internal, )
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
"""Get [`VSCDCLine`](@ref) `available`."""
get_available(value::VSCDCLine) = value.available
"""Get [`VSCDCLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::VSCDCLine) = get_value(value, value.active_power_flow)
"""Get [`VSCDCLine`](@ref) `arc`."""
get_arc(value::VSCDCLine) = value.arc
"""Get [`VSCDCLine`](@ref) `rectifier_tap_limits`."""
get_rectifier_tap_limits(value::VSCDCLine) = value.rectifier_tap_limits
"""Get [`VSCDCLine`](@ref) `rectifier_xrc`."""
get_rectifier_xrc(value::VSCDCLine) = value.rectifier_xrc
"""Get [`VSCDCLine`](@ref) `rectifier_firing_angle`."""
get_rectifier_firing_angle(value::VSCDCLine) = value.rectifier_firing_angle
"""Get [`VSCDCLine`](@ref) `inverter_tap_limits`."""
get_inverter_tap_limits(value::VSCDCLine) = value.inverter_tap_limits
"""Get [`VSCDCLine`](@ref) `inverter_xrc`."""
get_inverter_xrc(value::VSCDCLine) = value.inverter_xrc
"""Get [`VSCDCLine`](@ref) `inverter_firing_angle`."""
get_inverter_firing_angle(value::VSCDCLine) = value.inverter_firing_angle
"""Get [`VSCDCLine`](@ref) `services`."""
get_services(value::VSCDCLine) = value.services
"""Get [`VSCDCLine`](@ref) `ext`."""
get_ext(value::VSCDCLine) = value.ext

InfrastructureSystems.get_forecasts(value::VSCDCLine) = value.forecasts
"""Get [`VSCDCLine`](@ref) `internal`."""
get_internal(value::VSCDCLine) = value.internal


InfrastructureSystems.set_name!(value::VSCDCLine, val) = value.name = val
"""Set [`VSCDCLine`](@ref) `available`."""
set_available!(value::VSCDCLine, val) = value.available = val
"""Set [`VSCDCLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::VSCDCLine, val) = value.active_power_flow = val
"""Set [`VSCDCLine`](@ref) `arc`."""
set_arc!(value::VSCDCLine, val) = value.arc = val
"""Set [`VSCDCLine`](@ref) `rectifier_tap_limits`."""
set_rectifier_tap_limits!(value::VSCDCLine, val) = value.rectifier_tap_limits = val
"""Set [`VSCDCLine`](@ref) `rectifier_xrc`."""
set_rectifier_xrc!(value::VSCDCLine, val) = value.rectifier_xrc = val
"""Set [`VSCDCLine`](@ref) `rectifier_firing_angle`."""
set_rectifier_firing_angle!(value::VSCDCLine, val) = value.rectifier_firing_angle = val
"""Set [`VSCDCLine`](@ref) `inverter_tap_limits`."""
set_inverter_tap_limits!(value::VSCDCLine, val) = value.inverter_tap_limits = val
"""Set [`VSCDCLine`](@ref) `inverter_xrc`."""
set_inverter_xrc!(value::VSCDCLine, val) = value.inverter_xrc = val
"""Set [`VSCDCLine`](@ref) `inverter_firing_angle`."""
set_inverter_firing_angle!(value::VSCDCLine, val) = value.inverter_firing_angle = val
"""Set [`VSCDCLine`](@ref) `services`."""
set_services!(value::VSCDCLine, val) = value.services = val
"""Set [`VSCDCLine`](@ref) `ext`."""
set_ext!(value::VSCDCLine, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::VSCDCLine, val) = value.forecasts = val
"""Set [`VSCDCLine`](@ref) `internal`."""
set_internal!(value::VSCDCLine, val) = value.internal = val

