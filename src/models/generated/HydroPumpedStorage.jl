#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct HydroPumpedStorage <: HydroGen
        name::String
        available::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        base_power::Float64
        prime_mover_type::PrimeMovers
        active_power_limits::MinMax
        reactive_power_limits::Union{Nothing, MinMax}
        ramp_limits::Union{Nothing, UpDown}
        time_limits::Union{Nothing, UpDown}
        rating_pump::Float64
        active_power_limits_pump::MinMax
        reactive_power_limits_pump::Union{Nothing, MinMax}
        ramp_limits_pump::Union{Nothing, UpDown}
        time_limits_pump::Union{Nothing, UpDown}
        storage_capacity::UpDown
        inflow::Float64
        outflow::Float64
        initial_storage::UpDown
        storage_target::UpDown
        operation_cost::Union{HydroGenerationCost, StorageCost, MarketBidCost}
        pump_efficiency::Float64
        conversion_factor::Float64
        time_at_status::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon.
- `bus::ACBus`: Bus that this component is connected to
- `active_power::Float64`
- `reactive_power::Float64`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `base_power::Float64`: Base power of the unit (MVA), validation range: `(0, nothing)`, action if invalid: `warn`
- `prime_mover_type::PrimeMovers`: Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list).
- `active_power_limits::MinMax`, validation range: `(0, nothing)`, action if invalid: `warn`
- `reactive_power_limits::Union{Nothing, MinMax}`, action if invalid: `warn`
- `ramp_limits::Union{Nothing, UpDown}`: ramp up and ramp down limits in MW (in component base per unit) per minute, validation range: `(0, nothing)`, action if invalid: `error`
- `time_limits::Union{Nothing, UpDown}`: Minimum up and Minimum down time limits in hours, validation range: `(0, nothing)`, action if invalid: `error`
- `rating_pump::Float64`: Thermal limited MVA Power Withdrawl of the pump. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `active_power_limits_pump::MinMax`
- `reactive_power_limits_pump::Union{Nothing, MinMax}`, action if invalid: `warn`
- `ramp_limits_pump::Union{Nothing, UpDown}`: ramp up and ramp down limits in MW (in component base per unit) per minute of pump, validation range: `(0, nothing)`, action if invalid: `error`
- `time_limits_pump::Union{Nothing, UpDown}`: Minimum up and Minimum down time limits of pump in hours, validation range: `(0, nothing)`, action if invalid: `error`
- `storage_capacity::UpDown`: Maximum storage capacity in the upper and lower reservoirs (units can be p.u-hr or m^3)., validation range: `(0, nothing)`, action if invalid: `error`
- `inflow::Float64`: Baseline inflow into the upper reservoir (units can be p.u. or m^3/hr), validation range: `(0, nothing)`, action if invalid: `error`
- `outflow::Float64`: Baseline outflow from the lower reservoir (units can be p.u. or m^3/hr), validation range: `(0, nothing)`, action if invalid: `error`
- `initial_storage::UpDown`: Initial storage capacity in the upper and lower reservoir (units can be p.u-hr or m^3)., validation range: `(0, nothing)`, action if invalid: `error`
- `storage_target::UpDown`: Storage target of upper reservoir at the end of simulation as ratio of storage capacity.
- `operation_cost::Union{HydroGenerationCost, StorageCost, MarketBidCost}`: Operation Cost of Generation [`OperationalCost`](@ref)
- `pump_efficiency::Float64`: Efficiency of pump, validation range: `(0, 1)`, action if invalid: `warn`
- `conversion_factor::Float64`: Conversion factor from flow/volume to energy: m^3 -> p.u-hr.
- `time_at_status::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroPumpedStorage <: HydroGen
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon."
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    active_power::Float64
    reactive_power::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "Base power of the unit (MVA)"
    base_power::Float64
    "Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list)."
    prime_mover_type::PrimeMovers
    active_power_limits::MinMax
    reactive_power_limits::Union{Nothing, MinMax}
    "ramp up and ramp down limits in MW (in component base per unit) per minute"
    ramp_limits::Union{Nothing, UpDown}
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, UpDown}
    "Thermal limited MVA Power Withdrawl of the pump. <= Capacity"
    rating_pump::Float64
    active_power_limits_pump::MinMax
    reactive_power_limits_pump::Union{Nothing, MinMax}
    "ramp up and ramp down limits in MW (in component base per unit) per minute of pump"
    ramp_limits_pump::Union{Nothing, UpDown}
    "Minimum up and Minimum down time limits of pump in hours"
    time_limits_pump::Union{Nothing, UpDown}
    "Maximum storage capacity in the upper and lower reservoirs (units can be p.u-hr or m^3)."
    storage_capacity::UpDown
    "Baseline inflow into the upper reservoir (units can be p.u. or m^3/hr)"
    inflow::Float64
    "Baseline outflow from the lower reservoir (units can be p.u. or m^3/hr)"
    outflow::Float64
    "Initial storage capacity in the upper and lower reservoir (units can be p.u-hr or m^3)."
    initial_storage::UpDown
    "Storage target of upper reservoir at the end of simulation as ratio of storage capacity."
    storage_target::UpDown
    "Operation Cost of Generation [`OperationalCost`](@ref)"
    operation_cost::Union{HydroGenerationCost, StorageCost, MarketBidCost}
    "Efficiency of pump"
    pump_efficiency::Float64
    "Conversion factor from flow/volume to energy: m^3 -> p.u-hr."
    conversion_factor::Float64
    time_at_status::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HydroPumpedStorage(name, available, bus, active_power, reactive_power, rating, base_power, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, rating_pump, active_power_limits_pump, reactive_power_limits_pump, ramp_limits_pump, time_limits_pump, storage_capacity, inflow, outflow, initial_storage, storage_target=(up=1.0, down=1.0), operation_cost=HydroGenerationCost(nothing), pump_efficiency=1.0, conversion_factor=1.0, time_at_status=INFINITE_TIME, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    HydroPumpedStorage(name, available, bus, active_power, reactive_power, rating, base_power, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, rating_pump, active_power_limits_pump, reactive_power_limits_pump, ramp_limits_pump, time_limits_pump, storage_capacity, inflow, outflow, initial_storage, storage_target, operation_cost, pump_efficiency, conversion_factor, time_at_status, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function HydroPumpedStorage(; name, available, bus, active_power, reactive_power, rating, base_power, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, rating_pump, active_power_limits_pump, reactive_power_limits_pump, ramp_limits_pump, time_limits_pump, storage_capacity, inflow, outflow, initial_storage, storage_target=(up=1.0, down=1.0), operation_cost=HydroGenerationCost(nothing), pump_efficiency=1.0, conversion_factor=1.0, time_at_status=INFINITE_TIME, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    HydroPumpedStorage(name, available, bus, active_power, reactive_power, rating, base_power, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, rating_pump, active_power_limits_pump, reactive_power_limits_pump, ramp_limits_pump, time_limits_pump, storage_capacity, inflow, outflow, initial_storage, storage_target, operation_cost, pump_efficiency, conversion_factor, time_at_status, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function HydroPumpedStorage(::Nothing)
    HydroPumpedStorage(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        base_power=0.0,
        prime_mover_type=PrimeMovers.HY,
        active_power_limits=(min=0.0, max=0.0),
        reactive_power_limits=nothing,
        ramp_limits=nothing,
        time_limits=nothing,
        rating_pump=0.0,
        active_power_limits_pump=(min=0.0, max=0.0),
        reactive_power_limits_pump=nothing,
        ramp_limits_pump=nothing,
        time_limits_pump=nothing,
        storage_capacity=(up=0.0, down=0.0),
        inflow=0.0,
        outflow=0.0,
        initial_storage=(up=0.0, down=0.0),
        storage_target=(up=0.0, down=0.0),
        operation_cost=HydroGenerationCost(nothing),
        pump_efficiency=0.0,
        conversion_factor=0.0,
        time_at_status=INFINITE_TIME,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`HydroPumpedStorage`](@ref) `name`."""
get_name(value::HydroPumpedStorage) = value.name
"""Get [`HydroPumpedStorage`](@ref) `available`."""
get_available(value::HydroPumpedStorage) = value.available
"""Get [`HydroPumpedStorage`](@ref) `bus`."""
get_bus(value::HydroPumpedStorage) = value.bus
"""Get [`HydroPumpedStorage`](@ref) `active_power`."""
get_active_power(value::HydroPumpedStorage) = get_value(value, value.active_power)
"""Get [`HydroPumpedStorage`](@ref) `reactive_power`."""
get_reactive_power(value::HydroPumpedStorage) = get_value(value, value.reactive_power)
"""Get [`HydroPumpedStorage`](@ref) `rating`."""
get_rating(value::HydroPumpedStorage) = get_value(value, value.rating)
"""Get [`HydroPumpedStorage`](@ref) `base_power`."""
get_base_power(value::HydroPumpedStorage) = value.base_power
"""Get [`HydroPumpedStorage`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::HydroPumpedStorage) = value.prime_mover_type
"""Get [`HydroPumpedStorage`](@ref) `active_power_limits`."""
get_active_power_limits(value::HydroPumpedStorage) = get_value(value, value.active_power_limits)
"""Get [`HydroPumpedStorage`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::HydroPumpedStorage) = get_value(value, value.reactive_power_limits)
"""Get [`HydroPumpedStorage`](@ref) `ramp_limits`."""
get_ramp_limits(value::HydroPumpedStorage) = get_value(value, value.ramp_limits)
"""Get [`HydroPumpedStorage`](@ref) `time_limits`."""
get_time_limits(value::HydroPumpedStorage) = value.time_limits
"""Get [`HydroPumpedStorage`](@ref) `rating_pump`."""
get_rating_pump(value::HydroPumpedStorage) = get_value(value, value.rating_pump)
"""Get [`HydroPumpedStorage`](@ref) `active_power_limits_pump`."""
get_active_power_limits_pump(value::HydroPumpedStorage) = get_value(value, value.active_power_limits_pump)
"""Get [`HydroPumpedStorage`](@ref) `reactive_power_limits_pump`."""
get_reactive_power_limits_pump(value::HydroPumpedStorage) = get_value(value, value.reactive_power_limits_pump)
"""Get [`HydroPumpedStorage`](@ref) `ramp_limits_pump`."""
get_ramp_limits_pump(value::HydroPumpedStorage) = get_value(value, value.ramp_limits_pump)
"""Get [`HydroPumpedStorage`](@ref) `time_limits_pump`."""
get_time_limits_pump(value::HydroPumpedStorage) = value.time_limits_pump
"""Get [`HydroPumpedStorage`](@ref) `storage_capacity`."""
get_storage_capacity(value::HydroPumpedStorage) = get_value(value, value.storage_capacity)
"""Get [`HydroPumpedStorage`](@ref) `inflow`."""
get_inflow(value::HydroPumpedStorage) = get_value(value, value.inflow)
"""Get [`HydroPumpedStorage`](@ref) `outflow`."""
get_outflow(value::HydroPumpedStorage) = value.outflow
"""Get [`HydroPumpedStorage`](@ref) `initial_storage`."""
get_initial_storage(value::HydroPumpedStorage) = get_value(value, value.initial_storage)
"""Get [`HydroPumpedStorage`](@ref) `storage_target`."""
get_storage_target(value::HydroPumpedStorage) = value.storage_target
"""Get [`HydroPumpedStorage`](@ref) `operation_cost`."""
get_operation_cost(value::HydroPumpedStorage) = value.operation_cost
"""Get [`HydroPumpedStorage`](@ref) `pump_efficiency`."""
get_pump_efficiency(value::HydroPumpedStorage) = value.pump_efficiency
"""Get [`HydroPumpedStorage`](@ref) `conversion_factor`."""
get_conversion_factor(value::HydroPumpedStorage) = value.conversion_factor
"""Get [`HydroPumpedStorage`](@ref) `time_at_status`."""
get_time_at_status(value::HydroPumpedStorage) = value.time_at_status
"""Get [`HydroPumpedStorage`](@ref) `services`."""
get_services(value::HydroPumpedStorage) = value.services
"""Get [`HydroPumpedStorage`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::HydroPumpedStorage) = value.dynamic_injector
"""Get [`HydroPumpedStorage`](@ref) `ext`."""
get_ext(value::HydroPumpedStorage) = value.ext
"""Get [`HydroPumpedStorage`](@ref) `internal`."""
get_internal(value::HydroPumpedStorage) = value.internal

"""Set [`HydroPumpedStorage`](@ref) `available`."""
set_available!(value::HydroPumpedStorage, val) = value.available = val
"""Set [`HydroPumpedStorage`](@ref) `bus`."""
set_bus!(value::HydroPumpedStorage, val) = value.bus = val
"""Set [`HydroPumpedStorage`](@ref) `active_power`."""
set_active_power!(value::HydroPumpedStorage, val) = value.active_power = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `reactive_power`."""
set_reactive_power!(value::HydroPumpedStorage, val) = value.reactive_power = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `rating`."""
set_rating!(value::HydroPumpedStorage, val) = value.rating = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `base_power`."""
set_base_power!(value::HydroPumpedStorage, val) = value.base_power = val
"""Set [`HydroPumpedStorage`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::HydroPumpedStorage, val) = value.prime_mover_type = val
"""Set [`HydroPumpedStorage`](@ref) `active_power_limits`."""
set_active_power_limits!(value::HydroPumpedStorage, val) = value.active_power_limits = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::HydroPumpedStorage, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `ramp_limits`."""
set_ramp_limits!(value::HydroPumpedStorage, val) = value.ramp_limits = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `time_limits`."""
set_time_limits!(value::HydroPumpedStorage, val) = value.time_limits = val
"""Set [`HydroPumpedStorage`](@ref) `rating_pump`."""
set_rating_pump!(value::HydroPumpedStorage, val) = value.rating_pump = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `active_power_limits_pump`."""
set_active_power_limits_pump!(value::HydroPumpedStorage, val) = value.active_power_limits_pump = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `reactive_power_limits_pump`."""
set_reactive_power_limits_pump!(value::HydroPumpedStorage, val) = value.reactive_power_limits_pump = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `ramp_limits_pump`."""
set_ramp_limits_pump!(value::HydroPumpedStorage, val) = value.ramp_limits_pump = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `time_limits_pump`."""
set_time_limits_pump!(value::HydroPumpedStorage, val) = value.time_limits_pump = val
"""Set [`HydroPumpedStorage`](@ref) `storage_capacity`."""
set_storage_capacity!(value::HydroPumpedStorage, val) = value.storage_capacity = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `inflow`."""
set_inflow!(value::HydroPumpedStorage, val) = value.inflow = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `outflow`."""
set_outflow!(value::HydroPumpedStorage, val) = value.outflow = val
"""Set [`HydroPumpedStorage`](@ref) `initial_storage`."""
set_initial_storage!(value::HydroPumpedStorage, val) = value.initial_storage = set_value(value, val)
"""Set [`HydroPumpedStorage`](@ref) `storage_target`."""
set_storage_target!(value::HydroPumpedStorage, val) = value.storage_target = val
"""Set [`HydroPumpedStorage`](@ref) `operation_cost`."""
set_operation_cost!(value::HydroPumpedStorage, val) = value.operation_cost = val
"""Set [`HydroPumpedStorage`](@ref) `pump_efficiency`."""
set_pump_efficiency!(value::HydroPumpedStorage, val) = value.pump_efficiency = val
"""Set [`HydroPumpedStorage`](@ref) `conversion_factor`."""
set_conversion_factor!(value::HydroPumpedStorage, val) = value.conversion_factor = val
"""Set [`HydroPumpedStorage`](@ref) `time_at_status`."""
set_time_at_status!(value::HydroPumpedStorage, val) = value.time_at_status = val
"""Set [`HydroPumpedStorage`](@ref) `services`."""
set_services!(value::HydroPumpedStorage, val) = value.services = val
"""Set [`HydroPumpedStorage`](@ref) `ext`."""
set_ext!(value::HydroPumpedStorage, val) = value.ext = val
