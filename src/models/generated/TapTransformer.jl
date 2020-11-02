#=
This file is auto-generated. Do not edit.
=#
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
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow::Float64`
- `reactive_power_flow::Float64`
- `arc::Arc`
- `r::Float64`: System per-unit value, validation range: `(-2, 2)`, validation range: `(-2, 2)`, action if invalid: `warn`
- `x::Float64`: System per-unit value, validation range: `(-2, 4)`, validation range: `(-2, 4)`, action if invalid: `warn`
- `primary_shunt::Float64`: System per-unit value, validation range: `(0, 2)`, validation range: `(0, 2)`, action if invalid: `warn`
- `tap::Float64`, validation range: `(0, 2)`, validation range: `(0, 2)`, action if invalid: `error`
- `rate::Union{Nothing, Float64}`, validation range: `(0, nothing)`, validation range: `(0, nothing)`, action if invalid: `error`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TapTransformer <: ACBranch
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
    primary_shunt::Float64
    tap::Float64
    rate::Union{Nothing, Float64}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TapTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, rate, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    TapTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, rate, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function TapTransformer(; name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, rate, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), internal=InfrastructureSystemsInternal(), )
    TapTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, rate, services, ext, forecasts, internal, )
end

# Constructor for demo purposes; non-functional.
function TapTransformer(::Nothing)
    TapTransformer(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        primary_shunt=0.0,
        tap=1.0,
        rate=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::TapTransformer) = value.name
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

InfrastructureSystems.get_forecasts(value::TapTransformer) = value.forecasts
"""Get [`TapTransformer`](@ref) `internal`."""
get_internal(value::TapTransformer) = value.internal


InfrastructureSystems.set_name!(value::TapTransformer, val) = value.name = val
"""Set [`TapTransformer`](@ref) `available`."""
set_available!(value::TapTransformer, val) = value.available = val
"""Set [`TapTransformer`](@ref) `active_power_flow`."""
set_active_power_flow!(value::TapTransformer, val) = value.active_power_flow = val
"""Set [`TapTransformer`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::TapTransformer, val) = value.reactive_power_flow = val
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
set_rate!(value::TapTransformer, val) = value.rate = val
"""Set [`TapTransformer`](@ref) `services`."""
set_services!(value::TapTransformer, val) = value.services = val
"""Set [`TapTransformer`](@ref) `ext`."""
set_ext!(value::TapTransformer, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::TapTransformer, val) = value.forecasts = val
"""Set [`TapTransformer`](@ref) `internal`."""
set_internal!(value::TapTransformer, val) = value.internal = val

