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
        active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        reactive_power_limits::Union{Nothing, Min_Max}
        ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
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
- `reactive_power::Float64`, validation range: reactive_power_limits, action if invalid: warn
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `prime_mover::PrimeMovers.PrimeMover`: prime_mover Technology according to EIA 923
- `active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`
- `reactive_power_limits::Union{Nothing, Min_Max}`, action if invalid: warn
- `ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: ramp up and ramp down limits, validation range: (0, nothing), action if invalid: error
- `time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: Minimum up and Minimum down time limits in hours, validation range: (0, nothing), action if invalid: error
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
    "prime_mover Technology according to EIA 923"
    prime_mover::PrimeMovers.PrimeMover
    active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    reactive_power_limits::Union{Nothing, Min_Max}
    "ramp up and ramp down limits"
    ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
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

function HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, operation_cost, base_power, storage_capacity, inflow, initial_storage, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, operation_cost, base_power, storage_capacity, inflow, initial_storage, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HydroEnergyReservoir(; name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, operation_cost, base_power, storage_capacity, inflow, initial_storage, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroEnergyReservoir(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, operation_cost, base_power, storage_capacity, inflow, initial_storage, services, dynamic_injector, ext, forecasts, )
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
get_active_power(value::HydroEnergyReservoir) = get_value(Float64, value, :active_power)
"""Get HydroEnergyReservoir reactive_power."""
get_reactive_power(value::HydroEnergyReservoir) = get_value(Float64, value, :reactive_power)
"""Get HydroEnergyReservoir rating."""
get_rating(value::HydroEnergyReservoir) = get_value(Float64, value, :rating)
"""Get HydroEnergyReservoir prime_mover."""
get_prime_mover(value::HydroEnergyReservoir) = value.prime_mover
"""Get HydroEnergyReservoir active_power_limits."""
get_active_power_limits(value::HydroEnergyReservoir) = get_value(NamedTuple{(:min, :max), Tuple{Float64, Float64}}, value, :active_power_limits)
"""Get HydroEnergyReservoir reactive_power_limits."""
get_reactive_power_limits(value::HydroEnergyReservoir) = get_value(Union{Nothing, Min_Max}, value, :reactive_power_limits)
"""Get HydroEnergyReservoir ramp_limits."""
get_ramp_limits(value::HydroEnergyReservoir) = get_value(Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}, value, :ramp_limits)
"""Get HydroEnergyReservoir time_limits."""
get_time_limits(value::HydroEnergyReservoir) = value.time_limits
"""Get HydroEnergyReservoir operation_cost."""
get_operation_cost(value::HydroEnergyReservoir) = value.operation_cost
"""Get HydroEnergyReservoir base_power."""
get_base_power(value::HydroEnergyReservoir) = value.base_power
"""Get HydroEnergyReservoir storage_capacity."""
get_storage_capacity(value::HydroEnergyReservoir) = get_value(Float64, value, :storage_capacity)
"""Get HydroEnergyReservoir inflow."""
get_inflow(value::HydroEnergyReservoir) = value.inflow
"""Get HydroEnergyReservoir initial_storage."""
get_initial_storage(value::HydroEnergyReservoir) = get_value(Float64, value, :initial_storage)
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
"""Set HydroEnergyReservoir active_power_limits."""
set_active_power_limits!(value::HydroEnergyReservoir, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.active_power_limits = val
"""Set HydroEnergyReservoir reactive_power_limits."""
set_reactive_power_limits!(value::HydroEnergyReservoir, val::Union{Nothing, Min_Max}) = value.reactive_power_limits = val
"""Set HydroEnergyReservoir ramp_limits."""
set_ramp_limits!(value::HydroEnergyReservoir, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.ramp_limits = val
"""Set HydroEnergyReservoir time_limits."""
set_time_limits!(value::HydroEnergyReservoir, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.time_limits = val
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
