#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RenewableFix <: RenewableGen
        name::String
        available::Bool
        bus::Bus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover::PrimeMovers.PrimeMover
        power_factor::Float64
        base_power::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for fixed renewable generation technologies.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `active_power::Float64`
- `reactive_power::Float64`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `prime_mover::PrimeMovers.PrimeMover`: prime_mover Technology according to EIA 923
- `power_factor::Float64`, validation range: (0, 1), action if invalid: error
- `base_power::Float64`: Base power of the unit in MVA, validation range: (0, nothing), action if invalid: warn
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RenewableFix <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    active_power::Float64
    reactive_power::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "prime_mover Technology according to EIA 923"
    prime_mover::PrimeMovers.PrimeMover
    power_factor::Float64
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

function RenewableFix(name, available, bus, active_power, reactive_power, rating, prime_mover, power_factor, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableFix(name, available, bus, active_power, reactive_power, rating, prime_mover, power_factor, base_power, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function RenewableFix(; name, available, bus, active_power, reactive_power, rating, prime_mover, power_factor, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableFix(name, available, bus, active_power, reactive_power, rating, prime_mover, power_factor, base_power, services, dynamic_injector, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function RenewableFix(::Nothing)
    RenewableFix(;
        name="init",
        available=false,
        bus=Bus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        prime_mover=PrimeMovers.OT,
        power_factor=1.0,
        base_power=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::RenewableFix) = value.name
"""Get RenewableFix available."""
get_available(value::RenewableFix) = value.available
"""Get RenewableFix bus."""
get_bus(value::RenewableFix) = value.bus
"""Get RenewableFix active_power."""
get_active_power(value::RenewableFix) = get_value(Float64, value, :active_power)
"""Get RenewableFix reactive_power."""
get_reactive_power(value::RenewableFix) = get_value(Float64, value, :reactive_power)
"""Get RenewableFix rating."""
get_rating(value::RenewableFix) = get_value(Float64, value, :rating)
"""Get RenewableFix prime_mover."""
get_prime_mover(value::RenewableFix) = value.prime_mover
"""Get RenewableFix power_factor."""
get_power_factor(value::RenewableFix) = value.power_factor
"""Get RenewableFix base_power."""
get_base_power(value::RenewableFix) = value.base_power
"""Get RenewableFix services."""
get_services(value::RenewableFix) = value.services
"""Get RenewableFix dynamic_injector."""
get_dynamic_injector(value::RenewableFix) = value.dynamic_injector
"""Get RenewableFix ext."""
get_ext(value::RenewableFix) = value.ext

InfrastructureSystems.get_forecasts(value::RenewableFix) = value.forecasts
"""Get RenewableFix internal."""
get_internal(value::RenewableFix) = value.internal


InfrastructureSystems.set_name!(value::RenewableFix, val::String) = value.name = val
"""Set RenewableFix available."""
set_available!(value::RenewableFix, val::Bool) = value.available = val
"""Set RenewableFix bus."""
set_bus!(value::RenewableFix, val::Bus) = value.bus = val
"""Set RenewableFix active_power."""
set_active_power!(value::RenewableFix, val::Float64) = value.active_power = val
"""Set RenewableFix reactive_power."""
set_reactive_power!(value::RenewableFix, val::Float64) = value.reactive_power = val
"""Set RenewableFix rating."""
set_rating!(value::RenewableFix, val::Float64) = value.rating = val
"""Set RenewableFix prime_mover."""
set_prime_mover!(value::RenewableFix, val::PrimeMovers.PrimeMover) = value.prime_mover = val
"""Set RenewableFix power_factor."""
set_power_factor!(value::RenewableFix, val::Float64) = value.power_factor = val
"""Set RenewableFix base_power."""
set_base_power!(value::RenewableFix, val::Float64) = value.base_power = val
"""Set RenewableFix services."""
set_services!(value::RenewableFix, val::Vector{Service}) = value.services = val
"""Set RenewableFix ext."""
set_ext!(value::RenewableFix, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::RenewableFix, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set RenewableFix internal."""
set_internal!(value::RenewableFix, val::InfrastructureSystemsInternal) = value.internal = val
