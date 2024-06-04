#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct PhaseShiftingTransformer <: ACBranch
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
        rate::Union{Nothing, Float64}
        phase_angle_limits::MinMax
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `active_power_flow::Float64`: Initial condition of active power flow through the transformer (MW)
- `reactive_power_flow::Float64`: Initial condition of reactive power flow through the transformer (MVAR)
- `arc::Arc`: Used internally to represent network topology. **Do not modify.**
- `r::Float64`: Resistance in pu ([`System Base`](@ref per_unit)), validation range: `(0, 4)`, action if invalid: `warn`
- `x::Float64`: Reactance in pu ([`System Base`](@ref per_unit)), validation range: `(-2, 4)`, action if invalid: `warn`
- `primary_shunt::Float64`, validation range: `(0, 2)`, action if invalid: `warn`
- `tap::Float64`, validation range: `(0, 2)`, action if invalid: `error`
- `α::Float64`, validation range: `(-1.571, 1.571)`, action if invalid: `warn`
- `rate::Union{Nothing, Float64}`, validation range: `(0, nothing)`, action if invalid: `error`
- `phase_angle_limits::MinMax`: (optional), validation range: `(-1.571, 1.571)`, action if invalid: `error`
- `services::Vector{Service}`: (optional) Services that this device contributes to
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct PhaseShiftingTransformer <: ACBranch
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "Initial condition of active power flow through the transformer (MW)"
    active_power_flow::Float64
    "Initial condition of reactive power flow through the transformer (MVAR)"
    reactive_power_flow::Float64
    "Used internally to represent network topology. **Do not modify.**"
    arc::Arc
    "Resistance in pu ([`System Base`](@ref per_unit))"
    r::Float64
    "Reactance in pu ([`System Base`](@ref per_unit))"
    x::Float64
    primary_shunt::Float64
    tap::Float64
    α::Float64
    rate::Union{Nothing, Float64}
    "(optional)"
    phase_angle_limits::MinMax
    "(optional) Services that this device contributes to"
    services::Vector{Service}
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, phase_angle_limits=(min=-1.571, max=1.571), services=Device[], ext=Dict{String, Any}(), )
    PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, phase_angle_limits, services, ext, InfrastructureSystemsInternal(), )
end

function PhaseShiftingTransformer(; name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, phase_angle_limits=(min=-1.571, max=1.571), services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, phase_angle_limits, services, ext, internal, )
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
        rate=0.0,
        phase_angle_limits=(min=-1.571, max=1.571),
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`PhaseShiftingTransformer`](@ref) `name`."""
get_name(value::PhaseShiftingTransformer) = value.name
"""Get [`PhaseShiftingTransformer`](@ref) `available`."""
get_available(value::PhaseShiftingTransformer) = value.available
"""Get [`PhaseShiftingTransformer`](@ref) `active_power_flow`."""
get_active_power_flow(value::PhaseShiftingTransformer) = get_value(value, value.active_power_flow)
"""Get [`PhaseShiftingTransformer`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::PhaseShiftingTransformer) = get_value(value, value.reactive_power_flow)
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
"""Get [`PhaseShiftingTransformer`](@ref) `rate`."""
get_rate(value::PhaseShiftingTransformer) = get_value(value, value.rate)
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
set_active_power_flow!(value::PhaseShiftingTransformer, val) = value.active_power_flow = set_value(value, val)
"""Set [`PhaseShiftingTransformer`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::PhaseShiftingTransformer, val) = value.reactive_power_flow = set_value(value, val)
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
"""Set [`PhaseShiftingTransformer`](@ref) `rate`."""
set_rate!(value::PhaseShiftingTransformer, val) = value.rate = set_value(value, val)
"""Set [`PhaseShiftingTransformer`](@ref) `phase_angle_limits`."""
set_phase_angle_limits!(value::PhaseShiftingTransformer, val) = value.phase_angle_limits = val
"""Set [`PhaseShiftingTransformer`](@ref) `services`."""
set_services!(value::PhaseShiftingTransformer, val) = value.services = val
"""Set [`PhaseShiftingTransformer`](@ref) `ext`."""
set_ext!(value::PhaseShiftingTransformer, val) = value.ext = val
