#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct PowerLoad <: StaticLoad
        name::String
        available::Bool
        bus::ACBus
        active_power::Float64
        reactive_power::Float64
        base_power::Float64
        max_active_power::Float64
        max_reactive_power::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Data structure for a static power load.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `bus::ACBus`: Bus that this component is connected to
- `active_power::Float64`: Initial active power set point of the unit in MW. For power flow, this is the steady state operating point of the system. For production cost modeling, this may or may not be used as the initial starting point for the solver, depending on the solver used.
- `reactive_power::Float64`: Initial reactive power set point of the unit (MVAR)
- `base_power::Float64`: Base power of the unit (MVA) for per unitization, which is commonly the same as `rating`., validation range: `(0, nothing)`
- `max_active_power::Float64`:
- `max_reactive_power::Float64`:
- `services::Vector{Service}`: (default: `Device[]`) (optional) Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: (default: `nothing`) (optional) corresponding dynamic injection device
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct PowerLoad <: StaticLoad
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

function PowerLoad(name, available, bus, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    PowerLoad(name, available, bus, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function PowerLoad(; name, available, bus, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    PowerLoad(name, available, bus, active_power, reactive_power, base_power, max_active_power, max_reactive_power, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function PowerLoad(::Nothing)
    PowerLoad(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        active_power=0.0,
        reactive_power=0.0,
        base_power=0.0,
        max_active_power=0.0,
        max_reactive_power=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`PowerLoad`](@ref) `name`."""
get_name(value::PowerLoad) = value.name
"""Get [`PowerLoad`](@ref) `available`."""
get_available(value::PowerLoad) = value.available
"""Get [`PowerLoad`](@ref) `bus`."""
get_bus(value::PowerLoad) = value.bus
"""Get [`PowerLoad`](@ref) `active_power`."""
get_active_power(value::PowerLoad) = get_value(value, value.active_power)
"""Get [`PowerLoad`](@ref) `reactive_power`."""
get_reactive_power(value::PowerLoad) = get_value(value, value.reactive_power)
"""Get [`PowerLoad`](@ref) `base_power`."""
get_base_power(value::PowerLoad) = value.base_power
"""Get [`PowerLoad`](@ref) `max_active_power`."""
get_max_active_power(value::PowerLoad) = get_value(value, value.max_active_power)
"""Get [`PowerLoad`](@ref) `max_reactive_power`."""
get_max_reactive_power(value::PowerLoad) = get_value(value, value.max_reactive_power)
"""Get [`PowerLoad`](@ref) `services`."""
get_services(value::PowerLoad) = value.services
"""Get [`PowerLoad`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::PowerLoad) = value.dynamic_injector
"""Get [`PowerLoad`](@ref) `ext`."""
get_ext(value::PowerLoad) = value.ext
"""Get [`PowerLoad`](@ref) `internal`."""
get_internal(value::PowerLoad) = value.internal

"""Set [`PowerLoad`](@ref) `available`."""
set_available!(value::PowerLoad, val) = value.available = val
"""Set [`PowerLoad`](@ref) `bus`."""
set_bus!(value::PowerLoad, val) = value.bus = val
"""Set [`PowerLoad`](@ref) `active_power`."""
set_active_power!(value::PowerLoad, val) = value.active_power = set_value(value, val)
"""Set [`PowerLoad`](@ref) `reactive_power`."""
set_reactive_power!(value::PowerLoad, val) = value.reactive_power = set_value(value, val)
"""Set [`PowerLoad`](@ref) `base_power`."""
set_base_power!(value::PowerLoad, val) = value.base_power = val
"""Set [`PowerLoad`](@ref) `max_active_power`."""
set_max_active_power!(value::PowerLoad, val) = value.max_active_power = set_value(value, val)
"""Set [`PowerLoad`](@ref) `max_reactive_power`."""
set_max_reactive_power!(value::PowerLoad, val) = value.max_reactive_power = set_value(value, val)
"""Set [`PowerLoad`](@ref) `services`."""
set_services!(value::PowerLoad, val) = value.services = val
"""Set [`PowerLoad`](@ref) `ext`."""
set_ext!(value::PowerLoad, val) = value.ext = val
