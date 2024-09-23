#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct MonitoredLine <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        b::FromTo
        flow_limits::FromTo_ToFrom
        rating::Float64
        angle_limits::MinMax
        g::FromTo
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

An AC transmission line with additional power flow constraints specified by the system operator, more restrictive than the line's thermal limits.

For example, monitored lines can be used to restrict line flow following a contingency elsewhere in the network. See the `flow_limits` parameter. If monitoring is not needed, see [`Line`](@ref)

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `active_power_flow::Float64`: Initial condition of active power flow on the line (MW)
- `reactive_power_flow::Float64`: Initial condition of reactive power flow on the line (MVAR)
- `arc::Arc`: An [`Arc`](@ref) defining this line `from` a bus `to` another bus
- `r::Float64`: Resistance in pu ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(0, 4)`
- `x::Float64`: Reactance in pu ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(0, 4)`
- `b::FromTo`: Shunt susceptance in pu ([`SYSTEM_BASE`](@ref per_unit)), specified both on the `from` and `to` ends of the line. These are commonly modeled with the same value, validation range: `(0, 2)`
- `flow_limits::FromTo_ToFrom`: Minimum and maximum permissable flow on the line (MVA), if different from the thermal rating defined in `rating`
- `rating::Float64`: Thermal rating (MVA). Flow through the transformer must be between -`rating` and `rating`. When defining a line before it is attached to a `System`, `rating` must be in per-unit divided by the base power of the `System` it will be attached to
- `angle_limits::MinMax`: Minimum and maximum angle limits (radians), validation range: `(-1.571, 1.571)`
- `g::FromTo`: (default: `(from=0.0, to=0.0)`) Shunt conductance in pu ([`SYSTEM_BASE`](@ref per_unit)), specified both on the `from` and `to` ends of the line. These are commonly modeled with the same value, validation range: `(0, 100)`
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct MonitoredLine <: ACBranch
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
    "Minimum and maximum permissable flow on the line (MVA), if different from the thermal rating defined in `rating`"
    flow_limits::FromTo_ToFrom
    "Thermal rating (MVA). Flow through the transformer must be between -`rating` and `rating`. When defining a line before it is attached to a `System`, `rating` must be in per-unit divided by the base power of the `System` it will be attached to"
    rating::Float64
    "Minimum and maximum angle limits (radians)"
    angle_limits::MinMax
    "Shunt conductance in pu ([`SYSTEM_BASE`](@ref per_unit)), specified both on the `from` and `to` ends of the line. These are commonly modeled with the same value"
    g::FromTo
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function MonitoredLine(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rating, angle_limits, g=(from=0.0, to=0.0), services=Device[], ext=Dict{String, Any}(), )
    MonitoredLine(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rating, angle_limits, g, services, ext, InfrastructureSystemsInternal(), )
end

function MonitoredLine(; name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rating, angle_limits, g=(from=0.0, to=0.0), services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    MonitoredLine(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rating, angle_limits, g, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function MonitoredLine(::Nothing)
    MonitoredLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        r=0.0,
        x=0.0,
        b=(from=0.0, to=0.0),
        flow_limits=(from_to=0.0, to_from=0.0),
        rating=0.0,
        angle_limits=(min=-1.571, max=1.571),
        g=(from=0.0, to=0.0),
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`MonitoredLine`](@ref) `name`."""
get_name(value::MonitoredLine) = value.name
"""Get [`MonitoredLine`](@ref) `available`."""
get_available(value::MonitoredLine) = value.available
"""Get [`MonitoredLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::MonitoredLine) = get_value(value, value.active_power_flow)
"""Get [`MonitoredLine`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::MonitoredLine) = get_value(value, value.reactive_power_flow)
"""Get [`MonitoredLine`](@ref) `arc`."""
get_arc(value::MonitoredLine) = value.arc
"""Get [`MonitoredLine`](@ref) `r`."""
get_r(value::MonitoredLine) = value.r
"""Get [`MonitoredLine`](@ref) `x`."""
get_x(value::MonitoredLine) = value.x
"""Get [`MonitoredLine`](@ref) `b`."""
get_b(value::MonitoredLine) = value.b
"""Get [`MonitoredLine`](@ref) `flow_limits`."""
get_flow_limits(value::MonitoredLine) = get_value(value, value.flow_limits)
"""Get [`MonitoredLine`](@ref) `rating`."""
get_rating(value::MonitoredLine) = get_value(value, value.rating)
"""Get [`MonitoredLine`](@ref) `angle_limits`."""
get_angle_limits(value::MonitoredLine) = value.angle_limits
"""Get [`MonitoredLine`](@ref) `g`."""
get_g(value::MonitoredLine) = value.g
"""Get [`MonitoredLine`](@ref) `services`."""
get_services(value::MonitoredLine) = value.services
"""Get [`MonitoredLine`](@ref) `ext`."""
get_ext(value::MonitoredLine) = value.ext
"""Get [`MonitoredLine`](@ref) `internal`."""
get_internal(value::MonitoredLine) = value.internal

"""Set [`MonitoredLine`](@ref) `available`."""
set_available!(value::MonitoredLine, val) = value.available = val
"""Set [`MonitoredLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::MonitoredLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::MonitoredLine, val) = value.reactive_power_flow = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `arc`."""
set_arc!(value::MonitoredLine, val) = value.arc = val
"""Set [`MonitoredLine`](@ref) `r`."""
set_r!(value::MonitoredLine, val) = value.r = val
"""Set [`MonitoredLine`](@ref) `x`."""
set_x!(value::MonitoredLine, val) = value.x = val
"""Set [`MonitoredLine`](@ref) `b`."""
set_b!(value::MonitoredLine, val) = value.b = val
"""Set [`MonitoredLine`](@ref) `flow_limits`."""
set_flow_limits!(value::MonitoredLine, val) = value.flow_limits = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `rating`."""
set_rating!(value::MonitoredLine, val) = value.rating = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `angle_limits`."""
set_angle_limits!(value::MonitoredLine, val) = value.angle_limits = val
"""Set [`MonitoredLine`](@ref) `g`."""
set_g!(value::MonitoredLine, val) = value.g = val
"""Set [`MonitoredLine`](@ref) `services`."""
set_services!(value::MonitoredLine, val) = value.services = val
"""Set [`MonitoredLine`](@ref) `ext`."""
set_ext!(value::MonitoredLine, val) = value.ext = val
