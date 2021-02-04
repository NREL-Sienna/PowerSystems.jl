#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct BatteryEMS <: Storage
        name::String
        available::Bool
        bus::Bus
        prime_mover::PrimeMovers
        initial_energy::Float64
        state_of_charge_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        rating::Float64
        active_power::Float64
        input_active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        output_active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}
        reactive_power::Float64
        reactive_power_limits::Union{Nothing, Min_Max}
        base_power::Float64
        storage_target::Float64
        penalty_cost::Float64
        energy_value::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

Data structure for a battery compatible with energy management formulations.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `prime_mover::PrimeMovers`: Prime mover technology according to EIA 923
- `initial_energy::Float64`: State of Charge of the Battery p.u.-hr, validation range: `(0, nothing)`, action if invalid: `error`
- `state_of_charge_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Maximum and Minimum storage capacity in p.u.-hr, validation range: `(0, nothing)`, action if invalid: `error`
- `rating::Float64`
- `active_power::Float64`
- `input_active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`, validation range: `(0, nothing)`, action if invalid: `error`
- `output_active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`, validation range: `(0, nothing)`, action if invalid: `error`
- `efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}`, validation range: `(0, 1)`, action if invalid: `warn`
- `reactive_power::Float64`, validation range: `reactive_power_limits`, action if invalid: `warn`
- `reactive_power_limits::Union{Nothing, Min_Max}`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `storage_target::Float64`: Storage target at the end of simulation as ratio of storage capacity.
- `penalty_cost::Float64`: Cost penalty for missing storage target at the end of simulation.
- `energy_value::Float64`: Value provide by the stored energy at the end of simulation to the system.
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct BatteryEMS <: Storage
    name::String
    available::Bool
    bus::Bus
    "Prime mover technology according to EIA 923"
    prime_mover::PrimeMovers
    "State of Charge of the Battery p.u.-hr"
    initial_energy::Float64
    "Maximum and Minimum storage capacity in p.u.-hr"
    state_of_charge_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    rating::Float64
    active_power::Float64
    input_active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    output_active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}
    reactive_power::Float64
    reactive_power_limits::Union{Nothing, Min_Max}
    "Base power of the unit in MVA"
    base_power::Float64
    "Storage target at the end of simulation as ratio of storage capacity."
    storage_target::Float64
    "Cost penalty for missing storage target at the end of simulation."
    penalty_cost::Float64
    "Value provide by the stored energy at the end of simulation to the system."
    energy_value::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function BatteryEMS(name, available, bus, prime_mover, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, storage_target=0.0, penalty_cost=0.0, energy_value=0.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    BatteryEMS(name, available, bus, prime_mover, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, storage_target, penalty_cost, energy_value, services, dynamic_injector, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function BatteryEMS(; name, available, bus, prime_mover, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, storage_target=0.0, penalty_cost=0.0, energy_value=0.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    BatteryEMS(name, available, bus, prime_mover, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, storage_target, penalty_cost, energy_value, services, dynamic_injector, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function BatteryEMS(::Nothing)
    BatteryEMS(;
        name="init",
        available=false,
        bus=Bus(nothing),
        prime_mover=PrimeMovers.BA,
        initial_energy=0.0,
        state_of_charge_limits=(min=0.0, max=0.0),
        rating=0.0,
        active_power=0.0,
        input_active_power_limits=(min=0.0, max=0.0),
        output_active_power_limits=(min=0.0, max=0.0),
        efficiency=(in=0.0, out=0.0),
        reactive_power=0.0,
        reactive_power_limits=(min=0.0, max=0.0),
        base_power=0.0,
        storage_target=0.0,
        penalty_cost=0.0,
        energy_value=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end


InfrastructureSystems.get_name(value::BatteryEMS) = value.name
"""Get [`BatteryEMS`](@ref) `available`."""
get_available(value::BatteryEMS) = value.available
"""Get [`BatteryEMS`](@ref) `bus`."""
get_bus(value::BatteryEMS) = value.bus
"""Get [`BatteryEMS`](@ref) `prime_mover`."""
get_prime_mover(value::BatteryEMS) = value.prime_mover
"""Get [`BatteryEMS`](@ref) `initial_energy`."""
get_initial_energy(value::BatteryEMS) = get_value(value, value.initial_energy)
"""Get [`BatteryEMS`](@ref) `state_of_charge_limits`."""
get_state_of_charge_limits(value::BatteryEMS) = get_value(value, value.state_of_charge_limits)
"""Get [`BatteryEMS`](@ref) `rating`."""
get_rating(value::BatteryEMS) = get_value(value, value.rating)
"""Get [`BatteryEMS`](@ref) `active_power`."""
get_active_power(value::BatteryEMS) = get_value(value, value.active_power)
"""Get [`BatteryEMS`](@ref) `input_active_power_limits`."""
get_input_active_power_limits(value::BatteryEMS) = get_value(value, value.input_active_power_limits)
"""Get [`BatteryEMS`](@ref) `output_active_power_limits`."""
get_output_active_power_limits(value::BatteryEMS) = get_value(value, value.output_active_power_limits)
"""Get [`BatteryEMS`](@ref) `efficiency`."""
get_efficiency(value::BatteryEMS) = value.efficiency
"""Get [`BatteryEMS`](@ref) `reactive_power`."""
get_reactive_power(value::BatteryEMS) = get_value(value, value.reactive_power)
"""Get [`BatteryEMS`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::BatteryEMS) = get_value(value, value.reactive_power_limits)
"""Get [`BatteryEMS`](@ref) `base_power`."""
get_base_power(value::BatteryEMS) = value.base_power
"""Get [`BatteryEMS`](@ref) `storage_target`."""
get_storage_target(value::BatteryEMS) = value.storage_target
"""Get [`BatteryEMS`](@ref) `penalty_cost`."""
get_penalty_cost(value::BatteryEMS) = value.penalty_cost
"""Get [`BatteryEMS`](@ref) `energy_value`."""
get_energy_value(value::BatteryEMS) = value.energy_value
"""Get [`BatteryEMS`](@ref) `services`."""
get_services(value::BatteryEMS) = value.services
"""Get [`BatteryEMS`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::BatteryEMS) = value.dynamic_injector
"""Get [`BatteryEMS`](@ref) `ext`."""
get_ext(value::BatteryEMS) = value.ext

InfrastructureSystems.get_time_series_container(value::BatteryEMS) = value.time_series_container
"""Get [`BatteryEMS`](@ref) `internal`."""
get_internal(value::BatteryEMS) = value.internal


InfrastructureSystems.set_name!(value::BatteryEMS, val) = value.name = val
"""Set [`BatteryEMS`](@ref) `available`."""
set_available!(value::BatteryEMS, val) = value.available = val
"""Set [`BatteryEMS`](@ref) `bus`."""
set_bus!(value::BatteryEMS, val) = value.bus = val
"""Set [`BatteryEMS`](@ref) `prime_mover`."""
set_prime_mover!(value::BatteryEMS, val) = value.prime_mover = val
"""Set [`BatteryEMS`](@ref) `initial_energy`."""
set_initial_energy!(value::BatteryEMS, val) = value.initial_energy = val
"""Set [`BatteryEMS`](@ref) `state_of_charge_limits`."""
set_state_of_charge_limits!(value::BatteryEMS, val) = value.state_of_charge_limits = val
"""Set [`BatteryEMS`](@ref) `rating`."""
set_rating!(value::BatteryEMS, val) = value.rating = val
"""Set [`BatteryEMS`](@ref) `active_power`."""
set_active_power!(value::BatteryEMS, val) = value.active_power = val
"""Set [`BatteryEMS`](@ref) `input_active_power_limits`."""
set_input_active_power_limits!(value::BatteryEMS, val) = value.input_active_power_limits = val
"""Set [`BatteryEMS`](@ref) `output_active_power_limits`."""
set_output_active_power_limits!(value::BatteryEMS, val) = value.output_active_power_limits = val
"""Set [`BatteryEMS`](@ref) `efficiency`."""
set_efficiency!(value::BatteryEMS, val) = value.efficiency = val
"""Set [`BatteryEMS`](@ref) `reactive_power`."""
set_reactive_power!(value::BatteryEMS, val) = value.reactive_power = val
"""Set [`BatteryEMS`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::BatteryEMS, val) = value.reactive_power_limits = val
"""Set [`BatteryEMS`](@ref) `base_power`."""
set_base_power!(value::BatteryEMS, val) = value.base_power = val
"""Set [`BatteryEMS`](@ref) `storage_target`."""
set_storage_target!(value::BatteryEMS, val) = value.storage_target = val
"""Set [`BatteryEMS`](@ref) `penalty_cost`."""
set_penalty_cost!(value::BatteryEMS, val) = value.penalty_cost = val
"""Set [`BatteryEMS`](@ref) `energy_value`."""
set_energy_value!(value::BatteryEMS, val) = value.energy_value = val
"""Set [`BatteryEMS`](@ref) `services`."""
set_services!(value::BatteryEMS, val) = value.services = val
"""Set [`BatteryEMS`](@ref) `ext`."""
set_ext!(value::BatteryEMS, val) = value.ext = val

InfrastructureSystems.set_time_series_container!(value::BatteryEMS, val) = value.time_series_container = val

