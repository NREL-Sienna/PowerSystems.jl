#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TapTransformer <: ACBranch
        name::String
        available::Bool
        activepower_flow::Float64
        reactivepower_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        primaryshunt::Float64
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
- `activepower_flow::Float64`
- `reactivepower_flow::Float64`
- `arc::Arc`
- `r::Float64`: System per-unit value, validation range: (-2, 2), action if invalid: error
- `x::Float64`: System per-unit value, validation range: (-2, 4), action if invalid: error
- `primaryshunt::Float64`: System per-unit value, validation range: (0, 2), action if invalid: error
- `tap::Float64`, validation range: (0, 2), action if invalid: error
- `rate::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TapTransformer <: ACBranch
    name::String
    available::Bool
    activepower_flow::Float64
    reactivepower_flow::Float64
    arc::Arc
    "System per-unit value"
    r::Float64
    "System per-unit value"
    x::Float64
    "System per-unit value"
    primaryshunt::Float64
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

function TapTransformer(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, rate, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    TapTransformer(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, rate, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function TapTransformer(; name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, rate, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    TapTransformer(name, available, activepower_flow, reactivepower_flow, arc, r, x, primaryshunt, tap, rate, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function TapTransformer(::Nothing)
    TapTransformer(;
        name="init",
        available=false,
        activepower_flow=0.0,
        reactivepower_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        primaryshunt=0.0,
        tap=1.0,
        rate=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::TapTransformer) = value.name
"""Get TapTransformer available."""
get_available(value::TapTransformer) = value.available
"""Get TapTransformer activepower_flow."""
get_activepower_flow(value::TapTransformer) = value.activepower_flow
"""Get TapTransformer reactivepower_flow."""
get_reactivepower_flow(value::TapTransformer) = value.reactivepower_flow
"""Get TapTransformer arc."""
get_arc(value::TapTransformer) = value.arc
"""Get TapTransformer r."""
get_r(value::TapTransformer) = value.r
"""Get TapTransformer x."""
get_x(value::TapTransformer) = value.x
"""Get TapTransformer primaryshunt."""
get_primaryshunt(value::TapTransformer) = value.primaryshunt
"""Get TapTransformer tap."""
get_tap(value::TapTransformer) = value.tap
"""Get TapTransformer rate."""
get_rate(value::TapTransformer) = value.rate
"""Get TapTransformer services."""
get_services(value::TapTransformer) = value.services
"""Get TapTransformer ext."""
get_ext(value::TapTransformer) = value.ext

InfrastructureSystems.get_forecasts(value::TapTransformer) = value.forecasts
"""Get TapTransformer internal."""
get_internal(value::TapTransformer) = value.internal


InfrastructureSystems.set_name!(value::TapTransformer, val::String) = value.name = val
"""Set TapTransformer available."""
set_available!(value::TapTransformer, val::Bool) = value.available = val
"""Set TapTransformer activepower_flow."""
set_activepower_flow!(value::TapTransformer, val::Float64) = value.activepower_flow = val
"""Set TapTransformer reactivepower_flow."""
set_reactivepower_flow!(value::TapTransformer, val::Float64) = value.reactivepower_flow = val
"""Set TapTransformer arc."""
set_arc!(value::TapTransformer, val::Arc) = value.arc = val
"""Set TapTransformer r."""
set_r!(value::TapTransformer, val::Float64) = value.r = val
"""Set TapTransformer x."""
set_x!(value::TapTransformer, val::Float64) = value.x = val
"""Set TapTransformer primaryshunt."""
set_primaryshunt!(value::TapTransformer, val::Float64) = value.primaryshunt = val
"""Set TapTransformer tap."""
set_tap!(value::TapTransformer, val::Float64) = value.tap = val
"""Set TapTransformer rate."""
set_rate!(value::TapTransformer, val::Union{Nothing, Float64}) = value.rate = val
"""Set TapTransformer services."""
set_services!(value::TapTransformer, val::Vector{Service}) = value.services = val
"""Set TapTransformer ext."""
set_ext!(value::TapTransformer, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::TapTransformer, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set TapTransformer internal."""
set_internal!(value::TapTransformer, val::InfrastructureSystemsInternal) = value.internal = val
