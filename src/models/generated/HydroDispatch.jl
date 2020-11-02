#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HydroDispatch <: HydroGen
        name::String
        available::Bool
        bus::Bus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover::PrimeMovers.PrimeMover
        active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        reactive_power_limits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}
        ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        base_power::Float64
        operation_cost::OperationalCost
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
- `reactive_power::Float64`, validation range: `reactive_power_limits`, action if invalid: `warn`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: `(0, nothing)`, validation range: `(0, nothing)`, action if invalid: `error`
- `prime_mover::PrimeMovers.PrimeMover`: Prime mover technology according to EIA 923
- `active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`
- `reactive_power_limits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}`, action if invalid: `warn`
- `ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: ramp up and ramp down limits in MW (in component base per unit) per minute, validation range: `(0, nothing)`, validation range: `(0, nothing)`, action if invalid: `error`
- `time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: Minimum up and Minimum down time limits in hours, validation range: `(0, nothing)`, validation range: `(0, nothing)`, action if invalid: `error`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, validation range: `(0, nothing)`, action if invalid: `warn`
- `operation_cost::OperationalCost`: Operation Cost of Generation [`OperationalCost`](@ref)
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroDispatch <: HydroGen
    name::String
    available::Bool
    bus::Bus
    active_power::Float64
    reactive_power::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "Prime mover technology according to EIA 923"
    prime_mover::PrimeMovers.PrimeMover
    active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    reactive_power_limits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}
    "ramp up and ramp down limits in MW (in component base per unit) per minute"
    ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "Base power of the unit in MVA"
    base_power::Float64
    "Operation Cost of Generation [`OperationalCost`](@ref)"
    operation_cost::OperationalCost
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

function HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost=TwoPartCost(0.0, 0.0), services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HydroDispatch(; name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost=TwoPartCost(0.0, 0.0), services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), internal=InfrastructureSystemsInternal(), )
    HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost, services, dynamic_injector, ext, forecasts, internal, )
end

# Constructor for demo purposes; non-functional.
function HydroDispatch(::Nothing)
    HydroDispatch(;
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
        operation_cost=TwoPartCost(nothing),
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::HydroDispatch) = value.name
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
"""Get [`HydroDispatch`](@ref) `prime_mover`."""
get_prime_mover(value::HydroDispatch) = value.prime_mover
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

InfrastructureSystems.get_forecasts(value::HydroDispatch) = value.forecasts
"""Get [`HydroDispatch`](@ref) `internal`."""
get_internal(value::HydroDispatch) = value.internal


InfrastructureSystems.set_name!(value::HydroDispatch, val) = value.name = val
"""Set [`HydroDispatch`](@ref) `available`."""
set_available!(value::HydroDispatch, val) = value.available = val
"""Set [`HydroDispatch`](@ref) `bus`."""
set_bus!(value::HydroDispatch, val) = value.bus = val
"""Set [`HydroDispatch`](@ref) `active_power`."""
set_active_power!(value::HydroDispatch, val) = value.active_power = val
"""Set [`HydroDispatch`](@ref) `reactive_power`."""
set_reactive_power!(value::HydroDispatch, val) = value.reactive_power = val
"""Set [`HydroDispatch`](@ref) `rating`."""
set_rating!(value::HydroDispatch, val) = value.rating = val
"""Set [`HydroDispatch`](@ref) `prime_mover`."""
set_prime_mover!(value::HydroDispatch, val) = value.prime_mover = val
"""Set [`HydroDispatch`](@ref) `active_power_limits`."""
set_active_power_limits!(value::HydroDispatch, val) = value.active_power_limits = val
"""Set [`HydroDispatch`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::HydroDispatch, val) = value.reactive_power_limits = val
"""Set [`HydroDispatch`](@ref) `ramp_limits`."""
set_ramp_limits!(value::HydroDispatch, val) = value.ramp_limits = val
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

InfrastructureSystems.set_forecasts!(value::HydroDispatch, val) = value.forecasts = val
"""Set [`HydroDispatch`](@ref) `internal`."""
set_internal!(value::HydroDispatch, val) = value.internal = val

