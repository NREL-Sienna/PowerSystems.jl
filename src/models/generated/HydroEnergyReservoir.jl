#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct HydroEnergyReservoir <: HydroGen
        name::String
        available::Bool
        bus::Bus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover::PrimeMovers
        active_power_limits::Min_Max
        reactive_power_limits::Union{Nothing, Min_Max}
        ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        base_power::Float64
        storage_capacity::Float64
        inflow::Float64
        initial_storage::Float64
        operation_cost::OperationalCost
        storage_target::Float64
        conversion_factor::Float64
        time_at_status::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `active_power::Float64`
- `reactive_power::Float64`, validation range: `reactive_power_limits`, action if invalid: `warn`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `prime_mover::PrimeMovers`: Prime mover technology according to EIA 923
- `active_power_limits::Min_Max`
- `reactive_power_limits::Union{Nothing, Min_Max}`, action if invalid: `warn`
- `ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: ramp up and ramp down limits in MW (in component base per unit) per minute, validation range: `(0, nothing)`, action if invalid: `error`
- `time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: Minimum up and Minimum down time limits in hours, validation range: `(0, nothing)`, action if invalid: `error`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `storage_capacity::Float64`: Maximum storage capacity in the reservoir (units can be p.u-hr or m^3)., validation range: `(0, nothing)`, action if invalid: `error`
- `inflow::Float64`: Baseline inflow into the reservoir (units can be p.u. or m^3/hr), validation range: `(0, nothing)`, action if invalid: `error`
- `initial_storage::Float64`: Initial storage capacity in the reservoir (units can be p.u-hr or m^3)., validation range: `(0, nothing)`, action if invalid: `error`
- `operation_cost::OperationalCost`: Operation Cost of Generation [`OperationalCost`](@ref)
- `storage_target::Float64`: Storage target at the end of simulation as ratio of storage capacity.
- `conversion_factor::Float64`: Conversion factor from flow/volume to energy: m^3 -> p.u-hr.
- `time_at_status::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroEnergyReservoir <: HydroGen
    name::String
    available::Bool
    bus::Bus
    active_power::Float64
    reactive_power::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "Prime mover technology according to EIA 923"
    prime_mover::PrimeMovers
    active_power_limits::Min_Max
    reactive_power_limits::Union{Nothing, Min_Max}
    "ramp up and ramp down limits in MW (in component base per unit) per minute"
    ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "Base power of the unit in MVA"
    base_power::Float64
    "Maximum storage capacity in the reservoir (units can be p.u-hr or m^3)."
    storage_capacity::Float64
    "Baseline inflow into the reservoir (units can be p.u. or m^3/hr)"
    inflow::Float64
    "Initial storage capacity in the reservoir (units can be p.u-hr or m^3)."
    initial_storage::Float64
    "Operation Cost of Generation [`OperationalCost`](@ref)"
    operation_cost::OperationalCost
    "Storage target at the end of simulation as ratio of storage capacity."
    storage_target::Float64
    "Conversion factor from flow/volume to energy: m^3 -> p.u-hr."
    conversion_factor::Float64
    time_at_status::Float64
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

function HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, storage_capacity, inflow, initial_storage, operation_cost=TwoPartCost(0.0, 0.0), storage_target=1.0, conversion_factor=1.0, time_at_status=INFINITE_TIME, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, storage_capacity, inflow, initial_storage, operation_cost, storage_target, conversion_factor, time_at_status, services, dynamic_injector, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function HydroEnergyReservoir(; name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, storage_capacity, inflow, initial_storage, operation_cost=TwoPartCost(0.0, 0.0), storage_target=1.0, conversion_factor=1.0, time_at_status=INFINITE_TIME, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, storage_capacity, inflow, initial_storage, operation_cost, storage_target, conversion_factor, time_at_status, services, dynamic_injector, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function HydroEnergyReservoir(::Nothing)
    HydroEnergyReservoir(;
        name="init",
        available=false,
        bus=Bus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        prime_mover=PrimeMovers.HY,
        active_power_limits=(min=0.0, max=0.0),
        reactive_power_limits=nothing,
        ramp_limits=nothing,
        time_limits=nothing,
        base_power=0.0,
        storage_capacity=0.0,
        inflow=0.0,
        initial_storage=0.0,
        operation_cost=TwoPartCost(nothing),
        storage_target=0.0,
        conversion_factor=0.0,
        time_at_status=INFINITE_TIME,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`HydroEnergyReservoir`](@ref) `name`."""
get_name(value::HydroEnergyReservoir) = value.name
"""Get [`HydroEnergyReservoir`](@ref) `available`."""
get_available(value::HydroEnergyReservoir) = value.available
"""Get [`HydroEnergyReservoir`](@ref) `bus`."""
get_bus(value::HydroEnergyReservoir) = value.bus
"""Get [`HydroEnergyReservoir`](@ref) `active_power`."""
get_active_power(value::HydroEnergyReservoir) = get_value(value, value.active_power)
"""Get [`HydroEnergyReservoir`](@ref) `reactive_power`."""
get_reactive_power(value::HydroEnergyReservoir) = get_value(value, value.reactive_power)
"""Get [`HydroEnergyReservoir`](@ref) `rating`."""
get_rating(value::HydroEnergyReservoir) = get_value(value, value.rating)
"""Get [`HydroEnergyReservoir`](@ref) `prime_mover`."""
get_prime_mover(value::HydroEnergyReservoir) = value.prime_mover
"""Get [`HydroEnergyReservoir`](@ref) `active_power_limits`."""
get_active_power_limits(value::HydroEnergyReservoir) = get_value(value, value.active_power_limits)
"""Get [`HydroEnergyReservoir`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::HydroEnergyReservoir) = get_value(value, value.reactive_power_limits)
"""Get [`HydroEnergyReservoir`](@ref) `ramp_limits`."""
get_ramp_limits(value::HydroEnergyReservoir) = get_value(value, value.ramp_limits)
"""Get [`HydroEnergyReservoir`](@ref) `time_limits`."""
get_time_limits(value::HydroEnergyReservoir) = value.time_limits
"""Get [`HydroEnergyReservoir`](@ref) `base_power`."""
get_base_power(value::HydroEnergyReservoir) = value.base_power
"""Get [`HydroEnergyReservoir`](@ref) `storage_capacity`."""
get_storage_capacity(value::HydroEnergyReservoir) = get_value(value, value.storage_capacity)
"""Get [`HydroEnergyReservoir`](@ref) `inflow`."""
get_inflow(value::HydroEnergyReservoir) = get_value(value, value.inflow)
"""Get [`HydroEnergyReservoir`](@ref) `initial_storage`."""
get_initial_storage(value::HydroEnergyReservoir) = get_value(value, value.initial_storage)
"""Get [`HydroEnergyReservoir`](@ref) `operation_cost`."""
get_operation_cost(value::HydroEnergyReservoir) = value.operation_cost
"""Get [`HydroEnergyReservoir`](@ref) `storage_target`."""
get_storage_target(value::HydroEnergyReservoir) = value.storage_target
"""Get [`HydroEnergyReservoir`](@ref) `conversion_factor`."""
get_conversion_factor(value::HydroEnergyReservoir) = value.conversion_factor
"""Get [`HydroEnergyReservoir`](@ref) `time_at_status`."""
get_time_at_status(value::HydroEnergyReservoir) = value.time_at_status
"""Get [`HydroEnergyReservoir`](@ref) `services`."""
get_services(value::HydroEnergyReservoir) = value.services
"""Get [`HydroEnergyReservoir`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::HydroEnergyReservoir) = value.dynamic_injector
"""Get [`HydroEnergyReservoir`](@ref) `ext`."""
get_ext(value::HydroEnergyReservoir) = value.ext
"""Get [`HydroEnergyReservoir`](@ref) `time_series_container`."""
get_time_series_container(value::HydroEnergyReservoir) = value.time_series_container
"""Get [`HydroEnergyReservoir`](@ref) `internal`."""
get_internal(value::HydroEnergyReservoir) = value.internal

"""Set [`HydroEnergyReservoir`](@ref) `available`."""
set_available!(value::HydroEnergyReservoir, val) = value.available = val
"""Set [`HydroEnergyReservoir`](@ref) `bus`."""
set_bus!(value::HydroEnergyReservoir, val) = value.bus = val
"""Set [`HydroEnergyReservoir`](@ref) `active_power`."""
set_active_power!(value::HydroEnergyReservoir, val) = value.active_power = set_value(value, val)
"""Set [`HydroEnergyReservoir`](@ref) `reactive_power`."""
set_reactive_power!(value::HydroEnergyReservoir, val) = value.reactive_power = set_value(value, val)
"""Set [`HydroEnergyReservoir`](@ref) `rating`."""
set_rating!(value::HydroEnergyReservoir, val) = value.rating = set_value(value, val)
"""Set [`HydroEnergyReservoir`](@ref) `prime_mover`."""
set_prime_mover!(value::HydroEnergyReservoir, val) = value.prime_mover = val
"""Set [`HydroEnergyReservoir`](@ref) `active_power_limits`."""
set_active_power_limits!(value::HydroEnergyReservoir, val) = value.active_power_limits = set_value(value, val)
"""Set [`HydroEnergyReservoir`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::HydroEnergyReservoir, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`HydroEnergyReservoir`](@ref) `ramp_limits`."""
set_ramp_limits!(value::HydroEnergyReservoir, val) = value.ramp_limits = set_value(value, val)
"""Set [`HydroEnergyReservoir`](@ref) `time_limits`."""
set_time_limits!(value::HydroEnergyReservoir, val) = value.time_limits = val
"""Set [`HydroEnergyReservoir`](@ref) `base_power`."""
set_base_power!(value::HydroEnergyReservoir, val) = value.base_power = val
"""Set [`HydroEnergyReservoir`](@ref) `storage_capacity`."""
set_storage_capacity!(value::HydroEnergyReservoir, val) = value.storage_capacity = set_value(value, val)
"""Set [`HydroEnergyReservoir`](@ref) `inflow`."""
set_inflow!(value::HydroEnergyReservoir, val) = value.inflow = set_value(value, val)
"""Set [`HydroEnergyReservoir`](@ref) `initial_storage`."""
set_initial_storage!(value::HydroEnergyReservoir, val) = value.initial_storage = set_value(value, val)
"""Set [`HydroEnergyReservoir`](@ref) `operation_cost`."""
set_operation_cost!(value::HydroEnergyReservoir, val) = value.operation_cost = val
"""Set [`HydroEnergyReservoir`](@ref) `storage_target`."""
set_storage_target!(value::HydroEnergyReservoir, val) = value.storage_target = val
"""Set [`HydroEnergyReservoir`](@ref) `conversion_factor`."""
set_conversion_factor!(value::HydroEnergyReservoir, val) = value.conversion_factor = val
"""Set [`HydroEnergyReservoir`](@ref) `time_at_status`."""
set_time_at_status!(value::HydroEnergyReservoir, val) = value.time_at_status = val
"""Set [`HydroEnergyReservoir`](@ref) `services`."""
set_services!(value::HydroEnergyReservoir, val) = value.services = val
"""Set [`HydroEnergyReservoir`](@ref) `ext`."""
set_ext!(value::HydroEnergyReservoir, val) = value.ext = val
"""Set [`HydroEnergyReservoir`](@ref) `time_series_container`."""
set_time_series_container!(value::HydroEnergyReservoir, val) = value.time_series_container = val
