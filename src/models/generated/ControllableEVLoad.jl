#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ControllableEVLoad <: ControllableLoad
        name::String
        available::Bool
        bus::Bus
        model::Union{Nothing, LoadModels}
        active_power::Float64
        reactive_power::Float64
        base_power::Float64
        max_active_power::Float64
        max_reactive_power::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

Data structure for a shiftable EV charging power load.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `model::Union{Nothing, LoadModels}`
- `active_power::Float64`
- `reactive_power::Float64`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `max_active_power::Float64`
- `max_reactive_power::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ControllableEVLoad <: ControllableLoad
    name::String
    available::Bool
    bus::Bus
    model::Union{Nothing, LoadModels}
    active_power::Float64
    reactive_power::Float64
    "Base power of the unit in MVA"
    base_power::Float64
    max_active_power::Float64
    max_reactive_power::Float64
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

function ControllableEVLoad(name, available, bus, model, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    ControllableEVLoad(name, available, bus, model, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services, dynamic_injector, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function ControllableEVLoad(; name, available, bus, model, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    ControllableEVLoad(name, available, bus, model, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services, dynamic_injector, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function ControllableEVLoad(::Nothing)
    ControllableEVLoad(;
        name="init",
        available=false,
        bus=Bus(nothing),
        model=nothing,
        active_power=0.0,
        reactive_power=0.0,
        base_power=0.0,
        max_active_power=0.0,
        max_reactive_power=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`ControllableEVLoad`](@ref) `name`."""
get_name(value::ControllableEVLoad) = value.name
"""Get [`ControllableEVLoad`](@ref) `available`."""
get_available(value::ControllableEVLoad) = value.available
"""Get [`ControllableEVLoad`](@ref) `bus`."""
get_bus(value::ControllableEVLoad) = value.bus
"""Get [`ControllableEVLoad`](@ref) `model`."""
get_model(value::ControllableEVLoad) = value.model
"""Get [`ControllableEVLoad`](@ref) `active_power`."""
get_active_power(value::ControllableEVLoad) = get_value(value, value.active_power)
"""Get [`ControllableEVLoad`](@ref) `reactive_power`."""
get_reactive_power(value::ControllableEVLoad) = get_value(value, value.reactive_power)
"""Get [`ControllableEVLoad`](@ref) `base_power`."""
get_base_power(value::ControllableEVLoad) = value.base_power
"""Get [`ControllableEVLoad`](@ref) `max_active_power`."""
get_max_active_power(value::ControllableEVLoad) = get_value(value, value.max_active_power)
"""Get [`ControllableEVLoad`](@ref) `max_reactive_power`."""
get_max_reactive_power(value::ControllableEVLoad) = get_value(value, value.max_reactive_power)
"""Get [`ControllableEVLoad`](@ref) `services`."""
get_services(value::ControllableEVLoad) = value.services
"""Get [`ControllableEVLoad`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::ControllableEVLoad) = value.dynamic_injector
"""Get [`ControllableEVLoad`](@ref) `ext`."""
get_ext(value::ControllableEVLoad) = value.ext
"""Get [`ControllableEVLoad`](@ref) `time_series_container`."""
get_time_series_container(value::ControllableEVLoad) = value.time_series_container
"""Get [`ControllableEVLoad`](@ref) `internal`."""
get_internal(value::ControllableEVLoad) = value.internal

"""Set [`ControllableEVLoad`](@ref) `available`."""
set_available!(value::ControllableEVLoad, val) = value.available = val
"""Set [`ControllableEVLoad`](@ref) `bus`."""
set_bus!(value::ControllableEVLoad, val) = value.bus = val
"""Set [`ControllableEVLoad`](@ref) `model`."""
set_model!(value::ControllableEVLoad, val) = value.model = val
"""Set [`ControllableEVLoad`](@ref) `active_power`."""
set_active_power!(value::ControllableEVLoad, val) = value.active_power = set_value(value, val)
"""Set [`ControllableEVLoad`](@ref) `reactive_power`."""
set_reactive_power!(value::ControllableEVLoad, val) = value.reactive_power = set_value(value, val)
"""Set [`ControllableEVLoad`](@ref) `base_power`."""
set_base_power!(value::ControllableEVLoad, val) = value.base_power = val
"""Set [`ControllableEVLoad`](@ref) `max_active_power`."""
set_max_active_power!(value::ControllableEVLoad, val) = value.max_active_power = set_value(value, val)
"""Set [`ControllableEVLoad`](@ref) `max_reactive_power`."""
set_max_reactive_power!(value::ControllableEVLoad, val) = value.max_reactive_power = set_value(value, val)
"""Set [`ControllableEVLoad`](@ref) `services`."""
set_services!(value::ControllableEVLoad, val) = value.services = val
"""Set [`ControllableEVLoad`](@ref) `ext`."""
set_ext!(value::ControllableEVLoad, val) = value.ext = val
"""Set [`ControllableEVLoad`](@ref) `time_series_container`."""
set_time_series_container!(value::ControllableEVLoad, val) = value.time_series_container = val
