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
        g::Float64
        dc_current_from::Float64
        voltage_control_from::Bool
        dc_setpoint_from::Float64
        ac_setpoint_from::Float64
        converter_loss_from::Union{LinearCurve, QuadraticCurve}
        max_dc_current_from::Float64
        rating_from::Float64
        reactive_power_limits_from::MinMax
        power_factor_weighting_fraction_from::Float64
        voltage_limits_from::MinMax
        dc_current_to::Float64
        voltage_control_to::Bool
        dc_setpoint_to::Float64
        ac_setpoint_to::Float64
        converter_loss_to::Union{LinearCurve, QuadraticCurve}
        max_dc_current_to::Float64
        rating_to::Float64
        reactive_power_limits_to::MinMax
        power_factor_weighting_fraction_to::Float64
        voltage_limits_to::MinMax
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A High Voltage Voltage-Source Converter DC line, which must be connected to an [`ACBus`](@ref) on each end.

This model is appropriate for operational simulations with a linearized DC power flow approximation with losses using a voltage-current model. For modeling a DC network, see [`TModelHVDCLine`](@ref)

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `active_power_flow::Float64`: Initial condition of active power flowing from the from-bus to the to-bus in DC.
- `rating::Float64`: Maximum output power rating of the converter (MVA), validation range: `(0, nothing)`
- `active_power_limits_from::MinMax`: Minimum and maximum active power flows to the FROM node (MW)
- `active_power_limits_to::MinMax`: Minimum and maximum active power flows to the TO node (MW)
- `arc::Arc`: An [`Arc`](@ref) defining this line `from` a bus `to` another bus
- `g::Float64`: (default: `0.0`) Series conductance of the DC line in pu ([`SYSTEM_BASE`](@ref per_unit))
- `dc_current_from::Float64`: (default: `0.0`) DC current (A) on the converter on the `from`-bus DC side.
- `voltage_control_from::Bool`: (default: `true`) Converter control type in the `from` bus converter. Set true for DC Voltage Control (set DC voltage on the DC side of the converter), and false for power demand in the converter.
- `dc_setpoint_from::Float64`: (default: `0.0`) Converter DC setpoint in the `from` bus converter. If `voltage_control_from = true` this number is the DC voltage on the DC side of the converter, entered in kV. If `voltage_control_from = false`, this value is the power demand in MW, if positive the converter is supplying power to the AC network at the `from` bus; if negative, the converter is withdrawing power from the AC network at the `from` bus.
- `ac_setpoint_from::Float64`: (default: `1.0`) Converter AC setpoint in the `from` bus converter. If `voltage_control_from = true` this number is the AC voltage on the AC side of the converter, entered in [per unit](@ref per_unit). If `voltage_control_from = false`, this value is the power factor setpoint.
- `converter_loss_from::Union{LinearCurve, QuadraticCurve}`: (default: `LinearCurve(0.0)`) Loss model coefficients in the `from` bus converter. It accepts a linear model or quadratic. Same converter data is used in both ends.
- `max_dc_current_from::Float64`: (default: `1e8`) Maximum stable dc current limits (A).
- `rating_from::Float64`: (default: `1e8`) Converter rating in MVA in the `from` bus.
- `reactive_power_limits_from::MinMax`: (default: `(min=0.0, max=0.0)`) Limits on the Reactive Power at the `from` side.
- `power_factor_weighting_fraction_from::Float64`: (default: `1.0`) Power weighting factor fraction used in reducing the active power order and either the reactive power order when the converter rating is violated. When is 0.0, only the active power is reduced; when is 1.0, only the reactive power is reduced; otherwise, a weighted reduction of both active and reactive power is applied., validation range: `(0, 1)`
- `voltage_limits_from::MinMax`: (default: `(min=0.0, max=999.9)`) Limits on the Voltage at the DC `from` Bus in [per unit](@ref per_unit.
- `dc_current_to::Float64`: (default: `0.0`) DC current (A) on the converter on the to-bus DC side.
- `voltage_control_to::Bool`: (default: `true`) Converter control type in the `to` bus converter. Set true for DC Voltage Control (set DC voltage on the DC side of the converter), and false for power demand in the converter.
- `dc_setpoint_to::Float64`: (default: `0.0`) Converter DC setpoint in the `to` bus converter. If `voltage_control_to = true` this number is the DC voltage on the DC side of the converter, entered in kV. If `voltage_control_to = false`, this value is the power demand in MW, if positive the converter is supplying power to the AC network at the `to` bus; if negative, the converter is withdrawing power from the AC network at the `to` bus.
- `ac_setpoint_to::Float64`: (default: `1.0`) Converter AC setpoint in the `to`` bus converter. If `voltage_control_to = true` this number is the AC voltage on the AC side of the converter, entered in [per unit](@ref per_unit). If `voltage_control_to = false`, this value is the power factor setpoint.
- `converter_loss_to::Union{LinearCurve, QuadraticCurve}`: (default: `LinearCurve(0.0)`) Loss model coefficients in the `to` bus converter. It accepts a linear model or quadratic. Same converter data is used in both ends.
- `max_dc_current_to::Float64`: (default: `1e8`) Maximum stable dc current limits (A).
- `rating_to::Float64`: (default: `1e8`) Converter rating in MVA in the `to` bus.
- `reactive_power_limits_to::MinMax`: (default: `(min=0.0, max=0.0)`) Limits on the Reactive Power at the `to` side.
- `power_factor_weighting_fraction_to::Float64`: (default: `1.0`) Power weighting factor fraction used in reducing the active power order and either the reactive power order when the converter rating is violated. When is 0.0, only the active power is reduced; when is 1.0, only the reactive power is reduced; otherwise, a weighted reduction of both active and reactive power is applied., validation range: `(0, 1)`
- `voltage_limits_to::MinMax`: (default: `(min=0.0, max=999.9)`) Limits on the Voltage at the DC `to` Bus.
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
    "Series conductance of the DC line in pu ([`SYSTEM_BASE`](@ref per_unit))"
    g::Float64
    "DC current (A) on the converter on the `from`-bus DC side."
    dc_current_from::Float64
    "Converter control type in the `from` bus converter. Set true for DC Voltage Control (set DC voltage on the DC side of the converter), and false for power demand in the converter."
    voltage_control_from::Bool
    "Converter DC setpoint in the `from` bus converter. If `voltage_control_from = true` this number is the DC voltage on the DC side of the converter, entered in kV. If `voltage_control_from = false`, this value is the power demand in MW, if positive the converter is supplying power to the AC network at the `from` bus; if negative, the converter is withdrawing power from the AC network at the `from` bus."
    dc_setpoint_from::Float64
    "Converter AC setpoint in the `from` bus converter. If `voltage_control_from = true` this number is the AC voltage on the AC side of the converter, entered in [per unit](@ref per_unit). If `voltage_control_from = false`, this value is the power factor setpoint."
    ac_setpoint_from::Float64
    "Loss model coefficients in the `from` bus converter. It accepts a linear model or quadratic. Same converter data is used in both ends."
    converter_loss_from::Union{LinearCurve, QuadraticCurve}
    "Maximum stable dc current limits (A)."
    max_dc_current_from::Float64
    "Converter rating in MVA in the `from` bus."
    rating_from::Float64
    "Limits on the Reactive Power at the `from` side."
    reactive_power_limits_from::MinMax
    "Power weighting factor fraction used in reducing the active power order and either the reactive power order when the converter rating is violated. When is 0.0, only the active power is reduced; when is 1.0, only the reactive power is reduced; otherwise, a weighted reduction of both active and reactive power is applied."
    power_factor_weighting_fraction_from::Float64
    "Limits on the Voltage at the DC `from` Bus in [per unit](@ref per_unit."
    voltage_limits_from::MinMax
    "DC current (A) on the converter on the to-bus DC side."
    dc_current_to::Float64
    "Converter control type in the `to` bus converter. Set true for DC Voltage Control (set DC voltage on the DC side of the converter), and false for power demand in the converter."
    voltage_control_to::Bool
    "Converter DC setpoint in the `to` bus converter. If `voltage_control_to = true` this number is the DC voltage on the DC side of the converter, entered in kV. If `voltage_control_to = false`, this value is the power demand in MW, if positive the converter is supplying power to the AC network at the `to` bus; if negative, the converter is withdrawing power from the AC network at the `to` bus."
    dc_setpoint_to::Float64
    "Converter AC setpoint in the `to`` bus converter. If `voltage_control_to = true` this number is the AC voltage on the AC side of the converter, entered in [per unit](@ref per_unit). If `voltage_control_to = false`, this value is the power factor setpoint."
    ac_setpoint_to::Float64
    "Loss model coefficients in the `to` bus converter. It accepts a linear model or quadratic. Same converter data is used in both ends."
    converter_loss_to::Union{LinearCurve, QuadraticCurve}
    "Maximum stable dc current limits (A)."
    max_dc_current_to::Float64
    "Converter rating in MVA in the `to` bus."
    rating_to::Float64
    "Limits on the Reactive Power at the `to` side."
    reactive_power_limits_to::MinMax
    "Power weighting factor fraction used in reducing the active power order and either the reactive power order when the converter rating is violated. When is 0.0, only the active power is reduced; when is 1.0, only the reactive power is reduced; otherwise, a weighted reduction of both active and reactive power is applied."
    power_factor_weighting_fraction_to::Float64
    "Limits on the Voltage at the DC `to` Bus."
    voltage_limits_to::MinMax
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function TwoTerminalVSCLine(name, available, active_power_flow, rating, active_power_limits_from, active_power_limits_to, arc, g=0.0, dc_current_from=0.0, voltage_control_from=true, dc_setpoint_from=0.0, ac_setpoint_from=1.0, converter_loss_from=LinearCurve(0.0), max_dc_current_from=1e8, rating_from=1e8, reactive_power_limits_from=(min=0.0, max=0.0), power_factor_weighting_fraction_from=1.0, voltage_limits_from=(min=0.0, max=999.9), dc_current_to=0.0, voltage_control_to=true, dc_setpoint_to=0.0, ac_setpoint_to=1.0, converter_loss_to=LinearCurve(0.0), max_dc_current_to=1e8, rating_to=1e8, reactive_power_limits_to=(min=0.0, max=0.0), power_factor_weighting_fraction_to=1.0, voltage_limits_to=(min=0.0, max=999.9), services=Device[], ext=Dict{String, Any}(), )
    TwoTerminalVSCLine(name, available, active_power_flow, rating, active_power_limits_from, active_power_limits_to, arc, g, dc_current_from, voltage_control_from, dc_setpoint_from, ac_setpoint_from, converter_loss_from, max_dc_current_from, rating_from, reactive_power_limits_from, power_factor_weighting_fraction_from, voltage_limits_from, dc_current_to, voltage_control_to, dc_setpoint_to, ac_setpoint_to, converter_loss_to, max_dc_current_to, rating_to, reactive_power_limits_to, power_factor_weighting_fraction_to, voltage_limits_to, services, ext, InfrastructureSystemsInternal(), )
end

function TwoTerminalVSCLine(; name, available, active_power_flow, rating, active_power_limits_from, active_power_limits_to, arc, g=0.0, dc_current_from=0.0, voltage_control_from=true, dc_setpoint_from=0.0, ac_setpoint_from=1.0, converter_loss_from=LinearCurve(0.0), max_dc_current_from=1e8, rating_from=1e8, reactive_power_limits_from=(min=0.0, max=0.0), power_factor_weighting_fraction_from=1.0, voltage_limits_from=(min=0.0, max=999.9), dc_current_to=0.0, voltage_control_to=true, dc_setpoint_to=0.0, ac_setpoint_to=1.0, converter_loss_to=LinearCurve(0.0), max_dc_current_to=1e8, rating_to=1e8, reactive_power_limits_to=(min=0.0, max=0.0), power_factor_weighting_fraction_to=1.0, voltage_limits_to=(min=0.0, max=999.9), services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    TwoTerminalVSCLine(name, available, active_power_flow, rating, active_power_limits_from, active_power_limits_to, arc, g, dc_current_from, voltage_control_from, dc_setpoint_from, ac_setpoint_from, converter_loss_from, max_dc_current_from, rating_from, reactive_power_limits_from, power_factor_weighting_fraction_from, voltage_limits_from, dc_current_to, voltage_control_to, dc_setpoint_to, ac_setpoint_to, converter_loss_to, max_dc_current_to, rating_to, reactive_power_limits_to, power_factor_weighting_fraction_to, voltage_limits_to, services, ext, internal, )
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
        g=0.0,
        dc_current_from=0.0,
        voltage_control_from=false,
        dc_setpoint_from=0.0,
        ac_setpoint_from=0.0,
        converter_loss_from=LinearCurve(0.0),
        max_dc_current_from=0.0,
        rating_from=0.0,
        reactive_power_limits_from=(min=0.0, max=0.0),
        power_factor_weighting_fraction_from=0.0,
        voltage_limits_from=(min=0.0, max=0.0),
        dc_current_to=0.0,
        voltage_control_to=false,
        dc_setpoint_to=0.0,
        ac_setpoint_to=0.0,
        converter_loss_to=LinearCurve(0.0),
        max_dc_current_to=0.0,
        rating_to=0.0,
        reactive_power_limits_to=(min=0.0, max=0.0),
        power_factor_weighting_fraction_to=0.0,
        voltage_limits_to=(min=0.0, max=0.0),
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
"""Get [`TwoTerminalVSCLine`](@ref) `g`."""
get_g(value::TwoTerminalVSCLine) = value.g
"""Get [`TwoTerminalVSCLine`](@ref) `dc_current_from`."""
get_dc_current_from(value::TwoTerminalVSCLine) = value.dc_current_from
"""Get [`TwoTerminalVSCLine`](@ref) `voltage_control_from`."""
get_voltage_control_from(value::TwoTerminalVSCLine) = value.voltage_control_from
"""Get [`TwoTerminalVSCLine`](@ref) `dc_setpoint_from`."""
get_dc_setpoint_from(value::TwoTerminalVSCLine) = value.dc_setpoint_from
"""Get [`TwoTerminalVSCLine`](@ref) `ac_setpoint_from`."""
get_ac_setpoint_from(value::TwoTerminalVSCLine) = value.ac_setpoint_from
"""Get [`TwoTerminalVSCLine`](@ref) `converter_loss_from`."""
get_converter_loss_from(value::TwoTerminalVSCLine) = value.converter_loss_from
"""Get [`TwoTerminalVSCLine`](@ref) `max_dc_current_from`."""
get_max_dc_current_from(value::TwoTerminalVSCLine) = value.max_dc_current_from
"""Get [`TwoTerminalVSCLine`](@ref) `rating_from`."""
get_rating_from(value::TwoTerminalVSCLine) = get_value(value, value.rating_from)
"""Get [`TwoTerminalVSCLine`](@ref) `reactive_power_limits_from`."""
get_reactive_power_limits_from(value::TwoTerminalVSCLine) = value.reactive_power_limits_from
"""Get [`TwoTerminalVSCLine`](@ref) `power_factor_weighting_fraction_from`."""
get_power_factor_weighting_fraction_from(value::TwoTerminalVSCLine) = value.power_factor_weighting_fraction_from
"""Get [`TwoTerminalVSCLine`](@ref) `voltage_limits_from`."""
get_voltage_limits_from(value::TwoTerminalVSCLine) = value.voltage_limits_from
"""Get [`TwoTerminalVSCLine`](@ref) `dc_current_to`."""
get_dc_current_to(value::TwoTerminalVSCLine) = value.dc_current_to
"""Get [`TwoTerminalVSCLine`](@ref) `voltage_control_to`."""
get_voltage_control_to(value::TwoTerminalVSCLine) = value.voltage_control_to
"""Get [`TwoTerminalVSCLine`](@ref) `dc_setpoint_to`."""
get_dc_setpoint_to(value::TwoTerminalVSCLine) = value.dc_setpoint_to
"""Get [`TwoTerminalVSCLine`](@ref) `ac_setpoint_to`."""
get_ac_setpoint_to(value::TwoTerminalVSCLine) = value.ac_setpoint_to
"""Get [`TwoTerminalVSCLine`](@ref) `converter_loss_to`."""
get_converter_loss_to(value::TwoTerminalVSCLine) = value.converter_loss_to
"""Get [`TwoTerminalVSCLine`](@ref) `max_dc_current_to`."""
get_max_dc_current_to(value::TwoTerminalVSCLine) = value.max_dc_current_to
"""Get [`TwoTerminalVSCLine`](@ref) `rating_to`."""
get_rating_to(value::TwoTerminalVSCLine) = value.rating_to
"""Get [`TwoTerminalVSCLine`](@ref) `reactive_power_limits_to`."""
get_reactive_power_limits_to(value::TwoTerminalVSCLine) = value.reactive_power_limits_to
"""Get [`TwoTerminalVSCLine`](@ref) `power_factor_weighting_fraction_to`."""
get_power_factor_weighting_fraction_to(value::TwoTerminalVSCLine) = value.power_factor_weighting_fraction_to
"""Get [`TwoTerminalVSCLine`](@ref) `voltage_limits_to`."""
get_voltage_limits_to(value::TwoTerminalVSCLine) = value.voltage_limits_to
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
"""Set [`TwoTerminalVSCLine`](@ref) `g`."""
set_g!(value::TwoTerminalVSCLine, val) = value.g = val
"""Set [`TwoTerminalVSCLine`](@ref) `dc_current_from`."""
set_dc_current_from!(value::TwoTerminalVSCLine, val) = value.dc_current_from = val
"""Set [`TwoTerminalVSCLine`](@ref) `voltage_control_from`."""
set_voltage_control_from!(value::TwoTerminalVSCLine, val) = value.voltage_control_from = val
"""Set [`TwoTerminalVSCLine`](@ref) `dc_setpoint_from`."""
set_dc_setpoint_from!(value::TwoTerminalVSCLine, val) = value.dc_setpoint_from = val
"""Set [`TwoTerminalVSCLine`](@ref) `ac_setpoint_from`."""
set_ac_setpoint_from!(value::TwoTerminalVSCLine, val) = value.ac_setpoint_from = val
"""Set [`TwoTerminalVSCLine`](@ref) `converter_loss_from`."""
set_converter_loss_from!(value::TwoTerminalVSCLine, val) = value.converter_loss_from = val
"""Set [`TwoTerminalVSCLine`](@ref) `max_dc_current_from`."""
set_max_dc_current_from!(value::TwoTerminalVSCLine, val) = value.max_dc_current_from = val
"""Set [`TwoTerminalVSCLine`](@ref) `rating_from`."""
set_rating_from!(value::TwoTerminalVSCLine, val) = value.rating_from = set_value(value, val)
"""Set [`TwoTerminalVSCLine`](@ref) `reactive_power_limits_from`."""
set_reactive_power_limits_from!(value::TwoTerminalVSCLine, val) = value.reactive_power_limits_from = val
"""Set [`TwoTerminalVSCLine`](@ref) `power_factor_weighting_fraction_from`."""
set_power_factor_weighting_fraction_from!(value::TwoTerminalVSCLine, val) = value.power_factor_weighting_fraction_from = val
"""Set [`TwoTerminalVSCLine`](@ref) `voltage_limits_from`."""
set_voltage_limits_from!(value::TwoTerminalVSCLine, val) = value.voltage_limits_from = val
"""Set [`TwoTerminalVSCLine`](@ref) `dc_current_to`."""
set_dc_current_to!(value::TwoTerminalVSCLine, val) = value.dc_current_to = val
"""Set [`TwoTerminalVSCLine`](@ref) `voltage_control_to`."""
set_voltage_control_to!(value::TwoTerminalVSCLine, val) = value.voltage_control_to = val
"""Set [`TwoTerminalVSCLine`](@ref) `dc_setpoint_to`."""
set_dc_setpoint_to!(value::TwoTerminalVSCLine, val) = value.dc_setpoint_to = val
"""Set [`TwoTerminalVSCLine`](@ref) `ac_setpoint_to`."""
set_ac_setpoint_to!(value::TwoTerminalVSCLine, val) = value.ac_setpoint_to = val
"""Set [`TwoTerminalVSCLine`](@ref) `converter_loss_to`."""
set_converter_loss_to!(value::TwoTerminalVSCLine, val) = value.converter_loss_to = val
"""Set [`TwoTerminalVSCLine`](@ref) `max_dc_current_to`."""
set_max_dc_current_to!(value::TwoTerminalVSCLine, val) = value.max_dc_current_to = val
"""Set [`TwoTerminalVSCLine`](@ref) `rating_to`."""
set_rating_to!(value::TwoTerminalVSCLine, val) = value.rating_to = val
"""Set [`TwoTerminalVSCLine`](@ref) `reactive_power_limits_to`."""
set_reactive_power_limits_to!(value::TwoTerminalVSCLine, val) = value.reactive_power_limits_to = val
"""Set [`TwoTerminalVSCLine`](@ref) `power_factor_weighting_fraction_to`."""
set_power_factor_weighting_fraction_to!(value::TwoTerminalVSCLine, val) = value.power_factor_weighting_fraction_to = val
"""Set [`TwoTerminalVSCLine`](@ref) `voltage_limits_to`."""
set_voltage_limits_to!(value::TwoTerminalVSCLine, val) = value.voltage_limits_to = val
"""Set [`TwoTerminalVSCLine`](@ref) `services`."""
set_services!(value::TwoTerminalVSCLine, val) = value.services = val
"""Set [`TwoTerminalVSCLine`](@ref) `ext`."""
set_ext!(value::TwoTerminalVSCLine, val) = value.ext = val
