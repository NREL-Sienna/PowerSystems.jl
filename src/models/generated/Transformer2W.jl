#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct Transformer2W <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        primary_shunt::Float64
        rate::Union{Nothing, Float64}
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A 2-winding transformer that uses an equivalent circuit assuming the impedance is on the High Voltage Side of the transformer. The model allocates the iron losses and magnetizing susceptance to the primary side.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `active_power_flow::Float64`
- `reactive_power_flow::Float64`
- `arc::Arc`: Used internally to represent network topology. **Do not modify.**
- `r::Float64`: System per-unit value, validation range: `(-2, 4)`, action if invalid: `warn`
- `x::Float64`: System per-unit value, validation range: `(-2, 4)`, action if invalid: `warn`
- `primary_shunt::Float64`: System per-unit value, validation range: `(0, 2)`, action if invalid: `warn`
- `rate::Union{Nothing, Float64}`, validation range: `(0, nothing)`, action if invalid: `error`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct Transformer2W <: ACBranch
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    active_power_flow::Float64
    reactive_power_flow::Float64
    "Used internally to represent network topology. **Do not modify.**"
    arc::Arc
    "System per-unit value"
    r::Float64
    "System per-unit value"
    x::Float64
    "System per-unit value"
    primary_shunt::Float64
    rate::Union{Nothing, Float64}
    "Services that this device contributes to"
    services::Vector{Service}
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function Transformer2W(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rate, services=Device[], ext=Dict{String, Any}(), )
    Transformer2W(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rate, services, ext, InfrastructureSystemsInternal(), )
end

function Transformer2W(; name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rate, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    Transformer2W(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rate, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function Transformer2W(::Nothing)
    Transformer2W(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        r=0.0,
        x=0.0,
        primary_shunt=0.0,
        rate=nothing,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`Transformer2W`](@ref) `name`."""
get_name(value::Transformer2W) = value.name
"""Get [`Transformer2W`](@ref) `available`."""
get_available(value::Transformer2W) = value.available
"""Get [`Transformer2W`](@ref) `active_power_flow`."""
get_active_power_flow(value::Transformer2W) = get_value(value, value.active_power_flow)
"""Get [`Transformer2W`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::Transformer2W) = get_value(value, value.reactive_power_flow)
"""Get [`Transformer2W`](@ref) `arc`."""
get_arc(value::Transformer2W) = value.arc
"""Get [`Transformer2W`](@ref) `r`."""
get_r(value::Transformer2W) = value.r
"""Get [`Transformer2W`](@ref) `x`."""
get_x(value::Transformer2W) = value.x
"""Get [`Transformer2W`](@ref) `primary_shunt`."""
get_primary_shunt(value::Transformer2W) = value.primary_shunt
"""Get [`Transformer2W`](@ref) `rate`."""
get_rate(value::Transformer2W) = get_value(value, value.rate)
"""Get [`Transformer2W`](@ref) `services`."""
get_services(value::Transformer2W) = value.services
"""Get [`Transformer2W`](@ref) `ext`."""
get_ext(value::Transformer2W) = value.ext
"""Get [`Transformer2W`](@ref) `internal`."""
get_internal(value::Transformer2W) = value.internal

"""Set [`Transformer2W`](@ref) `available`."""
set_available!(value::Transformer2W, val) = value.available = val
"""Set [`Transformer2W`](@ref) `active_power_flow`."""
set_active_power_flow!(value::Transformer2W, val) = value.active_power_flow = set_value(value, val)
"""Set [`Transformer2W`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::Transformer2W, val) = value.reactive_power_flow = set_value(value, val)
"""Set [`Transformer2W`](@ref) `arc`."""
set_arc!(value::Transformer2W, val) = value.arc = val
"""Set [`Transformer2W`](@ref) `r`."""
set_r!(value::Transformer2W, val) = value.r = val
"""Set [`Transformer2W`](@ref) `x`."""
set_x!(value::Transformer2W, val) = value.x = val
"""Set [`Transformer2W`](@ref) `primary_shunt`."""
set_primary_shunt!(value::Transformer2W, val) = value.primary_shunt = val
"""Set [`Transformer2W`](@ref) `rate`."""
set_rate!(value::Transformer2W, val) = value.rate = set_value(value, val)
"""Set [`Transformer2W`](@ref) `services`."""
set_services!(value::Transformer2W, val) = value.services = val
"""Set [`Transformer2W`](@ref) `ext`."""
set_ext!(value::Transformer2W, val) = value.ext = val
