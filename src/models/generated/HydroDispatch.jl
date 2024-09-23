#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct HydroDispatch <: HydroGen
        name::String
        available::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        prime_mover_type::PrimeMovers
        active_power_limits::MinMax
        reactive_power_limits::Union{Nothing, MinMax}
        ramp_limits::Union{Nothing, UpDown}
        time_limits::Union{Nothing, UpDown}
        base_power::Float64
        operation_cost::Union{HydroGenerationCost, MarketBidCost}
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A hydropower generator without a reservoir, suitable for modeling run-of-river hydropower.

For hydro generators with an upper reservoir, see [`HydroEnergyReservoir`](@ref)

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `bus::ACBus`: Bus that this component is connected to
- `active_power::Float64`: Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used
- `reactive_power::Float64`: Initial reactive power set point of the unit (MVAR), validation range: `reactive_power_limits`
- `rating::Float64`: Maximum output power rating of the unit (MVA), validation range: `(0, nothing)`
- `prime_mover_type::PrimeMovers`: Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list)
- `active_power_limits::MinMax`: Minimum and maximum stable active power levels (MW), validation range: `(0, nothing)`
- `reactive_power_limits::Union{Nothing, MinMax}`: Minimum and maximum reactive power limits. Set to `Nothing` if not applicable
- `ramp_limits::Union{Nothing, UpDown}`: ramp up and ramp down limits in MW/min, validation range: `(0, nothing)`
- `time_limits::Union{Nothing, UpDown}`: Minimum up and Minimum down time limits in hours, validation range: `(0, nothing)`
- `base_power::Float64`: Base power of the unit (MVA) for [per unitization](@ref per_unit), validation range: `(0, nothing)`
- `operation_cost::Union{HydroGenerationCost, MarketBidCost}`: (default: `HydroGenerationCost(nothing)`) [`OperationalCost`](@ref) of generation
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: (default: `nothing`) corresponding dynamic injection device
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct HydroDispatch <: HydroGen
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    "Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used"
    active_power::Float64
    "Initial reactive power set point of the unit (MVAR)"
    reactive_power::Float64
    "Maximum output power rating of the unit (MVA)"
    rating::Float64
    "Prime mover technology according to EIA 923. Options are listed [here](@ref pm_list)"
    prime_mover_type::PrimeMovers
    "Minimum and maximum stable active power levels (MW)"
    active_power_limits::MinMax
    "Minimum and maximum reactive power limits. Set to `Nothing` if not applicable"
    reactive_power_limits::Union{Nothing, MinMax}
    "ramp up and ramp down limits in MW/min"
    ramp_limits::Union{Nothing, UpDown}
    "Minimum up and Minimum down time limits in hours"
    time_limits::Union{Nothing, UpDown}
    "Base power of the unit (MVA) for [per unitization](@ref per_unit)"
    base_power::Float64
    "[`OperationalCost`](@ref) of generation"
    operation_cost::Union{HydroGenerationCost, MarketBidCost}
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost=HydroGenerationCost(nothing), services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function HydroDispatch(; name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost=HydroGenerationCost(nothing), services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    HydroDispatch(name, available, bus, active_power, reactive_power, rating, prime_mover_type, active_power_limits, reactive_power_limits, ramp_limits, time_limits, base_power, operation_cost, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function HydroDispatch(::Nothing)
    HydroDispatch(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        prime_mover_type=PrimeMovers.HY,
        active_power_limits=(min=0.0, max=0.0),
        reactive_power_limits=nothing,
        ramp_limits=nothing,
        time_limits=nothing,
        base_power=0.0,
        operation_cost=HydroGenerationCost(nothing),
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`HydroDispatch`](@ref) `name`."""
get_name(value::HydroDispatch) = value.name
"""Get [`HydroDispatch`](@ref) `available`."""
get_available(value::HydroDispatch) = value.available
"""Get [`HydroDispatch`](@ref) `bus`."""
get_bus(value::HydroDispatch) = value.bus
"""Get [`HydroDispatch`](@ref) `active_power`."""
get_active_power(value::HydroDispatch) = get_value(value, value.active_power)
"""Get [`HydroDispatch`](@ref) `reactive_power`."""
get_reactive_power(value::HydroDispatch) = get_value(value, value.reactive_power)
"""Get [`HydroDispatch`](@ref) `rating`."""
get_rating(value::HydroDispatch) = get_value(value, value.rating)
"""Get [`HydroDispatch`](@ref) `prime_mover_type`."""
get_prime_mover_type(value::HydroDispatch) = value.prime_mover_type
"""Get [`HydroDispatch`](@ref) `active_power_limits`."""
get_active_power_limits(value::HydroDispatch) = get_value(value, value.active_power_limits)
"""Get [`HydroDispatch`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::HydroDispatch) = get_value(value, value.reactive_power_limits)
"""Get [`HydroDispatch`](@ref) `ramp_limits`."""
get_ramp_limits(value::HydroDispatch) = get_value(value, value.ramp_limits)
"""Get [`HydroDispatch`](@ref) `time_limits`."""
get_time_limits(value::HydroDispatch) = value.time_limits
"""Get [`HydroDispatch`](@ref) `base_power`."""
get_base_power(value::HydroDispatch) = value.base_power
"""Get [`HydroDispatch`](@ref) `operation_cost`."""
get_operation_cost(value::HydroDispatch) = value.operation_cost
"""Get [`HydroDispatch`](@ref) `services`."""
get_services(value::HydroDispatch) = value.services
"""Get [`HydroDispatch`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::HydroDispatch) = value.dynamic_injector
"""Get [`HydroDispatch`](@ref) `ext`."""
get_ext(value::HydroDispatch) = value.ext
"""Get [`HydroDispatch`](@ref) `internal`."""
get_internal(value::HydroDispatch) = value.internal

"""Set [`HydroDispatch`](@ref) `available`."""
set_available!(value::HydroDispatch, val) = value.available = val
"""Set [`HydroDispatch`](@ref) `bus`."""
set_bus!(value::HydroDispatch, val) = value.bus = val
"""Set [`HydroDispatch`](@ref) `active_power`."""
set_active_power!(value::HydroDispatch, val) = value.active_power = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `reactive_power`."""
set_reactive_power!(value::HydroDispatch, val) = value.reactive_power = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `rating`."""
set_rating!(value::HydroDispatch, val) = value.rating = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `prime_mover_type`."""
set_prime_mover_type!(value::HydroDispatch, val) = value.prime_mover_type = val
"""Set [`HydroDispatch`](@ref) `active_power_limits`."""
set_active_power_limits!(value::HydroDispatch, val) = value.active_power_limits = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::HydroDispatch, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `ramp_limits`."""
set_ramp_limits!(value::HydroDispatch, val) = value.ramp_limits = set_value(value, val)
"""Set [`HydroDispatch`](@ref) `time_limits`."""
set_time_limits!(value::HydroDispatch, val) = value.time_limits = val
"""Set [`HydroDispatch`](@ref) `base_power`."""
set_base_power!(value::HydroDispatch, val) = value.base_power = val
"""Set [`HydroDispatch`](@ref) `operation_cost`."""
set_operation_cost!(value::HydroDispatch, val) = value.operation_cost = val
"""Set [`HydroDispatch`](@ref) `services`."""
set_services!(value::HydroDispatch, val) = value.services = val
"""Set [`HydroDispatch`](@ref) `ext`."""
set_ext!(value::HydroDispatch, val) = value.ext = val
