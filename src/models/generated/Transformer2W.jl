#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct Transformer2W <: ACTransmission
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        primary_shunt::Float64
        rating::Union{Nothing, Float64}
        base_power::Float64
        rating_b::Union{Nothing, Float64}
        rating_c::Union{Nothing, Float64}
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A basic 2-winding transformer.

The model uses an equivalent circuit assuming the impedance is on the High Voltage Side of the transformer. The model allocates the iron losses and magnetizing susceptance to the primary side

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `active_power_flow::Float64`: Initial condition of active power flow through the transformer (MW)
- `reactive_power_flow::Float64`: Initial condition of reactive power flow through the transformer (MVAR)
- `arc::Arc`: An [`Arc`](@ref) defining this transformer `from` a bus `to` another bus
- `r::Float64`: Resistance in pu ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(-2, 4)`
- `x::Float64`: Reactance in pu ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(-2, 4)`
- `primary_shunt::Float64`: Shunt reactance in pu ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(0, 2)`
- `rating::Union{Nothing, Float64}`: Thermal rating (MVA). Flow through the transformer must be between -`rating` and `rating`. When defining a transformer before it is attached to a `System`, `rating` must be in pu ([`SYSTEM_BASE`](@ref per_unit)) using the base power of the `System` it will be attached to, validation range: `(0, nothing)`
- `base_power::Float64`: Base power (MVA) for [per unitization](@ref per_unit), validation range: `(0, nothing)`
- `rating_b::Union{Nothing, Float64}`: (default: `nothing`) Second current rating; entered in MVA.
- `rating_c::Union{Nothing, Float64}`: (default: `nothing`) Third current rating; entered in MVA.
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct Transformer2W <: ACTransmission
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Initial condition of active power flow through the transformer (MW)"
    active_power_flow::Float64
    "Initial condition of reactive power flow through the transformer (MVAR)"
    reactive_power_flow::Float64
    "An [`Arc`](@ref) defining this transformer `from` a bus `to` another bus"
    arc::Arc
    "Resistance in pu ([`SYSTEM_BASE`](@ref per_unit))"
    r::Float64
    "Reactance in pu ([`SYSTEM_BASE`](@ref per_unit))"
    x::Float64
    "Shunt reactance in pu ([`SYSTEM_BASE`](@ref per_unit))"
    primary_shunt::Float64
    "Thermal rating (MVA). Flow through the transformer must be between -`rating` and `rating`. When defining a transformer before it is attached to a `System`, `rating` must be in pu ([`SYSTEM_BASE`](@ref per_unit)) using the base power of the `System` it will be attached to"
    rating::Union{Nothing, Float64}
    "Base power (MVA) for [per unitization](@ref per_unit)"
    base_power::Float64
    "Second current rating; entered in MVA."
    rating_b::Union{Nothing, Float64}
    "Third current rating; entered in MVA."
    rating_c::Union{Nothing, Float64}
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function Transformer2W(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rating, base_power, rating_b=nothing, rating_c=nothing, services=Device[], ext=Dict{String, Any}(), )
    Transformer2W(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rating, base_power, rating_b, rating_c, services, ext, InfrastructureSystemsInternal(), )
end

function Transformer2W(; name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rating, base_power, rating_b=nothing, rating_c=nothing, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    Transformer2W(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, rating, base_power, rating_b, rating_c, services, ext, internal, )
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
        rating=nothing,
        base_power=0.0,
        rating_b=0.0,
        rating_c=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`Transformer2W`](@ref) `name`."""
get_name(value::Transformer2W) = value.name
"""Get [`Transformer2W`](@ref) `available`."""
get_available(value::Transformer2W) = value.available
"""Get [`Transformer2W`](@ref) `active_power_flow`."""
get_active_power_flow(value::Transformer2W) = get_value(value, value.active_power_flow, Val(:mva))
"""Get [`Transformer2W`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::Transformer2W) = get_value(value, value.reactive_power_flow, Val(:mva))
"""Get [`Transformer2W`](@ref) `arc`."""
get_arc(value::Transformer2W) = value.arc
"""Get [`Transformer2W`](@ref) `r`."""
get_r(value::Transformer2W) = value.r
"""Get [`Transformer2W`](@ref) `x`."""
get_x(value::Transformer2W) = value.x
"""Get [`Transformer2W`](@ref) `primary_shunt`."""
get_primary_shunt(value::Transformer2W) = value.primary_shunt
"""Get [`Transformer2W`](@ref) `rating`."""
get_rating(value::Transformer2W) = get_value(value, value.rating, Val(:mva))
"""Get [`Transformer2W`](@ref) `base_power`."""
get_base_power(value::Transformer2W) = value.base_power
"""Get [`Transformer2W`](@ref) `rating_b`."""
get_rating_b(value::Transformer2W) = get_value(value, value.rating_b, Val(:mva))
"""Get [`Transformer2W`](@ref) `rating_c`."""
get_rating_c(value::Transformer2W) = get_value(value, value.rating_c, Val(:mva))
"""Get [`Transformer2W`](@ref) `services`."""
get_services(value::Transformer2W) = value.services
"""Get [`Transformer2W`](@ref) `ext`."""
get_ext(value::Transformer2W) = value.ext
"""Get [`Transformer2W`](@ref) `internal`."""
get_internal(value::Transformer2W) = value.internal

"""Set [`Transformer2W`](@ref) `available`."""
set_available!(value::Transformer2W, val) = value.available = val
"""Set [`Transformer2W`](@ref) `active_power_flow`."""
set_active_power_flow!(value::Transformer2W, val) = value.active_power_flow = set_value(value, val, Val(:mva))
"""Set [`Transformer2W`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::Transformer2W, val) = value.reactive_power_flow = set_value(value, val, Val(:mva))
"""Set [`Transformer2W`](@ref) `arc`."""
set_arc!(value::Transformer2W, val) = value.arc = val
"""Set [`Transformer2W`](@ref) `r`."""
set_r!(value::Transformer2W, val) = value.r = val
"""Set [`Transformer2W`](@ref) `x`."""
set_x!(value::Transformer2W, val) = value.x = val
"""Set [`Transformer2W`](@ref) `primary_shunt`."""
set_primary_shunt!(value::Transformer2W, val) = value.primary_shunt = val
"""Set [`Transformer2W`](@ref) `rating`."""
set_rating!(value::Transformer2W, val) = value.rating = set_value(value, val, Val(:mva))
"""Set [`Transformer2W`](@ref) `base_power`."""
set_base_power!(value::Transformer2W, val) = value.base_power = val
"""Set [`Transformer2W`](@ref) `rating_b`."""
set_rating_b!(value::Transformer2W, val) = value.rating_b = set_value(value, val, Val(:mva))
"""Set [`Transformer2W`](@ref) `rating_c`."""
set_rating_c!(value::Transformer2W, val) = value.rating_c = set_value(value, val, Val(:mva))
"""Set [`Transformer2W`](@ref) `services`."""
set_services!(value::Transformer2W, val) = value.services = val
"""Set [`Transformer2W`](@ref) `ext`."""
set_ext!(value::Transformer2W, val) = value.ext = val
