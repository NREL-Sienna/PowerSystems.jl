#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct HydroDispatch <: HydroGen
        name::String
        available::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover_type::PrimeMovers
        active_power_limits::MinMax
        reactive_power_limits::Union{Nothing, MinMax}
        ramp_limits::Union{Nothing, UpDown}
        time_limits::Union{Nothing, UpDown}
        base_power::Float64
        operation_cost::OperationalCost
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::ACBus`
- `active_power::Float64`
- `reactive_power::Float64`, validation range: `reactive_power_limits`, action if invalid: `warn`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `prime_mover_type::PrimeMovers`: Prime mover technology according to EIA 923
- `active_power_limits::MinMax`, validation range: `(0, nothing)`, action if invalid: `warn`
- `reactive_power_limits::Union{Nothing, MinMax}`, action if invalid: `warn`
- `ramp_limits::Union{Nothing, UpDown}`: ramp up and ramp down limits in MW (in component base per unit) per minute, validation range: `(0, nothing)`, action if invalid: `error`
- `time_limits::Union{Nothing, UpDown}`: Minimum up and Minimum down time limits in hours, validation range: `(0, nothing)`, action if invalid: `error`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `operation_cost::OperationalCost`: Operation Cost of Generation [`OperationalCost`](@ref)
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroDispatch <: HydroGen
    name::String
    available::Bool
    bus::ACBus
    active_power::Float64
    reactive_power::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "Prime mover technology according to EIA 923"
    prime_mover_type::PrimeMovers
    active_power_limits::MinMax
    reactive_power_limits::Union{Nothing, MinMax}
    "ramp up and ramp down limits in MW (in component base per unit) per minute"
    ramp_limits::Union{Nothing, UpDown}
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, UpDown}
    "Base power of the unit in MVA"
    base_power::Float64
    "Operation Cost of Generation [`OperationalCost`](@ref)"
    operation_cost::OperationalCost
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

function HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost=TwoPartCost(LinearFunctionData(0.0), 0.0), services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost, services, dynamic_injector, ext, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function HydroDispatch(; name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost=TwoPartCost(LinearFunctionData(0.0), 0.0), services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost, services, dynamic_injector, ext, time_series_container, supplemental_attributes_container, internal, )
end

# Constructor for demo purposes; non-functional.
function HydroDispatch(::Nothing)
    HydroDispatch(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        prime_mover_type=PrimeMovers.HY,
        active_power_limits=(min=0.0, max=0.0),
        reactive_power_limits=nothing,
        ramp_limits=nothing,
        time_limits=nothing,
        base_power=0.0,
        operation_cost=TwoPartCost(nothing),
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
    )
end

"""Get [`HydroDispatch`](@ref) `name`."""
get_name(value::HydroDispatch) = value.name
"""Get [`HydroDispatch`](@ref) `available`."""
get_available(value::HydroDispatch) = value.available
"""Get [`HydroDispatch`](@ref) `bus`."""
get_bus(value::HydroDispatch) = value.bus
"""Get [`HydroDispatch`](@ref) `active_power`."""
get_active_power(value::HydroDispatch) = get_value(value, value.active_power)
"""Get [`HydroDispatch`](@ref) `reactive_power`."""
get_reactive_power(value::HydroDispatch) = get_value(value, value.reactive_power)
"""Get [`HydroDispatch`](@ref) `rating`."""
get_rating(value::HydroDispatch) = get_value(value, value.rating)
"""Get [`HydroDispatch`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::HydroDispatch) = value.prime_mover_type
"""Get [`HydroDispatch`](@ref) `active_power_limits`."""
get_active_power_limits(value::HydroDispatch) = get_value(value, value.active_power_limits)
"""Get [`HydroDispatch`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::HydroDispatch) = get_value(value, value.reactive_power_limits)
"""Get [`HydroDispatch`](@ref) `ramp_limits`."""
get_ramp_limits(value::HydroDispatch) = get_value(value, value.ramp_limits)
"""Get [`HydroDispatch`](@ref) `time_limits`."""
get_time_limits(value::HydroDispatch) = value.time_limits
"""Get [`HydroDispatch`](@ref) `base_power`."""
get_base_power(value::HydroDispatch) = value.base_power
"""Get [`HydroDispatch`](@ref) `operation_cost`."""
get_operation_cost(value::HydroDispatch) = value.operation_cost
"""Get [`HydroDispatch`](@ref) `services`."""
get_services(value::HydroDispatch) = value.services
"""Get [`HydroDispatch`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::HydroDispatch) = value.dynamic_injector
"""Get [`HydroDispatch`](@ref) `ext`."""
get_ext(value::HydroDispatch) = value.ext
"""Get [`HydroDispatch`](@ref) `time_series_container`."""
get_time_series_container(value::HydroDispatch) = value.time_series_container
"""Get [`HydroDispatch`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::HydroDispatch) = value.supplemental_attributes_container
"""Get [`HydroDispatch`](@ref) `internal`."""
get_internal(value::HydroDispatch) = value.internal

"""Set [`HydroDispatch`](@ref) `available`."""
set_available!(value::HydroDispatch, val) = value.available = val
"""Set [`HydroDispatch`](@ref) `bus`."""
set_bus!(value::HydroDispatch, val) = value.bus = val
"""Set [`HydroDispatch`](@ref) `active_power`."""
set_active_power!(value::HydroDispatch, val) = value.active_power = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `reactive_power`."""
set_reactive_power!(value::HydroDispatch, val) = value.reactive_power = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `rating`."""
set_rating!(value::HydroDispatch, val) = value.rating = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::HydroDispatch, val) = value.prime_mover_type = val
"""Set [`HydroDispatch`](@ref) `active_power_limits`."""
set_active_power_limits!(value::HydroDispatch, val) = value.active_power_limits = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::HydroDispatch, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `ramp_limits`."""
set_ramp_limits!(value::HydroDispatch, val) = value.ramp_limits = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `time_limits`."""
set_time_limits!(value::HydroDispatch, val) = value.time_limits = val
"""Set [`HydroDispatch`](@ref) `base_power`."""
set_base_power!(value::HydroDispatch, val) = value.base_power = val
"""Set [`HydroDispatch`](@ref) `operation_cost`."""
set_operation_cost!(value::HydroDispatch, val) = value.operation_cost = val
"""Set [`HydroDispatch`](@ref) `services`."""
set_services!(value::HydroDispatch, val) = value.services = val
"""Set [`HydroDispatch`](@ref) `ext`."""
set_ext!(value::HydroDispatch, val) = value.ext = val
"""Set [`HydroDispatch`](@ref) `time_series_container`."""
set_time_series_container!(value::HydroDispatch, val) = value.time_series_container = val
"""Set [`HydroDispatch`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::HydroDispatch, val) = value.supplemental_attributes_container = val
