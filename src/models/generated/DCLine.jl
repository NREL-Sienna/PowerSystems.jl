#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct DCLine <: DCBranch
        name::String
        available::Bool
        active_power_flow::Float64
        arc::Arc
        r::Float64
        active_power_limits_from::MinMax
        active_power_limits_to::MinMax
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

a Standard DC line.

# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow::Float64`
- `arc::Arc`
- `r::Float64`: Resistance system per-unit value, validation range: `(0, 10)`, action if invalid: `warn`
- `active_power_limits_from::MinMax`
- `active_power_limits_to::MinMax`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct DCLine <: DCBranch
    name::String
    available::Bool
    active_power_flow::Float64
    arc::Arc
    "Resistance system per-unit value"
    r::Float64
    active_power_limits_from::MinMax
    active_power_limits_to::MinMax
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function DCLine(name, available, active_power_flow, arc, r, active_power_limits_from, active_power_limits_to, services=Device[], ext=Dict{String, Any}(), )
    DCLine(name, available, active_power_flow, arc, r, active_power_limits_from, active_power_limits_to, services, ext, InfrastructureSystemsInternal(), )
end

function DCLine(; name, available, active_power_flow, arc, r, active_power_limits_from, active_power_limits_to, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    DCLine(name, available, active_power_flow, arc, r, active_power_limits_from, active_power_limits_to, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function DCLine(::Nothing)
    DCLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        arc=Arc(DCBus(nothing), DCBus(nothing)),
        r=0.0,
        active_power_limits_from=(min=0.0, max=0.0),
        active_power_limits_to=(min=0.0, max=0.0),
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`DCLine`](@ref) `name`."""
get_name(value::DCLine) = value.name
"""Get [`DCLine`](@ref) `available`."""
get_available(value::DCLine) = value.available
"""Get [`DCLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::DCLine) = get_value(value, value.active_power_flow)
"""Get [`DCLine`](@ref) `arc`."""
get_arc(value::DCLine) = value.arc
"""Get [`DCLine`](@ref) `r`."""
get_r(value::DCLine) = value.r
"""Get [`DCLine`](@ref) `active_power_limits_from`."""
get_active_power_limits_from(value::DCLine) = get_value(value, value.active_power_limits_from)
"""Get [`DCLine`](@ref) `active_power_limits_to`."""
get_active_power_limits_to(value::DCLine) = get_value(value, value.active_power_limits_to)
"""Get [`DCLine`](@ref) `services`."""
get_services(value::DCLine) = value.services
"""Get [`DCLine`](@ref) `ext`."""
get_ext(value::DCLine) = value.ext
"""Get [`DCLine`](@ref) `internal`."""
get_internal(value::DCLine) = value.internal

"""Set [`DCLine`](@ref) `available`."""
set_available!(value::DCLine, val) = value.available = val
"""Set [`DCLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::DCLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`DCLine`](@ref) `arc`."""
set_arc!(value::DCLine, val) = value.arc = val
"""Set [`DCLine`](@ref) `r`."""
set_r!(value::DCLine, val) = value.r = val
"""Set [`DCLine`](@ref) `active_power_limits_from`."""
set_active_power_limits_from!(value::DCLine, val) = value.active_power_limits_from = set_value(value, val)
"""Set [`DCLine`](@ref) `active_power_limits_to`."""
set_active_power_limits_to!(value::DCLine, val) = value.active_power_limits_to = set_value(value, val)
"""Set [`DCLine`](@ref) `services`."""
set_services!(value::DCLine, val) = value.services = val
"""Set [`DCLine`](@ref) `ext`."""
set_ext!(value::DCLine, val) = value.ext = val
