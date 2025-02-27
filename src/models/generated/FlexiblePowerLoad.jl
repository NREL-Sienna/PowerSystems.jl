#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct FlexiblePowerLoad <: ControllableLoad
        name::String
        available::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        max_active_power::Float64
        max_reactive_power::Float64
        base_power::Float64
        balance_time_period::Union{Nothing, Dates.Period}
        operation_cost::Union{LoadCost, MarketBidCost}
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A [static](@ref S) power load that can be partially or completed shifted to later time periods.

 These loads are used to model demand response programs, and were originally developed as a component of a virtual power plant. This load has a target demand profile (set by a [`max_active_power` time series](@ref ts_data) for an operational simulation). Load in the profile can be shifted to later time periods to aid in satisfing other system needs; however, any shifted load must be served within a desingated period of time (e.g., 24 hours), which is set by `balance_time_period`.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `bus::ACBus`: Bus that this component is connected to
- `active_power::Float64`: Initial steady state active power demand (MW)
- `reactive_power::Float64`: Initial steady state reactive power demand (MVAR)
- `max_active_power::Float64`: Maximum active power (MW) that this load can demand
- `max_reactive_power::Float64`: Maximum reactive power (MVAR) that this load can demand
- `base_power::Float64`: Base power (MVA) for [per unitization](@ref per_unit), validation range: `(0, nothing)`
- `balance_time_period::Union{Nothing, Dates.Period}`: Time period during which load must be balanced
- `operation_cost::Union{LoadCost, MarketBidCost}`: [`OperationalCost`](@ref) of interrupting load
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct FlexiblePowerLoad <: ControllableLoad
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    "Initial steady state active power demand (MW)"
    active_power::Float64
    "Initial steady state reactive power demand (MVAR)"
    reactive_power::Float64
    "Maximum active power (MW) that this load can demand"
    max_active_power::Float64
    "Maximum reactive power (MVAR) that this load can demand"
    max_reactive_power::Float64
    "Base power (MVA) for [per unitization](@ref per_unit)"
    base_power::Float64
    "Time period during which load must be balanced"
    balance_time_period::Union{Nothing, Dates.Period}
    "[`OperationalCost`](@ref) of interrupting load"
    operation_cost::Union{LoadCost, MarketBidCost}
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function FlexiblePowerLoad(name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, balance_time_period, operation_cost, services=Device[], ext=Dict{String, Any}(), )
    FlexiblePowerLoad(name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, balance_time_period, operation_cost, services, ext, InfrastructureSystemsInternal(), )
end

function FlexiblePowerLoad(; name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, balance_time_period, operation_cost, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    FlexiblePowerLoad(name, available, bus, active_power, reactive_power, max_active_power, max_reactive_power, base_power, balance_time_period, operation_cost, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function FlexiblePowerLoad(::Nothing)
    FlexiblePowerLoad(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        max_active_power=0.0,
        max_reactive_power=0.0,
        base_power=0.0,
        balance_time_period=Dates.Hour(0),
        operation_cost=LoadCost(nothing),
        services=Device[],
        ext=Dict{String, Any}(),
    )
end

"""Get [`FlexiblePowerLoad`](@ref) `name`."""
get_name(value::FlexiblePowerLoad) = value.name
"""Get [`FlexiblePowerLoad`](@ref) `available`."""
get_available(value::FlexiblePowerLoad) = value.available
"""Get [`FlexiblePowerLoad`](@ref) `bus`."""
get_bus(value::FlexiblePowerLoad) = value.bus
"""Get [`FlexiblePowerLoad`](@ref) `active_power`."""
get_active_power(value::FlexiblePowerLoad) = get_value(value, value.active_power)
"""Get [`FlexiblePowerLoad`](@ref) `reactive_power`."""
get_reactive_power(value::FlexiblePowerLoad) = get_value(value, value.reactive_power)
"""Get [`FlexiblePowerLoad`](@ref) `max_active_power`."""
get_max_active_power(value::FlexiblePowerLoad) = get_value(value, value.max_active_power)
"""Get [`FlexiblePowerLoad`](@ref) `max_reactive_power`."""
get_max_reactive_power(value::FlexiblePowerLoad) = get_value(value, value.max_reactive_power)
"""Get [`FlexiblePowerLoad`](@ref) `base_power`."""
get_base_power(value::FlexiblePowerLoad) = value.base_power
"""Get [`FlexiblePowerLoad`](@ref) `balance_time_period`."""
get_balance_time_period(value::FlexiblePowerLoad) = value.balance_time_period
"""Get [`FlexiblePowerLoad`](@ref) `operation_cost`."""
get_operation_cost(value::FlexiblePowerLoad) = value.operation_cost
"""Get [`FlexiblePowerLoad`](@ref) `services`."""
get_services(value::FlexiblePowerLoad) = value.services
"""Get [`FlexiblePowerLoad`](@ref) `ext`."""
get_ext(value::FlexiblePowerLoad) = value.ext
"""Get [`FlexiblePowerLoad`](@ref) `internal`."""
get_internal(value::FlexiblePowerLoad) = value.internal

"""Set [`FlexiblePowerLoad`](@ref) `available`."""
set_available!(value::FlexiblePowerLoad, val) = value.available = val
"""Set [`FlexiblePowerLoad`](@ref) `bus`."""
set_bus!(value::FlexiblePowerLoad, val) = value.bus = val
"""Set [`FlexiblePowerLoad`](@ref) `active_power`."""
set_active_power!(value::FlexiblePowerLoad, val) = value.active_power = set_value(value, val)
"""Set [`FlexiblePowerLoad`](@ref) `reactive_power`."""
set_reactive_power!(value::FlexiblePowerLoad, val) = value.reactive_power = set_value(value, val)
"""Set [`FlexiblePowerLoad`](@ref) `max_active_power`."""
set_max_active_power!(value::FlexiblePowerLoad, val) = value.max_active_power = set_value(value, val)
"""Set [`FlexiblePowerLoad`](@ref) `max_reactive_power`."""
set_max_reactive_power!(value::FlexiblePowerLoad, val) = value.max_reactive_power = set_value(value, val)
"""Set [`FlexiblePowerLoad`](@ref) `base_power`."""
set_base_power!(value::FlexiblePowerLoad, val) = value.base_power = val
"""Set [`FlexiblePowerLoad`](@ref) `balance_time_period`."""
set_balance_time_period!(value::FlexiblePowerLoad, val) = value.balance_time_period = val
"""Set [`FlexiblePowerLoad`](@ref) `operation_cost`."""
set_operation_cost!(value::FlexiblePowerLoad, val) = value.operation_cost = val
"""Set [`FlexiblePowerLoad`](@ref) `services`."""
set_services!(value::FlexiblePowerLoad, val) = value.services = val
"""Set [`FlexiblePowerLoad`](@ref) `ext`."""
set_ext!(value::FlexiblePowerLoad, val) = value.ext = val
