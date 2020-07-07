#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HydroEnergyReservoir <: HydroGen
        name::String
        available::Bool
        bus::Bus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover::PrimeMovers.PrimeMover
        activepower_max::Float64
        activepower_min::Float64
        reactivepower_max::Union{Nothing, Float64}
        reactivepower_min::Union{Nothing, Float64}
        ramp_limit_up::Union{Nothing, Float64}
        ramp_limit_dn::Union{Nothing, Float64}
        time_limits_up::Union{Nothing, Float64}
        time_limits_dn::Union{Nothing, Float64}
        operation_cost::TwoPartCost
        base_power::Float64
        storage_capacity::Float64
        inflow::Float64
        initial_storage::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `active_power::Float64`
- `reactive_power::Float64`, action if invalid: warn
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `prime_mover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `activepower_max::Float64`, validation range: (0, nothing), action if invalid: error
- `activepower_min::Float64`, validation range: (0, nothing), action if invalid: error
- `reactivepower_max::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `reactivepower_min::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `ramp_limit_up::Union{Nothing, Float64}`: ramp up limit in %/min, validation range: (0, nothing), action if invalid: error
- `ramp_limit_dn::Union{Nothing, Float64}`: ramp dn limit in %/min, validation range: (0, nothing), action if invalid: error
- `time_limits_up::Union{Nothing, Float64}`: Minimum up time limits in hours, validation range: (0, nothing), action if invalid: error
- `time_limits_dn::Union{Nothing, Float64}`: Minimum down time limits in hours, validation range: (0, nothing), action if invalid: error
- `operation_cost::TwoPartCost`: Operation Cost of Generation [`TwoPartCost`](@ref)
- `base_power::Float64`: Base power of the unit in MVA, validation range: (0, nothing), action if invalid: warn
- `storage_capacity::Float64`, validation range: (0, nothing), action if invalid: error
- `inflow::Float64`, validation range: (0, nothing), action if invalid: error
- `initial_storage::Float64`, validation range: (0, nothing), action if invalid: error
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
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
    "PrimeMover Technology according to EIA 923"
    prime_mover::PrimeMovers.PrimeMover
    activepower_max::Float64
    activepower_min::Float64
    reactivepower_max::Union{Nothing, Float64}
    reactivepower_min::Union{Nothing, Float64}
    "ramp up limit in %/min"
    ramp_limit_up::Union{Nothing, Float64}
    "ramp dn limit in %/min"
    ramp_limit_dn::Union{Nothing, Float64}
    "Minimum up time limits in hours"
    time_limits_up::Union{Nothing, Float64}
    "Minimum down time limits in hours"
    time_limits_dn::Union{Nothing, Float64}
    "Operation Cost of Generation [`TwoPartCost`](@ref)"
    operation_cost::TwoPartCost
    "Base power of the unit in MVA"
    base_power::Float64
    storage_capacity::Float64
    inflow::Float64
    initial_storage::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover, activepower_max, activepower_min, reactivepower_max, reactivepower_min, ramp_limit_up, ramp_limit_dn, time_limits_up, time_limits_dn, operation_cost, base_power, storage_capacity, inflow, initial_storage, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover, activepower_max, activepower_min, reactivepower_max, reactivepower_min, ramp_limit_up, ramp_limit_dn, time_limits_up, time_limits_dn, operation_cost, base_power, storage_capacity, inflow, initial_storage, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HydroEnergyReservoir(; name, available, bus, active_power, reactive_power, rating, prime_mover, activepower_max, activepower_min, reactivepower_max, reactivepower_min, ramp_limit_up, ramp_limit_dn, time_limits_up, time_limits_dn, operation_cost, base_power, storage_capacity, inflow, initial_storage, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover, activepower_max, activepower_min, reactivepower_max, reactivepower_min, ramp_limit_up, ramp_limit_dn, time_limits_up, time_limits_dn, operation_cost, base_power, storage_capacity, inflow, initial_storage, services, dynamic_injector, ext, forecasts, )
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
        activepower_max=0.0,
        activepower_min=0.0,
        reactivepower_max=nothing,
        reactivepower_min=nothing,
        ramp_limit_up=nothing,
        ramp_limit_dn=nothing,
        time_limits_up=nothing,
        time_limits_dn=nothing,
        operation_cost=TwoPartCost(nothing),
        base_power=0.0,
        storage_capacity=0.0,
        inflow=0.0,
        initial_storage=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::HydroEnergyReservoir) = value.name
"""Get HydroEnergyReservoir available."""
get_available(value::HydroEnergyReservoir) = value.available
"""Get HydroEnergyReservoir bus."""
get_bus(value::HydroEnergyReservoir) = value.bus
"""Get HydroEnergyReservoir active_power."""
get_active_power(value::HydroEnergyReservoir) = get_value(value, :active_power)
"""Get HydroEnergyReservoir reactive_power."""
get_reactive_power(value::HydroEnergyReservoir) = get_value(value, :reactive_power)
"""Get HydroEnergyReservoir rating."""
get_rating(value::HydroEnergyReservoir) = get_value(value, :rating)
"""Get HydroEnergyReservoir prime_mover."""
get_prime_mover(value::HydroEnergyReservoir) = value.prime_mover
"""Get HydroEnergyReservoir activepower_max."""
get_activepower_max(value::HydroEnergyReservoir) = get_value(value, :activepower_max)
"""Get HydroEnergyReservoir activepower_min."""
get_activepower_min(value::HydroEnergyReservoir) = get_value(value, :activepower_min)
"""Get HydroEnergyReservoir reactivepower_max."""
get_reactivepower_max(value::HydroEnergyReservoir) = get_value(value, :reactivepower_max)
"""Get HydroEnergyReservoir reactivepower_min."""
get_reactivepower_min(value::HydroEnergyReservoir) = get_value(value, :reactivepower_min)
"""Get HydroEnergyReservoir ramp_limit_up."""
get_ramp_limit_up(value::HydroEnergyReservoir) = get_value(value, :ramp_limit_up)
"""Get HydroEnergyReservoir ramp_limit_dn."""
get_ramp_limit_dn(value::HydroEnergyReservoir) = get_value(value, :ramp_limit_dn)
"""Get HydroEnergyReservoir time_limits_up."""
get_time_limits_up(value::HydroEnergyReservoir) = get_value(value, :time_limits_up)
"""Get HydroEnergyReservoir time_limits_dn."""
get_time_limits_dn(value::HydroEnergyReservoir) = get_value(value, :time_limits_dn)
"""Get HydroEnergyReservoir operation_cost."""
get_operation_cost(value::HydroEnergyReservoir) = value.operation_cost
"""Get HydroEnergyReservoir base_power."""
get_base_power(value::HydroEnergyReservoir) = value.base_power
"""Get HydroEnergyReservoir storage_capacity."""
get_storage_capacity(value::HydroEnergyReservoir) = value.storage_capacity
"""Get HydroEnergyReservoir inflow."""
get_inflow(value::HydroEnergyReservoir) = value.inflow
"""Get HydroEnergyReservoir initial_storage."""
get_initial_storage(value::HydroEnergyReservoir) = value.initial_storage
"""Get HydroEnergyReservoir services."""
get_services(value::HydroEnergyReservoir) = value.services
"""Get HydroEnergyReservoir dynamic_injector."""
get_dynamic_injector(value::HydroEnergyReservoir) = value.dynamic_injector
"""Get HydroEnergyReservoir ext."""
get_ext(value::HydroEnergyReservoir) = value.ext

InfrastructureSystems.get_forecasts(value::HydroEnergyReservoir) = value.forecasts
"""Get HydroEnergyReservoir internal."""
get_internal(value::HydroEnergyReservoir) = value.internal


InfrastructureSystems.set_name!(value::HydroEnergyReservoir, val::String) = value.name = val
"""Set HydroEnergyReservoir available."""
set_available!(value::HydroEnergyReservoir, val::Bool) = value.available = val
"""Set HydroEnergyReservoir bus."""
set_bus!(value::HydroEnergyReservoir, val::Bus) = value.bus = val
"""Set HydroEnergyReservoir active_power."""
set_active_power!(value::HydroEnergyReservoir, val::Float64) = value.active_power = val
"""Set HydroEnergyReservoir reactive_power."""
set_reactive_power!(value::HydroEnergyReservoir, val::Float64) = value.reactive_power = val
"""Set HydroEnergyReservoir rating."""
set_rating!(value::HydroEnergyReservoir, val::Float64) = value.rating = val
"""Set HydroEnergyReservoir prime_mover."""
set_prime_mover!(value::HydroEnergyReservoir, val::PrimeMovers.PrimeMover) = value.prime_mover = val
"""Set HydroEnergyReservoir activepower_max."""
set_activepower_max!(value::HydroEnergyReservoir, val::Float64) = value.activepower_max = val
"""Set HydroEnergyReservoir activepower_min."""
set_activepower_min!(value::HydroEnergyReservoir, val::Float64) = value.activepower_min = val
"""Set HydroEnergyReservoir reactivepower_max."""
set_reactivepower_max!(value::HydroEnergyReservoir, val::Union{Nothing, Float64}) = value.reactivepower_max = val
"""Set HydroEnergyReservoir reactivepower_min."""
set_reactivepower_min!(value::HydroEnergyReservoir, val::Union{Nothing, Float64}) = value.reactivepower_min = val
"""Set HydroEnergyReservoir ramp_limit_up."""
set_ramp_limit_up!(value::HydroEnergyReservoir, val::Union{Nothing, Float64}) = value.ramp_limit_up = val
"""Set HydroEnergyReservoir ramp_limit_dn."""
set_ramp_limit_dn!(value::HydroEnergyReservoir, val::Union{Nothing, Float64}) = value.ramp_limit_dn = val
"""Set HydroEnergyReservoir time_limits_up."""
set_time_limits_up!(value::HydroEnergyReservoir, val::Union{Nothing, Float64}) = value.time_limits_up = val
"""Set HydroEnergyReservoir time_limits_dn."""
set_time_limits_dn!(value::HydroEnergyReservoir, val::Union{Nothing, Float64}) = value.time_limits_dn = val
"""Set HydroEnergyReservoir operation_cost."""
set_operation_cost!(value::HydroEnergyReservoir, val::TwoPartCost) = value.operation_cost = val
"""Set HydroEnergyReservoir base_power."""
set_base_power!(value::HydroEnergyReservoir, val::Float64) = value.base_power = val
"""Set HydroEnergyReservoir storage_capacity."""
set_storage_capacity!(value::HydroEnergyReservoir, val::Float64) = value.storage_capacity = val
"""Set HydroEnergyReservoir inflow."""
set_inflow!(value::HydroEnergyReservoir, val::Float64) = value.inflow = val
"""Set HydroEnergyReservoir initial_storage."""
set_initial_storage!(value::HydroEnergyReservoir, val::Float64) = value.initial_storage = val
"""Set HydroEnergyReservoir services."""
set_services!(value::HydroEnergyReservoir, val::Vector{Service}) = value.services = val
"""Set HydroEnergyReservoir ext."""
set_ext!(value::HydroEnergyReservoir, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::HydroEnergyReservoir, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set HydroEnergyReservoir internal."""
set_internal!(value::HydroEnergyReservoir, val::InfrastructureSystemsInternal) = value.internal = val
