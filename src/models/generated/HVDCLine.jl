#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct HVDCLine <: DCBranch
        name::String
        available::Bool
        active_power_flow::Float64
        arc::Arc
        active_power_limits_from::Min_Max
        active_power_limits_to::Min_Max
        reactive_power_limits_from::Min_Max
        reactive_power_limits_to::Min_Max
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
- `active_power_limits_from::Min_Max`
- `active_power_limits_to::Min_Max`
- `reactive_power_limits_from::Min_Max`
- `reactive_power_limits_to::Min_Max`
- `loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HVDCLine <: DCBranch
    name::String
    available::Bool
    active_power_flow::Float64
    arc::Arc
    active_power_limits_from::Min_Max
    active_power_limits_to::Min_Max
    reactive_power_limits_from::Min_Max
    reactive_power_limits_to::Min_Max
    loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    HVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function HVDCLine(; name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    HVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function HVDCLine(::Nothing)
    HVDCLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
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

"""Get [`HVDCLine`](@ref) `name`."""
get_name(value::HVDCLine) = value.name
"""Get [`HVDCLine`](@ref) `available`."""
get_available(value::HVDCLine) = value.available
"""Get [`HVDCLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::HVDCLine) = get_value(value, value.active_power_flow)
"""Get [`HVDCLine`](@ref) `arc`."""
get_arc(value::HVDCLine) = value.arc
"""Get [`HVDCLine`](@ref) `active_power_limits_from`."""
get_active_power_limits_from(value::HVDCLine) = get_value(value, value.active_power_limits_from)
"""Get [`HVDCLine`](@ref) `active_power_limits_to`."""
get_active_power_limits_to(value::HVDCLine) = get_value(value, value.active_power_limits_to)
"""Get [`HVDCLine`](@ref) `reactive_power_limits_from`."""
get_reactive_power_limits_from(value::HVDCLine) = get_value(value, value.reactive_power_limits_from)
"""Get [`HVDCLine`](@ref) `reactive_power_limits_to`."""
get_reactive_power_limits_to(value::HVDCLine) = get_value(value, value.reactive_power_limits_to)
"""Get [`HVDCLine`](@ref) `loss`."""
get_loss(value::HVDCLine) = value.loss
"""Get [`HVDCLine`](@ref) `services`."""
get_services(value::HVDCLine) = value.services
"""Get [`HVDCLine`](@ref) `ext`."""
get_ext(value::HVDCLine) = value.ext
"""Get [`HVDCLine`](@ref) `time_series_container`."""
get_time_series_container(value::HVDCLine) = value.time_series_container
"""Get [`HVDCLine`](@ref) `internal`."""
get_internal(value::HVDCLine) = value.internal

"""Set [`HVDCLine`](@ref) `available`."""
set_available!(value::HVDCLine, val) = value.available = val
"""Set [`HVDCLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::HVDCLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`HVDCLine`](@ref) `arc`."""
set_arc!(value::HVDCLine, val) = value.arc = val
"""Set [`HVDCLine`](@ref) `active_power_limits_from`."""
set_active_power_limits_from!(value::HVDCLine, val) = value.active_power_limits_from = set_value(value, val)
"""Set [`HVDCLine`](@ref) `active_power_limits_to`."""
set_active_power_limits_to!(value::HVDCLine, val) = value.active_power_limits_to = set_value(value, val)
"""Set [`HVDCLine`](@ref) `reactive_power_limits_from`."""
set_reactive_power_limits_from!(value::HVDCLine, val) = value.reactive_power_limits_from = set_value(value, val)
"""Set [`HVDCLine`](@ref) `reactive_power_limits_to`."""
set_reactive_power_limits_to!(value::HVDCLine, val) = value.reactive_power_limits_to = set_value(value, val)
"""Set [`HVDCLine`](@ref) `loss`."""
set_loss!(value::HVDCLine, val) = value.loss = val
"""Set [`HVDCLine`](@ref) `services`."""
set_services!(value::HVDCLine, val) = value.services = val
"""Set [`HVDCLine`](@ref) `ext`."""
set_ext!(value::HVDCLine, val) = value.ext = val
"""Set [`HVDCLine`](@ref) `time_series_container`."""
set_time_series_container!(value::HVDCLine, val) = value.time_series_container = val
