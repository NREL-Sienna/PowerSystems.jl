#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct SynchronousCondenser <: StaticInjection
        name::String
        available::Bool
        bus::ACBus
        reactive_power::Float64
        rating::Float64
        reactive_power_limits::Union{Nothing, MinMax}
        base_power::Float64
        must_run::Bool
        active_power_losses::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A Synchronous Machine connected to the system to provide inertia or reactive power support

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `bus::ACBus`: Bus that this component is connected to
- `reactive_power::Float64`: Initial reactive power set point of the unit (MVAR), validation range: `reactive_power_limits`
- `rating::Float64`: Maximum output power rating of the unit (MVA), validation range: `(0, nothing)`
- `reactive_power_limits::Union{Nothing, MinMax}`: Minimum and maximum reactive power limits. Set to `Nothing` if not applicable
- `base_power::Float64`: Base power of the unit (MVA) for [per unitization](@ref per_unit), validation range: `(0, nothing)`
- `must_run::Bool`: (default: `false`) Set to `true` if the unit is must run
- `active_power_losses::Float64`: (default: `0.0`) Active Power Loss incurred by having the unit online., validation range: `(0, nothing)`
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: (default: `nothing`) corresponding dynamic injection device
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct SynchronousCondenser <: StaticInjection
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    "Initial reactive power set point of the unit (MVAR)"
    reactive_power::Float64
    "Maximum output power rating of the unit (MVA)"
    rating::Float64
    "Minimum and maximum reactive power limits. Set to `Nothing` if not applicable"
    reactive_power_limits::Union{Nothing, MinMax}
    "Base power of the unit (MVA) for [per unitization](@ref per_unit)"
    base_power::Float64
    "Set to `true` if the unit is must run"
    must_run::Bool
    "Active Power Loss incurred by having the unit online."
    active_power_losses::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function SynchronousCondenser(name, available, bus, reactive_power, rating, reactive_power_limits, base_power, must_run=false, active_power_losses=0.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), )
    SynchronousCondenser(name, available, bus, reactive_power, rating, reactive_power_limits, base_power, must_run, active_power_losses, services, dynamic_injector, ext, InfrastructureSystemsInternal(), )
end

function SynchronousCondenser(; name, available, bus, reactive_power, rating, reactive_power_limits, base_power, must_run=false, active_power_losses=0.0, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    SynchronousCondenser(name, available, bus, reactive_power, rating, reactive_power_limits, base_power, must_run, active_power_losses, services, dynamic_injector, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function SynchronousCondenser(::Nothing)
    SynchronousCondenser(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        reactive_power=0.0,
        rating=0.0,
        reactive_power_limits=nothing,
        base_power=0.0,
        must_run=false,
        active_power_losses=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
    )
end

"""Get [`SynchronousCondenser`](@ref) `name`."""
get_name(value::SynchronousCondenser) = value.name
"""Get [`SynchronousCondenser`](@ref) `available`."""
get_available(value::SynchronousCondenser) = value.available
"""Get [`SynchronousCondenser`](@ref) `bus`."""
get_bus(value::SynchronousCondenser) = value.bus
"""Get [`SynchronousCondenser`](@ref) `reactive_power`."""
get_reactive_power(value::SynchronousCondenser) = get_value(value, value.reactive_power)
"""Get [`SynchronousCondenser`](@ref) `rating`."""
get_rating(value::SynchronousCondenser) = get_value(value, value.rating)
"""Get [`SynchronousCondenser`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::SynchronousCondenser) = get_value(value, value.reactive_power_limits)
"""Get [`SynchronousCondenser`](@ref) `base_power`."""
get_base_power(value::SynchronousCondenser) = value.base_power
"""Get [`SynchronousCondenser`](@ref) `must_run`."""
get_must_run(value::SynchronousCondenser) = value.must_run
"""Get [`SynchronousCondenser`](@ref) `active_power_losses`."""
get_active_power_losses(value::SynchronousCondenser) = get_value(value, value.active_power_losses)
"""Get [`SynchronousCondenser`](@ref) `services`."""
get_services(value::SynchronousCondenser) = value.services
"""Get [`SynchronousCondenser`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::SynchronousCondenser) = value.dynamic_injector
"""Get [`SynchronousCondenser`](@ref) `ext`."""
get_ext(value::SynchronousCondenser) = value.ext
"""Get [`SynchronousCondenser`](@ref) `internal`."""
get_internal(value::SynchronousCondenser) = value.internal

"""Set [`SynchronousCondenser`](@ref) `available`."""
set_available!(value::SynchronousCondenser, val) = value.available = val
"""Set [`SynchronousCondenser`](@ref) `bus`."""
set_bus!(value::SynchronousCondenser, val) = value.bus = val
"""Set [`SynchronousCondenser`](@ref) `reactive_power`."""
set_reactive_power!(value::SynchronousCondenser, val) = value.reactive_power = set_value(value, val)
"""Set [`SynchronousCondenser`](@ref) `rating`."""
set_rating!(value::SynchronousCondenser, val) = value.rating = set_value(value, val)
"""Set [`SynchronousCondenser`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::SynchronousCondenser, val) = value.reactive_power_limits = set_value(value, val)
"""Set [`SynchronousCondenser`](@ref) `base_power`."""
set_base_power!(value::SynchronousCondenser, val) = value.base_power = val
"""Set [`SynchronousCondenser`](@ref) `must_run`."""
set_must_run!(value::SynchronousCondenser, val) = value.must_run = val
"""Set [`SynchronousCondenser`](@ref) `active_power_losses`."""
set_active_power_losses!(value::SynchronousCondenser, val) = value.active_power_losses = set_value(value, val)
"""Set [`SynchronousCondenser`](@ref) `services`."""
set_services!(value::SynchronousCondenser, val) = value.services = val
"""Set [`SynchronousCondenser`](@ref) `ext`."""
set_ext!(value::SynchronousCondenser, val) = value.ext = val
