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
        loss::Union{LinearCurve, PiecewiseIncrementalCurve}
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A High Voltage DC line, which must be connected to an [`ACBus`](@ref) on each end.

This model is appropriate for operational simulations with a linearized DC power flow approximation with losses proportional to the power flow. For modeling a DC network, see [`TModelHVDCLine`](@ref)

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `active_power_flow::Float64`: Initial condition of active power flow on the line (MW)
- `arc::Arc`: An [`Arc`](@ref) defining this line `from` a bus `to` another bus
- `active_power_limits_from::MinMax`: Minimum and maximum active power flows to the FROM node (MW)
- `active_power_limits_to::MinMax`: Minimum and maximum active power flows to the TO node (MW)
- `reactive_power_limits_from::MinMax`: Minimum and maximum reactive power limits to the FROM node (MVAR)
- `reactive_power_limits_to::MinMax`: Minimum and maximum reactive power limits to the TO node (MVAR)
- `loss::Union{LinearCurve, PiecewiseIncrementalCurve}`: (default: `LinearCurve(0.0)`) Loss model coefficients. It accepts a linear model with a constant loss (MW) and a proportional loss rate (MW of loss per MW of flow). It also accepts a Piecewise loss, with N segments to specify different proportional losses for different segments.
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct TwoTerminalHVDCLine <: ACBranch
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Initial condition of active power flow on the line (MW)"
    active_power_flow::Float64
    "An [`Arc`](@ref) defining this line `from` a bus `to` another bus"
    arc::Arc
    "Minimum and maximum active power flows to the FROM node (MW)"
    active_power_limits_from::MinMax
    "Minimum and maximum active power flows to the TO node (MW)"
    active_power_limits_to::MinMax
    "Minimum and maximum reactive power limits to the FROM node (MVAR)"
    reactive_power_limits_from::MinMax
    "Minimum and maximum reactive power limits to the TO node (MVAR)"
    reactive_power_limits_to::MinMax
    "Loss model coefficients. It accepts a linear model with a constant loss (MW) and a proportional loss rate (MW of loss per MW of flow). It also accepts a Piecewise loss, with N segments to specify different proportional losses for different segments."
    loss::Union{LinearCurve, PiecewiseIncrementalCurve}
    "Services that this device contributes to"
    services::Vector{Service}
    "An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)"
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function TwoTerminalHVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss=LinearCurve(0.0), services=Device[], ext=Dict{String, Any}(), )
    TwoTerminalHVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services, ext, InfrastructureSystemsInternal(), )
end

function TwoTerminalHVDCLine(; name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss=LinearCurve(0.0), services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    TwoTerminalHVDCLine(name, available, active_power_flow, arc, active_power_limits_from, active_power_limits_to, reactive_power_limits_from, reactive_power_limits_to, loss, services, ext, internal, )
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
        loss=LinearCurve(0.0),
        services=Device[],
        ext=Dict{String, Any}(),
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
