#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct GenericBattery <: Storage
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
        operation_cost::Union{StorageCost, MarketBidCost}
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Data structure for a generic battery

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
- `operation_cost::Union{StorageCost, MarketBidCost}`
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct GenericBattery <: Storage
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
    operation_cost::Union{StorageCost, MarketBidCost}
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function GenericBattery(name, available, bus, prime_mover_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost=StorageCost(nothing), services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    GenericBattery(name, available, bus, prime_mover_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function GenericBattery(; name, available, bus, prime_mover_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost=StorageCost(nothing), services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    GenericBattery(name, available, bus, prime_mover_type, initial_energy, state_of_charge_limits, rating, active_power, input_active_power_limits, output_active_power_limits, efficiency, reactive_power, reactive_power_limits, base_power, operation_cost, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function GenericBattery(::Nothing)
    GenericBattery(;
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
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`GenericBattery`](@ref) `name`."""
get_name(value::GenericBattery) = value.name
"""Get [`GenericBattery`](@ref) `available`."""
get_available(value::GenericBattery) = value.available
"""Get [`GenericBattery`](@ref) `bus`."""
get_bus(value::GenericBattery) = value.bus
"""Get [`GenericBattery`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::GenericBattery) = value.prime_mover_type
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
"""Get [`GenericBattery`](@ref) `internal`."""
get_internal(value::GenericBattery) = value.internal

"""Set [`GenericBattery`](@ref) `available`."""
set_available!(value::GenericBattery, val) = value.available = val
"""Set [`GenericBattery`](@ref) `bus`."""
set_bus!(value::GenericBattery, val) = value.bus = val
"""Set [`GenericBattery`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::GenericBattery, val) = value.prime_mover_type = val
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
