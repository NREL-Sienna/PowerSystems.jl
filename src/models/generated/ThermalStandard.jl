#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ThermalStandard <: ThermalGen
        name::String
        available::Bool
        status::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        active_power_limits::MinMax
        reactive_power_limits::Union{Nothing, MinMax}
        ramp_limits::Union{Nothing, UpDown}
        operation_cost::OperationalCost
        base_power::Float64
        time_limits::Union{Nothing, UpDown}
        must_run::Bool
        prime_mover_type::PrimeMovers
        fuel::ThermalFuels
        services::Vector{Service}
        time_at_status::Float64
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

Data Structure for thermal generation technologies.

# Arguments
- `name::String`
- `available::Bool`
- `status::Bool`
- `bus::ACBus`
- `active_power::Float64`, validation range: `active_power_limits`, action if invalid: `warn`
- `reactive_power::Float64`, validation range: `reactive_power_limits`, action if invalid: `warn`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `active_power_limits::MinMax`, validation range: `(0, nothing)`, action if invalid: `warn`
- `reactive_power_limits::Union{Nothing, MinMax}`
- `ramp_limits::Union{Nothing, UpDown}`: ramp up and ramp down limits in MW (in component base per unit) per minute, validation range: `(0, nothing)`, action if invalid: `error`
- `operation_cost::OperationalCost`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `time_limits::Union{Nothing, UpDown}`: Minimum up and Minimum down time limits in hours, validation range: `(0, nothing)`, action if invalid: `error`
- `must_run::Bool`
- `prime_mover_type::PrimeMovers`: Prime mover technology according to EIA 923
- `fuel::ThermalFuels`: Prime mover fuel according to EIA 923
- `services::Vector{Service}`: Services that this device contributes to
- `time_at_status::Float64`
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ThermalStandard <: ThermalGen
    name::String
    available::Bool
    status::Bool
    bus::ACBus
    active_power::Float64
    reactive_power::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    active_power_limits::MinMax
    reactive_power_limits::Union{Nothing, MinMax}
    "ramp up and ramp down limits in MW (in component base per unit) per minute"
    ramp_limits::Union{Nothing, UpDown}
    operation_cost::OperationalCost
    "Base power of the unit in MVA"
    base_power::Float64
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, UpDown}
    must_run::Bool
    "Prime mover technology according to EIA 923"
    prime_mover_type::PrimeMovers
    "Prime mover fuel according to EIA 923"
    fuel::ThermalFuels
    "Services that this device contributes to"
    services::Vector{Service}
    time_at_status::Float64
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ThermalStandard(name, available, status, bus, active_power, reactive_power, rating, active_power_limits, reactive_power_limits, ramp_limits, operation_cost, base_power, time_limits=nothing, must_run=false, prime_mover_type=PrimeMovers.OT, fuel=ThermalFuels.OTHER, services=Device[], time_at_status=INFINITE_TIME, dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    ThermalStandard(name, available, status, bus, active_power, reactive_power, rating, active_power_limits, reactive_power_limits, ramp_limits, operation_cost, base_power, time_limits, must_run, prime_mover_type, fuel, services, time_at_status, dynamic_injector, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function ThermalStandard(; name, available, status, bus, active_power, reactive_power, rating, active_power_limits, reactive_power_limits, ramp_limits, operation_cost, base_power, time_limits=nothing, must_run=false, prime_mover_type=PrimeMovers.OT, fuel=ThermalFuels.OTHER, services=Device[], time_at_status=INFINITE_TIME, dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    ThermalStandard(name, available, status, bus, active_power, reactive_power, rating, active_power_limits, reactive_power_limits, ramp_limits, operation_cost, base_power, time_limits, must_run, prime_mover_type, fuel, services, time_at_status, dynamic_injector, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function ThermalStandard(::Nothing)
    ThermalStandard(;
        name="init",
        available=false,
        status=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        active_power_limits=(min=0.0, max=0.0),
        reactive_power_limits=nothing,
        ramp_limits=nothing,
        operation_cost=ThreePartCost(nothing),
        base_power=0.0,
        time_limits=nothing,
        must_run=false,
        prime_mover_type=PrimeMovers.OT,
        fuel=ThermalFuels.OTHER,
        services=Device[],
        time_at_status=INFINITE_TIME,
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`ThermalStandard`](@ref) `name`."""
get_name(value::ThermalStandard) = value.name
"""Get [`ThermalStandard`](@ref) `available`."""
get_available(value::ThermalStandard) = value.available
"""Get [`ThermalStandard`](@ref) `status`."""
get_status(value::ThermalStandard) = value.status
"""Get [`ThermalStandard`](@ref) `bus`."""
get_bus(value::ThermalStandard) = value.bus
"""Get [`ThermalStandard`](@ref) `active_power`."""
get_active_power(value::ThermalStandard) = get_value(value, value.active_power)
"""Get [`ThermalStandard`](@ref) `reactive_power`."""
get_reactive_power(value::ThermalStandard) = get_value(value, value.reactive_power)
"""Get [`ThermalStandard`](@ref) `rating`."""
get_rating(value::ThermalStandard) = get_value(value, value.rating)
"""Get [`ThermalStandard`](@ref) `active_power_limits`."""
get_active_power_limits(value::ThermalStandard) = get_value(value, value.active_power_limits)
"""Get [`ThermalStandard`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::ThermalStandard) = get_value(value, value.reactive_power_limits)
"""Get [`ThermalStandard`](@ref) `ramp_limits`."""
get_ramp_limits(value::ThermalStandard) = get_value(value, value.ramp_limits)
"""Get [`ThermalStandard`](@ref) `operation_cost`."""
get_operation_cost(value::ThermalStandard) = value.operation_cost
"""Get [`ThermalStandard`](@ref) `base_power`."""
get_base_power(value::ThermalStandard) = value.base_power
"""Get [`ThermalStandard`](@ref) `time_limits`."""
get_time_limits(value::ThermalStandard) = value.time_limits
"""Get [`ThermalStandard`](@ref) `must_run`."""
get_must_run(value::ThermalStandard) = value.must_run
"""Get [`ThermalStandard`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::ThermalStandard) = value.prime_mover_type
"""Get [`ThermalStandard`](@ref) `fuel`."""
get_fuel(value::ThermalStandard) = value.fuel
"""Get [`ThermalStandard`](@ref) `services`."""
get_services(value::ThermalStandard) = value.services
"""Get [`ThermalStandard`](@ref) `time_at_status`."""
get_time_at_status(value::ThermalStandard) = value.time_at_status
"""Get [`ThermalStandard`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::ThermalStandard) = value.dynamic_injector
"""Get [`ThermalStandard`](@ref) `ext`."""
get_ext(value::ThermalStandard) = value.ext
"""Get [`ThermalStandard`](@ref) `time_series_container`."""
get_time_series_container(value::ThermalStandard) = value.time_series_container
"""Get [`ThermalStandard`](@ref) `internal`."""
get_internal(value::ThermalStandard) = value.internal

"""Set [`ThermalStandard`](@ref) `available`."""
set_available!(value::ThermalStandard, val) = value.available = val
"""Set [`ThermalStandard`](@ref) `status`."""
set_status!(value::ThermalStandard, val) = value.status = val
"""Set [`ThermalStandard`](@ref) `bus`."""
set_bus!(value::ThermalStandard, val) = value.bus = val
"""Set [`ThermalStandard`](@ref) `active_power`."""
set_active_power!(value::ThermalStandard, val) = value.active_power = set_value(value, val)
"""Set [`ThermalStandard`](@ref) `reactive_power`."""
set_reactive_power!(value::ThermalStandard, val) = value.reactive_power = set_value(value, val)
"""Set [`ThermalStandard`](@ref) `rating`."""
set_rating!(value::ThermalStandard, val) = value.rating = set_value(value, val)
"""Set [`ThermalStandard`](@ref) `active_power_limits`."""
set_active_power_limits!(value::ThermalStandard, val) = value.active_power_limits = set_value(value, val)
"""Set [`ThermalStandard`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::ThermalStandard, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`ThermalStandard`](@ref) `ramp_limits`."""
set_ramp_limits!(value::ThermalStandard, val) = value.ramp_limits = set_value(value, val)
"""Set [`ThermalStandard`](@ref) `operation_cost`."""
set_operation_cost!(value::ThermalStandard, val) = value.operation_cost = val
"""Set [`ThermalStandard`](@ref) `base_power`."""
set_base_power!(value::ThermalStandard, val) = value.base_power = val
"""Set [`ThermalStandard`](@ref) `time_limits`."""
set_time_limits!(value::ThermalStandard, val) = value.time_limits = val
"""Set [`ThermalStandard`](@ref) `must_run`."""
set_must_run!(value::ThermalStandard, val) = value.must_run = val
"""Set [`ThermalStandard`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::ThermalStandard, val) = value.prime_mover_type = val
"""Set [`ThermalStandard`](@ref) `fuel`."""
set_fuel!(value::ThermalStandard, val) = value.fuel = val
"""Set [`ThermalStandard`](@ref) `services`."""
set_services!(value::ThermalStandard, val) = value.services = val
"""Set [`ThermalStandard`](@ref) `time_at_status`."""
set_time_at_status!(value::ThermalStandard, val) = value.time_at_status = val
"""Set [`ThermalStandard`](@ref) `ext`."""
set_ext!(value::ThermalStandard, val) = value.ext = val
"""Set [`ThermalStandard`](@ref) `time_series_container`."""
set_time_series_container!(value::ThermalStandard, val) = value.time_series_container = val
