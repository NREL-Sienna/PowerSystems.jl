#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct EnergyReservoirStorage <: Storage
        name::String
        available::Bool
        bus::ACBus
        prime_mover_type::PrimeMovers
        storage_technology_type::StorageTech
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
        operation_cost::StorageCost
        storage_target::Float64
        cycle_limits::Int
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

An energy storage device, modeled as a generic energy reservoir.

This is suitable for modeling storage charging and discharging with a round-trip efficiency, ignoring the physical dynamics of the storage unit. A variety of energy storage types and chemistries can be modeled with this approach.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `bus::ACBus`: Bus that this component is connected to
- `prime_mover_type::PrimeMovers`: Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list).
- `storage_technology_type::StorageTech`: Storage Technology Complementary to EIA 923.
- `initial_energy::Float64`: State of Charge of the Battery p.u.-hr, validation range: `(0, nothing)`, action if invalid: `error`
- `state_of_charge_limits::MinMax`: Maximum and Minimum storage capacity in p.u.-hr, validation range: `(0, nothing)`, action if invalid: `error`
- `rating::Float64`: Maximum output power rating of the unit (MVA)
- `active_power::Float64`: Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used.
- `input_active_power_limits::MinMax`, validation range: `(0, nothing)`, action if invalid: `error`
- `output_active_power_limits::MinMax`, validation range: `(0, nothing)`, action if invalid: `error`
- `efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}`, validation range: `(0, 1)`, action if invalid: `warn`
- `reactive_power::Float64`: Initial reactive power set point of the unit (MVAR), validation range: `reactive_power_limits`, action if invalid: `warn`
- `reactive_power_limits::Union{Nothing, MinMax}`: Minimum and maximum reactive power limits. Set to `Nothing` if not applicable.
- `base_power::Float64`: Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`., validation range: `(0, nothing)`, action if invalid: `warn`
- `operation_cost::StorageCost`: (optional) Operation Cost of Storage [`StorageCost`](@ref)
- `storage_target::Float64`: (optional) Storage target at the end of simulation as ratio of storage capacity.
- `cycle_limits::Int`: (optional) Storage Maximum number of cycles per year
- `services::Vector{Service}`: (optional) Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: (optional) corresponding dynamic injection device
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct EnergyReservoirStorage <: Storage
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    "Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list)."
    prime_mover_type::PrimeMovers
    "Storage Technology Complementary to EIA 923."
    storage_technology_type::StorageTech
    "State of Charge of the Battery p.u.-hr"
    initial_energy::Float64
    "Maximum and Minimum storage capacity in p.u.-hr"
    state_of_charge_limits::MinMax
    "Maximum output power rating of the unit (MVA)"
    rating::Float64
    "Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used."
    active_power::Float64
    input_active_power_limits::MinMax
    output_active_power_limits::MinMax
    efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}
    "Initial reactive power set point of the unit (MVAR)"
    reactive_power::Float64
    "Minimum and maximum reactive power limits. Set to `Nothing` if not applicable."
    reactive_power_limits::Union{Nothing, MinMax}
    "Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`."
    base_power::Float64
    "(optional) Operation Cost of Storage [`StorageCost`](@ref)"
    operation_cost::StorageCost
    "(optional) Storage target at the end of simulation as ratio of storage capacity."
    storage_target::Float64
    "(optional) Storage Maximum number of cycles per year"
    cycle_limits::Int
    "(optional) Services that this device contributes to"
    services::Vector{Service}
    "(optional) corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function EnergyReservoirStorage(name, available, bus, prime_mover_type, storage_technology_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost=StorageCost(nothing), storage_target=0.0, cycle_limits=1e4, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    EnergyReservoirStorage(name, available, bus, prime_mover_type, storage_technology_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost, storage_target, cycle_limits, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function EnergyReservoirStorage(; name, available, bus, prime_mover_type, storage_technology_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost=StorageCost(nothing), storage_target=0.0, cycle_limits=1e4, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    EnergyReservoirStorage(name, available, bus, prime_mover_type, storage_technology_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost, storage_target, cycle_limits, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function EnergyReservoirStorage(::Nothing)
    EnergyReservoirStorage(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        prime_mover_type=PrimeMovers.BA,
        storage_technology_type=StorageTech.OTHER_CHEM,
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
        operation_cost=StorageCost(nothing),
        storage_target=0.0,
        cycle_limits=0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`EnergyReservoirStorage`](@ref) `name`."""
get_name(value::EnergyReservoirStorage) = value.name
"""Get [`EnergyReservoirStorage`](@ref) `available`."""
get_available(value::EnergyReservoirStorage) = value.available
"""Get [`EnergyReservoirStorage`](@ref) `bus`."""
get_bus(value::EnergyReservoirStorage) = value.bus
"""Get [`EnergyReservoirStorage`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::EnergyReservoirStorage) = value.prime_mover_type
"""Get [`EnergyReservoirStorage`](@ref) `storage_technology_type`."""
get_storage_technology_type(value::EnergyReservoirStorage) = value.storage_technology_type
"""Get [`EnergyReservoirStorage`](@ref) `initial_energy`."""
get_initial_energy(value::EnergyReservoirStorage) = get_value(value, value.initial_energy)
"""Get [`EnergyReservoirStorage`](@ref) `state_of_charge_limits`."""
get_state_of_charge_limits(value::EnergyReservoirStorage) = get_value(value, value.state_of_charge_limits)
"""Get [`EnergyReservoirStorage`](@ref) `rating`."""
get_rating(value::EnergyReservoirStorage) = get_value(value, value.rating)
"""Get [`EnergyReservoirStorage`](@ref) `active_power`."""
get_active_power(value::EnergyReservoirStorage) = get_value(value, value.active_power)
"""Get [`EnergyReservoirStorage`](@ref) `input_active_power_limits`."""
get_input_active_power_limits(value::EnergyReservoirStorage) = get_value(value, value.input_active_power_limits)
"""Get [`EnergyReservoirStorage`](@ref) `output_active_power_limits`."""
get_output_active_power_limits(value::EnergyReservoirStorage) = get_value(value, value.output_active_power_limits)
"""Get [`EnergyReservoirStorage`](@ref) `efficiency`."""
get_efficiency(value::EnergyReservoirStorage) = value.efficiency
"""Get [`EnergyReservoirStorage`](@ref) `reactive_power`."""
get_reactive_power(value::EnergyReservoirStorage) = get_value(value, value.reactive_power)
"""Get [`EnergyReservoirStorage`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::EnergyReservoirStorage) = get_value(value, value.reactive_power_limits)
"""Get [`EnergyReservoirStorage`](@ref) `base_power`."""
get_base_power(value::EnergyReservoirStorage) = value.base_power
"""Get [`EnergyReservoirStorage`](@ref) `operation_cost`."""
get_operation_cost(value::EnergyReservoirStorage) = value.operation_cost
"""Get [`EnergyReservoirStorage`](@ref) `storage_target`."""
get_storage_target(value::EnergyReservoirStorage) = value.storage_target
"""Get [`EnergyReservoirStorage`](@ref) `cycle_limits`."""
get_cycle_limits(value::EnergyReservoirStorage) = value.cycle_limits
"""Get [`EnergyReservoirStorage`](@ref) `services`."""
get_services(value::EnergyReservoirStorage) = value.services
"""Get [`EnergyReservoirStorage`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::EnergyReservoirStorage) = value.dynamic_injector
"""Get [`EnergyReservoirStorage`](@ref) `ext`."""
get_ext(value::EnergyReservoirStorage) = value.ext
"""Get [`EnergyReservoirStorage`](@ref) `internal`."""
get_internal(value::EnergyReservoirStorage) = value.internal

"""Set [`EnergyReservoirStorage`](@ref) `available`."""
set_available!(value::EnergyReservoirStorage, val) = value.available = val
"""Set [`EnergyReservoirStorage`](@ref) `bus`."""
set_bus!(value::EnergyReservoirStorage, val) = value.bus = val
"""Set [`EnergyReservoirStorage`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::EnergyReservoirStorage, val) = value.prime_mover_type = val
"""Set [`EnergyReservoirStorage`](@ref) `storage_technology_type`."""
set_storage_technology_type!(value::EnergyReservoirStorage, val) = value.storage_technology_type = val
"""Set [`EnergyReservoirStorage`](@ref) `initial_energy`."""
set_initial_energy!(value::EnergyReservoirStorage, val) = value.initial_energy = set_value(value, val)
"""Set [`EnergyReservoirStorage`](@ref) `state_of_charge_limits`."""
set_state_of_charge_limits!(value::EnergyReservoirStorage, val) = value.state_of_charge_limits = set_value(value, val)
"""Set [`EnergyReservoirStorage`](@ref) `rating`."""
set_rating!(value::EnergyReservoirStorage, val) = value.rating = set_value(value, val)
"""Set [`EnergyReservoirStorage`](@ref) `active_power`."""
set_active_power!(value::EnergyReservoirStorage, val) = value.active_power = set_value(value, val)
"""Set [`EnergyReservoirStorage`](@ref) `input_active_power_limits`."""
set_input_active_power_limits!(value::EnergyReservoirStorage, val) = value.input_active_power_limits = set_value(value, val)
"""Set [`EnergyReservoirStorage`](@ref) `output_active_power_limits`."""
set_output_active_power_limits!(value::EnergyReservoirStorage, val) = value.output_active_power_limits = set_value(value, val)
"""Set [`EnergyReservoirStorage`](@ref) `efficiency`."""
set_efficiency!(value::EnergyReservoirStorage, val) = value.efficiency = val
"""Set [`EnergyReservoirStorage`](@ref) `reactive_power`."""
set_reactive_power!(value::EnergyReservoirStorage, val) = value.reactive_power = set_value(value, val)
"""Set [`EnergyReservoirStorage`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::EnergyReservoirStorage, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`EnergyReservoirStorage`](@ref) `base_power`."""
set_base_power!(value::EnergyReservoirStorage, val) = value.base_power = val
"""Set [`EnergyReservoirStorage`](@ref) `operation_cost`."""
set_operation_cost!(value::EnergyReservoirStorage, val) = value.operation_cost = val
"""Set [`EnergyReservoirStorage`](@ref) `storage_target`."""
set_storage_target!(value::EnergyReservoirStorage, val) = value.storage_target = val
"""Set [`EnergyReservoirStorage`](@ref) `cycle_limits`."""
set_cycle_limits!(value::EnergyReservoirStorage, val) = value.cycle_limits = val
"""Set [`EnergyReservoirStorage`](@ref) `services`."""
set_services!(value::EnergyReservoirStorage, val) = value.services = val
"""Set [`EnergyReservoirStorage`](@ref) `ext`."""
set_ext!(value::EnergyReservoirStorage, val) = value.ext = val
