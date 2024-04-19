#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct PowerLoad <: StaticLoad
        name::String
        available::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        base_power::Float64
        max_active_power::Float64
        max_reactive_power::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end

Data structure for a static power load.

# Arguments
- `name::String`
- `available::Bool`
- `bus::ACBus`
- `active_power::Float64`
- `reactive_power::Float64`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `max_active_power::Float64`
- `max_reactive_power::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PowerLoad <: StaticLoad
    name::String
    available::Bool
    bus::ACBus
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
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "container for supplemental attributes"
    supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PowerLoad(name, available, bus, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    PowerLoad(name, available, bus, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services, dynamic_injector, ext, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function PowerLoad(; name, available, bus, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    PowerLoad(name, available, bus, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services, dynamic_injector, ext, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function PowerLoad(::Nothing)
    PowerLoad(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        base_power=0.0,
        max_active_power=0.0,
        max_reactive_power=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`PowerLoad`](@ref) `name`."""
get_name(value::PowerLoad) = value.name
"""Get [`PowerLoad`](@ref) `available`."""
get_available(value::PowerLoad) = value.available
"""Get [`PowerLoad`](@ref) `bus`."""
get_bus(value::PowerLoad) = value.bus
"""Get [`PowerLoad`](@ref) `active_power`."""
get_active_power(value::PowerLoad) = get_value(value, value.active_power)
"""Get [`PowerLoad`](@ref) `reactive_power`."""
get_reactive_power(value::PowerLoad) = get_value(value, value.reactive_power)
"""Get [`PowerLoad`](@ref) `base_power`."""
get_base_power(value::PowerLoad) = value.base_power
"""Get [`PowerLoad`](@ref) `max_active_power`."""
get_max_active_power(value::PowerLoad) = get_value(value, value.max_active_power)
"""Get [`PowerLoad`](@ref) `max_reactive_power`."""
get_max_reactive_power(value::PowerLoad) = get_value(value, value.max_reactive_power)
"""Get [`PowerLoad`](@ref) `services`."""
get_services(value::PowerLoad) = value.services
"""Get [`PowerLoad`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::PowerLoad) = value.dynamic_injector
"""Get [`PowerLoad`](@ref) `ext`."""
get_ext(value::PowerLoad) = value.ext
"""Get [`PowerLoad`](@ref) `time_series_container`."""
get_time_series_container(value::PowerLoad) = value.time_series_container
"""Get [`PowerLoad`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::PowerLoad) = value.supplemental_attributes_container
"""Get [`PowerLoad`](@ref) `internal`."""
get_internal(value::PowerLoad) = value.internal

"""Set [`PowerLoad`](@ref) `available`."""
set_available!(value::PowerLoad, val) = value.available = val
"""Set [`PowerLoad`](@ref) `bus`."""
set_bus!(value::PowerLoad, val) = value.bus = val
"""Set [`PowerLoad`](@ref) `active_power`."""
set_active_power!(value::PowerLoad, val) = value.active_power = set_value(value, val)
"""Set [`PowerLoad`](@ref) `reactive_power`."""
set_reactive_power!(value::PowerLoad, val) = value.reactive_power = set_value(value, val)
"""Set [`PowerLoad`](@ref) `base_power`."""
set_base_power!(value::PowerLoad, val) = value.base_power = val
"""Set [`PowerLoad`](@ref) `max_active_power`."""
set_max_active_power!(value::PowerLoad, val) = value.max_active_power = set_value(value, val)
"""Set [`PowerLoad`](@ref) `max_reactive_power`."""
set_max_reactive_power!(value::PowerLoad, val) = value.max_reactive_power = set_value(value, val)
"""Set [`PowerLoad`](@ref) `services`."""
set_services!(value::PowerLoad, val) = value.services = val
"""Set [`PowerLoad`](@ref) `ext`."""
set_ext!(value::PowerLoad, val) = value.ext = val
"""Set [`PowerLoad`](@ref) `time_series_container`."""
set_time_series_container!(value::PowerLoad, val) = value.time_series_container = val
"""Set [`PowerLoad`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::PowerLoad, val) = value.supplemental_attributes_container = val
