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
        reactivepower_max::Union{Nothing, Float64}
        reactivepower_min::Union{Nothing, Float64}
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
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `prime_mover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `reactivepower_max::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `reactivepower_min::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `power_factor::Float64`, validation range: (0, 1), action if invalid: error
- `operation_cost::TwoPartCost`: Operation Cost of Generation [`TwoPartCost`](@ref)
- `base_power::Float64`: Base power of the unit in MVA, validation range: (0, nothing), action if invalid: warn
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
    "PrimeMover Technology according to EIA 923"
    prime_mover::PrimeMovers.PrimeMover
    reactivepower_max::Union{Nothing, Float64}
    reactivepower_min::Union{Nothing, Float64}
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

function RenewableDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, reactivepower_max, reactivepower_min, power_factor, operation_cost, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, reactivepower_max, reactivepower_min, power_factor, operation_cost, base_power, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function RenewableDispatch(; name, available, bus, active_power, reactive_power, rating, prime_mover, reactivepower_max, reactivepower_min, power_factor, operation_cost, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, reactivepower_max, reactivepower_min, power_factor, operation_cost, base_power, services, dynamic_injector, ext, forecasts, )
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
        reactivepower_max=nothing,
        reactivepower_min=nothing,
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
"""Get RenewableDispatch available."""
get_available(value::RenewableDispatch) = value.available
"""Get RenewableDispatch bus."""
get_bus(value::RenewableDispatch) = value.bus
"""Get RenewableDispatch active_power."""
get_active_power(value::RenewableDispatch) = get_value(value, :active_power)
"""Get RenewableDispatch reactive_power."""
get_reactive_power(value::RenewableDispatch) = get_value(value, :reactive_power)
"""Get RenewableDispatch rating."""
get_rating(value::RenewableDispatch) = get_value(value, :rating)
"""Get RenewableDispatch prime_mover."""
get_prime_mover(value::RenewableDispatch) = get_value(value, :prime_mover)
"""Get RenewableDispatch reactivepower_max."""
get_reactivepower_max(value::RenewableDispatch) = get_value(value, :reactivepower_max)
"""Get RenewableDispatch reactivepower_min."""
get_reactivepower_min(value::RenewableDispatch) = get_value(value, :reactivepower_min)
"""Get RenewableDispatch power_factor."""
get_power_factor(value::RenewableDispatch) = value.power_factor
"""Get RenewableDispatch operation_cost."""
get_operation_cost(value::RenewableDispatch) = value.operation_cost
"""Get RenewableDispatch base_power."""
get_base_power(value::RenewableDispatch) = value.base_power
"""Get RenewableDispatch services."""
get_services(value::RenewableDispatch) = value.services
"""Get RenewableDispatch dynamic_injector."""
get_dynamic_injector(value::RenewableDispatch) = value.dynamic_injector
"""Get RenewableDispatch ext."""
get_ext(value::RenewableDispatch) = value.ext

InfrastructureSystems.get_forecasts(value::RenewableDispatch) = value.forecasts
"""Get RenewableDispatch internal."""
get_internal(value::RenewableDispatch) = value.internal


InfrastructureSystems.set_name!(value::RenewableDispatch, val::String) = value.name = val
"""Set RenewableDispatch available."""
set_available!(value::RenewableDispatch, val::Bool) = value.available = val
"""Set RenewableDispatch bus."""
set_bus!(value::RenewableDispatch, val::Bus) = value.bus = val
"""Set RenewableDispatch active_power."""
set_active_power!(value::RenewableDispatch, val::Float64) = value.active_power = val
"""Set RenewableDispatch reactive_power."""
set_reactive_power!(value::RenewableDispatch, val::Float64) = value.reactive_power = val
"""Set RenewableDispatch rating."""
set_rating!(value::RenewableDispatch, val::Float64) = value.rating = val
"""Set RenewableDispatch prime_mover."""
set_prime_mover!(value::RenewableDispatch, val::PrimeMovers.PrimeMover) = value.prime_mover = val
"""Set RenewableDispatch reactivepower_max."""
set_reactivepower_max!(value::RenewableDispatch, val::Union{Nothing, Float64}) = value.reactivepower_max = val
"""Set RenewableDispatch reactivepower_min."""
set_reactivepower_min!(value::RenewableDispatch, val::Union{Nothing, Float64}) = value.reactivepower_min = val
"""Set RenewableDispatch power_factor."""
set_power_factor!(value::RenewableDispatch, val::Float64) = value.power_factor = val
"""Set RenewableDispatch operation_cost."""
set_operation_cost!(value::RenewableDispatch, val::TwoPartCost) = value.operation_cost = val
"""Set RenewableDispatch base_power."""
set_base_power!(value::RenewableDispatch, val::Float64) = value.base_power = val
"""Set RenewableDispatch services."""
set_services!(value::RenewableDispatch, val::Vector{Service}) = value.services = val
"""Set RenewableDispatch ext."""
set_ext!(value::RenewableDispatch, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::RenewableDispatch, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set RenewableDispatch internal."""
set_internal!(value::RenewableDispatch, val::InfrastructureSystemsInternal) = value.internal = val
