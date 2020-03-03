#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HVDCLine <: DCBranch
        name::String
        available::Bool
        activepower_flow::Float64
        arc::Arc
        activepowerlimits_from::Min_Max
        activepowerlimits_to::Min_Max
        reactivepowerlimits_from::Min_Max
        reactivepowerlimits_to::Min_Max
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
- `activepowerlimits_from::Min_Max`
- `activepowerlimits_to::Min_Max`
- `reactivepowerlimits_from::Min_Max`
- `reactivepowerlimits_to::Min_Max`
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
    activepowerlimits_from::Min_Max
    activepowerlimits_to::Min_Max
    reactivepowerlimits_from::Min_Max
    reactivepowerlimits_to::Min_Max
    loss::NamedTuple{(:l0, :l1), Tuple{Float64, Float64}}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HVDCLine(name, available, activepower_flow, arc, activepowerlimits_from, activepowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to, loss, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HVDCLine(name, available, activepower_flow, arc, activepowerlimits_from, activepowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to, loss, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HVDCLine(; name, available, activepower_flow, arc, activepowerlimits_from, activepowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to, loss, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HVDCLine(name, available, activepower_flow, arc, activepowerlimits_from, activepowerlimits_to, reactivepowerlimits_from, reactivepowerlimits_to, loss, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function HVDCLine(::Nothing)
    HVDCLine(;
        name="init",
        available=false,
        activepower_flow=0.0,
        arc=Arc(Bus(nothing), Bus(nothing)),
        activepowerlimits_from=(min=0.0, max=0.0),
        activepowerlimits_to=(min=0.0, max=0.0),
        reactivepowerlimits_from=(min=0.0, max=0.0),
        reactivepowerlimits_to=(min=0.0, max=0.0),
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
get_activepower_flow(value::HVDCLine) = value.activepower_flow
"""Get HVDCLine arc."""
get_arc(value::HVDCLine) = value.arc
"""Get HVDCLine activepowerlimits_from."""
get_activepowerlimits_from(value::HVDCLine) = value.activepowerlimits_from
"""Get HVDCLine activepowerlimits_to."""
get_activepowerlimits_to(value::HVDCLine) = value.activepowerlimits_to
"""Get HVDCLine reactivepowerlimits_from."""
get_reactivepowerlimits_from(value::HVDCLine) = value.reactivepowerlimits_from
"""Get HVDCLine reactivepowerlimits_to."""
get_reactivepowerlimits_to(value::HVDCLine) = value.reactivepowerlimits_to
"""Get HVDCLine loss."""
get_loss(value::HVDCLine) = value.loss
"""Get HVDCLine services."""
get_services(value::HVDCLine) = value.services
"""Get HVDCLine ext."""
get_ext(value::HVDCLine) = value.ext

InfrastructureSystems.get_forecasts(value::HVDCLine) = value.forecasts
"""Get HVDCLine internal."""
get_internal(value::HVDCLine) = value.internal
