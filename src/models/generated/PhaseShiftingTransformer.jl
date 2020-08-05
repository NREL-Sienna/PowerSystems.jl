#=
This file is auto-generated. Do not edit.
=#
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
- `r::Float64`: System per-unit value, validation range: (0, 4), action if invalid: error
- `x::Float64`: System per-unit value, validation range: (-2, 4), action if invalid: error
- `primary_shunt::Float64`, validation range: (0, 2), action if invalid: error
- `tap::Float64`, validation range: (0, 2), action if invalid: error
- `α::Float64`, validation range: (-1.571, 1.571), action if invalid: warn
- `rate::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PhaseShiftingTransformer <: ACBranch
    name::String
    available::Bool
    active_power_flow::Float64
    reactive_power_flow::Float64
    arc::Arc
    "System per-unit value"
    r::Float64
    "System per-unit value"
    x::Float64
    primary_shunt::Float64
    tap::Float64
    α::Float64
    rate::Union{Nothing, Float64}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function PhaseShiftingTransformer(; name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function PhaseShiftingTransformer(::Nothing)
    PhaseShiftingTransformer(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        primary_shunt=0.0,
        tap=1.0,
        α=0.0,
        rate=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::PhaseShiftingTransformer) = value.name
"""Get PhaseShiftingTransformer available."""
get_available(value::PhaseShiftingTransformer) = value.available
"""Get PhaseShiftingTransformer active_power_flow."""
get_active_power_flow(value::PhaseShiftingTransformer) = get_value(value, value.active_power_flow)
"""Get PhaseShiftingTransformer reactive_power_flow."""
get_reactive_power_flow(value::PhaseShiftingTransformer) = get_value(value, value.reactive_power_flow)
"""Get PhaseShiftingTransformer arc."""
get_arc(value::PhaseShiftingTransformer) = value.arc
"""Get PhaseShiftingTransformer r."""
get_r(value::PhaseShiftingTransformer) = value.r
"""Get PhaseShiftingTransformer x."""
get_x(value::PhaseShiftingTransformer) = value.x
"""Get PhaseShiftingTransformer primary_shunt."""
get_primary_shunt(value::PhaseShiftingTransformer) = value.primary_shunt
"""Get PhaseShiftingTransformer tap."""
get_tap(value::PhaseShiftingTransformer) = value.tap
"""Get PhaseShiftingTransformer α."""
get_α(value::PhaseShiftingTransformer) = value.α
"""Get PhaseShiftingTransformer rate."""
get_rate(value::PhaseShiftingTransformer) = get_value(value, value.rate)
"""Get PhaseShiftingTransformer services."""
get_services(value::PhaseShiftingTransformer) = value.services
"""Get PhaseShiftingTransformer ext."""
get_ext(value::PhaseShiftingTransformer) = value.ext

InfrastructureSystems.get_forecasts(value::PhaseShiftingTransformer) = value.forecasts
"""Get PhaseShiftingTransformer internal."""
get_internal(value::PhaseShiftingTransformer) = value.internal


InfrastructureSystems.set_name!(value::PhaseShiftingTransformer, val::String) = value.name = val
"""Set PhaseShiftingTransformer available."""
set_available!(value::PhaseShiftingTransformer, val::Bool) = value.available = val
"""Set PhaseShiftingTransformer active_power_flow."""
set_active_power_flow!(value::PhaseShiftingTransformer, val::Float64) = value.active_power_flow = val
"""Set PhaseShiftingTransformer reactive_power_flow."""
set_reactive_power_flow!(value::PhaseShiftingTransformer, val::Float64) = value.reactive_power_flow = val
"""Set PhaseShiftingTransformer arc."""
set_arc!(value::PhaseShiftingTransformer, val::Arc) = value.arc = val
"""Set PhaseShiftingTransformer r."""
set_r!(value::PhaseShiftingTransformer, val::Float64) = value.r = val
"""Set PhaseShiftingTransformer x."""
set_x!(value::PhaseShiftingTransformer, val::Float64) = value.x = val
"""Set PhaseShiftingTransformer primary_shunt."""
set_primary_shunt!(value::PhaseShiftingTransformer, val::Float64) = value.primary_shunt = val
"""Set PhaseShiftingTransformer tap."""
set_tap!(value::PhaseShiftingTransformer, val::Float64) = value.tap = val
"""Set PhaseShiftingTransformer α."""
set_α!(value::PhaseShiftingTransformer, val::Float64) = value.α = val
"""Set PhaseShiftingTransformer rate."""
set_rate!(value::PhaseShiftingTransformer, val::Union{Nothing, Float64}) = value.rate = val
"""Set PhaseShiftingTransformer services."""
set_services!(value::PhaseShiftingTransformer, val::Vector{Service}) = value.services = val
"""Set PhaseShiftingTransformer ext."""
set_ext!(value::PhaseShiftingTransformer, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::PhaseShiftingTransformer, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set PhaseShiftingTransformer internal."""
set_internal!(value::PhaseShiftingTransformer, val::InfrastructureSystemsInternal) = value.internal = val
