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
        phase_angle_limits::Min_Max
        services::Vector{Service}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow::Float64`
- `reactive_power_flow::Float64`
- `arc::Arc`
- `r::Float64`: System per-unit value, validation range: `(0, 4)`, action if invalid: `warn`
- `x::Float64`: System per-unit value, validation range: `(-2, 4)`, action if invalid: `warn`
- `primary_shunt::Float64`, validation range: `(0, 2)`, action if invalid: `warn`
- `tap::Float64`, validation range: `(0, 2)`, action if invalid: `error`
- `α::Float64`, validation range: `(-1.571, 1.571)`, action if invalid: `warn`
- `rate::Union{Nothing, Float64}`, validation range: `(0, nothing)`, action if invalid: `error`
- `phase_angle_limits::Min_Max`, validation range: `(-1.571, 1.571)`, action if invalid: `error`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
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
    phase_angle_limits::Min_Max
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, phase_angle_limits=(min=-1.571, max=1.571), services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, phase_angle_limits, services, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function PhaseShiftingTransformer(; name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, phase_angle_limits=(min=-1.571, max=1.571), services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    PhaseShiftingTransformer(name, available, active_power_flow, reactive_power_flow, arc, r, x, primary_shunt, tap, α, rate, phase_angle_limits, services, ext, time_series_container, internal, )
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
        phase_angle_limits=(min=-1.571, max=1.571),
        services=Device[],
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
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
"""Get [`PhaseShiftingTransformer`](@ref) `time_series_container`."""
get_time_series_container(value::PhaseShiftingTransformer) = value.time_series_container
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
"""Set [`PhaseShiftingTransformer`](@ref) `time_series_container`."""
set_time_series_container!(value::PhaseShiftingTransformer, val) = value.time_series_container = val
