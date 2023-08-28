#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct GenericBattery <: Storage
        name::String
        available::Bool
        bus::Bus
        prime_mover::PrimeMovers
        initial_energy::Float64
        state_of_charge_limits::MinMax
        rating::Float64
        active_power::Float64
        input_active_power_limits::MinMax
        output_active_power_limits::MinMax
        efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}
        reactive_power::Float64
        reactive_power_limits::Union{Nothing, MinMax}
        base_power::Float64
        operation_cost::Union{Nothing, StorageManagementCost}
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

Data structure for a generic battery

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `prime_mover::PrimeMovers`: Prime mover technology according to EIA 923
- `initial_energy::Float64`: State of Charge of the Battery p.u.-hr, validation range: `(0, nothing)`, action if invalid: `error`
- `state_of_charge_limits::MinMax`: Maximum and Minimum storage capacity in p.u.-hr, validation range: `(0, nothing)`, action if invalid: `error`
- `rating::Float64`
- `active_power::Float64`
- `input_active_power_limits::MinMax`, validation range: `(0, nothing)`, action if invalid: `error`
- `output_active_power_limits::MinMax`, validation range: `(0, nothing)`, action if invalid: `error`
- `efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}`, validation range: `(0, 1)`, action if invalid: `warn`
- `reactive_power::Float64`, validation range: `reactive_power_limits`, action if invalid: `warn`
- `reactive_power_limits::Union{Nothing, MinMax}`
- `base_power::Float64`: Base power of the unit in MVA, validation range: `(0, nothing)`, action if invalid: `warn`
- `operation_cost::Union{Nothing, StorageManagementCost}`
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct GenericBattery <: Storage
    name::String
    available::Bool
    bus::Bus
    "Prime mover technology according to EIA 923"
    prime_mover::PrimeMovers
    "State of Charge of the Battery p.u.-hr"
    initial_energy::Float64
    "Maximum and Minimum storage capacity in p.u.-hr"
    state_of_charge_limits::MinMax
    rating::Float64
    active_power::Float64
    input_active_power_limits::MinMax
    output_active_power_limits::MinMax
    efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}
    reactive_power::Float64
    reactive_power_limits::Union{Nothing, MinMax}
    "Base power of the unit in MVA"
    base_power::Float64
    operation_cost::Union{Nothing, StorageManagementCost}
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

function GenericBattery(name, available, bus, prime_mover, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost=nothing, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    GenericBattery(name, available, bus, prime_mover, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost, services, dynamic_injector, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function GenericBattery(; name, available, bus, prime_mover, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost=nothing, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    GenericBattery(name, available, bus, prime_mover, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost, services, dynamic_injector, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function GenericBattery(::Nothing)
    GenericBattery(;
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
        operation_cost=nothing,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`GenericBattery`](@ref) `name`."""
get_name(value::GenericBattery) = value.name
"""Get [`GenericBattery`](@ref) `available`."""
get_available(value::GenericBattery) = value.available
"""Get [`GenericBattery`](@ref) `bus`."""
get_bus(value::GenericBattery) = value.bus
"""Get [`GenericBattery`](@ref) `prime_mover`."""
get_prime_mover(value::GenericBattery) = value.prime_mover
"""Get [`GenericBattery`](@ref) `initial_energy`."""
get_initial_energy(value::GenericBattery) = get_value(value, value.initial_energy)
"""Get [`GenericBattery`](@ref) `state_of_charge_limits`."""
get_state_of_charge_limits(value::GenericBattery) = get_value(value, value.state_of_charge_limits)
"""Get [`GenericBattery`](@ref) `rating`."""
get_rating(value::GenericBattery) = get_value(value, value.rating)
"""Get [`GenericBattery`](@ref) `active_power`."""
get_active_power(value::GenericBattery) = get_value(value, value.active_power)
"""Get [`GenericBattery`](@ref) `input_active_power_limits`."""
get_input_active_power_limits(value::GenericBattery) = get_value(value, value.input_active_power_limits)
"""Get [`GenericBattery`](@ref) `output_active_power_limits`."""
get_output_active_power_limits(value::GenericBattery) = get_value(value, value.output_active_power_limits)
"""Get [`GenericBattery`](@ref) `efficiency`."""
get_efficiency(value::GenericBattery) = value.efficiency
"""Get [`GenericBattery`](@ref) `reactive_power`."""
get_reactive_power(value::GenericBattery) = get_value(value, value.reactive_power)
"""Get [`GenericBattery`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::GenericBattery) = get_value(value, value.reactive_power_limits)
"""Get [`GenericBattery`](@ref) `base_power`."""
get_base_power(value::GenericBattery) = value.base_power
"""Get [`GenericBattery`](@ref) `operation_cost`."""
get_operation_cost(value::GenericBattery) = value.operation_cost
"""Get [`GenericBattery`](@ref) `services`."""
get_services(value::GenericBattery) = value.services
"""Get [`GenericBattery`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::GenericBattery) = value.dynamic_injector
"""Get [`GenericBattery`](@ref) `ext`."""
get_ext(value::GenericBattery) = value.ext
"""Get [`GenericBattery`](@ref) `time_series_container`."""
get_time_series_container(value::GenericBattery) = value.time_series_container
"""Get [`GenericBattery`](@ref) `internal`."""
get_internal(value::GenericBattery) = value.internal

"""Set [`GenericBattery`](@ref) `available`."""
set_available!(value::GenericBattery, val) = value.available = val
"""Set [`GenericBattery`](@ref) `bus`."""
set_bus!(value::GenericBattery, val) = value.bus = val
"""Set [`GenericBattery`](@ref) `prime_mover`."""
set_prime_mover!(value::GenericBattery, val) = value.prime_mover = val
"""Set [`GenericBattery`](@ref) `initial_energy`."""
set_initial_energy!(value::GenericBattery, val) = value.initial_energy = set_value(value, val)
"""Set [`GenericBattery`](@ref) `state_of_charge_limits`."""
set_state_of_charge_limits!(value::GenericBattery, val) = value.state_of_charge_limits = set_value(value, val)
"""Set [`GenericBattery`](@ref) `rating`."""
set_rating!(value::GenericBattery, val) = value.rating = set_value(value, val)
"""Set [`GenericBattery`](@ref) `active_power`."""
set_active_power!(value::GenericBattery, val) = value.active_power = set_value(value, val)
"""Set [`GenericBattery`](@ref) `input_active_power_limits`."""
set_input_active_power_limits!(value::GenericBattery, val) = value.input_active_power_limits = set_value(value, val)
"""Set [`GenericBattery`](@ref) `output_active_power_limits`."""
set_output_active_power_limits!(value::GenericBattery, val) = value.output_active_power_limits = set_value(value, val)
"""Set [`GenericBattery`](@ref) `efficiency`."""
set_efficiency!(value::GenericBattery, val) = value.efficiency = val
"""Set [`GenericBattery`](@ref) `reactive_power`."""
set_reactive_power!(value::GenericBattery, val) = value.reactive_power = set_value(value, val)
"""Set [`GenericBattery`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::GenericBattery, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`GenericBattery`](@ref) `base_power`."""
set_base_power!(value::GenericBattery, val) = value.base_power = val
"""Set [`GenericBattery`](@ref) `operation_cost`."""
set_operation_cost!(value::GenericBattery, val) = value.operation_cost = val
"""Set [`GenericBattery`](@ref) `services`."""
set_services!(value::GenericBattery, val) = value.services = val
"""Set [`GenericBattery`](@ref) `ext`."""
set_ext!(value::GenericBattery, val) = value.ext = val
"""Set [`GenericBattery`](@ref) `time_series_container`."""
set_time_series_container!(value::GenericBattery, val) = value.time_series_container = val
