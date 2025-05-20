#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct PhaseShiftingTransformer <: ACTransmission
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        primary_shunt::Float64
        tap::Float64
        α::Float64
        rating::Union{Nothing, Float64}
        base_power::Float64
        rating_b::Union{Nothing, Float64}
        rating_c::Union{Nothing, Float64}
        phase_angle_limits::MinMax
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A phase-shifting transformer regulating the phase angle between two buses to control active power flow in the system.

The model uses an equivalent circuit assuming the impedance is on the High Voltage Side of the transformer. The model allocates the iron losses and magnetizing susceptance to the primary side

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `active_power_flow::Float64`: Initial condition of active power flow through the transformer (MW)
- `reactive_power_flow::Float64`: Initial condition of reactive power flow through the transformer (MVAR)
- `arc::Arc`: An [`Arc`](@ref) defining this transformer `from` a bus `to` another bus
- `r::Float64`: Resistance in pu ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(0, 4)`
- `x::Float64`: Reactance in pu ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(-2, 4)`
- `primary_shunt::Float64`:, validation range: `(0, 2)`
- `tap::Float64`: Normalized tap changer position for voltage control, varying between 0 and 2, with 1 centered at the nominal voltage, validation range: `(0, 2)`
- `α::Float64`: Initial condition of phase shift (radians) between the `from` and `to` buses , validation range: `(-1.571, 1.571)`
- `rating::Union{Nothing, Float64}`: Thermal rating (MVA). Flow through the transformer must be between -`rating` and `rating`. When defining a transformer before it is attached to a `System`, `rating` must be in pu ([`SYSTEM_BASE`](@ref per_unit)) using the base power of the `System` it will be attached to, validation range: `(0, nothing)`
- `base_power::Float64`: Base power (MVA) for [per unitization](@ref per_unit), validation range: `(0, nothing)`
- `rating_b::Union{Nothing, Float64}`: (default: `nothing`) Second current rating; entered in MVA.
- `rating_c::Union{Nothing, Float64}`: (default: `nothing`) Third current rating; entered in MVA.
- `phase_angle_limits::MinMax`: (default: `(min=-3.1416, max=3.1416)`) Minimum and maximum phase angle limits (radians)
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct PhaseShiftingTransformer <: ACTransmission
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
    primary_shunt::Float64
    "Normalized tap changer position for voltage control, varying between 0 and 2, with 1 centered at the nominal voltage"
    tap::Float64
    "Initial condition of phase shift (radians) between the `from` and `to` buses "
    α::Float64
    "Thermal rating (MVA). Flow through the transformer must be between -`rating` and `rating`. When defining a transformer before it is attached to a `System`, `rating` must be in pu ([`SYSTEM_BASE`](@ref per_unit)) using the base power of the `System` it will be attached to"
    rating::Union{Nothing, Float64}
    "Base power (MVA) for [per unitization](@ref per_unit)"
    base_power::Float64
    "Second current rating; entered in MVA."
    rating_b::Union{Nothing, Float64}
    "Third current rating; entered in MVA."
    rating_c::Union{Nothing, Float64}
    "Minimum and maximum phase angle limits (radians)"
    phase_angle_limits::MinMax
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rating, base_power, rating_b=nothing, rating_c=nothing, phase_angle_limits=(min=-3.1416, max=3.1416), services=Device[], ext=Dict{String, Any}(), )
    PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rating, base_power, rating_b, rating_c, phase_angle_limits, services, ext, InfrastructureSystemsInternal(), )
end

function PhaseShiftingTransformer(; name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rating, base_power, rating_b=nothing, rating_c=nothing, phase_angle_limits=(min=-3.1416, max=3.1416), services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rating, base_power, rating_b, rating_c, phase_angle_limits, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function PhaseShiftingTransformer(::Nothing)
    PhaseShiftingTransformer(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        r=0.0,
        x=0.0,
        primary_shunt=0.0,
        tap=1.0,
        α=0.0,
        rating=0.0,
        base_power=0.0,
        rating_b=0.0,
        rating_c=0.0,
        phase_angle_limits=(min=-3.1416, max=3.1416),
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`PhaseShiftingTransformer`](@ref) `name`."""
get_name(value::PhaseShiftingTransformer) = value.name
"""Get [`PhaseShiftingTransformer`](@ref) `available`."""
get_available(value::PhaseShiftingTransformer) = value.available
"""Get [`PhaseShiftingTransformer`](@ref) `active_power_flow`."""
get_active_power_flow(value::PhaseShiftingTransformer) = get_value(value, Val(:active_power_flow), Val(:mva))
"""Get [`PhaseShiftingTransformer`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::PhaseShiftingTransformer) = get_value(value, Val(:reactive_power_flow), Val(:mva))
"""Get [`PhaseShiftingTransformer`](@ref) `arc`."""
get_arc(value::PhaseShiftingTransformer) = value.arc
"""Get [`PhaseShiftingTransformer`](@ref) `r`."""
get_r(value::PhaseShiftingTransformer) = value.r
"""Get [`PhaseShiftingTransformer`](@ref) `x`."""
get_x(value::PhaseShiftingTransformer) = value.x
"""Get [`PhaseShiftingTransformer`](@ref) `primary_shunt`."""
get_primary_shunt(value::PhaseShiftingTransformer) = value.primary_shunt
"""Get [`PhaseShiftingTransformer`](@ref) `tap`."""
get_tap(value::PhaseShiftingTransformer) = value.tap
"""Get [`PhaseShiftingTransformer`](@ref) `α`."""
get_α(value::PhaseShiftingTransformer) = value.α
"""Get [`PhaseShiftingTransformer`](@ref) `rating`."""
get_rating(value::PhaseShiftingTransformer) = get_value(value, Val(:rating), Val(:mva))
"""Get [`PhaseShiftingTransformer`](@ref) `base_power`."""
get_base_power(value::PhaseShiftingTransformer) = value.base_power
"""Get [`PhaseShiftingTransformer`](@ref) `rating_b`."""
get_rating_b(value::PhaseShiftingTransformer) = get_value(value, Val(:rating_b), Val(:mva))
"""Get [`PhaseShiftingTransformer`](@ref) `rating_c`."""
get_rating_c(value::PhaseShiftingTransformer) = get_value(value, Val(:rating_c), Val(:mva))
"""Get [`PhaseShiftingTransformer`](@ref) `phase_angle_limits`."""
get_phase_angle_limits(value::PhaseShiftingTransformer) = value.phase_angle_limits
"""Get [`PhaseShiftingTransformer`](@ref) `services`."""
get_services(value::PhaseShiftingTransformer) = value.services
"""Get [`PhaseShiftingTransformer`](@ref) `ext`."""
get_ext(value::PhaseShiftingTransformer) = value.ext
"""Get [`PhaseShiftingTransformer`](@ref) `internal`."""
get_internal(value::PhaseShiftingTransformer) = value.internal

"""Set [`PhaseShiftingTransformer`](@ref) `available`."""
set_available!(value::PhaseShiftingTransformer, val) = value.available = val
"""Set [`PhaseShiftingTransformer`](@ref) `active_power_flow`."""
set_active_power_flow!(value::PhaseShiftingTransformer, val) = value.active_power_flow = set_value(value, Val(:active_power_flow), val, Val(:mva))
"""Set [`PhaseShiftingTransformer`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::PhaseShiftingTransformer, val) = value.reactive_power_flow = set_value(value, Val(:reactive_power_flow), val, Val(:mva))
"""Set [`PhaseShiftingTransformer`](@ref) `arc`."""
set_arc!(value::PhaseShiftingTransformer, val) = value.arc = val
"""Set [`PhaseShiftingTransformer`](@ref) `r`."""
set_r!(value::PhaseShiftingTransformer, val) = value.r = val
"""Set [`PhaseShiftingTransformer`](@ref) `x`."""
set_x!(value::PhaseShiftingTransformer, val) = value.x = val
"""Set [`PhaseShiftingTransformer`](@ref) `primary_shunt`."""
set_primary_shunt!(value::PhaseShiftingTransformer, val) = value.primary_shunt = val
"""Set [`PhaseShiftingTransformer`](@ref) `tap`."""
set_tap!(value::PhaseShiftingTransformer, val) = value.tap = val
"""Set [`PhaseShiftingTransformer`](@ref) `α`."""
set_α!(value::PhaseShiftingTransformer, val) = value.α = val
"""Set [`PhaseShiftingTransformer`](@ref) `rating`."""
set_rating!(value::PhaseShiftingTransformer, val) = value.rating = set_value(value, Val(:rating), val, Val(:mva))
"""Set [`PhaseShiftingTransformer`](@ref) `base_power`."""
set_base_power!(value::PhaseShiftingTransformer, val) = value.base_power = val
"""Set [`PhaseShiftingTransformer`](@ref) `rating_b`."""
set_rating_b!(value::PhaseShiftingTransformer, val) = value.rating_b = set_value(value, Val(:rating_b), val, Val(:mva))
"""Set [`PhaseShiftingTransformer`](@ref) `rating_c`."""
set_rating_c!(value::PhaseShiftingTransformer, val) = value.rating_c = set_value(value, Val(:rating_c), val, Val(:mva))
"""Set [`PhaseShiftingTransformer`](@ref) `phase_angle_limits`."""
set_phase_angle_limits!(value::PhaseShiftingTransformer, val) = value.phase_angle_limits = val
"""Set [`PhaseShiftingTransformer`](@ref) `services`."""
set_services!(value::PhaseShiftingTransformer, val) = value.services = val
"""Set [`PhaseShiftingTransformer`](@ref) `ext`."""
set_ext!(value::PhaseShiftingTransformer, val) = value.ext = val
