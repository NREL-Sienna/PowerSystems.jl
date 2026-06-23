#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct InterconnectingConverter <: StaticInjection
        name::String
        available::Bool
        bus::ACBus
        dc_bus::DCBus
        active_power::Float64
        rating::Float64
        active_power_limits::MinMax
        base_power::Float64
        reactive_power_limits::Union{Nothing, MinMax}
        dc_current::Float64
        max_dc_current::Float64
        loss_function::Union{LinearCurve, QuadraticCurve}
        dc_voltage_control::Bool
        ac_voltage_control::Bool
        dc_setpoint::Float64
        ac_setpoint::Float64
        dc_voltage_droop::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Interconnecting Power Converter (IPC) for transforming power from an [`ACBus`](@ref) to a [`DCBus`](@ref)

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `bus::ACBus`: The [`ACBus`](@ref) on the AC side of this converter
- `dc_bus::DCBus`: The [`DCBus`](@ref) on the DC side of this converter
- `active_power::Float64`: Active power (MW) on the DC side, validation range: `active_power_limits`
- `rating::Float64`: Maximum output power rating of the converter (MVA), validation range: `(0, nothing)`
- `active_power_limits::MinMax`: Minimum and maximum stable active power levels (MW)
- `base_power::Float64`: Base power of the converter in MVA, validation range: `(0.0001, nothing)`
- `reactive_power_limits::Union{Nothing, MinMax}`: (default: `nothing`) Minimum and maximum reactive power limits. Set to `Nothing` if not applicable
- `dc_current::Float64`: (default: `0.0`) DC current (A) on the converter
- `max_dc_current::Float64`: (default: `1e8`) Maximum stable dc current limits (A)
- `loss_function::Union{LinearCurve, QuadraticCurve}`: (default: `LinearCurve(0.0)`) Linear or quadratic loss function with respect to the converter current
- `dc_voltage_control::Bool`: (default: `true`) Converter control type. Set true for DC-voltage control (the converter regulates the DC-bus voltage), false for active-power control.
- `ac_voltage_control::Bool`: (default: `false`) Set true for AC-voltage control (the converter regulates the AC-bus voltage magnitude), false for reactive-power control.
- `dc_setpoint::Float64`: (default: `0.0`) DC-voltage target (when dc_voltage_control is true) or active-power order (when false), in per unit.
- `ac_setpoint::Float64`: (default: `1.0`) AC-voltage magnitude target (when ac_voltage_control is true), in per unit.
- `dc_voltage_droop::Float64`: (default: `0.0`) DC-voltage droop gain relating DC voltage to converter active power as V_dc = dc_setpoint - dc_voltage_droop * P_c. A value of 0.0 disables droop.
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: (default: `nothing`) corresponding dynamic injection device
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct InterconnectingConverter <: StaticInjection
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "The [`ACBus`](@ref) on the AC side of this converter"
    bus::ACBus
    "The [`DCBus`](@ref) on the DC side of this converter"
    dc_bus::DCBus
    "Active power (MW) on the DC side"
    active_power::Float64
    "Maximum output power rating of the converter (MVA)"
    rating::Float64
    "Minimum and maximum stable active power levels (MW)"
    active_power_limits::MinMax
    "Base power of the converter in MVA"
    base_power::Float64
    "Minimum and maximum reactive power limits. Set to `Nothing` if not applicable"
    reactive_power_limits::Union{Nothing, MinMax}
    "DC current (A) on the converter"
    dc_current::Float64
    "Maximum stable dc current limits (A)"
    max_dc_current::Float64
    "Linear or quadratic loss function with respect to the converter current"
    loss_function::Union{LinearCurve, QuadraticCurve}
    "Converter control type. Set true for DC-voltage control (the converter regulates the DC-bus voltage), false for active-power control."
    dc_voltage_control::Bool
    "Set true for AC-voltage control (the converter regulates the AC-bus voltage magnitude), false for reactive-power control."
    ac_voltage_control::Bool
    "DC-voltage target (when dc_voltage_control is true) or active-power order (when false), in per unit."
    dc_setpoint::Float64
    "AC-voltage magnitude target (when ac_voltage_control is true), in per unit."
    ac_setpoint::Float64
    "DC-voltage droop gain relating DC voltage to converter active power as V_dc = dc_setpoint - dc_voltage_droop * P_c. A value of 0.0 disables droop."
    dc_voltage_droop::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function InterconnectingConverter(name, available, bus, dc_bus, active_power, rating, active_power_limits, base_power, reactive_power_limits=nothing, dc_current=0.0, max_dc_current=1e8, loss_function=LinearCurve(0.0), dc_voltage_control=true, ac_voltage_control=false, dc_setpoint=0.0, ac_setpoint=1.0, dc_voltage_droop=0.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    InterconnectingConverter(name, available, bus, dc_bus, active_power, rating, active_power_limits, base_power, reactive_power_limits, dc_current, max_dc_current, loss_function, dc_voltage_control, ac_voltage_control, dc_setpoint, ac_setpoint, dc_voltage_droop, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function InterconnectingConverter(; name, available, bus, dc_bus, active_power, rating, active_power_limits, base_power, reactive_power_limits=nothing, dc_current=0.0, max_dc_current=1e8, loss_function=LinearCurve(0.0), dc_voltage_control=true, ac_voltage_control=false, dc_setpoint=0.0, ac_setpoint=1.0, dc_voltage_droop=0.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    InterconnectingConverter(name, available, bus, dc_bus, active_power, rating, active_power_limits, base_power, reactive_power_limits, dc_current, max_dc_current, loss_function, dc_voltage_control, ac_voltage_control, dc_setpoint, ac_setpoint, dc_voltage_droop, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function InterconnectingConverter(::Nothing)
    InterconnectingConverter(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        dc_bus=DCBus(nothing),
        active_power=0.0,
        rating=0.0,
        active_power_limits=(min=0.0, max=0.0),
        base_power=100,
        reactive_power_limits=nothing,
        dc_current=0.0,
        max_dc_current=0.0,
        loss_function=LinearCurve(0.0),
        dc_voltage_control=false,
        ac_voltage_control=false,
        dc_setpoint=0.0,
        ac_setpoint=0.0,
        dc_voltage_droop=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`InterconnectingConverter`](@ref) `name`."""
get_name(value::InterconnectingConverter) = value.name
"""Get [`InterconnectingConverter`](@ref) `available`."""
get_available(value::InterconnectingConverter) = value.available
"""Get [`InterconnectingConverter`](@ref) `bus`."""
get_bus(value::InterconnectingConverter) = value.bus
"""Get [`InterconnectingConverter`](@ref) `dc_bus`."""
get_dc_bus(value::InterconnectingConverter) = value.dc_bus
"""Get [`InterconnectingConverter`](@ref) `active_power`."""
get_active_power(value::InterconnectingConverter) = get_value(value, Val(:active_power), Val(:mva))
"""Get [`InterconnectingConverter`](@ref) `rating`."""
get_rating(value::InterconnectingConverter) = get_value(value, Val(:rating), Val(:mva))
"""Get [`InterconnectingConverter`](@ref) `active_power_limits`."""
get_active_power_limits(value::InterconnectingConverter) = get_value(value, Val(:active_power_limits), Val(:mva))
"""Get [`InterconnectingConverter`](@ref) `base_power`."""
get_base_power(value::InterconnectingConverter) = value.base_power
"""Get [`InterconnectingConverter`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::InterconnectingConverter) = get_value(value, Val(:reactive_power_limits), Val(:mva))
"""Get [`InterconnectingConverter`](@ref) `dc_current`."""
get_dc_current(value::InterconnectingConverter) = value.dc_current
"""Get [`InterconnectingConverter`](@ref) `max_dc_current`."""
get_max_dc_current(value::InterconnectingConverter) = value.max_dc_current
"""Get [`InterconnectingConverter`](@ref) `loss_function`."""
get_loss_function(value::InterconnectingConverter) = value.loss_function
"""Get [`InterconnectingConverter`](@ref) `dc_voltage_control`."""
get_dc_voltage_control(value::InterconnectingConverter) = value.dc_voltage_control
"""Get [`InterconnectingConverter`](@ref) `ac_voltage_control`."""
get_ac_voltage_control(value::InterconnectingConverter) = value.ac_voltage_control
"""Get [`InterconnectingConverter`](@ref) `dc_setpoint`."""
get_dc_setpoint(value::InterconnectingConverter) = value.dc_setpoint
"""Get [`InterconnectingConverter`](@ref) `ac_setpoint`."""
get_ac_setpoint(value::InterconnectingConverter) = value.ac_setpoint
"""Get [`InterconnectingConverter`](@ref) `dc_voltage_droop`."""
get_dc_voltage_droop(value::InterconnectingConverter) = value.dc_voltage_droop
"""Get [`InterconnectingConverter`](@ref) `services`."""
get_services(value::InterconnectingConverter) = value.services
"""Get [`InterconnectingConverter`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::InterconnectingConverter) = value.dynamic_injector
"""Get [`InterconnectingConverter`](@ref) `ext`."""
get_ext(value::InterconnectingConverter) = value.ext
"""Get [`InterconnectingConverter`](@ref) `internal`."""
get_internal(value::InterconnectingConverter) = value.internal

"""Set [`InterconnectingConverter`](@ref) `available`."""
set_available!(value::InterconnectingConverter, val) = value.available = val
"""Set [`InterconnectingConverter`](@ref) `bus`."""
set_bus!(value::InterconnectingConverter, val) = value.bus = val
"""Set [`InterconnectingConverter`](@ref) `dc_bus`."""
set_dc_bus!(value::InterconnectingConverter, val) = value.dc_bus = val
"""Set [`InterconnectingConverter`](@ref) `active_power`."""
set_active_power!(value::InterconnectingConverter, val) = value.active_power = set_value(value, Val(:active_power), val, Val(:mva))
"""Set [`InterconnectingConverter`](@ref) `rating`."""
set_rating!(value::InterconnectingConverter, val) = value.rating = set_value(value, Val(:rating), val, Val(:mva))
"""Set [`InterconnectingConverter`](@ref) `active_power_limits`."""
set_active_power_limits!(value::InterconnectingConverter, val) = value.active_power_limits = set_value(value, Val(:active_power_limits), val, Val(:mva))
"""Set [`InterconnectingConverter`](@ref) `base_power`."""
set_base_power!(value::InterconnectingConverter, val) = value.base_power = val
"""Set [`InterconnectingConverter`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::InterconnectingConverter, val) = value.reactive_power_limits = set_value(value, Val(:reactive_power_limits), val, Val(:mva))
"""Set [`InterconnectingConverter`](@ref) `dc_current`."""
set_dc_current!(value::InterconnectingConverter, val) = value.dc_current = val
"""Set [`InterconnectingConverter`](@ref) `max_dc_current`."""
set_max_dc_current!(value::InterconnectingConverter, val) = value.max_dc_current = val
"""Set [`InterconnectingConverter`](@ref) `loss_function`."""
set_loss_function!(value::InterconnectingConverter, val) = value.loss_function = val
"""Set [`InterconnectingConverter`](@ref) `dc_voltage_control`."""
set_dc_voltage_control!(value::InterconnectingConverter, val) = value.dc_voltage_control = val
"""Set [`InterconnectingConverter`](@ref) `ac_voltage_control`."""
set_ac_voltage_control!(value::InterconnectingConverter, val) = value.ac_voltage_control = val
"""Set [`InterconnectingConverter`](@ref) `dc_setpoint`."""
set_dc_setpoint!(value::InterconnectingConverter, val) = value.dc_setpoint = val
"""Set [`InterconnectingConverter`](@ref) `ac_setpoint`."""
set_ac_setpoint!(value::InterconnectingConverter, val) = value.ac_setpoint = val
"""Set [`InterconnectingConverter`](@ref) `dc_voltage_droop`."""
set_dc_voltage_droop!(value::InterconnectingConverter, val) = value.dc_voltage_droop = val
"""Set [`InterconnectingConverter`](@ref) `services`."""
set_services!(value::InterconnectingConverter, val) = value.services = val
"""Set [`InterconnectingConverter`](@ref) `ext`."""
set_ext!(value::InterconnectingConverter, val) = value.ext = val
