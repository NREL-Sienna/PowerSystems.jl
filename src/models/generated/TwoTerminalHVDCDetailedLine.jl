#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct TwoTerminalHVDCDetailedLine <: ACBranch
        name::String
        available::Bool
        active_power_flow::Float64
        rating::Float64
        active_power_limits::MinMax
        arc::Arc
        converter_loss::Union{LinearCurve, PiecewiseIncrementalCurve}
        dc_current::Float64
        max_dc_current::Float64
        g::Float64
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
- `active_power_limits::MinMax`: Minimum and maximum stable active power levels (MW)
- `arc::Arc`: An [`Arc`](@ref) defining this line `from` a bus `to` another bus
- `converter_loss::Union{LinearCurve, PiecewiseIncrementalCurve}`: (default: `LinearCurve(0.0)`) Loss model coefficients. It accepts a linear model or quadratic. Same converter data is used in both ends.
- `dc_current::Float64`: (default: `0.0`) DC current (A) on the converter on the from-bus DC side.
- `max_dc_current::Float64`: (default: `1e8`) Maximum stable dc current limits (A). Includes converter and DC line.
- `g::Float64`: (default: `0.0`) Series conductance of the DC line in pu ([`SYSTEM_BASE`](@ref per_unit))
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct TwoTerminalHVDCDetailedLine <: ACBranch
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Initial condition of active power flowing from the from-bus to the to-bus in DC."
    active_power_flow::Float64
    "Maximum output power rating of the converter (MVA)"
    rating::Float64
    "Minimum and maximum stable active power levels (MW)"
    active_power_limits::MinMax
    "An [`Arc`](@ref) defining this line `from` a bus `to` another bus"
    arc::Arc
    "Loss model coefficients. It accepts a linear model or quadratic. Same converter data is used in both ends."
    converter_loss::Union{LinearCurve, PiecewiseIncrementalCurve}
    "DC current (A) on the converter on the from-bus DC side."
    dc_current::Float64
    "Maximum stable dc current limits (A). Includes converter and DC line."
    max_dc_current::Float64
    "Series conductance of the DC line in pu ([`SYSTEM_BASE`](@ref per_unit))"
    g::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function TwoTerminalHVDCDetailedLine(name, available, active_power_flow, rating, active_power_limits, arc, converter_loss=LinearCurve(0.0), dc_current=0.0, max_dc_current=1e8, g=0.0, services=Device[], ext=Dict{String, Any}(), )
    TwoTerminalHVDCDetailedLine(name, available, active_power_flow, rating, active_power_limits, arc, converter_loss, dc_current, max_dc_current, g, services, ext, InfrastructureSystemsInternal(), )
end

function TwoTerminalHVDCDetailedLine(; name, available, active_power_flow, rating, active_power_limits, arc, converter_loss=LinearCurve(0.0), dc_current=0.0, max_dc_current=1e8, g=0.0, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    TwoTerminalHVDCDetailedLine(name, available, active_power_flow, rating, active_power_limits, arc, converter_loss, dc_current, max_dc_current, g, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function TwoTerminalHVDCDetailedLine(::Nothing)
    TwoTerminalHVDCDetailedLine(;
        name="init",
        available=false,
        active_power_flow=0.0,
        rating=0.0,
        active_power_limits=(min=0.0, max=0.0),
        arc=Arc(ACBus(nothing), ACBus(nothing)),
        converter_loss=LinearCurve(0.0),
        dc_current=0.0,
        max_dc_current=0.0,
        g=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `name`."""
get_name(value::TwoTerminalHVDCDetailedLine) = value.name
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `available`."""
get_available(value::TwoTerminalHVDCDetailedLine) = value.available
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::TwoTerminalHVDCDetailedLine) = get_value(value, value.active_power_flow)
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `rating`."""
get_rating(value::TwoTerminalHVDCDetailedLine) = get_value(value, value.rating)
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `active_power_limits`."""
get_active_power_limits(value::TwoTerminalHVDCDetailedLine) = get_value(value, value.active_power_limits)
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `arc`."""
get_arc(value::TwoTerminalHVDCDetailedLine) = value.arc
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `converter_loss`."""
get_converter_loss(value::TwoTerminalHVDCDetailedLine) = value.converter_loss
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `dc_current`."""
get_dc_current(value::TwoTerminalHVDCDetailedLine) = value.dc_current
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `max_dc_current`."""
get_max_dc_current(value::TwoTerminalHVDCDetailedLine) = value.max_dc_current
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `g`."""
get_g(value::TwoTerminalHVDCDetailedLine) = value.g
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `services`."""
get_services(value::TwoTerminalHVDCDetailedLine) = value.services
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `ext`."""
get_ext(value::TwoTerminalHVDCDetailedLine) = value.ext
"""Get [`TwoTerminalHVDCDetailedLine`](@ref) `internal`."""
get_internal(value::TwoTerminalHVDCDetailedLine) = value.internal

"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `available`."""
set_available!(value::TwoTerminalHVDCDetailedLine, val) = value.available = val
"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::TwoTerminalHVDCDetailedLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `rating`."""
set_rating!(value::TwoTerminalHVDCDetailedLine, val) = value.rating = set_value(value, val)
"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `active_power_limits`."""
set_active_power_limits!(value::TwoTerminalHVDCDetailedLine, val) = value.active_power_limits = set_value(value, val)
"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `arc`."""
set_arc!(value::TwoTerminalHVDCDetailedLine, val) = value.arc = val
"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `converter_loss`."""
set_converter_loss!(value::TwoTerminalHVDCDetailedLine, val) = value.converter_loss = val
"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `dc_current`."""
set_dc_current!(value::TwoTerminalHVDCDetailedLine, val) = value.dc_current = val
"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `max_dc_current`."""
set_max_dc_current!(value::TwoTerminalHVDCDetailedLine, val) = value.max_dc_current = val
"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `g`."""
set_g!(value::TwoTerminalHVDCDetailedLine, val) = value.g = val
"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `services`."""
set_services!(value::TwoTerminalHVDCDetailedLine, val) = value.services = val
"""Set [`TwoTerminalHVDCDetailedLine`](@ref) `ext`."""
set_ext!(value::TwoTerminalHVDCDetailedLine, val) = value.ext = val
