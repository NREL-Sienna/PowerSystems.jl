#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct StandardLoad <: StaticLoad
        name::String
        available::Bool
        bus::Bus
        base_power::Float64
        constant_active_power::Float64
        constant_reactive_power::Float64
        impedance_active_power::Float64
        impedance_reactive_power::Float64
        current_active_power::Float64
        current_reactive_power::Float64
        max_constant_active_power::Float64
        max_constant_reactive_power::Float64
        max_impedance_active_power::Float64
        max_impedance_reactive_power::Float64
        max_current_active_power::Float64
        max_current_reactive_power::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

Data structure for a standard load.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `constant_active_power::Float64`
- `constant_reactive_power::Float64`
- `impedance_active_power::Float64`
- `impedance_reactive_power::Float64`
- `current_active_power::Float64`
- `current_reactive_power::Float64`
- `max_constant_active_power::Float64`
- `max_constant_reactive_power::Float64`
- `max_impedance_active_power::Float64`
- `max_impedance_reactive_power::Float64`
- `max_current_active_power::Float64`
- `max_current_reactive_power::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct StandardLoad <: StaticLoad
    name::String
    available::Bool
    bus::Bus
    "Base power of the unit in MVA"
    base_power::Float64
    constant_active_power::Float64
    constant_reactive_power::Float64
    impedance_active_power::Float64
    impedance_reactive_power::Float64
    current_active_power::Float64
    current_reactive_power::Float64
    max_constant_active_power::Float64
    max_constant_reactive_power::Float64
    max_impedance_active_power::Float64
    max_impedance_reactive_power::Float64
    max_current_active_power::Float64
    max_current_reactive_power::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function StandardLoad(name, available, bus, base_power, constant_active_power=0.0, constant_reactive_power=0.0, impedance_active_power=0.0, impedance_reactive_power=0.0, current_active_power=0.0, current_reactive_power=0.0, max_constant_active_power=0.0, max_constant_reactive_power=0.0, max_impedance_active_power=0.0, max_impedance_reactive_power=0.0, max_current_active_power=0.0, max_current_reactive_power=0.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    StandardLoad(name, available, bus, base_power, constant_active_power, constant_reactive_power, impedance_active_power, impedance_reactive_power, current_active_power, current_reactive_power, max_constant_active_power, max_constant_reactive_power, max_impedance_active_power, max_impedance_reactive_power, max_current_active_power, max_current_reactive_power, services, dynamic_injector, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function StandardLoad(; name, available, bus, base_power, constant_active_power=0.0, constant_reactive_power=0.0, impedance_active_power=0.0, impedance_reactive_power=0.0, current_active_power=0.0, current_reactive_power=0.0, max_constant_active_power=0.0, max_constant_reactive_power=0.0, max_impedance_active_power=0.0, max_impedance_reactive_power=0.0, max_current_active_power=0.0, max_current_reactive_power=0.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    StandardLoad(name, available, bus, base_power, constant_active_power, constant_reactive_power, impedance_active_power, impedance_reactive_power, current_active_power, current_reactive_power, max_constant_active_power, max_constant_reactive_power, max_impedance_active_power, max_impedance_reactive_power, max_current_active_power, max_current_reactive_power, services, dynamic_injector, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function StandardLoad(::Nothing)
    StandardLoad(;
        name="init",
        available=false,
        bus=Bus(nothing),
        base_power=0.0,
        constant_active_power=0.0,
        constant_reactive_power=0.0,
        impedance_active_power=0.0,
        impedance_reactive_power=0.0,
        current_active_power=0.0,
        current_reactive_power=0.0,
        max_constant_active_power=0.0,
        max_constant_reactive_power=0.0,
        max_impedance_active_power=0.0,
        max_impedance_reactive_power=0.0,
        max_current_active_power=0.0,
        max_current_reactive_power=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`StandardLoad`](@ref) `name`."""
get_name(value::StandardLoad) = value.name
"""Get [`StandardLoad`](@ref) `available`."""
get_available(value::StandardLoad) = value.available
"""Get [`StandardLoad`](@ref) `bus`."""
get_bus(value::StandardLoad) = value.bus
"""Get [`StandardLoad`](@ref) `base_power`."""
get_base_power(value::StandardLoad) = value.base_power
"""Get [`StandardLoad`](@ref) `constant_active_power`."""
get_constant_active_power(value::StandardLoad) = get_value(value, value.constant_active_power)
"""Get [`StandardLoad`](@ref) `constant_reactive_power`."""
get_constant_reactive_power(value::StandardLoad) = get_value(value, value.constant_reactive_power)
"""Get [`StandardLoad`](@ref) `impedance_active_power`."""
get_impedance_active_power(value::StandardLoad) = get_value(value, value.impedance_active_power)
"""Get [`StandardLoad`](@ref) `impedance_reactive_power`."""
get_impedance_reactive_power(value::StandardLoad) = get_value(value, value.impedance_reactive_power)
"""Get [`StandardLoad`](@ref) `current_active_power`."""
get_current_active_power(value::StandardLoad) = get_value(value, value.current_active_power)
"""Get [`StandardLoad`](@ref) `current_reactive_power`."""
get_current_reactive_power(value::StandardLoad) = get_value(value, value.current_reactive_power)
"""Get [`StandardLoad`](@ref) `max_constant_active_power`."""
get_max_constant_active_power(value::StandardLoad) = get_value(value, value.max_constant_active_power)
"""Get [`StandardLoad`](@ref) `max_constant_reactive_power`."""
get_max_constant_reactive_power(value::StandardLoad) = get_value(value, value.max_constant_reactive_power)
"""Get [`StandardLoad`](@ref) `max_impedance_active_power`."""
get_max_impedance_active_power(value::StandardLoad) = get_value(value, value.max_impedance_active_power)
"""Get [`StandardLoad`](@ref) `max_impedance_reactive_power`."""
get_max_impedance_reactive_power(value::StandardLoad) = get_value(value, value.max_impedance_reactive_power)
"""Get [`StandardLoad`](@ref) `max_current_active_power`."""
get_max_current_active_power(value::StandardLoad) = get_value(value, value.max_current_active_power)
"""Get [`StandardLoad`](@ref) `max_current_reactive_power`."""
get_max_current_reactive_power(value::StandardLoad) = get_value(value, value.max_current_reactive_power)
"""Get [`StandardLoad`](@ref) `services`."""
get_services(value::StandardLoad) = value.services
"""Get [`StandardLoad`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::StandardLoad) = value.dynamic_injector
"""Get [`StandardLoad`](@ref) `ext`."""
get_ext(value::StandardLoad) = value.ext
"""Get [`StandardLoad`](@ref) `time_series_container`."""
get_time_series_container(value::StandardLoad) = value.time_series_container
"""Get [`StandardLoad`](@ref) `internal`."""
get_internal(value::StandardLoad) = value.internal

"""Set [`StandardLoad`](@ref) `available`."""
set_available!(value::StandardLoad, val) = value.available = val
"""Set [`StandardLoad`](@ref) `bus`."""
set_bus!(value::StandardLoad, val) = value.bus = val
"""Set [`StandardLoad`](@ref) `base_power`."""
set_base_power!(value::StandardLoad, val) = value.base_power = val
"""Set [`StandardLoad`](@ref) `constant_active_power`."""
set_constant_active_power!(value::StandardLoad, val) = value.constant_active_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `constant_reactive_power`."""
set_constant_reactive_power!(value::StandardLoad, val) = value.constant_reactive_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `impedance_active_power`."""
set_impedance_active_power!(value::StandardLoad, val) = value.impedance_active_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `impedance_reactive_power`."""
set_impedance_reactive_power!(value::StandardLoad, val) = value.impedance_reactive_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `current_active_power`."""
set_current_active_power!(value::StandardLoad, val) = value.current_active_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `current_reactive_power`."""
set_current_reactive_power!(value::StandardLoad, val) = value.current_reactive_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `max_constant_active_power`."""
set_max_constant_active_power!(value::StandardLoad, val) = value.max_constant_active_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `max_constant_reactive_power`."""
set_max_constant_reactive_power!(value::StandardLoad, val) = value.max_constant_reactive_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `max_impedance_active_power`."""
set_max_impedance_active_power!(value::StandardLoad, val) = value.max_impedance_active_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `max_impedance_reactive_power`."""
set_max_impedance_reactive_power!(value::StandardLoad, val) = value.max_impedance_reactive_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `max_current_active_power`."""
set_max_current_active_power!(value::StandardLoad, val) = value.max_current_active_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `max_current_reactive_power`."""
set_max_current_reactive_power!(value::StandardLoad, val) = value.max_current_reactive_power = set_value(value, val)
"""Set [`StandardLoad`](@ref) `services`."""
set_services!(value::StandardLoad, val) = value.services = val
"""Set [`StandardLoad`](@ref) `ext`."""
set_ext!(value::StandardLoad, val) = value.ext = val
"""Set [`StandardLoad`](@ref) `time_series_container`."""
set_time_series_container!(value::StandardLoad, val) = value.time_series_container = val
