#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HVDCLine <: DCBranch
        name::String
        available::Bool
        active_power_flow::Float64
        arc::Arc
        active_power_limits_from::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        active_power_limits_to::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        reactive_power_limits_from::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        reactive_power_limits_to::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}
        services::Vector{Service}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

a High voltage DC line.

# Arguments
- `name::String`
- `available::Bool`
- `active_power_flow::Float64`
- `arc::Arc`
- `active_power_limits_from::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`
- `active_power_limits_to::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`
- `reactive_power_limits_from::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`
- `reactive_power_limits_to::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`
- `loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HVDCLine <: DCBranch
    name::String
    available::Bool
    active_power_flow::Float64
    arc::Arc
    active_power_limits_from::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    active_power_limits_to::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    reactive_power_limits_from::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    reactive_power_limits_to::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HVDCLine(; name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services, ext, forecasts, )
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
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::HVDCLine) = value.name
"""Get HVDCLine available."""
get_available(value::HVDCLine) = value.available
"""Get HVDCLine active_power_flow."""
get_active_power_flow(value::HVDCLine) = get_value(value, value.active_power_flow)
"""Get HVDCLine arc."""
get_arc(value::HVDCLine) = value.arc
"""Get HVDCLine active_power_limits_from."""
get_active_power_limits_from(value::HVDCLine) = get_value(value, value.active_power_limits_from)
"""Get HVDCLine active_power_limits_to."""
get_active_power_limits_to(value::HVDCLine) = get_value(value, value.active_power_limits_to)
"""Get HVDCLine reactive_power_limits_from."""
get_reactive_power_limits_from(value::HVDCLine) = get_value(value, value.reactive_power_limits_from)
"""Get HVDCLine reactive_power_limits_to."""
get_reactive_power_limits_to(value::HVDCLine) = get_value(value, value.reactive_power_limits_to)
"""Get HVDCLine loss."""
get_loss(value::HVDCLine) = value.loss
"""Get HVDCLine services."""
get_services(value::HVDCLine) = value.services
"""Get HVDCLine ext."""
get_ext(value::HVDCLine) = value.ext

InfrastructureSystems.get_forecasts(value::HVDCLine) = value.forecasts
"""Get HVDCLine internal."""
get_internal(value::HVDCLine) = value.internal


InfrastructureSystems.set_name!(value::HVDCLine, val::String) = value.name = val
"""Set HVDCLine available."""
set_available!(value::HVDCLine, val::Bool) = value.available = val
"""Set HVDCLine active_power_flow."""
set_active_power_flow!(value::HVDCLine, val::Float64) = value.active_power_flow = val
"""Set HVDCLine arc."""
set_arc!(value::HVDCLine, val::Arc) = value.arc = val
"""Set HVDCLine active_power_limits_from."""
set_active_power_limits_from!(value::HVDCLine, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.active_power_limits_from = val
"""Set HVDCLine active_power_limits_to."""
set_active_power_limits_to!(value::HVDCLine, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.active_power_limits_to = val
"""Set HVDCLine reactive_power_limits_from."""
set_reactive_power_limits_from!(value::HVDCLine, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.reactive_power_limits_from = val
"""Set HVDCLine reactive_power_limits_to."""
set_reactive_power_limits_to!(value::HVDCLine, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.reactive_power_limits_to = val
"""Set HVDCLine loss."""
set_loss!(value::HVDCLine, val::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}) = value.loss = val
"""Set HVDCLine services."""
set_services!(value::HVDCLine, val::Vector{Service}) = value.services = val
"""Set HVDCLine ext."""
set_ext!(value::HVDCLine, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::HVDCLine, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set HVDCLine internal."""
set_internal!(value::HVDCLine, val::InfrastructureSystemsInternal) = value.internal = val
