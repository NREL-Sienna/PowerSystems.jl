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
- `reactive_power_limits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}`, action if invalid: warn
- `ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: ramp up and ramp down limits, validation range: (0, nothing), action if invalid: error
- `time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: Minimum up and Minimum down time limits in hours, validation range: (0, nothing), action if invalid: error
- `base_power::Float64`: Base power of the unit in MVA, validation range: (0, nothing), action if invalid: warn
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
    "prime_mover Technology according to EIA 923"
    prime_mover::PrimeMovers.PrimeMover
    active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    reactive_power_limits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}
    "ramp up and ramp down limits"
    ramp_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
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

function HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HydroDispatch(; name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, services, dynamic_injector, ext, forecasts, )
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
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::HydroDispatch) = value.name
"""Get HydroDispatch available."""
get_available(value::HydroDispatch) = value.available
"""Get HydroDispatch bus."""
get_bus(value::HydroDispatch) = value.bus
"""Get HydroDispatch active_power."""
get_active_power(value::HydroDispatch) = get_value(Float64, value, :active_power)
"""Get HydroDispatch reactive_power."""
get_reactive_power(value::HydroDispatch) = get_value(Float64, value, :reactive_power)
"""Get HydroDispatch rating."""
get_rating(value::HydroDispatch) = get_value(Float64, value, :rating)
"""Get HydroDispatch prime_mover."""
get_prime_mover(value::HydroDispatch) = value.prime_mover
"""Get HydroDispatch active_power_limits."""
get_active_power_limits(value::HydroDispatch) = get_value(NamedTuple{(:min, :max), Tuple{Float64, Float64}}, value, :active_power_limits)
"""Get HydroDispatch reactive_power_limits."""
get_reactive_power_limits(value::HydroDispatch) = get_value(Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}, value, :reactive_power_limits)
"""Get HydroDispatch ramp_limits."""
get_ramp_limits(value::HydroDispatch) = get_value(Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}, value, :ramp_limits)
"""Get HydroDispatch time_limits."""
get_time_limits(value::HydroDispatch) = value.time_limits
"""Get HydroDispatch base_power."""
get_base_power(value::HydroDispatch) = value.base_power
"""Get HydroDispatch services."""
get_services(value::HydroDispatch) = value.services
"""Get HydroDispatch dynamic_injector."""
get_dynamic_injector(value::HydroDispatch) = value.dynamic_injector
"""Get HydroDispatch ext."""
get_ext(value::HydroDispatch) = value.ext

InfrastructureSystems.get_forecasts(value::HydroDispatch) = value.forecasts
"""Get HydroDispatch internal."""
get_internal(value::HydroDispatch) = value.internal


InfrastructureSystems.set_name!(value::HydroDispatch, val::String) = value.name = val
"""Set HydroDispatch available."""
set_available!(value::HydroDispatch, val::Bool) = value.available = val
"""Set HydroDispatch bus."""
set_bus!(value::HydroDispatch, val::Bus) = value.bus = val
"""Set HydroDispatch active_power."""
set_active_power!(value::HydroDispatch, val::Float64) = value.active_power = val
"""Set HydroDispatch reactive_power."""
set_reactive_power!(value::HydroDispatch, val::Float64) = value.reactive_power = val
"""Set HydroDispatch rating."""
set_rating!(value::HydroDispatch, val::Float64) = value.rating = val
"""Set HydroDispatch prime_mover."""
set_prime_mover!(value::HydroDispatch, val::PrimeMovers.PrimeMover) = value.prime_mover = val
"""Set HydroDispatch active_power_limits."""
set_active_power_limits!(value::HydroDispatch, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.active_power_limits = val
"""Set HydroDispatch reactive_power_limits."""
set_reactive_power_limits!(value::HydroDispatch, val::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}) = value.reactive_power_limits = val
"""Set HydroDispatch ramp_limits."""
set_ramp_limits!(value::HydroDispatch, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.ramp_limits = val
"""Set HydroDispatch time_limits."""
set_time_limits!(value::HydroDispatch, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.time_limits = val
"""Set HydroDispatch base_power."""
set_base_power!(value::HydroDispatch, val::Float64) = value.base_power = val
"""Set HydroDispatch services."""
set_services!(value::HydroDispatch, val::Vector{Service}) = value.services = val
"""Set HydroDispatch ext."""
set_ext!(value::HydroDispatch, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::HydroDispatch, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set HydroDispatch internal."""
set_internal!(value::HydroDispatch, val::InfrastructureSystemsInternal) = value.internal = val
