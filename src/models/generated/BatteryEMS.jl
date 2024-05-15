#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct BatteryEMS <: Storage
        name::String
        available::Bool
        bus::ACBus
        prime_mover_type::PrimeMovers
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

Data structure for a battery compatible with energy management formulations.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `bus::ACBus`: Bus that this component is connected to
- `prime_mover_type::PrimeMovers`: Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list).
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
- `operation_cost::StorageCost`: (optional) Operation Cost of Storage [`OperationalCost`](@ref)
- `storage_target::Float64`: (optional) Storage target at the end of simulation as ratio of storage capacity.
- `cycle_limits::Int`: (optional) Storage Maximum number of cycles per year
- `services::Vector{Service}`: (optional) Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: (optional) corresponding dynamic injection device
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct BatteryEMS <: Storage
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    "Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list)."
    prime_mover_type::PrimeMovers
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
    "(optional) Operation Cost of Storage [`OperationalCost`](@ref)"
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

function BatteryEMS(name, available, bus, prime_mover_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost=StorageCost(nothing), storage_target=0.0, cycle_limits=1e4, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    BatteryEMS(name, available, bus, prime_mover_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost, storage_target, cycle_limits, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function BatteryEMS(; name, available, bus, prime_mover_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost=StorageCost(nothing), storage_target=0.0, cycle_limits=1e4, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    BatteryEMS(name, available, bus, prime_mover_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost, storage_target, cycle_limits, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function BatteryEMS(::Nothing)
    BatteryEMS(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        prime_mover_type=PrimeMovers.BA,
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

"""Get [`BatteryEMS`](@ref) `name`."""
get_name(value::BatteryEMS) = value.name
"""Get [`BatteryEMS`](@ref) `available`."""
get_available(value::BatteryEMS) = value.available
"""Get [`BatteryEMS`](@ref) `bus`."""
get_bus(value::BatteryEMS) = value.bus
"""Get [`BatteryEMS`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::BatteryEMS) = value.prime_mover_type
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
"""Get [`BatteryEMS`](@ref) `operation_cost`."""
get_operation_cost(value::BatteryEMS) = value.operation_cost
"""Get [`BatteryEMS`](@ref) `storage_target`."""
get_storage_target(value::BatteryEMS) = value.storage_target
"""Get [`BatteryEMS`](@ref) `cycle_limits`."""
get_cycle_limits(value::BatteryEMS) = value.cycle_limits
"""Get [`BatteryEMS`](@ref) `services`."""
get_services(value::BatteryEMS) = value.services
"""Get [`BatteryEMS`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::BatteryEMS) = value.dynamic_injector
"""Get [`BatteryEMS`](@ref) `ext`."""
get_ext(value::BatteryEMS) = value.ext
"""Get [`BatteryEMS`](@ref) `internal`."""
get_internal(value::BatteryEMS) = value.internal

"""Set [`BatteryEMS`](@ref) `available`."""
set_available!(value::BatteryEMS, val) = value.available = val
"""Set [`BatteryEMS`](@ref) `bus`."""
set_bus!(value::BatteryEMS, val) = value.bus = val
"""Set [`BatteryEMS`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::BatteryEMS, val) = value.prime_mover_type = val
"""Set [`BatteryEMS`](@ref) `initial_energy`."""
set_initial_energy!(value::BatteryEMS, val) = value.initial_energy = set_value(value, val)
"""Set [`BatteryEMS`](@ref) `state_of_charge_limits`."""
set_state_of_charge_limits!(value::BatteryEMS, val) = value.state_of_charge_limits = set_value(value, val)
"""Set [`BatteryEMS`](@ref) `rating`."""
set_rating!(value::BatteryEMS, val) = value.rating = set_value(value, val)
"""Set [`BatteryEMS`](@ref) `active_power`."""
set_active_power!(value::BatteryEMS, val) = value.active_power = set_value(value, val)
"""Set [`BatteryEMS`](@ref) `input_active_power_limits`."""
set_input_active_power_limits!(value::BatteryEMS, val) = value.input_active_power_limits = set_value(value, val)
"""Set [`BatteryEMS`](@ref) `output_active_power_limits`."""
set_output_active_power_limits!(value::BatteryEMS, val) = value.output_active_power_limits = set_value(value, val)
"""Set [`BatteryEMS`](@ref) `efficiency`."""
set_efficiency!(value::BatteryEMS, val) = value.efficiency = val
"""Set [`BatteryEMS`](@ref) `reactive_power`."""
set_reactive_power!(value::BatteryEMS, val) = value.reactive_power = set_value(value, val)
"""Set [`BatteryEMS`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::BatteryEMS, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`BatteryEMS`](@ref) `base_power`."""
set_base_power!(value::BatteryEMS, val) = value.base_power = val
"""Set [`BatteryEMS`](@ref) `operation_cost`."""
set_operation_cost!(value::BatteryEMS, val) = value.operation_cost = val
"""Set [`BatteryEMS`](@ref) `storage_target`."""
set_storage_target!(value::BatteryEMS, val) = value.storage_target = val
"""Set [`BatteryEMS`](@ref) `cycle_limits`."""
set_cycle_limits!(value::BatteryEMS, val) = value.cycle_limits = val
"""Set [`BatteryEMS`](@ref) `services`."""
set_services!(value::BatteryEMS, val) = value.services = val
"""Set [`BatteryEMS`](@ref) `ext`."""
set_ext!(value::BatteryEMS, val) = value.ext = val
