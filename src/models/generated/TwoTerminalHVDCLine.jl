#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TwoTerminalHVDCLine <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        arc::Arc
        active_power_limits_from::MinMax
        active_power_limits_to::MinMax
        reactive_power_limits_from::MinMax
        reactive_power_limits_to::MinMax
        loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}
        services::Vector{Service}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

a High voltage DC line.

# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow::Float64`
- `arc::Arc`
- `active_power_limits_from::MinMax`
- `active_power_limits_to::MinMax`
- `reactive_power_limits_from::MinMax`
- `reactive_power_limits_to::MinMax`
- `loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TwoTerminalHVDCLine <: ACBranch
    name::String
    available::Bool
    active_power_flow::Float64
    arc::Arc
    active_power_limits_from::MinMax
    active_power_limits_to::MinMax
    reactive_power_limits_from::MinMax
    reactive_power_limits_to::MinMax
    loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TwoTerminalHVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    TwoTerminalHVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function TwoTerminalHVDCLine(; name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    TwoTerminalHVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function TwoTerminalHVDCLine(::Nothing)
    TwoTerminalHVDCLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        active_power_limits_from=(min=0.0, max=0.0),
        active_power_limits_to=(min=0.0, max=0.0),
        reactive_power_limits_from=(min=0.0, max=0.0),
        reactive_power_limits_to=(min=0.0, max=0.0),
        loss=(l0=0.0, l1=0.0),
        services=Device[],
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`TwoTerminalHVDCLine`](@ref) `name`."""
get_name(value::TwoTerminalHVDCLine) = value.name
"""Get [`TwoTerminalHVDCLine`](@ref) `available`."""
get_available(value::TwoTerminalHVDCLine) = value.available
"""Get [`TwoTerminalHVDCLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::TwoTerminalHVDCLine) = get_value(value, value.active_power_flow)
"""Get [`TwoTerminalHVDCLine`](@ref) `arc`."""
get_arc(value::TwoTerminalHVDCLine) = value.arc
"""Get [`TwoTerminalHVDCLine`](@ref) `active_power_limits_from`."""
get_active_power_limits_from(value::TwoTerminalHVDCLine) = get_value(value, value.active_power_limits_from)
"""Get [`TwoTerminalHVDCLine`](@ref) `active_power_limits_to`."""
get_active_power_limits_to(value::TwoTerminalHVDCLine) = get_value(value, value.active_power_limits_to)
"""Get [`TwoTerminalHVDCLine`](@ref) `reactive_power_limits_from`."""
get_reactive_power_limits_from(value::TwoTerminalHVDCLine) = get_value(value, value.reactive_power_limits_from)
"""Get [`TwoTerminalHVDCLine`](@ref) `reactive_power_limits_to`."""
get_reactive_power_limits_to(value::TwoTerminalHVDCLine) = get_value(value, value.reactive_power_limits_to)
"""Get [`TwoTerminalHVDCLine`](@ref) `loss`."""
get_loss(value::TwoTerminalHVDCLine) = value.loss
"""Get [`TwoTerminalHVDCLine`](@ref) `services`."""
get_services(value::TwoTerminalHVDCLine) = value.services
"""Get [`TwoTerminalHVDCLine`](@ref) `ext`."""
get_ext(value::TwoTerminalHVDCLine) = value.ext
"""Get [`TwoTerminalHVDCLine`](@ref) `time_series_container`."""
get_time_series_container(value::TwoTerminalHVDCLine) = value.time_series_container
"""Get [`TwoTerminalHVDCLine`](@ref) `internal`."""
get_internal(value::TwoTerminalHVDCLine) = value.internal

"""Set [`TwoTerminalHVDCLine`](@ref) `available`."""
set_available!(value::TwoTerminalHVDCLine, val) = value.available = val
"""Set [`TwoTerminalHVDCLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::TwoTerminalHVDCLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`TwoTerminalHVDCLine`](@ref) `arc`."""
set_arc!(value::TwoTerminalHVDCLine, val) = value.arc = val
"""Set [`TwoTerminalHVDCLine`](@ref) `active_power_limits_from`."""
set_active_power_limits_from!(value::TwoTerminalHVDCLine, val) = value.active_power_limits_from = set_value(value, val)
"""Set [`TwoTerminalHVDCLine`](@ref) `active_power_limits_to`."""
set_active_power_limits_to!(value::TwoTerminalHVDCLine, val) = value.active_power_limits_to = set_value(value, val)
"""Set [`TwoTerminalHVDCLine`](@ref) `reactive_power_limits_from`."""
set_reactive_power_limits_from!(value::TwoTerminalHVDCLine, val) = value.reactive_power_limits_from = set_value(value, val)
"""Set [`TwoTerminalHVDCLine`](@ref) `reactive_power_limits_to`."""
set_reactive_power_limits_to!(value::TwoTerminalHVDCLine, val) = value.reactive_power_limits_to = set_value(value, val)
"""Set [`TwoTerminalHVDCLine`](@ref) `loss`."""
set_loss!(value::TwoTerminalHVDCLine, val) = value.loss = val
"""Set [`TwoTerminalHVDCLine`](@ref) `services`."""
set_services!(value::TwoTerminalHVDCLine, val) = value.services = val
"""Set [`TwoTerminalHVDCLine`](@ref) `ext`."""
set_ext!(value::TwoTerminalHVDCLine, val) = value.ext = val
"""Set [`TwoTerminalHVDCLine`](@ref) `time_series_container`."""
set_time_series_container!(value::TwoTerminalHVDCLine, val) = value.time_series_container = val
