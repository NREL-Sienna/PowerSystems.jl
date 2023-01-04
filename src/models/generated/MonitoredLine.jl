#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct MonitoredLine <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        reactive_power_flow::Float64
        arc::Arc
        r::Float64
        x::Float64
        b::FromTo
        flow_limits::FromTo_ToFrom
        rate::Float64
        angle_limits::MinMax
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
- `x::Float64`: System per-unit value, validation range: `(0, 4)`, action if invalid: `warn`
- `b::FromTo`: System per-unit value, validation range: `(0, 2)`, action if invalid: `warn`
- `flow_limits::FromTo_ToFrom`: throw warning above max SIL
- `rate::Float64`: compare to SIL (warn) (theoretical limit)
- `angle_limits::MinMax`, validation range: `(-1.571, 1.571)`, action if invalid: `error`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct MonitoredLine <: ACBranch
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
    b::FromTo
    "throw warning above max SIL"
    flow_limits::FromTo_ToFrom
    "compare to SIL (warn) (theoretical limit)"
    rate::Float64
    angle_limits::MinMax
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function MonitoredLine(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rate, angle_limits, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    MonitoredLine(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rate, angle_limits, services, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function MonitoredLine(; name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rate, angle_limits, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    MonitoredLine(name, available, active_power_flow, reactive_power_flow, arc, r, x, b, flow_limits, rate, angle_limits, services, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function MonitoredLine(::Nothing)
    MonitoredLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        reactive_power_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        r=0.0,
        x=0.0,
        b=(from=0.0, to=0.0),
        flow_limits=(from_to=0.0, to_from=0.0),
        rate=0.0,
        angle_limits=(min=-1.571, max=1.571),
        services=Device[],
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`MonitoredLine`](@ref) `name`."""
get_name(value::MonitoredLine) = value.name
"""Get [`MonitoredLine`](@ref) `available`."""
get_available(value::MonitoredLine) = value.available
"""Get [`MonitoredLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::MonitoredLine) = get_value(value, value.active_power_flow)
"""Get [`MonitoredLine`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::MonitoredLine) = get_value(value, value.reactive_power_flow)
"""Get [`MonitoredLine`](@ref) `arc`."""
get_arc(value::MonitoredLine) = value.arc
"""Get [`MonitoredLine`](@ref) `r`."""
get_r(value::MonitoredLine) = value.r
"""Get [`MonitoredLine`](@ref) `x`."""
get_x(value::MonitoredLine) = value.x
"""Get [`MonitoredLine`](@ref) `b`."""
get_b(value::MonitoredLine) = value.b
"""Get [`MonitoredLine`](@ref) `flow_limits`."""
get_flow_limits(value::MonitoredLine) = get_value(value, value.flow_limits)
"""Get [`MonitoredLine`](@ref) `rate`."""
get_rate(value::MonitoredLine) = get_value(value, value.rate)
"""Get [`MonitoredLine`](@ref) `angle_limits`."""
get_angle_limits(value::MonitoredLine) = value.angle_limits
"""Get [`MonitoredLine`](@ref) `services`."""
get_services(value::MonitoredLine) = value.services
"""Get [`MonitoredLine`](@ref) `ext`."""
get_ext(value::MonitoredLine) = value.ext
"""Get [`MonitoredLine`](@ref) `time_series_container`."""
get_time_series_container(value::MonitoredLine) = value.time_series_container
"""Get [`MonitoredLine`](@ref) `internal`."""
get_internal(value::MonitoredLine) = value.internal

"""Set [`MonitoredLine`](@ref) `available`."""
set_available!(value::MonitoredLine, val) = value.available = val
"""Set [`MonitoredLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::MonitoredLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::MonitoredLine, val) = value.reactive_power_flow = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `arc`."""
set_arc!(value::MonitoredLine, val) = value.arc = val
"""Set [`MonitoredLine`](@ref) `r`."""
set_r!(value::MonitoredLine, val) = value.r = val
"""Set [`MonitoredLine`](@ref) `x`."""
set_x!(value::MonitoredLine, val) = value.x = val
"""Set [`MonitoredLine`](@ref) `b`."""
set_b!(value::MonitoredLine, val) = value.b = val
"""Set [`MonitoredLine`](@ref) `flow_limits`."""
set_flow_limits!(value::MonitoredLine, val) = value.flow_limits = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `rate`."""
set_rate!(value::MonitoredLine, val) = value.rate = set_value(value, val)
"""Set [`MonitoredLine`](@ref) `angle_limits`."""
set_angle_limits!(value::MonitoredLine, val) = value.angle_limits = val
"""Set [`MonitoredLine`](@ref) `services`."""
set_services!(value::MonitoredLine, val) = value.services = val
"""Set [`MonitoredLine`](@ref) `ext`."""
set_ext!(value::MonitoredLine, val) = value.ext = val
"""Set [`MonitoredLine`](@ref) `time_series_container`."""
set_time_series_container!(value::MonitoredLine, val) = value.time_series_container = val
