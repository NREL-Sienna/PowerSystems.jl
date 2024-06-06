#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct Line <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        b::FromTo
        rating::Float64
        angle_limits::MinMax
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

An AC transmission line

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `active_power_flow::Float64`: Initial condition of active power flow on the line (MW)
- `reactive_power_flow::Float64`: Initial condition of reactive power flow on the line (MVAR)
- `arc::Arc`: An [`Arc`](@ref) defining this line `from` a bus `to` another bus
- `r::Float64`: Resistance in pu ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(0, 4)`
- `x::Float64`: Reactance in pu ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(0, 4)`
- `b::FromTo`: Shunt susceptance in pu ([`SYSTEM_BASE`](@ref per_unit)), specified both on the `from` and `to` ends of the line. These are commonly modeled with the same value, validation range: `(0, 100)`
- `rating::Float64`: Thermal rating (MVA). Flow on the line must be between -`rating` and `rating`
- `angle_limits::MinMax`: Minimum and maximum angle limits (radians), validation range: `(-1.571, 1.571)`
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct Line <: ACBranch
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Initial condition of active power flow on the line (MW)"
    active_power_flow::Float64
    "Initial condition of reactive power flow on the line (MVAR)"
    reactive_power_flow::Float64
    "An [`Arc`](@ref) defining this line `from` a bus `to` another bus"
    arc::Arc
    "Resistance in pu ([`SYSTEM_BASE`](@ref per_unit))"
    r::Float64
    "Reactance in pu ([`SYSTEM_BASE`](@ref per_unit))"
    x::Float64
    "Shunt susceptance in pu ([`SYSTEM_BASE`](@ref per_unit)), specified both on the `from` and `to` ends of the line. These are commonly modeled with the same value"
    b::FromTo
    "Thermal rating (MVA). Flow on the line must be between -`rating` and `rating`"
    rating::Float64
    "Minimum and maximum angle limits (radians)"
    angle_limits::MinMax
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function Line(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, rating, angle_limits, services=Device[], ext=Dict{String, Any}(), )
    Line(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, rating, angle_limits, services, ext, InfrastructureSystemsInternal(), )
end

function Line(; name, available, active_power_flow, reactive_power_flow, arc, r, x, b, rating, angle_limits, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    Line(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, rating, angle_limits, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function Line(::Nothing)
    Line(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        r=0.0,
        x=0.0,
        b=(from=0.0, to=0.0),
        rating=0.0,
        angle_limits=(min=-1.571, max=1.571),
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`Line`](@ref) `name`."""
get_name(value::Line) = value.name
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
"""Get [`Line`](@ref) `rating`."""
get_rating(value::Line) = get_value(value, value.rating)
"""Get [`Line`](@ref) `angle_limits`."""
get_angle_limits(value::Line) = value.angle_limits
"""Get [`Line`](@ref) `services`."""
get_services(value::Line) = value.services
"""Get [`Line`](@ref) `ext`."""
get_ext(value::Line) = value.ext
"""Get [`Line`](@ref) `internal`."""
get_internal(value::Line) = value.internal

"""Set [`Line`](@ref) `available`."""
set_available!(value::Line, val) = value.available = val
"""Set [`Line`](@ref) `active_power_flow`."""
set_active_power_flow!(value::Line, val) = value.active_power_flow = set_value(value, val)
"""Set [`Line`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::Line, val) = value.reactive_power_flow = set_value(value, val)
"""Set [`Line`](@ref) `arc`."""
set_arc!(value::Line, val) = value.arc = val
"""Set [`Line`](@ref) `r`."""
set_r!(value::Line, val) = value.r = val
"""Set [`Line`](@ref) `x`."""
set_x!(value::Line, val) = value.x = val
"""Set [`Line`](@ref) `b`."""
set_b!(value::Line, val) = value.b = val
"""Set [`Line`](@ref) `rating`."""
set_rating!(value::Line, val) = value.rating = set_value(value, val)
"""Set [`Line`](@ref) `angle_limits`."""
set_angle_limits!(value::Line, val) = value.angle_limits = val
"""Set [`Line`](@ref) `services`."""
set_services!(value::Line, val) = value.services = val
"""Set [`Line`](@ref) `ext`."""
set_ext!(value::Line, val) = value.ext = val
