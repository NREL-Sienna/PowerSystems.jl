#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Line <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        b::NamedTuple{(:from, :to), Tuple{Float64, Float64}}
        rate::Float64
        angle_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        services::Vector{Service}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow::Float64`
- `reactive_power_flow::Float64`
- `arc::Arc`
- `r::Float64`: System per-unit value, validation range: `(0, 4)`, action if invalid: `warn`
- `x::Float64`: System per-unit value, validation range: `(0, 4)`, action if invalid: `warn`
- `b::NamedTuple{(:from, :to), Tuple{Float64, Float64}}`: System per-unit value, validation range: `(0, 100)`, action if invalid: `warn`
- `rate::Float64`
- `angle_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`, validation range: `(-1.571, 1.571)`, action if invalid: `error`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Line <: ACBranch
    name::String
    available::Bool
    active_power_flow::Float64
    reactive_power_flow::Float64
    arc::Arc
    "System per-unit value"
    r::Float64
    "System per-unit value"
    x::Float64
    "System per-unit value"
    b::NamedTuple{(:from, :to), Tuple{Float64, Float64}}
    rate::Float64
    angle_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Line(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, rate, angle_limits, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    Line(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, rate, angle_limits, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function Line(; name, available, active_power_flow, reactive_power_flow, arc, r, x, b, rate, angle_limits, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), internal=InfrastructureSystemsInternal(), )
    Line(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, rate, angle_limits, services, ext, forecasts, internal, )
end

# Constructor for demo purposes; non-functional.
function Line(::Nothing)
    Line(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        b=(from=0.0, to=0.0),
        rate=0.0,
        angle_limits=(min=-1.571, max=1.571),
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::Line) = value.name
"""Get [`Line`](@ref) `available`."""
get_available(value::Line) = value.available
"""Get [`Line`](@ref) `active_power_flow`."""
get_active_power_flow(value::Line) = get_value(value, value.active_power_flow)
"""Get [`Line`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::Line) = get_value(value, value.reactive_power_flow)
"""Get [`Line`](@ref) `arc`."""
get_arc(value::Line) = value.arc
"""Get [`Line`](@ref) `r`."""
get_r(value::Line) = value.r
"""Get [`Line`](@ref) `x`."""
get_x(value::Line) = value.x
"""Get [`Line`](@ref) `b`."""
get_b(value::Line) = value.b
"""Get [`Line`](@ref) `rate`."""
get_rate(value::Line) = get_value(value, value.rate)
"""Get [`Line`](@ref) `angle_limits`."""
get_angle_limits(value::Line) = value.angle_limits
"""Get [`Line`](@ref) `services`."""
get_services(value::Line) = value.services
"""Get [`Line`](@ref) `ext`."""
get_ext(value::Line) = value.ext

InfrastructureSystems.get_forecasts(value::Line) = value.forecasts
"""Get [`Line`](@ref) `internal`."""
get_internal(value::Line) = value.internal


InfrastructureSystems.set_name!(value::Line, val) = value.name = val
"""Set [`Line`](@ref) `available`."""
set_available!(value::Line, val) = value.available = val
"""Set [`Line`](@ref) `active_power_flow`."""
set_active_power_flow!(value::Line, val) = value.active_power_flow = val
"""Set [`Line`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::Line, val) = value.reactive_power_flow = val
"""Set [`Line`](@ref) `arc`."""
set_arc!(value::Line, val) = value.arc = val
"""Set [`Line`](@ref) `r`."""
set_r!(value::Line, val) = value.r = val
"""Set [`Line`](@ref) `x`."""
set_x!(value::Line, val) = value.x = val
"""Set [`Line`](@ref) `b`."""
set_b!(value::Line, val) = value.b = val
"""Set [`Line`](@ref) `rate`."""
set_rate!(value::Line, val) = value.rate = val
"""Set [`Line`](@ref) `angle_limits`."""
set_angle_limits!(value::Line, val) = value.angle_limits = val
"""Set [`Line`](@ref) `services`."""
set_services!(value::Line, val) = value.services = val
"""Set [`Line`](@ref) `ext`."""
set_ext!(value::Line, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::Line, val) = value.forecasts = val
"""Set [`Line`](@ref) `internal`."""
set_internal!(value::Line, val) = value.internal = val

