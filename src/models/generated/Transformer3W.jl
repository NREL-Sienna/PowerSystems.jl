#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct Transformer3W <: ACBranch
        name::String
        available::Bool
        primary_secondary_arc::Arc
        secondary_tertiary_arc::Arc
        primary_tertiary_arc::Arc
        star_bus::ACBus
        active_power_flow_primary::Float64
        reactive_power_flow_primary::Float64
        active_power_flow_secondary::Float64
        reactive_power_flow_secondary::Float64
        active_power_flow_tertiary::Float64
        reactive_power_flow_tertiary::Float64
        r_primary::Float64
        x_primary::Float64
        r_secondary::Float64
        x_secondary::Float64
        r_tertiary::Float64
        x_tertiary::Float64
        rating::Union{Nothing, Float64}
        r_12::Float64
        x_12::Float64
        r_23::Float64
        x_23::Float64
        r_13::Float64
        x_13::Float64
        g::Float64
        b::Float64
        primary_turns_ratio::Float64
        secondary_turns_ratio::Float64
        tertiary_turns_ratio::Float64
        available_primary::Bool
        available_secondary::Bool
        available_tertiary::Bool
        rating_primary::Float64
        rating_secondary::Float64
        rating_tertiary::Float64
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A 3-winding transformer.

The model uses an equivalent star model with a star (hidden) bus. The user must transform the data to use `CW = CZ = CM = 1` and `COD1 = COD2 = COD3 = 0` (no voltage control) if taken from a PSS/E 3W transformer model. Three equivalent impedances (connecting each side to the star bus) are required to define the model. Shunt conductance (iron losses) and magnetizing susceptance can be considered from the star bus to ground. The model is described in Chapter 3.6 in J.D. Glover, M.S. Sarma and T. Overbye: Power Systems Analysis and Design.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `primary_secondary_arc::Arc`: An [`Arc`](@ref) defining this transformer `from` a primary bus `to` a secondary bus
- `secondary_tertiary_arc::Arc`: An [`Arc`](@ref) defining this transformer `from` a secondary bus `to` a tertiary bus
- `primary_tertiary_arc::Arc`: An [`Arc`](@ref) defining this transformer `from` a primary bus `to` a tertiary bus
- `star_bus::ACBus`: Star (hidden) Bus that this component (equivalent model) is connected to
- `active_power_flow_primary::Float64`: Initial condition of active power flow through the transformer primary side to star (hidden) bus (MW)
- `reactive_power_flow_primary::Float64`: Initial condition of reactive power flow through the transformer primary side to star (hidden) bus (MW)
- `active_power_flow_secondary::Float64`: Initial condition of active power flow through the transformer secondary side to star (hidden) bus (MW)
- `reactive_power_flow_secondary::Float64`: Initial condition of reactive power flow through the transformer secondary side to star (hidden) bus (MW)
- `active_power_flow_tertiary::Float64`: Initial condition of active power flow through the transformer tertiary side to star (hidden) bus (MW)
- `reactive_power_flow_tertiary::Float64`: Initial condition of reactive power flow through the transformer tertiary side to star (hidden) bus (MW)
- `r_primary::Float64`: Equivalent resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to star (hidden) bus., validation range: `(-2, 4)`
- `x_primary::Float64`: Equivalent reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to star (hidden) bus., validation range: `(-2, 4)`
- `r_secondary::Float64`: Equivalent resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from secondary to star (hidden) bus., validation range: `(-2, 4)`
- `x_secondary::Float64`: Equivalent reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from secondary to star (hidden) bus., validation range: `(-2, 4)`
- `r_tertiary::Float64`: Equivalent resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from tertiary to star (hidden) bus., validation range: `(-2, 4)`
- `x_tertiary::Float64`: Equivalent reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from tertiary to star (hidden) bus., validation range: `(-2, 4)`
- `rating::Union{Nothing, Float64}`: Thermal rating (MVA). Flow through the transformer must be between -`rating` and `rating`. When defining a transformer before it is attached to a `System`, `rating` must be in pu ([`SYSTEM_BASE`](@ref per_unit)) using the base power of the `System` it will be attached to, validation range: `(0, nothing)`
- `r_12::Float64`: Measured resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to secondary windings (R1-2 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `x_12::Float64`: Measured reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to secondary windings (X1-2 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `r_23::Float64`: Measured resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from secondary to tertiary windings (R2-3 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `x_23::Float64`: Measured reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from secondary to tertiary windings (X2-3 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `r_13::Float64`: Measured resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to tertiary windings (R1-3 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `x_13::Float64`: Measured reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to tertiary windings (X1-3 with CZ = 1 in PSS/E)., validation range: `(0, 4)`
- `g::Float64`: (default: `0.0`) Shunt conductance in pu ([`SYSTEM_BASE`](@ref per_unit)) from star (hidden) bus to ground (MAG1 in PSS/E).
- `b::Float64`: (default: `0.0`) Shunt susceptance in pu ([`SYSTEM_BASE`](@ref per_unit)) from star (hidden) bus to ground (MAG2 in PSS/E).
- `primary_turns_ratio::Float64`: (default: `1.0`) Primary side off-nominal turns ratio in p.u. with respect to connected primary bus (WINDV1 with CW = 1 in PSS/E).
- `secondary_turns_ratio::Float64`: (default: `1.0`) Secondary side off-nominal turns ratio in p.u. with respect to connected secondary bus (WINDV2 with CW = 1 in PSS/E).
- `tertiary_turns_ratio::Float64`: (default: `1.0`) Tertiary side off-nominal turns ratio in p.u. with respect to connected tertiary bus (WINDV3 with CW = 1 in PSS/E).
- `available_primary::Bool`: (default: `true`) Status if primary winding is available or not.
- `available_secondary::Bool`: (default: `true`) Status if primary winding is available or not.
- `available_tertiary::Bool`: (default: `true`) Status if primary winding is available or not.
- `rating_primary::Float64`: (default: `0.0`) Rating (in MVA) for primary winding.
- `rating_secondary::Float64`: (default: `0.0`) Rating (in MVA) for secondary winding.
- `rating_tertiary::Float64`: (default: `0.0`) Rating (in MVA) for tertiary winding.
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct Transformer3W <: ACBranch
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "An [`Arc`](@ref) defining this transformer `from` a primary bus `to` a secondary bus"
    primary_secondary_arc::Arc
    "An [`Arc`](@ref) defining this transformer `from` a secondary bus `to` a tertiary bus"
    secondary_tertiary_arc::Arc
    "An [`Arc`](@ref) defining this transformer `from` a primary bus `to` a tertiary bus"
    primary_tertiary_arc::Arc
    "Star (hidden) Bus that this component (equivalent model) is connected to"
    star_bus::ACBus
    "Initial condition of active power flow through the transformer primary side to star (hidden) bus (MW)"
    active_power_flow_primary::Float64
    "Initial condition of reactive power flow through the transformer primary side to star (hidden) bus (MW)"
    reactive_power_flow_primary::Float64
    "Initial condition of active power flow through the transformer secondary side to star (hidden) bus (MW)"
    active_power_flow_secondary::Float64
    "Initial condition of reactive power flow through the transformer secondary side to star (hidden) bus (MW)"
    reactive_power_flow_secondary::Float64
    "Initial condition of active power flow through the transformer tertiary side to star (hidden) bus (MW)"
    active_power_flow_tertiary::Float64
    "Initial condition of reactive power flow through the transformer tertiary side to star (hidden) bus (MW)"
    reactive_power_flow_tertiary::Float64
    "Equivalent resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to star (hidden) bus."
    r_primary::Float64
    "Equivalent reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to star (hidden) bus."
    x_primary::Float64
    "Equivalent resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from secondary to star (hidden) bus."
    r_secondary::Float64
    "Equivalent reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from secondary to star (hidden) bus."
    x_secondary::Float64
    "Equivalent resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from tertiary to star (hidden) bus."
    r_tertiary::Float64
    "Equivalent reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from tertiary to star (hidden) bus."
    x_tertiary::Float64
    "Thermal rating (MVA). Flow through the transformer must be between -`rating` and `rating`. When defining a transformer before it is attached to a `System`, `rating` must be in pu ([`SYSTEM_BASE`](@ref per_unit)) using the base power of the `System` it will be attached to"
    rating::Union{Nothing, Float64}
    "Measured resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to secondary windings (R1-2 with CZ = 1 in PSS/E)."
    r_12::Float64
    "Measured reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to secondary windings (X1-2 with CZ = 1 in PSS/E)."
    x_12::Float64
    "Measured resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from secondary to tertiary windings (R2-3 with CZ = 1 in PSS/E)."
    r_23::Float64
    "Measured reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from secondary to tertiary windings (X2-3 with CZ = 1 in PSS/E)."
    x_23::Float64
    "Measured resistance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to tertiary windings (R1-3 with CZ = 1 in PSS/E)."
    r_13::Float64
    "Measured reactance in pu ([`SYSTEM_BASE`](@ref per_unit)) from primary to tertiary windings (X1-3 with CZ = 1 in PSS/E)."
    x_13::Float64
    "Shunt conductance in pu ([`SYSTEM_BASE`](@ref per_unit)) from star (hidden) bus to ground (MAG1 in PSS/E)."
    g::Float64
    "Shunt susceptance in pu ([`SYSTEM_BASE`](@ref per_unit)) from star (hidden) bus to ground (MAG2 in PSS/E)."
    b::Float64
    "Primary side off-nominal turns ratio in p.u. with respect to connected primary bus (WINDV1 with CW = 1 in PSS/E)."
    primary_turns_ratio::Float64
    "Secondary side off-nominal turns ratio in p.u. with respect to connected secondary bus (WINDV2 with CW = 1 in PSS/E)."
    secondary_turns_ratio::Float64
    "Tertiary side off-nominal turns ratio in p.u. with respect to connected tertiary bus (WINDV3 with CW = 1 in PSS/E)."
    tertiary_turns_ratio::Float64
    "Status if primary winding is available or not."
    available_primary::Bool
    "Status if primary winding is available or not."
    available_secondary::Bool
    "Status if primary winding is available or not."
    available_tertiary::Bool
    "Rating (in MVA) for primary winding."
    rating_primary::Float64
    "Rating (in MVA) for secondary winding."
    rating_secondary::Float64
    "Rating (in MVA) for tertiary winding."
    rating_tertiary::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function Transformer3W(name, available, primary_secondary_arc, secondary_tertiary_arc, primary_tertiary_arc, star_bus, active_power_flow_primary, reactive_power_flow_primary, active_power_flow_secondary, reactive_power_flow_secondary, active_power_flow_tertiary, reactive_power_flow_tertiary, r_primary, x_primary, r_secondary, x_secondary, r_tertiary, x_tertiary, rating, r_12, x_12, r_23, x_23, r_13, x_13, g=0.0, b=0.0, primary_turns_ratio=1.0, secondary_turns_ratio=1.0, tertiary_turns_ratio=1.0, available_primary=true, available_secondary=true, available_tertiary=true, rating_primary=0.0, rating_secondary=0.0, rating_tertiary=0.0, services=Device[], ext=Dict{String, Any}(), )
    Transformer3W(name, available, primary_secondary_arc, secondary_tertiary_arc, primary_tertiary_arc, star_bus, active_power_flow_primary, reactive_power_flow_primary, active_power_flow_secondary, reactive_power_flow_secondary, active_power_flow_tertiary, reactive_power_flow_tertiary, r_primary, x_primary, r_secondary, x_secondary, r_tertiary, x_tertiary, rating, r_12, x_12, r_23, x_23, r_13, x_13, g, b, primary_turns_ratio, secondary_turns_ratio, tertiary_turns_ratio, available_primary, available_secondary, available_tertiary, rating_primary, rating_secondary, rating_tertiary, services, ext, InfrastructureSystemsInternal(), )
end

function Transformer3W(; name, available, primary_secondary_arc, secondary_tertiary_arc, primary_tertiary_arc, star_bus, active_power_flow_primary, reactive_power_flow_primary, active_power_flow_secondary, reactive_power_flow_secondary, active_power_flow_tertiary, reactive_power_flow_tertiary, r_primary, x_primary, r_secondary, x_secondary, r_tertiary, x_tertiary, rating, r_12, x_12, r_23, x_23, r_13, x_13, g=0.0, b=0.0, primary_turns_ratio=1.0, secondary_turns_ratio=1.0, tertiary_turns_ratio=1.0, available_primary=true, available_secondary=true, available_tertiary=true, rating_primary=0.0, rating_secondary=0.0, rating_tertiary=0.0, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    Transformer3W(name, available, primary_secondary_arc, secondary_tertiary_arc, primary_tertiary_arc, star_bus, active_power_flow_primary, reactive_power_flow_primary, active_power_flow_secondary, reactive_power_flow_secondary, active_power_flow_tertiary, reactive_power_flow_tertiary, r_primary, x_primary, r_secondary, x_secondary, r_tertiary, x_tertiary, rating, r_12, x_12, r_23, x_23, r_13, x_13, g, b, primary_turns_ratio, secondary_turns_ratio, tertiary_turns_ratio, available_primary, available_secondary, available_tertiary, rating_primary, rating_secondary, rating_tertiary, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function Transformer3W(::Nothing)
    Transformer3W(;
        name="init",
        available=false,
        primary_secondary_arc=Arc(ACBus(nothing), ACBus(nothing)),
        secondary_tertiary_arc=Arc(ACBus(nothing), ACBus(nothing)),
        primary_tertiary_arc=Arc(ACBus(nothing), ACBus(nothing)),
        star_bus=ACBus(nothing),
        active_power_flow_primary=0.0,
        reactive_power_flow_primary=0.0,
        active_power_flow_secondary=0.0,
        reactive_power_flow_secondary=0.0,
        active_power_flow_tertiary=0.0,
        reactive_power_flow_tertiary=0.0,
        r_primary=0.0,
        x_primary=0.0,
        r_secondary=0.0,
        x_secondary=0.0,
        r_tertiary=0.0,
        x_tertiary=0.0,
        rating=nothing,
        r_12=0.0,
        x_12=0.0,
        r_23=0.0,
        x_23=0.0,
        r_13=0.0,
        x_13=0.0,
        g=0.0,
        b=0.0,
        primary_turns_ratio=0.0,
        secondary_turns_ratio=0.0,
        tertiary_turns_ratio=0.0,
        available_primary=false,
        available_secondary=false,
        available_tertiary=false,
        rating_primary=0.0,
        rating_secondary=0.0,
        rating_tertiary=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`Transformer3W`](@ref) `name`."""
get_name(value::Transformer3W) = value.name
"""Get [`Transformer3W`](@ref) `available`."""
get_available(value::Transformer3W) = value.available
"""Get [`Transformer3W`](@ref) `primary_secondary_arc`."""
get_primary_secondary_arc(value::Transformer3W) = value.primary_secondary_arc
"""Get [`Transformer3W`](@ref) `secondary_tertiary_arc`."""
get_secondary_tertiary_arc(value::Transformer3W) = value.secondary_tertiary_arc
"""Get [`Transformer3W`](@ref) `primary_tertiary_arc`."""
get_primary_tertiary_arc(value::Transformer3W) = value.primary_tertiary_arc
"""Get [`Transformer3W`](@ref) `star_bus`."""
get_star_bus(value::Transformer3W) = value.star_bus
"""Get [`Transformer3W`](@ref) `active_power_flow_primary`."""
get_active_power_flow_primary(value::Transformer3W) = get_value(value, value.active_power_flow_primary)
"""Get [`Transformer3W`](@ref) `reactive_power_flow_primary`."""
get_reactive_power_flow_primary(value::Transformer3W) = get_value(value, value.reactive_power_flow_primary)
"""Get [`Transformer3W`](@ref) `active_power_flow_secondary`."""
get_active_power_flow_secondary(value::Transformer3W) = get_value(value, value.active_power_flow_secondary)
"""Get [`Transformer3W`](@ref) `reactive_power_flow_secondary`."""
get_reactive_power_flow_secondary(value::Transformer3W) = get_value(value, value.reactive_power_flow_secondary)
"""Get [`Transformer3W`](@ref) `active_power_flow_tertiary`."""
get_active_power_flow_tertiary(value::Transformer3W) = get_value(value, value.active_power_flow_tertiary)
"""Get [`Transformer3W`](@ref) `reactive_power_flow_tertiary`."""
get_reactive_power_flow_tertiary(value::Transformer3W) = get_value(value, value.reactive_power_flow_tertiary)
"""Get [`Transformer3W`](@ref) `r_primary`."""
get_r_primary(value::Transformer3W) = value.r_primary
"""Get [`Transformer3W`](@ref) `x_primary`."""
get_x_primary(value::Transformer3W) = value.x_primary
"""Get [`Transformer3W`](@ref) `r_secondary`."""
get_r_secondary(value::Transformer3W) = value.r_secondary
"""Get [`Transformer3W`](@ref) `x_secondary`."""
get_x_secondary(value::Transformer3W) = value.x_secondary
"""Get [`Transformer3W`](@ref) `r_tertiary`."""
get_r_tertiary(value::Transformer3W) = value.r_tertiary
"""Get [`Transformer3W`](@ref) `x_tertiary`."""
get_x_tertiary(value::Transformer3W) = value.x_tertiary
"""Get [`Transformer3W`](@ref) `rating`."""
get_rating(value::Transformer3W) = get_value(value, value.rating)
"""Get [`Transformer3W`](@ref) `r_12`."""
get_r_12(value::Transformer3W) = value.r_12
"""Get [`Transformer3W`](@ref) `x_12`."""
get_x_12(value::Transformer3W) = value.x_12
"""Get [`Transformer3W`](@ref) `r_23`."""
get_r_23(value::Transformer3W) = value.r_23
"""Get [`Transformer3W`](@ref) `x_23`."""
get_x_23(value::Transformer3W) = value.x_23
"""Get [`Transformer3W`](@ref) `r_13`."""
get_r_13(value::Transformer3W) = value.r_13
"""Get [`Transformer3W`](@ref) `x_13`."""
get_x_13(value::Transformer3W) = value.x_13
"""Get [`Transformer3W`](@ref) `g`."""
get_g(value::Transformer3W) = value.g
"""Get [`Transformer3W`](@ref) `b`."""
get_b(value::Transformer3W) = value.b
"""Get [`Transformer3W`](@ref) `primary_turns_ratio`."""
get_primary_turns_ratio(value::Transformer3W) = value.primary_turns_ratio
"""Get [`Transformer3W`](@ref) `secondary_turns_ratio`."""
get_secondary_turns_ratio(value::Transformer3W) = value.secondary_turns_ratio
"""Get [`Transformer3W`](@ref) `tertiary_turns_ratio`."""
get_tertiary_turns_ratio(value::Transformer3W) = value.tertiary_turns_ratio
"""Get [`Transformer3W`](@ref) `available_primary`."""
get_available_primary(value::Transformer3W) = value.available_primary
"""Get [`Transformer3W`](@ref) `available_secondary`."""
get_available_secondary(value::Transformer3W) = value.available_secondary
"""Get [`Transformer3W`](@ref) `available_tertiary`."""
get_available_tertiary(value::Transformer3W) = value.available_tertiary
"""Get [`Transformer3W`](@ref) `rating_primary`."""
get_rating_primary(value::Transformer3W) = get_value(value, value.rating_primary)
"""Get [`Transformer3W`](@ref) `rating_secondary`."""
get_rating_secondary(value::Transformer3W) = get_value(value, value.rating_secondary)
"""Get [`Transformer3W`](@ref) `rating_tertiary`."""
get_rating_tertiary(value::Transformer3W) = get_value(value, value.rating_tertiary)
"""Get [`Transformer3W`](@ref) `services`."""
get_services(value::Transformer3W) = value.services
"""Get [`Transformer3W`](@ref) `ext`."""
get_ext(value::Transformer3W) = value.ext
"""Get [`Transformer3W`](@ref) `internal`."""
get_internal(value::Transformer3W) = value.internal

"""Set [`Transformer3W`](@ref) `available`."""
set_available!(value::Transformer3W, val) = value.available = val
"""Set [`Transformer3W`](@ref) `primary_secondary_arc`."""
set_primary_secondary_arc!(value::Transformer3W, val) = value.primary_secondary_arc = val
"""Set [`Transformer3W`](@ref) `secondary_tertiary_arc`."""
set_secondary_tertiary_arc!(value::Transformer3W, val) = value.secondary_tertiary_arc = val
"""Set [`Transformer3W`](@ref) `primary_tertiary_arc`."""
set_primary_tertiary_arc!(value::Transformer3W, val) = value.primary_tertiary_arc = val
"""Set [`Transformer3W`](@ref) `star_bus`."""
set_star_bus!(value::Transformer3W, val) = value.star_bus = val
"""Set [`Transformer3W`](@ref) `active_power_flow_primary`."""
set_active_power_flow_primary!(value::Transformer3W, val) = value.active_power_flow_primary = set_value(value, val)
"""Set [`Transformer3W`](@ref) `reactive_power_flow_primary`."""
set_reactive_power_flow_primary!(value::Transformer3W, val) = value.reactive_power_flow_primary = set_value(value, val)
"""Set [`Transformer3W`](@ref) `active_power_flow_secondary`."""
set_active_power_flow_secondary!(value::Transformer3W, val) = value.active_power_flow_secondary = set_value(value, val)
"""Set [`Transformer3W`](@ref) `reactive_power_flow_secondary`."""
set_reactive_power_flow_secondary!(value::Transformer3W, val) = value.reactive_power_flow_secondary = set_value(value, val)
"""Set [`Transformer3W`](@ref) `active_power_flow_tertiary`."""
set_active_power_flow_tertiary!(value::Transformer3W, val) = value.active_power_flow_tertiary = set_value(value, val)
"""Set [`Transformer3W`](@ref) `reactive_power_flow_tertiary`."""
set_reactive_power_flow_tertiary!(value::Transformer3W, val) = value.reactive_power_flow_tertiary = set_value(value, val)
"""Set [`Transformer3W`](@ref) `r_primary`."""
set_r_primary!(value::Transformer3W, val) = value.r_primary = val
"""Set [`Transformer3W`](@ref) `x_primary`."""
set_x_primary!(value::Transformer3W, val) = value.x_primary = val
"""Set [`Transformer3W`](@ref) `r_secondary`."""
set_r_secondary!(value::Transformer3W, val) = value.r_secondary = val
"""Set [`Transformer3W`](@ref) `x_secondary`."""
set_x_secondary!(value::Transformer3W, val) = value.x_secondary = val
"""Set [`Transformer3W`](@ref) `r_tertiary`."""
set_r_tertiary!(value::Transformer3W, val) = value.r_tertiary = val
"""Set [`Transformer3W`](@ref) `x_tertiary`."""
set_x_tertiary!(value::Transformer3W, val) = value.x_tertiary = val
"""Set [`Transformer3W`](@ref) `rating`."""
set_rating!(value::Transformer3W, val) = value.rating = set_value(value, val)
"""Set [`Transformer3W`](@ref) `r_12`."""
set_r_12!(value::Transformer3W, val) = value.r_12 = val
"""Set [`Transformer3W`](@ref) `x_12`."""
set_x_12!(value::Transformer3W, val) = value.x_12 = val
"""Set [`Transformer3W`](@ref) `r_23`."""
set_r_23!(value::Transformer3W, val) = value.r_23 = val
"""Set [`Transformer3W`](@ref) `x_23`."""
set_x_23!(value::Transformer3W, val) = value.x_23 = val
"""Set [`Transformer3W`](@ref) `r_13`."""
set_r_13!(value::Transformer3W, val) = value.r_13 = val
"""Set [`Transformer3W`](@ref) `x_13`."""
set_x_13!(value::Transformer3W, val) = value.x_13 = val
"""Set [`Transformer3W`](@ref) `g`."""
set_g!(value::Transformer3W, val) = value.g = val
"""Set [`Transformer3W`](@ref) `b`."""
set_b!(value::Transformer3W, val) = value.b = val
"""Set [`Transformer3W`](@ref) `primary_turns_ratio`."""
set_primary_turns_ratio!(value::Transformer3W, val) = value.primary_turns_ratio = val
"""Set [`Transformer3W`](@ref) `secondary_turns_ratio`."""
set_secondary_turns_ratio!(value::Transformer3W, val) = value.secondary_turns_ratio = val
"""Set [`Transformer3W`](@ref) `tertiary_turns_ratio`."""
set_tertiary_turns_ratio!(value::Transformer3W, val) = value.tertiary_turns_ratio = val
"""Set [`Transformer3W`](@ref) `available_primary`."""
set_available_primary!(value::Transformer3W, val) = value.available_primary = val
"""Set [`Transformer3W`](@ref) `available_secondary`."""
set_available_secondary!(value::Transformer3W, val) = value.available_secondary = val
"""Set [`Transformer3W`](@ref) `available_tertiary`."""
set_available_tertiary!(value::Transformer3W, val) = value.available_tertiary = val
"""Set [`Transformer3W`](@ref) `rating_primary`."""
set_rating_primary!(value::Transformer3W, val) = value.rating_primary = set_value(value, val)
"""Set [`Transformer3W`](@ref) `rating_secondary`."""
set_rating_secondary!(value::Transformer3W, val) = value.rating_secondary = set_value(value, val)
"""Set [`Transformer3W`](@ref) `rating_tertiary`."""
set_rating_tertiary!(value::Transformer3W, val) = value.rating_tertiary = set_value(value, val)
"""Set [`Transformer3W`](@ref) `services`."""
set_services!(value::Transformer3W, val) = value.services = val
"""Set [`Transformer3W`](@ref) `ext`."""
set_ext!(value::Transformer3W, val) = value.ext = val
