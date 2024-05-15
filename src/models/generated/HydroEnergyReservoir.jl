#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct HydroEnergyReservoir <: HydroGen
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
        storage_capacity::Float64
        inflow::Float64
        initial_storage::Float64
        operation_cost::Union{HydroGenerationCost, StorageCost, MarketBidCost}
        storage_target::Float64
        conversion_factor::Float64
        time_at_status::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `bus::ACBus`: Bus that this component is connected to
- `active_power::Float64`: Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used.
- `reactive_power::Float64`: Initial reactive power set point of the unit (MVAR), validation range: `reactive_power_limits`, action if invalid: `warn`
- `rating::Float64`: Maximum output power rating of the unit (MVA), validation range: `(0, nothing)`, action if invalid: `error`
- `prime_mover_type::PrimeMovers`: Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list).
- `active_power_limits::MinMax`: Minimum and maximum stable active power levels (MW)
- `reactive_power_limits::Union{Nothing, MinMax}`: Minimum and maximum reactive power limits. Set to `Nothing` if not applicable., action if invalid: `warn`
- `ramp_limits::Union{Nothing, UpDown}`: ramp up and ramp down limits in MW/min, validation range: `(0, nothing)`, action if invalid: `error`
- `time_limits::Union{Nothing, UpDown}`: Minimum up and Minimum down time limits in hours, validation range: `(0, nothing)`, action if invalid: `error`
- `base_power::Float64`: Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`., validation range: `(0, nothing)`, action if invalid: `warn`
- `storage_capacity::Float64`: Maximum storage capacity in the reservoir (units can be p.u-hr or m^3)., validation range: `(0, nothing)`, action if invalid: `error`
- `inflow::Float64`: Baseline inflow into the reservoir (units can be p.u. or m^3/hr), validation range: `(0, nothing)`, action if invalid: `error`
- `initial_storage::Float64`: Initial storage capacity in the reservoir (units can be p.u-hr or m^3)., validation range: `(0, nothing)`, action if invalid: `error`
- `operation_cost::Union{HydroGenerationCost, StorageCost, MarketBidCost}`: Operation Cost of Generation [`OperationalCost`](@ref)
- `storage_target::Float64`: Storage target at the end of simulation as ratio of storage capacity.
- `conversion_factor::Float64`: Conversion factor from flow/volume to energy: m^3 -> p.u-hr.
- `time_at_status::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct HydroEnergyReservoir <: HydroGen
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    "Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used."
    active_power::Float64
    "Initial reactive power set point of the unit (MVAR)"
    reactive_power::Float64
    "Maximum output power rating of the unit (MVA)"
    rating::Float64
    "Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list)."
    prime_mover_type::PrimeMovers
    "Minimum and maximum stable active power levels (MW)"
    active_power_limits::MinMax
    "Minimum and maximum reactive power limits. Set to `Nothing` if not applicable."
    reactive_power_limits::Union{Nothing, MinMax}
    "ramp up and ramp down limits in MW/min"
    ramp_limits::Union{Nothing, UpDown}
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, UpDown}
    "Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`."
    base_power::Float64
    "Maximum storage capacity in the reservoir (units can be p.u-hr or m^3)."
    storage_capacity::Float64
    "Baseline inflow into the reservoir (units can be p.u. or m^3/hr)"
    inflow::Float64
    "Initial storage capacity in the reservoir (units can be p.u-hr or m^3)."
    initial_storage::Float64
    "Operation Cost of Generation [`OperationalCost`](@ref)"
    operation_cost::Union{HydroGenerationCost, StorageCost, MarketBidCost}
    "Storage target at the end of simulation as ratio of storage capacity."
    storage_target::Float64
    "Conversion factor from flow/volume to energy: m^3 -> p.u-hr."
    conversion_factor::Float64
    time_at_status::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, storage_capacity, inflow, initial_storage, operation_cost=HydroGenerationCost(nothing), storage_target=1.0, conversion_factor=1.0, time_at_status=INFINITE_TIME, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, storage_capacity, inflow, initial_storage, operation_cost, storage_target, conversion_factor, time_at_status, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function HydroEnergyReservoir(; name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, storage_capacity, inflow, initial_storage, operation_cost=HydroGenerationCost(nothing), storage_target=1.0, conversion_factor=1.0, time_at_status=INFINITE_TIME, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, storage_capacity, inflow, initial_storage, operation_cost, storage_target, conversion_factor, time_at_status, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function HydroEnergyReservoir(::Nothing)
    HydroEnergyReservoir(;
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
        storage_capacity=0.0,
        inflow=0.0,
        initial_storage=0.0,
        operation_cost=HydroGenerationCost(nothing),
        storage_target=0.0,
        conversion_factor=0.0,
        time_at_status=INFINITE_TIME,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
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
"""Get [`HydroEnergyReservoir`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::HydroEnergyReservoir) = value.prime_mover_type
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
"""Set [`HydroEnergyReservoir`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::HydroEnergyReservoir, val) = value.prime_mover_type = val
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
