#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HVDCLine <: DCBranch
        name::String
        available::Bool
        activepower_flow::Float64
        arc::Arc
        activepower_from_max::Float64
        activepower_from_min::Float64
        activepower_to_max::Float64
        activepower_to_min::Float64
        reactivepower_from_max::Float64
        reactivepower_to_max::Float64
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
- `activepower_flow::Float64`
- `arc::Arc`
- `activepower_from_max::Float64`
- `activepower_from_min::Float64`
- `activepower_to_max::Float64`
- `activepower_to_min::Float64`
- `reactivepower_from_max::Float64`
- `reactivepower_to_max::Float64`
- `loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HVDCLine <: DCBranch
    name::String
    available::Bool
    activepower_flow::Float64
    arc::Arc
    activepower_from_max::Float64
    activepower_from_min::Float64
    activepower_to_max::Float64
    activepower_to_min::Float64
    reactivepower_from_max::Float64
    reactivepower_to_max::Float64
    loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HVDCLine(name, available, activepower_flow, arc, activepower_from_max, activepower_from_min, activepower_to_max, activepower_to_min, reactivepower_from_max, reactivepower_to_max, loss, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HVDCLine(name, available, activepower_flow, arc, activepower_from_max, activepower_from_min, activepower_to_max, activepower_to_min, reactivepower_from_max, reactivepower_to_max, loss, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HVDCLine(; name, available, activepower_flow, arc, activepower_from_max, activepower_from_min, activepower_to_max, activepower_to_min, reactivepower_from_max, reactivepower_to_max, loss, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HVDCLine(name, available, activepower_flow, arc, activepower_from_max, activepower_from_min, activepower_to_max, activepower_to_min, reactivepower_from_max, reactivepower_to_max, loss, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function HVDCLine(::Nothing)
    HVDCLine(;
        name="init",
        available=false,
        activepower_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        activepower_from_max=0.0,
        activepower_from_min=0.0,
        activepower_to_max=0.0,
        activepower_to_min=0.0,
        reactivepower_from_max=0.0,
        reactivepower_to_max=0.0,
        loss=(l0=0.0, l1=0.0),
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::HVDCLine) = value.name
"""Get HVDCLine available."""
get_available(value::HVDCLine) = value.available
"""Get HVDCLine activepower_flow."""
get_activepower_flow(value::HVDCLine) = get_value(value, :activepower_flow)
"""Get HVDCLine arc."""
get_arc(value::HVDCLine) = value.arc
"""Get HVDCLine activepower_from_max."""
get_activepower_from_max(value::HVDCLine) = get_value(value, :activepower_from_max)
"""Get HVDCLine activepower_from_min."""
get_activepower_from_min(value::HVDCLine) = get_value(value, :activepower_from_min)
"""Get HVDCLine activepower_to_max."""
get_activepower_to_max(value::HVDCLine) = get_value(value, :activepower_to_max)
"""Get HVDCLine activepower_to_min."""
get_activepower_to_min(value::HVDCLine) = get_value(value, :activepower_to_min)
"""Get HVDCLine reactivepower_from_max."""
get_reactivepower_from_max(value::HVDCLine) = get_value(value, :reactivepower_from_max)
"""Get HVDCLine reactivepower_to_max."""
get_reactivepower_to_max(value::HVDCLine) = get_value(value, :reactivepower_to_max)
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
"""Set HVDCLine activepower_flow."""
set_activepower_flow!(value::HVDCLine, val::Float64) = value.activepower_flow = val
"""Set HVDCLine arc."""
set_arc!(value::HVDCLine, val::Arc) = value.arc = val
"""Set HVDCLine activepower_from_max."""
set_activepower_from_max!(value::HVDCLine, val::Float64) = value.activepower_from_max = val
"""Set HVDCLine activepower_from_min."""
set_activepower_from_min!(value::HVDCLine, val::Float64) = value.activepower_from_min = val
"""Set HVDCLine activepower_to_max."""
set_activepower_to_max!(value::HVDCLine, val::Float64) = value.activepower_to_max = val
"""Set HVDCLine activepower_to_min."""
set_activepower_to_min!(value::HVDCLine, val::Float64) = value.activepower_to_min = val
"""Set HVDCLine reactivepower_from_max."""
set_reactivepower_from_max!(value::HVDCLine, val::Float64) = value.reactivepower_from_max = val
"""Set HVDCLine reactivepower_to_max."""
set_reactivepower_to_max!(value::HVDCLine, val::Float64) = value.reactivepower_to_max = val
"""Set HVDCLine loss."""
set_loss!(value::HVDCLine, val::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}) = value.loss = val
"""Set HVDCLine services."""
set_services!(value::HVDCLine, val::Vector{Service}) = value.services = val
"""Set HVDCLine ext."""
set_ext!(value::HVDCLine, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::HVDCLine, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set HVDCLine internal."""
set_internal!(value::HVDCLine, val::InfrastructureSystemsInternal) = value.internal = val
