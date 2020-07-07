#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ThermalStandard <: ThermalGen
        name::String
        available::Bool
        status::Bool
        bus::Bus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover::PrimeMovers.PrimeMover
        fuel::ThermalFuels.ThermalFuel
        activepower_max::Float64
        activepower_min::Float64
        reactivepower_max::Union{Nothing, Float64}
        reactivepower_min::Union{Nothing, Float64}
        ramp_limit_up::Union{Nothing, Float64}
        ramp_limit_dn::Union{Nothing, Float64}
        time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        operation_cost::ThreePartCost
        base_power::Float64
        services::Vector{Service}
        time_at_status::Float64
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for thermal generation technologies.

# Arguments
- `name::String`
- `available::Bool`
- `status::Bool`
- `bus::Bus`
- `active_power::Float64`, action if invalid: warn
- `reactive_power::Float64`, action if invalid: warn
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `prime_mover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `fuel::ThermalFuels.ThermalFuel`: PrimeMover Fuel according to EIA 923
- `activepower_max::Float64`, validation range: (0, nothing), action if invalid: error
- `activepower_min::Float64`, validation range: (0, nothing), action if invalid: error
- `reactivepower_max::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `reactivepower_min::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `ramp_limit_up::Union{Nothing, Float64}`: ramp up limit in %/min, validation range: (0, nothing), action if invalid: error
- `ramp_limit_dn::Union{Nothing, Float64}`: ramp dn limit in %/min, validation range: (0, nothing), action if invalid: error
- `time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: Minimum up and Minimum down time limits in hours, validation range: (0, nothing), action if invalid: error
- `operation_cost::ThreePartCost`
- `base_power::Float64`: Base power of the unit in MVA, validation range: (0, nothing), action if invalid: warn
- `services::Vector{Service}`: Services that this device contributes to
- `time_at_status::Float64`
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ThermalStandard <: ThermalGen
    name::String
    available::Bool
    status::Bool
    bus::Bus
    active_power::Float64
    reactive_power::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "PrimeMover Technology according to EIA 923"
    prime_mover::PrimeMovers.PrimeMover
    "PrimeMover Fuel according to EIA 923"
    fuel::ThermalFuels.ThermalFuel
    activepower_max::Float64
    activepower_min::Float64
    reactivepower_max::Union{Nothing, Float64}
    reactivepower_min::Union{Nothing, Float64}
    "ramp up limit in %/min"
    ramp_limit_up::Union{Nothing, Float64}
    "ramp dn limit in %/min"
    ramp_limit_dn::Union{Nothing, Float64}
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    operation_cost::ThreePartCost
    "Base power of the unit in MVA"
    base_power::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    time_at_status::Float64
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ThermalStandard(name, available, status, bus, active_power, reactive_power, rating, prime_mover, fuel, activepower_max, activepower_min, reactivepower_max, reactivepower_min, ramp_limit_up, ramp_limit_dn, time_limits, operation_cost, base_power, services=Device[], time_at_status=INFINITE_TIME, dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    ThermalStandard(name, available, status, bus, active_power, reactive_power, rating, prime_mover, fuel, activepower_max, activepower_min, reactivepower_max, reactivepower_min, ramp_limit_up, ramp_limit_dn, time_limits, operation_cost, base_power, services, time_at_status, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function ThermalStandard(; name, available, status, bus, active_power, reactive_power, rating, prime_mover, fuel, activepower_max, activepower_min, reactivepower_max, reactivepower_min, ramp_limit_up, ramp_limit_dn, time_limits, operation_cost, base_power, services=Device[], time_at_status=INFINITE_TIME, dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    ThermalStandard(name, available, status, bus, active_power, reactive_power, rating, prime_mover, fuel, activepower_max, activepower_min, reactivepower_max, reactivepower_min, ramp_limit_up, ramp_limit_dn, time_limits, operation_cost, base_power, services, time_at_status, dynamic_injector, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function ThermalStandard(::Nothing)
    ThermalStandard(;
        name="init",
        available=false,
        status=false,
        bus=Bus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        prime_mover=PrimeMovers.OT,
        fuel=ThermalFuels.OTHER,
        activepower_max=0.0,
        activepower_min=0.0,
        reactivepower_max=nothing,
        reactivepower_min=nothing,
        ramp_limit_up=nothing,
        ramp_limit_dn=nothing,
        time_limits=nothing,
        operation_cost=ThreePartCost(nothing),
        base_power=0.0,
        services=Device[],
        time_at_status=INFINITE_TIME,
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::ThermalStandard) = value.name
"""Get ThermalStandard available."""
get_available(value::ThermalStandard) = value.available
"""Get ThermalStandard status."""
get_status(value::ThermalStandard) = value.status
"""Get ThermalStandard bus."""
get_bus(value::ThermalStandard) = value.bus
"""Get ThermalStandard active_power."""
get_active_power(value::ThermalStandard) = get_value(value, :active_power)
"""Get ThermalStandard reactive_power."""
get_reactive_power(value::ThermalStandard) = get_value(value, :reactive_power)
"""Get ThermalStandard rating."""
get_rating(value::ThermalStandard) = get_value(value, :rating)
"""Get ThermalStandard prime_mover."""
get_prime_mover(value::ThermalStandard) = value.prime_mover
"""Get ThermalStandard fuel."""
get_fuel(value::ThermalStandard) = value.fuel
"""Get ThermalStandard activepower_max."""
get_activepower_max(value::ThermalStandard) = get_value(value, :activepower_max)
"""Get ThermalStandard activepower_min."""
get_activepower_min(value::ThermalStandard) = get_value(value, :activepower_min)
"""Get ThermalStandard reactivepower_max."""
get_reactivepower_max(value::ThermalStandard) = get_value(value, :reactivepower_max)
"""Get ThermalStandard reactivepower_min."""
get_reactivepower_min(value::ThermalStandard) = get_value(value, :reactivepower_min)
"""Get ThermalStandard ramp_limit_up."""
get_ramp_limit_up(value::ThermalStandard) = get_value(value, :ramp_limit_up)
"""Get ThermalStandard ramp_limit_dn."""
get_ramp_limit_dn(value::ThermalStandard) = get_value(value, :ramp_limit_dn)
"""Get ThermalStandard time_limits."""
get_time_limits(value::ThermalStandard) = get_value(value, :time_limits)
"""Get ThermalStandard operation_cost."""
get_operation_cost(value::ThermalStandard) = value.operation_cost
"""Get ThermalStandard base_power."""
get_base_power(value::ThermalStandard) = value.base_power
"""Get ThermalStandard services."""
get_services(value::ThermalStandard) = value.services
"""Get ThermalStandard time_at_status."""
get_time_at_status(value::ThermalStandard) = value.time_at_status
"""Get ThermalStandard dynamic_injector."""
get_dynamic_injector(value::ThermalStandard) = value.dynamic_injector
"""Get ThermalStandard ext."""
get_ext(value::ThermalStandard) = value.ext

InfrastructureSystems.get_forecasts(value::ThermalStandard) = value.forecasts
"""Get ThermalStandard internal."""
get_internal(value::ThermalStandard) = value.internal


InfrastructureSystems.set_name!(value::ThermalStandard, val::String) = value.name = val
"""Set ThermalStandard available."""
set_available!(value::ThermalStandard, val::Bool) = value.available = val
"""Set ThermalStandard status."""
set_status!(value::ThermalStandard, val::Bool) = value.status = val
"""Set ThermalStandard bus."""
set_bus!(value::ThermalStandard, val::Bus) = value.bus = val
"""Set ThermalStandard active_power."""
set_active_power!(value::ThermalStandard, val::Float64) = value.active_power = val
"""Set ThermalStandard reactive_power."""
set_reactive_power!(value::ThermalStandard, val::Float64) = value.reactive_power = val
"""Set ThermalStandard rating."""
set_rating!(value::ThermalStandard, val::Float64) = value.rating = val
"""Set ThermalStandard prime_mover."""
set_prime_mover!(value::ThermalStandard, val::PrimeMovers.PrimeMover) = value.prime_mover = val
"""Set ThermalStandard fuel."""
set_fuel!(value::ThermalStandard, val::ThermalFuels.ThermalFuel) = value.fuel = val
"""Set ThermalStandard activepower_max."""
set_activepower_max!(value::ThermalStandard, val::Float64) = value.activepower_max = val
"""Set ThermalStandard activepower_min."""
set_activepower_min!(value::ThermalStandard, val::Float64) = value.activepower_min = val
"""Set ThermalStandard reactivepower_max."""
set_reactivepower_max!(value::ThermalStandard, val::Union{Nothing, Float64}) = value.reactivepower_max = val
"""Set ThermalStandard reactivepower_min."""
set_reactivepower_min!(value::ThermalStandard, val::Union{Nothing, Float64}) = value.reactivepower_min = val
"""Set ThermalStandard ramp_limit_up."""
set_ramp_limit_up!(value::ThermalStandard, val::Union{Nothing, Float64}) = value.ramp_limit_up = val
"""Set ThermalStandard ramp_limit_dn."""
set_ramp_limit_dn!(value::ThermalStandard, val::Union{Nothing, Float64}) = value.ramp_limit_dn = val
"""Set ThermalStandard time_limits."""
set_time_limits!(value::ThermalStandard, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.time_limits = val
"""Set ThermalStandard operation_cost."""
set_operation_cost!(value::ThermalStandard, val::ThreePartCost) = value.operation_cost = val
"""Set ThermalStandard base_power."""
set_base_power!(value::ThermalStandard, val::Float64) = value.base_power = val
"""Set ThermalStandard services."""
set_services!(value::ThermalStandard, val::Vector{Service}) = value.services = val
"""Set ThermalStandard time_at_status."""
set_time_at_status!(value::ThermalStandard, val::Float64) = value.time_at_status = val
"""Set ThermalStandard ext."""
set_ext!(value::ThermalStandard, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::ThermalStandard, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set ThermalStandard internal."""
set_internal!(value::ThermalStandard, val::InfrastructureSystemsInternal) = value.internal = val
