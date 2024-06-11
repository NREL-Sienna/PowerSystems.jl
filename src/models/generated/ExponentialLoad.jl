#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ExponentialLoad <: StaticLoad
        name::String
        available::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        active_power_coefficient::Float64
        reactive_power_coefficient::Float64
        base_power::Float64
        max_active_power::Float64
        max_reactive_power::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Data structure for a static exponential load.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `bus::ACBus`: Bus that this component is connected to
- `active_power::Float64`: Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used.
- `reactive_power::Float64`: Initial reactive power set point of the unit (MVAR)
- `active_power_coefficient::Float64`: Coefficient relating voltage dependence for power P = P0 * V^α, validation range: `(0, nothing)`
- `reactive_power_coefficient::Float64`: Coefficient relating voltage dependence for power Q = Q0 * V^β, validation range: `(0, nothing)`
- `base_power::Float64`: Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`., validation range: `(0, nothing)`
- `max_active_power::Float64`:
- `max_reactive_power::Float64`:
- `services::Vector{Service}`: (default: `Device[]`) (optional) Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: (default: `nothing`) (optional) corresponding dynamic injection device
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct ExponentialLoad <: StaticLoad
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    "Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used."
    active_power::Float64
    "Initial reactive power set point of the unit (MVAR)"
    reactive_power::Float64
    "Coefficient relating voltage dependence for power P = P0 * V^α"
    active_power_coefficient::Float64
    "Coefficient relating voltage dependence for power Q = Q0 * V^β"
    reactive_power_coefficient::Float64
    "Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`."
    base_power::Float64
    max_active_power::Float64
    max_reactive_power::Float64
    "(optional) Services that this device contributes to"
    services::Vector{Service}
    "(optional) corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function ExponentialLoad(name, available, bus, active_power, reactive_power, active_power_coefficient, reactive_power_coefficient, base_power, max_active_power, max_reactive_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    ExponentialLoad(name, available, bus, active_power, reactive_power, active_power_coefficient, reactive_power_coefficient, base_power, max_active_power, max_reactive_power, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function ExponentialLoad(; name, available, bus, active_power, reactive_power, active_power_coefficient, reactive_power_coefficient, base_power, max_active_power, max_reactive_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    ExponentialLoad(name, available, bus, active_power, reactive_power, active_power_coefficient, reactive_power_coefficient, base_power, max_active_power, max_reactive_power, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function ExponentialLoad(::Nothing)
    ExponentialLoad(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        active_power_coefficient=0.0,
        reactive_power_coefficient=0.0,
        base_power=0.0,
        max_active_power=0.0,
        max_reactive_power=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ExponentialLoad`](@ref) `name`."""
get_name(value::ExponentialLoad) = value.name
"""Get [`ExponentialLoad`](@ref) `available`."""
get_available(value::ExponentialLoad) = value.available
"""Get [`ExponentialLoad`](@ref) `bus`."""
get_bus(value::ExponentialLoad) = value.bus
"""Get [`ExponentialLoad`](@ref) `active_power`."""
get_active_power(value::ExponentialLoad) = get_value(value, value.active_power)
"""Get [`ExponentialLoad`](@ref) `reactive_power`."""
get_reactive_power(value::ExponentialLoad) = get_value(value, value.reactive_power)
"""Get [`ExponentialLoad`](@ref) `active_power_coefficient`."""
get_active_power_coefficient(value::ExponentialLoad) = value.active_power_coefficient
"""Get [`ExponentialLoad`](@ref) `reactive_power_coefficient`."""
get_reactive_power_coefficient(value::ExponentialLoad) = value.reactive_power_coefficient
"""Get [`ExponentialLoad`](@ref) `base_power`."""
get_base_power(value::ExponentialLoad) = value.base_power
"""Get [`ExponentialLoad`](@ref) `max_active_power`."""
get_max_active_power(value::ExponentialLoad) = get_value(value, value.max_active_power)
"""Get [`ExponentialLoad`](@ref) `max_reactive_power`."""
get_max_reactive_power(value::ExponentialLoad) = get_value(value, value.max_reactive_power)
"""Get [`ExponentialLoad`](@ref) `services`."""
get_services(value::ExponentialLoad) = value.services
"""Get [`ExponentialLoad`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::ExponentialLoad) = value.dynamic_injector
"""Get [`ExponentialLoad`](@ref) `ext`."""
get_ext(value::ExponentialLoad) = value.ext
"""Get [`ExponentialLoad`](@ref) `internal`."""
get_internal(value::ExponentialLoad) = value.internal

"""Set [`ExponentialLoad`](@ref) `available`."""
set_available!(value::ExponentialLoad, val) = value.available = val
"""Set [`ExponentialLoad`](@ref) `bus`."""
set_bus!(value::ExponentialLoad, val) = value.bus = val
"""Set [`ExponentialLoad`](@ref) `active_power`."""
set_active_power!(value::ExponentialLoad, val) = value.active_power = set_value(value, val)
"""Set [`ExponentialLoad`](@ref) `reactive_power`."""
set_reactive_power!(value::ExponentialLoad, val) = value.reactive_power = set_value(value, val)
"""Set [`ExponentialLoad`](@ref) `active_power_coefficient`."""
set_active_power_coefficient!(value::ExponentialLoad, val) = value.active_power_coefficient = val
"""Set [`ExponentialLoad`](@ref) `reactive_power_coefficient`."""
set_reactive_power_coefficient!(value::ExponentialLoad, val) = value.reactive_power_coefficient = val
"""Set [`ExponentialLoad`](@ref) `base_power`."""
set_base_power!(value::ExponentialLoad, val) = value.base_power = val
"""Set [`ExponentialLoad`](@ref) `max_active_power`."""
set_max_active_power!(value::ExponentialLoad, val) = value.max_active_power = set_value(value, val)
"""Set [`ExponentialLoad`](@ref) `max_reactive_power`."""
set_max_reactive_power!(value::ExponentialLoad, val) = value.max_reactive_power = set_value(value, val)
"""Set [`ExponentialLoad`](@ref) `services`."""
set_services!(value::ExponentialLoad, val) = value.services = val
"""Set [`ExponentialLoad`](@ref) `ext`."""
set_ext!(value::ExponentialLoad, val) = value.ext = val
