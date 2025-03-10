#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct HydroTurbine <: HydroGen
        name::String
        available::Bool
        reservoir::HydroReservoir
        active_power::Float64
        reactive_power::Float64
        rating::Float64
        active_power_limits::MinMax
        reactive_power_limits::Union{Nothing, MinMax}
        outflow_limits::Union{Nothing, MinMax}
        efficiency::Float64
        ramp_limits::Union{Nothing, UpDown}
        time_limits::Union{Nothing, UpDown}
        base_power::Float64
        operation_cost::Union{HydroGenerationCost, MarketBidCost}
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A hydropower generator that needs to be attached to a reservoir, suitable for modeling indenpendent turbines and reservoirs.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `reservoir::HydroReservoir`: Reservoir that this component is connected to
- `active_power::Float64`: Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used
- `reactive_power::Float64`: Initial reactive power set point of the unit (MVAR), validation range: `reactive_power_limits`
- `rating::Float64`: Maximum output power rating of the unit (MVA), validation range: `(0, nothing)`
- `active_power_limits::MinMax`: Minimum and maximum stable active power levels (MW), validation range: `(0, nothing)`
- `reactive_power_limits::Union{Nothing, MinMax}`: Minimum and maximum reactive power limits. Set to `Nothing` if not applicable
- `outflow_limits::Union{Nothing, MinMax}`: Turbine outflow limits. Set to `Nothing` if not applicable
- `efficiency::Float64`: (default: `1.0`) Turbine efficiency [0, 1.0], validation range: `(0, 1)`
- `ramp_limits::Union{Nothing, UpDown}`: ramp up and ramp down limits in MW/min, validation range: `(0, nothing)`
- `time_limits::Union{Nothing, UpDown}`: Minimum up and Minimum down time limits in hours, validation range: `(0, nothing)`
- `base_power::Float64`: Base power of the unit (MVA) for [per unitization](@ref per_unit), validation range: `(0, nothing)`
- `operation_cost::Union{HydroGenerationCost, MarketBidCost}`: (default: `HydroGenerationCost(nothing)`) [`OperationalCost`](@ref) of generation
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: (default: `nothing`) corresponding dynamic injection device
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct HydroTurbine <: HydroGen
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Reservoir that this component is connected to"
    reservoir::HydroReservoir
    "Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used"
    active_power::Float64
    "Initial reactive power set point of the unit (MVAR)"
    reactive_power::Float64
    "Maximum output power rating of the unit (MVA)"
    rating::Float64
    "Minimum and maximum stable active power levels (MW)"
    active_power_limits::MinMax
    "Minimum and maximum reactive power limits. Set to `Nothing` if not applicable"
    reactive_power_limits::Union{Nothing, MinMax}
    "Turbine outflow limits. Set to `Nothing` if not applicable"
    outflow_limits::Union{Nothing, MinMax}
    "Turbine efficiency [0, 1.0]"
    efficiency::Float64
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

function HydroTurbine(name, available, reservoir, active_power, reactive_power, rating, active_power_limits, reactive_power_limits, outflow_limits, efficiency=1.0, ramp_limits, time_limits, base_power, operation_cost=HydroGenerationCost(nothing), services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    HydroTurbine(name, available, reservoir, active_power, reactive_power, rating, active_power_limits, reactive_power_limits, outflow_limits, efficiency, ramp_limits, time_limits, base_power, operation_cost, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function HydroTurbine(; name, available, reservoir, active_power, reactive_power, rating, active_power_limits, reactive_power_limits, outflow_limits, efficiency=1.0, ramp_limits, time_limits, base_power, operation_cost=HydroGenerationCost(nothing), services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    HydroTurbine(name, available, reservoir, active_power, reactive_power, rating, active_power_limits, reactive_power_limits, outflow_limits, efficiency, ramp_limits, time_limits, base_power, operation_cost, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function HydroTurbine(::Nothing)
    HydroTurbine(;
        name="init",
        available=false,
        reservoir=HydroReservoir(nothing),
        active_power=0.0,
        reactive_power=0.0,
        rating=0.0,
        active_power_limits=(min=0.0, max=0.0),
        reactive_power_limits=nothing,
        outflow_limits=nothing,
        efficiency=0.0,
        ramp_limits=nothing,
        time_limits=nothing,
        base_power=0.0,
        operation_cost=HydroGenerationCost(nothing),
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`HydroTurbine`](@ref) `name`."""
get_name(value::HydroTurbine) = value.name
"""Get [`HydroTurbine`](@ref) `available`."""
get_available(value::HydroTurbine) = value.available
"""Get [`HydroTurbine`](@ref) `reservoir`."""
get_reservoir(value::HydroTurbine) = value.reservoir
"""Get [`HydroTurbine`](@ref) `active_power`."""
get_active_power(value::HydroTurbine) = get_value(value, value.active_power)
"""Get [`HydroTurbine`](@ref) `reactive_power`."""
get_reactive_power(value::HydroTurbine) = get_value(value, value.reactive_power)
"""Get [`HydroTurbine`](@ref) `rating`."""
get_rating(value::HydroTurbine) = get_value(value, value.rating)
"""Get [`HydroTurbine`](@ref) `active_power_limits`."""
get_active_power_limits(value::HydroTurbine) = get_value(value, value.active_power_limits)
"""Get [`HydroTurbine`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::HydroTurbine) = get_value(value, value.reactive_power_limits)
"""Get [`HydroTurbine`](@ref) `outflow_limits`."""
get_outflow_limits(value::HydroTurbine) = get_value(value, value.outflow_limits)
"""Get [`HydroTurbine`](@ref) `efficiency`."""
get_efficiency(value::HydroTurbine) = value.efficiency
"""Get [`HydroTurbine`](@ref) `ramp_limits`."""
get_ramp_limits(value::HydroTurbine) = get_value(value, value.ramp_limits)
"""Get [`HydroTurbine`](@ref) `time_limits`."""
get_time_limits(value::HydroTurbine) = value.time_limits
"""Get [`HydroTurbine`](@ref) `base_power`."""
get_base_power(value::HydroTurbine) = value.base_power
"""Get [`HydroTurbine`](@ref) `operation_cost`."""
get_operation_cost(value::HydroTurbine) = value.operation_cost
"""Get [`HydroTurbine`](@ref) `services`."""
get_services(value::HydroTurbine) = value.services
"""Get [`HydroTurbine`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::HydroTurbine) = value.dynamic_injector
"""Get [`HydroTurbine`](@ref) `ext`."""
get_ext(value::HydroTurbine) = value.ext
"""Get [`HydroTurbine`](@ref) `internal`."""
get_internal(value::HydroTurbine) = value.internal

"""Set [`HydroTurbine`](@ref) `available`."""
set_available!(value::HydroTurbine, val) = value.available = val
"""Set [`HydroTurbine`](@ref) `reservoir`."""
set_reservoir!(value::HydroTurbine, val) = value.reservoir = val
"""Set [`HydroTurbine`](@ref) `active_power`."""
set_active_power!(value::HydroTurbine, val) = value.active_power = set_value(value, val)
"""Set [`HydroTurbine`](@ref) `reactive_power`."""
set_reactive_power!(value::HydroTurbine, val) = value.reactive_power = set_value(value, val)
"""Set [`HydroTurbine`](@ref) `rating`."""
set_rating!(value::HydroTurbine, val) = value.rating = set_value(value, val)
"""Set [`HydroTurbine`](@ref) `active_power_limits`."""
set_active_power_limits!(value::HydroTurbine, val) = value.active_power_limits = set_value(value, val)
"""Set [`HydroTurbine`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::HydroTurbine, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`HydroTurbine`](@ref) `outflow_limits`."""
set_outflow_limits!(value::HydroTurbine, val) = value.outflow_limits = set_value(value, val)
"""Set [`HydroTurbine`](@ref) `efficiency`."""
set_efficiency!(value::HydroTurbine, val) = value.efficiency = val
"""Set [`HydroTurbine`](@ref) `ramp_limits`."""
set_ramp_limits!(value::HydroTurbine, val) = value.ramp_limits = set_value(value, val)
"""Set [`HydroTurbine`](@ref) `time_limits`."""
set_time_limits!(value::HydroTurbine, val) = value.time_limits = val
"""Set [`HydroTurbine`](@ref) `base_power`."""
set_base_power!(value::HydroTurbine, val) = value.base_power = val
"""Set [`HydroTurbine`](@ref) `operation_cost`."""
set_operation_cost!(value::HydroTurbine, val) = value.operation_cost = val
"""Set [`HydroTurbine`](@ref) `services`."""
set_services!(value::HydroTurbine, val) = value.services = val
"""Set [`HydroTurbine`](@ref) `ext`."""
set_ext!(value::HydroTurbine, val) = value.ext = val
