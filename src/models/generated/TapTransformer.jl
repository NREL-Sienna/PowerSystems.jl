#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TapTransformer <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        primary_shunt::Float64
        tap::Float64
        rate::Union{Nothing, Float64}
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
- `r::Float64`: Resistance in p.u. ([`System Base`](@ref per_unit)), validation range: `(-2, 2)`
- `x::Float64`: Reactance in p.u. ([`System Base`](@ref per_unit)), validation range: `(-2, 4)`
- `primary_shunt::Float64`: in p.u. ([`System Base`](@ref per_unit)), validation range: `(0, 2)`
- `tap::Float64`:, validation range: `(0, 2)`
- `rate::Union{Nothing, Float64}`:, validation range: `(0, nothing)`
- `services::Vector{Service}`: (default: `Device[]`) (optional) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct TapTransformer <: ACBranch
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
    "Resistance in p.u. ([`System Base`](@ref per_unit))"
    r::Float64
    "Reactance in p.u. ([`System Base`](@ref per_unit))"
    x::Float64
    "in p.u. ([`System Base`](@ref per_unit))"
    primary_shunt::Float64
    tap::Float64
    rate::Union{Nothing, Float64}
    "(optional) Services that this device contributes to"
    services::Vector{Service}
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function TapTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, rate, services=Device[], ext=Dict{String, Any}(), )
    TapTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, rate, services, ext, InfrastructureSystemsInternal(), )
end

function TapTransformer(; name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, rate, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    TapTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, rate, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function TapTransformer(::Nothing)
    TapTransformer(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        r=0.0,
        x=0.0,
        primary_shunt=0.0,
        tap=1.0,
        rate=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`TapTransformer`](@ref) `name`."""
get_name(value::TapTransformer) = value.name
"""Get [`TapTransformer`](@ref) `available`."""
get_available(value::TapTransformer) = value.available
"""Get [`TapTransformer`](@ref) `active_power_flow`."""
get_active_power_flow(value::TapTransformer) = get_value(value, value.active_power_flow)
"""Get [`TapTransformer`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::TapTransformer) = get_value(value, value.reactive_power_flow)
"""Get [`TapTransformer`](@ref) `arc`."""
get_arc(value::TapTransformer) = value.arc
"""Get [`TapTransformer`](@ref) `r`."""
get_r(value::TapTransformer) = value.r
"""Get [`TapTransformer`](@ref) `x`."""
get_x(value::TapTransformer) = value.x
"""Get [`TapTransformer`](@ref) `primary_shunt`."""
get_primary_shunt(value::TapTransformer) = value.primary_shunt
"""Get [`TapTransformer`](@ref) `tap`."""
get_tap(value::TapTransformer) = value.tap
"""Get [`TapTransformer`](@ref) `rate`."""
get_rate(value::TapTransformer) = get_value(value, value.rate)
"""Get [`TapTransformer`](@ref) `services`."""
get_services(value::TapTransformer) = value.services
"""Get [`TapTransformer`](@ref) `ext`."""
get_ext(value::TapTransformer) = value.ext
"""Get [`TapTransformer`](@ref) `internal`."""
get_internal(value::TapTransformer) = value.internal

"""Set [`TapTransformer`](@ref) `available`."""
set_available!(value::TapTransformer, val) = value.available = val
"""Set [`TapTransformer`](@ref) `active_power_flow`."""
set_active_power_flow!(value::TapTransformer, val) = value.active_power_flow = set_value(value, val)
"""Set [`TapTransformer`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::TapTransformer, val) = value.reactive_power_flow = set_value(value, val)
"""Set [`TapTransformer`](@ref) `arc`."""
set_arc!(value::TapTransformer, val) = value.arc = val
"""Set [`TapTransformer`](@ref) `r`."""
set_r!(value::TapTransformer, val) = value.r = val
"""Set [`TapTransformer`](@ref) `x`."""
set_x!(value::TapTransformer, val) = value.x = val
"""Set [`TapTransformer`](@ref) `primary_shunt`."""
set_primary_shunt!(value::TapTransformer, val) = value.primary_shunt = val
"""Set [`TapTransformer`](@ref) `tap`."""
set_tap!(value::TapTransformer, val) = value.tap = val
"""Set [`TapTransformer`](@ref) `rate`."""
set_rate!(value::TapTransformer, val) = value.rate = set_value(value, val)
"""Set [`TapTransformer`](@ref) `services`."""
set_services!(value::TapTransformer, val) = value.services = val
"""Set [`TapTransformer`](@ref) `ext`."""
set_ext!(value::TapTransformer, val) = value.ext = val
