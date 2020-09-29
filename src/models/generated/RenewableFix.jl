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
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: `(0, nothing)`, action if invalid: `error`
- `prime_mover::PrimeMovers.PrimeMover`: Prime mover technology according to EIA 923
- `power_factor::Float64`, validation range: `(0, 1)`, action if invalid: `error`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
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
    "Prime mover technology according to EIA 923"
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

function RenewableFix(; name, available, bus, active_power, reactive_power, rating, prime_mover, power_factor, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), internal=InfrastructureSystemsInternal(), )
    RenewableFix(name, available, bus, active_power, reactive_power, rating, prime_mover, power_factor, base_power, services, dynamic_injector, ext, forecasts, internal, )
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
"""Get [`RenewableFix`](@ref) `available`."""
get_available(value::RenewableFix) = value.available
"""Get [`RenewableFix`](@ref) `bus`."""
get_bus(value::RenewableFix) = value.bus
"""Get [`RenewableFix`](@ref) `active_power`."""
get_active_power(value::RenewableFix) = get_value(value, value.active_power)
"""Get [`RenewableFix`](@ref) `reactive_power`."""
get_reactive_power(value::RenewableFix) = get_value(value, value.reactive_power)
"""Get [`RenewableFix`](@ref) `rating`."""
get_rating(value::RenewableFix) = get_value(value, value.rating)
"""Get [`RenewableFix`](@ref) `prime_mover`."""
get_prime_mover(value::RenewableFix) = value.prime_mover
"""Get [`RenewableFix`](@ref) `power_factor`."""
get_power_factor(value::RenewableFix) = value.power_factor
"""Get [`RenewableFix`](@ref) `base_power`."""
get_base_power(value::RenewableFix) = value.base_power
"""Get [`RenewableFix`](@ref) `services`."""
get_services(value::RenewableFix) = value.services
"""Get [`RenewableFix`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::RenewableFix) = value.dynamic_injector
"""Get [`RenewableFix`](@ref) `ext`."""
get_ext(value::RenewableFix) = value.ext

InfrastructureSystems.get_forecasts(value::RenewableFix) = value.forecasts
"""Get [`RenewableFix`](@ref) `internal`."""
get_internal(value::RenewableFix) = value.internal


InfrastructureSystems.set_name!(value::RenewableFix, val) = value.name = val
"""Set [`RenewableFix`](@ref) `available`."""
set_available!(value::RenewableFix, val) = value.available = val
"""Set [`RenewableFix`](@ref) `bus`."""
set_bus!(value::RenewableFix, val) = value.bus = val
"""Set [`RenewableFix`](@ref) `active_power`."""
set_active_power!(value::RenewableFix, val) = value.active_power = val
"""Set [`RenewableFix`](@ref) `reactive_power`."""
set_reactive_power!(value::RenewableFix, val) = value.reactive_power = val
"""Set [`RenewableFix`](@ref) `rating`."""
set_rating!(value::RenewableFix, val) = value.rating = val
"""Set [`RenewableFix`](@ref) `prime_mover`."""
set_prime_mover!(value::RenewableFix, val) = value.prime_mover = val
"""Set [`RenewableFix`](@ref) `power_factor`."""
set_power_factor!(value::RenewableFix, val) = value.power_factor = val
"""Set [`RenewableFix`](@ref) `base_power`."""
set_base_power!(value::RenewableFix, val) = value.base_power = val
"""Set [`RenewableFix`](@ref) `services`."""
set_services!(value::RenewableFix, val) = value.services = val
"""Set [`RenewableFix`](@ref) `ext`."""
set_ext!(value::RenewableFix, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::RenewableFix, val) = value.forecasts = val
"""Set [`RenewableFix`](@ref) `internal`."""
set_internal!(value::RenewableFix, val) = value.internal = val

