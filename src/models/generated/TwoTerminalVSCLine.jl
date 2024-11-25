#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TwoTerminalVSCLine <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        rating::Float64
        active_power_limits_from::MinMax
        active_power_limits_to::MinMax
        arc::Arc
        converter_loss::Union{LinearCurve, QuadraticCurve}
        dc_current::Float64
        max_dc_current::Float64
        g::Float64
        voltage_limits::MinMax
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A High Voltage DC line, which must be connected to an [`ACBus`](@ref) on each end.

This model is appropriate for operational simulations with a linearized DC power flow approximation with losses using a voltage-current model. For modeling a DC network, see [`TModelHVDCLine`](@ref)

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `active_power_flow::Float64`: Initial condition of active power flowing from the from-bus to the to-bus in DC.
- `rating::Float64`: Maximum output power rating of the converter (MVA), validation range: `(0, nothing)`
- `active_power_limits_from::MinMax`: Minimum and maximum active power flows to the FROM node (MW)
- `active_power_limits_to::MinMax`: Minimum and maximum active power flows to the TO node (MW)
- `arc::Arc`: An [`Arc`](@ref) defining this line `from` a bus `to` another bus
- `converter_loss::Union{LinearCurve, QuadraticCurve}`: (default: `LinearCurve(0.0)`) Loss model coefficients. It accepts a linear model or quadratic. Same converter data is used in both ends.
- `dc_current::Float64`: (default: `0.0`) DC current (A) on the converter on the from-bus DC side.
- `max_dc_current::Float64`: (default: `1e8`) Maximum stable dc current limits (A). Includes converter and DC line.
- `g::Float64`: (default: `0.0`) Series conductance of the DC line in pu ([`SYSTEM_BASE`](@ref per_unit))
- `voltage_limits::MinMax`: (default: `(min=0.0, max=999.9)`) Limits on the Voltage at the DC Bus.
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct TwoTerminalVSCLine <: ACBranch
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Initial condition of active power flowing from the from-bus to the to-bus in DC."
    active_power_flow::Float64
    "Maximum output power rating of the converter (MVA)"
    rating::Float64
    "Minimum and maximum active power flows to the FROM node (MW)"
    active_power_limits_from::MinMax
    "Minimum and maximum active power flows to the TO node (MW)"
    active_power_limits_to::MinMax
    "An [`Arc`](@ref) defining this line `from` a bus `to` another bus"
    arc::Arc
    "Loss model coefficients. It accepts a linear model or quadratic. Same converter data is used in both ends."
    converter_loss::Union{LinearCurve, QuadraticCurve}
    "DC current (A) on the converter on the from-bus DC side."
    dc_current::Float64
    "Maximum stable dc current limits (A). Includes converter and DC line."
    max_dc_current::Float64
    "Series conductance of the DC line in pu ([`SYSTEM_BASE`](@ref per_unit))"
    g::Float64
    "Limits on the Voltage at the DC Bus."
    voltage_limits::MinMax
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function TwoTerminalVSCLine(name, available, active_power_flow, rating, active_power_limits_from, active_power_limits_to, arc, converter_loss=LinearCurve(0.0), dc_current=0.0, max_dc_current=1e8, g=0.0, voltage_limits=(min=0.0, max=999.9), services=Device[], ext=Dict{String, Any}(), )
    TwoTerminalVSCLine(name, available, active_power_flow, rating, active_power_limits_from, active_power_limits_to, arc, converter_loss, dc_current, max_dc_current, g, voltage_limits, services, ext, InfrastructureSystemsInternal(), )
end

function TwoTerminalVSCLine(; name, available, active_power_flow, rating, active_power_limits_from, active_power_limits_to, arc, converter_loss=LinearCurve(0.0), dc_current=0.0, max_dc_current=1e8, g=0.0, voltage_limits=(min=0.0, max=999.9), services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    TwoTerminalVSCLine(name, available, active_power_flow, rating, active_power_limits_from, active_power_limits_to, arc, converter_loss, dc_current, max_dc_current, g, voltage_limits, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function TwoTerminalVSCLine(::Nothing)
    TwoTerminalVSCLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        rating=0.0,
        active_power_limits_from=(min=0.0, max=0.0),
        active_power_limits_to=(min=0.0, max=0.0),
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        converter_loss=LinearCurve(0.0),
        dc_current=0.0,
        max_dc_current=0.0,
        g=0.0,
        voltage_limits=(min=0.0, max=0.0),
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`TwoTerminalVSCLine`](@ref) `name`."""
get_name(value::TwoTerminalVSCLine) = value.name
"""Get [`TwoTerminalVSCLine`](@ref) `available`."""
get_available(value::TwoTerminalVSCLine) = value.available
"""Get [`TwoTerminalVSCLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::TwoTerminalVSCLine) = get_value(value, value.active_power_flow)
"""Get [`TwoTerminalVSCLine`](@ref) `rating`."""
get_rating(value::TwoTerminalVSCLine) = get_value(value, value.rating)
"""Get [`TwoTerminalVSCLine`](@ref) `active_power_limits_from`."""
get_active_power_limits_from(value::TwoTerminalVSCLine) = get_value(value, value.active_power_limits_from)
"""Get [`TwoTerminalVSCLine`](@ref) `active_power_limits_to`."""
get_active_power_limits_to(value::TwoTerminalVSCLine) = get_value(value, value.active_power_limits_to)
"""Get [`TwoTerminalVSCLine`](@ref) `arc`."""
get_arc(value::TwoTerminalVSCLine) = value.arc
"""Get [`TwoTerminalVSCLine`](@ref) `converter_loss`."""
get_converter_loss(value::TwoTerminalVSCLine) = value.converter_loss
"""Get [`TwoTerminalVSCLine`](@ref) `dc_current`."""
get_dc_current(value::TwoTerminalVSCLine) = value.dc_current
"""Get [`TwoTerminalVSCLine`](@ref) `max_dc_current`."""
get_max_dc_current(value::TwoTerminalVSCLine) = value.max_dc_current
"""Get [`TwoTerminalVSCLine`](@ref) `g`."""
get_g(value::TwoTerminalVSCLine) = value.g
"""Get [`TwoTerminalVSCLine`](@ref) `voltage_limits`."""
get_voltage_limits(value::TwoTerminalVSCLine) = value.voltage_limits
"""Get [`TwoTerminalVSCLine`](@ref) `services`."""
get_services(value::TwoTerminalVSCLine) = value.services
"""Get [`TwoTerminalVSCLine`](@ref) `ext`."""
get_ext(value::TwoTerminalVSCLine) = value.ext
"""Get [`TwoTerminalVSCLine`](@ref) `internal`."""
get_internal(value::TwoTerminalVSCLine) = value.internal

"""Set [`TwoTerminalVSCLine`](@ref) `available`."""
set_available!(value::TwoTerminalVSCLine, val) = value.available = val
"""Set [`TwoTerminalVSCLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::TwoTerminalVSCLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`TwoTerminalVSCLine`](@ref) `rating`."""
set_rating!(value::TwoTerminalVSCLine, val) = value.rating = set_value(value, val)
"""Set [`TwoTerminalVSCLine`](@ref) `active_power_limits_from`."""
set_active_power_limits_from!(value::TwoTerminalVSCLine, val) = value.active_power_limits_from = set_value(value, val)
"""Set [`TwoTerminalVSCLine`](@ref) `active_power_limits_to`."""
set_active_power_limits_to!(value::TwoTerminalVSCLine, val) = value.active_power_limits_to = set_value(value, val)
"""Set [`TwoTerminalVSCLine`](@ref) `arc`."""
set_arc!(value::TwoTerminalVSCLine, val) = value.arc = val
"""Set [`TwoTerminalVSCLine`](@ref) `converter_loss`."""
set_converter_loss!(value::TwoTerminalVSCLine, val) = value.converter_loss = val
"""Set [`TwoTerminalVSCLine`](@ref) `dc_current`."""
set_dc_current!(value::TwoTerminalVSCLine, val) = value.dc_current = val
"""Set [`TwoTerminalVSCLine`](@ref) `max_dc_current`."""
set_max_dc_current!(value::TwoTerminalVSCLine, val) = value.max_dc_current = val
"""Set [`TwoTerminalVSCLine`](@ref) `g`."""
set_g!(value::TwoTerminalVSCLine, val) = value.g = val
"""Set [`TwoTerminalVSCLine`](@ref) `voltage_limits`."""
set_voltage_limits!(value::TwoTerminalVSCLine, val) = value.voltage_limits = val
"""Set [`TwoTerminalVSCLine`](@ref) `services`."""
set_services!(value::TwoTerminalVSCLine, val) = value.services = val
"""Set [`TwoTerminalVSCLine`](@ref) `ext`."""
set_ext!(value::TwoTerminalVSCLine, val) = value.ext = val
