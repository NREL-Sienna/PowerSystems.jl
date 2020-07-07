#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct GenericBattery <: Storage
        name::String
        available::Bool
        bus::Bus
        prime_mover::PrimeMovers.PrimeMover
        energy_level::Float64
        energy_level_min::Float64
        energy_level_max::Float64
        rating::Float64
        active_power::Float64
        input_activepower_max::Float64
        input_activepower_min::Float64
        output_activepower_max::Float64
        output_activepower_min::Float64
        efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}
        reactive_power::Float64
        reactivepower_max::Union{Nothing, Float64}
        reactivepower_min::Union{Nothing, Float64}
        base_power::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data structure for a generic battery

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `prime_mover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `energy_level::Float64`: State of Charge of the Battery p.u.-hr, validation range: (0, nothing), action if invalid: error
- `energy_level_min::Float64`: Minimum storage capacity in p.u.-hr, validation range: (0, nothing), action if invalid: error
- `energy_level_max::Float64`: Maximum storage capacity in p.u.-hr, validation range: (0, nothing), action if invalid: error
- `rating::Float64`, validation range: (0, nothing), action if invalid: error
- `active_power::Float64`, validation range: (0, nothing), action if invalid: error
- `input_activepower_max::Float64`, validation range: (0, nothing), action if invalid: error
- `input_activepower_min::Float64`, validation range: (0, nothing), action if invalid: error
- `output_activepower_max::Float64`, validation range: (0, nothing), action if invalid: error
- `output_activepower_min::Float64`, validation range: (0, nothing), action if invalid: error
- `efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}`, validation range: (0, 1), action if invalid: warn
- `reactive_power::Float64`, action if invalid: warn
- `reactivepower_max::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `reactivepower_min::Union{Nothing, Float64}`, validation range: (0, nothing), action if invalid: error
- `base_power::Float64`: Base power of the unit in system base per unit, validation range: (0, nothing), action if invalid: warn
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct GenericBattery <: Storage
    name::String
    available::Bool
    bus::Bus
    "PrimeMover Technology according to EIA 923"
    prime_mover::PrimeMovers.PrimeMover
    "State of Charge of the Battery p.u.-hr"
    energy_level::Float64
    "Minimum storage capacity in p.u.-hr"
    energy_level_min::Float64
    "Maximum storage capacity in p.u.-hr"
    energy_level_max::Float64
    rating::Float64
    active_power::Float64
    input_activepower_max::Float64
    input_activepower_min::Float64
    output_activepower_max::Float64
    output_activepower_min::Float64
    efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}
    reactive_power::Float64
    reactivepower_max::Union{Nothing, Float64}
    reactivepower_min::Union{Nothing, Float64}
    "Base power of the unit in system base per unit"
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

function GenericBattery(name, available, bus, prime_mover, energy_level, energy_level_min, energy_level_max, rating, active_power, input_activepower_max, input_activepower_min, output_activepower_max, output_activepower_min, efficiency, reactive_power, reactivepower_max, reactivepower_min, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    GenericBattery(name, available, bus, prime_mover, energy_level, energy_level_min, energy_level_max, rating, active_power, input_activepower_max, input_activepower_min, output_activepower_max, output_activepower_min, efficiency, reactive_power, reactivepower_max, reactivepower_min, base_power, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function GenericBattery(; name, available, bus, prime_mover, energy_level, energy_level_min, energy_level_max, rating, active_power, input_activepower_max, input_activepower_min, output_activepower_max, output_activepower_min, efficiency, reactive_power, reactivepower_max, reactivepower_min, base_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    GenericBattery(name, available, bus, prime_mover, energy_level, energy_level_min, energy_level_max, rating, active_power, input_activepower_max, input_activepower_min, output_activepower_max, output_activepower_min, efficiency, reactive_power, reactivepower_max, reactivepower_min, base_power, services, dynamic_injector, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function GenericBattery(::Nothing)
    GenericBattery(;
        name="init",
        available=false,
        bus=Bus(nothing),
        prime_mover=PrimeMovers.BA,
        energy_level=0.0,
        energy_level_min=0.0,
        energy_level_max=0.0,
        rating=0.0,
        active_power=0.0,
        input_activepower_max=0.0,
        input_activepower_min=0.0,
        output_activepower_max=0.0,
        output_activepower_min=0.0,
        efficiency=(in=0.0, out=0.0),
        reactive_power=0.0,
        reactivepower_max=nothing,
        reactivepower_min=nothing,
        base_power=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::GenericBattery) = value.name
"""Get GenericBattery available."""
get_available(value::GenericBattery) = value.available
"""Get GenericBattery bus."""
get_bus(value::GenericBattery) = value.bus
"""Get GenericBattery prime_mover."""
get_prime_mover(value::GenericBattery) = value.prime_mover
"""Get GenericBattery energy_level."""
get_energy_level(value::GenericBattery) = get_value(value, :energy_level)
"""Get GenericBattery energy_level_min."""
get_energy_level_min(value::GenericBattery) = get_value(value, :energy_level_min)
"""Get GenericBattery energy_level_max."""
get_energy_level_max(value::GenericBattery) = get_value(value, :energy_level_max)
"""Get GenericBattery rating."""
get_rating(value::GenericBattery) = get_value(value, :rating)
"""Get GenericBattery active_power."""
get_active_power(value::GenericBattery) = get_value(value, :active_power)
"""Get GenericBattery input_activepower_max."""
get_input_activepower_max(value::GenericBattery) = get_value(value, :input_activepower_max)
"""Get GenericBattery input_activepower_min."""
get_input_activepower_min(value::GenericBattery) = get_value(value, :input_activepower_min)
"""Get GenericBattery output_activepower_max."""
get_output_activepower_max(value::GenericBattery) = get_value(value, :output_activepower_max)
"""Get GenericBattery output_activepower_min."""
get_output_activepower_min(value::GenericBattery) = get_value(value, :output_activepower_min)
"""Get GenericBattery efficiency."""
get_efficiency(value::GenericBattery) = value.efficiency
"""Get GenericBattery reactive_power."""
get_reactive_power(value::GenericBattery) = value.reactive_power
"""Get GenericBattery reactivepower_max."""
get_reactivepower_max(value::GenericBattery) = get_value(value, :reactivepower_max)
"""Get GenericBattery reactivepower_min."""
get_reactivepower_min(value::GenericBattery) = get_value(value, :reactivepower_min)
"""Get GenericBattery base_power."""
get_base_power(value::GenericBattery) = value.base_power
"""Get GenericBattery services."""
get_services(value::GenericBattery) = value.services
"""Get GenericBattery dynamic_injector."""
get_dynamic_injector(value::GenericBattery) = value.dynamic_injector
"""Get GenericBattery ext."""
get_ext(value::GenericBattery) = value.ext

InfrastructureSystems.get_forecasts(value::GenericBattery) = value.forecasts
"""Get GenericBattery internal."""
get_internal(value::GenericBattery) = value.internal


InfrastructureSystems.set_name!(value::GenericBattery, val::String) = value.name = val
"""Set GenericBattery available."""
set_available!(value::GenericBattery, val::Bool) = value.available = val
"""Set GenericBattery bus."""
set_bus!(value::GenericBattery, val::Bus) = value.bus = val
"""Set GenericBattery prime_mover."""
set_prime_mover!(value::GenericBattery, val::PrimeMovers.PrimeMover) = value.prime_mover = val
"""Set GenericBattery energy_level."""
set_energy_level!(value::GenericBattery, val::Float64) = value.energy_level = val
"""Set GenericBattery energy_level_min."""
set_energy_level_min!(value::GenericBattery, val::Float64) = value.energy_level_min = val
"""Set GenericBattery energy_level_max."""
set_energy_level_max!(value::GenericBattery, val::Float64) = value.energy_level_max = val
"""Set GenericBattery rating."""
set_rating!(value::GenericBattery, val::Float64) = value.rating = val
"""Set GenericBattery active_power."""
set_active_power!(value::GenericBattery, val::Float64) = value.active_power = val
"""Set GenericBattery input_activepower_max."""
set_input_activepower_max!(value::GenericBattery, val::Float64) = value.input_activepower_max = val
"""Set GenericBattery input_activepower_min."""
set_input_activepower_min!(value::GenericBattery, val::Float64) = value.input_activepower_min = val
"""Set GenericBattery output_activepower_max."""
set_output_activepower_max!(value::GenericBattery, val::Float64) = value.output_activepower_max = val
"""Set GenericBattery output_activepower_min."""
set_output_activepower_min!(value::GenericBattery, val::Float64) = value.output_activepower_min = val
"""Set GenericBattery efficiency."""
set_efficiency!(value::GenericBattery, val::NamedTuple{(:in, :out), Tuple{Float64, Float64}}) = value.efficiency = val
"""Set GenericBattery reactive_power."""
set_reactive_power!(value::GenericBattery, val::Float64) = value.reactive_power = val
"""Set GenericBattery reactivepower_max."""
set_reactivepower_max!(value::GenericBattery, val::Union{Nothing, Float64}) = value.reactivepower_max = val
"""Set GenericBattery reactivepower_min."""
set_reactivepower_min!(value::GenericBattery, val::Union{Nothing, Float64}) = value.reactivepower_min = val
"""Set GenericBattery base_power."""
set_base_power!(value::GenericBattery, val::Float64) = value.base_power = val
"""Set GenericBattery services."""
set_services!(value::GenericBattery, val::Vector{Service}) = value.services = val
"""Set GenericBattery ext."""
set_ext!(value::GenericBattery, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::GenericBattery, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set GenericBattery internal."""
set_internal!(value::GenericBattery, val::InfrastructureSystemsInternal) = value.internal = val
