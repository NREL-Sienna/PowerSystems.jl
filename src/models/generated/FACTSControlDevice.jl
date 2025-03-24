#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct FACTSControlDevice <: ElectricLoad
        name::String
        available::Bool
        bus::ACBus
        control_mode::Union{Nothing, FACTSOperationModes}
        voltage_setpoint::Float64
        max_shunt_current::Float64
        reactive_power_required::Float64
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Facts control devices.

Most often used in AC power flow studies as a control of voltage and, active and reactive power.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `bus::ACBus`: Sending end bus number
- `control_mode::Union{Nothing, FACTSOperationModes}`: Control mode. Used to describe the behavior of the control device. [Options are listed here.](@ref factsmodes_list)
- `voltage_setpoint::Float64`: Voltage setpoint at the sending end bus, it has to be a [`PV`](@ref acbustypes_list) bus, in p.u. ([`SYSTEM_BASE`](@ref per_unit)).
- `max_shunt_current::Float64`: Maximum shunt current at the sending end bus; entered in MVA at unity voltage.
- `reactive_power_required::Float64`: Total MVAr required to hold voltage at sending bus, in %.
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct FACTSControlDevice <: ElectricLoad
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Sending end bus number"
    bus::ACBus
    "Control mode. Used to describe the behavior of the control device. [Options are listed here.](@ref factsmodes_list)"
    control_mode::Union{Nothing, FACTSOperationModes}
    "Voltage setpoint at the sending end bus, it has to be a [`PV`](@ref acbustypes_list) bus, in p.u. ([`SYSTEM_BASE`](@ref per_unit))."
    voltage_setpoint::Float64
    "Maximum shunt current at the sending end bus; entered in MVA at unity voltage."
    max_shunt_current::Float64
    "Total MVAr required to hold voltage at sending bus, in %."
    reactive_power_required::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function FACTSControlDevice(name, available, bus, control_mode, services=Device[], ext=Dict{String, Any}(), )
    FACTSControlDevice(name, available, bus, control_mode, services, ext, 1.0, 9999.0, 100.0, InfrastructureSystemsInternal(), )
end

function FACTSControlDevice(; name, available, bus, control_mode, voltage_setpoint=1.0, max_shunt_current=9999.0, reactive_power_required=100.0, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    FACTSControlDevice(name, available, bus, control_mode, voltage_setpoint, max_shunt_current, reactive_power_required, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function FACTSControlDevice(::Nothing)
    FACTSControlDevice(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        control_mode=nothing,
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`FACTSControlDevice`](@ref) `name`."""
get_name(value::FACTSControlDevice) = value.name
"""Get [`FACTSControlDevice`](@ref) `available`."""
get_available(value::FACTSControlDevice) = value.available
"""Get [`FACTSControlDevice`](@ref) `bus`."""
get_bus(value::FACTSControlDevice) = value.bus
"""Get [`FACTSControlDevice`](@ref) `control_mode`."""
get_control_mode(value::FACTSControlDevice) = value.control_mode
"""Get [`FACTSControlDevice`](@ref) `voltage_setpoint`."""
get_voltage_setpoint(value::FACTSControlDevice) = value.voltage_setpoint
"""Get [`FACTSControlDevice`](@ref) `max_shunt_current`."""
get_max_shunt_current(value::FACTSControlDevice) = value.max_shunt_current
"""Get [`FACTSControlDevice`](@ref) `reactive_power_required`."""
get_reactive_power_required(value::FACTSControlDevice) = value.reactive_power_required
"""Get [`FACTSControlDevice`](@ref) `services`."""
get_services(value::FACTSControlDevice) = value.services
"""Get [`FACTSControlDevice`](@ref) `ext`."""
get_ext(value::FACTSControlDevice) = value.ext
"""Get [`FACTSControlDevice`](@ref) `internal`."""
get_internal(value::FACTSControlDevice) = value.internal

"""Set [`FACTSControlDevice`](@ref) `available`."""
set_available!(value::FACTSControlDevice, val) = value.available = val
"""Set [`FACTSControlDevice`](@ref) `bus`."""
set_bus!(value::FACTSControlDevice, val) = value.bus = val
"""Set [`FACTSControlDevice`](@ref) `control_mode`."""
set_control_mode!(value::FACTSControlDevice, val) = value.control_mode = val
"""Set [`FACTSControlDevice`](@ref) `voltage_setpoint`."""
set_voltage_setpoint!(value::FACTSControlDevice, val) = value.voltage_setpoint = val
"""Set [`FACTSControlDevice`](@ref) `max_shunt_current`."""
set_max_shunt_current!(value::FACTSControlDevice, val) = value.max_shunt_current = val
"""Set [`FACTSControlDevice`](@ref) `reactive_power_required`."""
set_reactive_power_required!(value::FACTSControlDevice, val) = value.reactive_power_required = val
"""Set [`FACTSControlDevice`](@ref) `services`."""
set_services!(value::FACTSControlDevice, val) = value.services = val
"""Set [`FACTSControlDevice`](@ref) `ext`."""
set_ext!(value::FACTSControlDevice, val) = value.ext = val
