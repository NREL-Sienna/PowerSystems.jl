#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RenewableDispatch <: RenewableGen
        name::String
        available::Bool
        bus::Bus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover::PrimeMovers.PrimeMover
        reactive_power_limits::Union{Nothing, Min_Max}
        power_factor::Float64
        operation_cost::TwoPartCost
        base_power::Float64
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
- `reactive_power::Float64`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `prime_mover::PrimeMovers.PrimeMover`: Prime mover technology according to EIA 923
- `reactive_power_limits::Union{Nothing, Min_Max}`
- `power_factor::Float64`, validation range: `(0, 1)`, action if invalid: `error`
- `operation_cost::TwoPartCost`: Operation Cost of Generation [`TwoPartCost`](@ref)
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RenewableDispatch <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    active_power::Float64
    reactive_power::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "Prime mover technology according to EIA 923"
    prime_mover::PrimeMovers.PrimeMover
    reactive_power_limits::Union{Nothing, Min_Max}
    power_factor::Float64
    "Operation Cost of Generation [`TwoPartCost`](@ref)"
    operation_cost::TwoPartCost
    "Base power of the unit in MVA"
    base_power::Float64
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

function RenewableDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, reactive_power_limits, power_factor, operation_cost, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, reactive_power_limits, power_factor, operation_cost, base_power, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function RenewableDispatch(; name, available, bus, active_power, reactive_power, rating, prime_mover, reactive_power_limits, power_factor, operation_cost, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), internal=InfrastructureSystemsInternal(), )
    RenewableDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, reactive_power_limits, power_factor, operation_cost, base_power, services, dynamic_injector, ext, forecasts, internal, )
end

# Constructor for demo purposes; non-functional.
function RenewableDispatch(::Nothing)
    RenewableDispatch(;
        name="init",
        available=false,
        bus=Bus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        prime_mover=PrimeMovers.OT,
        reactive_power_limits=nothing,
        power_factor=1.0,
        operation_cost=TwoPartCost(nothing),
        base_power=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::RenewableDispatch) = value.name
"""Get [`RenewableDispatch`](@ref) `available`."""
get_available(value::RenewableDispatch) = value.available
"""Get [`RenewableDispatch`](@ref) `bus`."""
get_bus(value::RenewableDispatch) = value.bus
"""Get [`RenewableDispatch`](@ref) `active_power`."""
get_active_power(value::RenewableDispatch) = get_value(value, value.active_power)
"""Get [`RenewableDispatch`](@ref) `reactive_power`."""
get_reactive_power(value::RenewableDispatch) = get_value(value, value.reactive_power)
"""Get [`RenewableDispatch`](@ref) `rating`."""
get_rating(value::RenewableDispatch) = get_value(value, value.rating)
"""Get [`RenewableDispatch`](@ref) `prime_mover`."""
get_prime_mover(value::RenewableDispatch) = value.prime_mover
"""Get [`RenewableDispatch`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::RenewableDispatch) = get_value(value, value.reactive_power_limits)
"""Get [`RenewableDispatch`](@ref) `power_factor`."""
get_power_factor(value::RenewableDispatch) = value.power_factor
"""Get [`RenewableDispatch`](@ref) `operation_cost`."""
get_operation_cost(value::RenewableDispatch) = value.operation_cost
"""Get [`RenewableDispatch`](@ref) `base_power`."""
get_base_power(value::RenewableDispatch) = value.base_power
"""Get [`RenewableDispatch`](@ref) `services`."""
get_services(value::RenewableDispatch) = value.services
"""Get [`RenewableDispatch`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::RenewableDispatch) = value.dynamic_injector
"""Get [`RenewableDispatch`](@ref) `ext`."""
get_ext(value::RenewableDispatch) = value.ext

InfrastructureSystems.get_forecasts(value::RenewableDispatch) = value.forecasts
"""Get [`RenewableDispatch`](@ref) `internal`."""
get_internal(value::RenewableDispatch) = value.internal


InfrastructureSystems.set_name!(value::RenewableDispatch, val) = value.name = val
"""Set [`RenewableDispatch`](@ref) `available`."""
set_available!(value::RenewableDispatch, val) = value.available = val
"""Set [`RenewableDispatch`](@ref) `bus`."""
set_bus!(value::RenewableDispatch, val) = value.bus = val
"""Set [`RenewableDispatch`](@ref) `active_power`."""
set_active_power!(value::RenewableDispatch, val) = value.active_power = val
"""Set [`RenewableDispatch`](@ref) `reactive_power`."""
set_reactive_power!(value::RenewableDispatch, val) = value.reactive_power = val
"""Set [`RenewableDispatch`](@ref) `rating`."""
set_rating!(value::RenewableDispatch, val) = value.rating = val
"""Set [`RenewableDispatch`](@ref) `prime_mover`."""
set_prime_mover!(value::RenewableDispatch, val) = value.prime_mover = val
"""Set [`RenewableDispatch`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::RenewableDispatch, val) = value.reactive_power_limits = val
"""Set [`RenewableDispatch`](@ref) `power_factor`."""
set_power_factor!(value::RenewableDispatch, val) = value.power_factor = val
"""Set [`RenewableDispatch`](@ref) `operation_cost`."""
set_operation_cost!(value::RenewableDispatch, val) = value.operation_cost = val
"""Set [`RenewableDispatch`](@ref) `base_power`."""
set_base_power!(value::RenewableDispatch, val) = value.base_power = val
"""Set [`RenewableDispatch`](@ref) `services`."""
set_services!(value::RenewableDispatch, val) = value.services = val
"""Set [`RenewableDispatch`](@ref) `ext`."""
set_ext!(value::RenewableDispatch, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::RenewableDispatch, val) = value.forecasts = val
"""Set [`RenewableDispatch`](@ref) `internal`."""
set_internal!(value::RenewableDispatch, val) = value.internal = val

