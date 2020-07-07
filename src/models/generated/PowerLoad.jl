#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PowerLoad <: StaticLoad
        name::String
        available::Bool
        bus::Bus
        model::Union{Nothing, LoadModels.LoadModel}
        active_power::Float64
        reactive_power::Float64
        max_active_power::Float64
        max_reactive_power::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data structure for a static power load.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `model::Union{Nothing, LoadModels.LoadModel}`
- `active_power::Float64`
- `reactive_power::Float64`
- `max_active_power::Float64`
- `max_reactive_power::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PowerLoad <: StaticLoad
    name::String
    available::Bool
    bus::Bus
    model::Union{Nothing, LoadModels.LoadModel}
    active_power::Float64
    reactive_power::Float64
    max_active_power::Float64
    max_reactive_power::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PowerLoad(name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    PowerLoad(name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function PowerLoad(; name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    PowerLoad(name, available, bus, model, active_power, reactive_power, max_active_power, max_reactive_power, services, dynamic_injector, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function PowerLoad(::Nothing)
    PowerLoad(;
        name="init",
        available=false,
        bus=Bus(nothing),
        model=nothing,
        active_power=0.0,
        reactive_power=0.0,
        max_active_power=0.0,
        max_reactive_power=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::PowerLoad) = value.name
"""Get PowerLoad available."""
get_available(value::PowerLoad) = value.available
"""Get PowerLoad bus."""
get_bus(value::PowerLoad) = value.bus
"""Get PowerLoad model."""
get_model(value::PowerLoad) = value.model
"""Get PowerLoad active_power."""
get_active_power(value::PowerLoad) = get_value(value, :active_power)
"""Get PowerLoad reactive_power."""
get_reactive_power(value::PowerLoad) = get_value(value, :reactive_power)
"""Get PowerLoad max_active_power."""
get_max_active_power(value::PowerLoad) = get_value(value, :max_active_power)
"""Get PowerLoad max_reactive_power."""
get_max_reactive_power(value::PowerLoad) = get_value(value, :max_reactive_power)
"""Get PowerLoad services."""
get_services(value::PowerLoad) = value.services
"""Get PowerLoad dynamic_injector."""
get_dynamic_injector(value::PowerLoad) = value.dynamic_injector
"""Get PowerLoad ext."""
get_ext(value::PowerLoad) = value.ext

InfrastructureSystems.get_forecasts(value::PowerLoad) = value.forecasts
"""Get PowerLoad internal."""
get_internal(value::PowerLoad) = value.internal


InfrastructureSystems.set_name!(value::PowerLoad, val::String) = value.name = val
"""Set PowerLoad available."""
set_available!(value::PowerLoad, val::Bool) = value.available = val
"""Set PowerLoad bus."""
set_bus!(value::PowerLoad, val::Bus) = value.bus = val
"""Set PowerLoad model."""
set_model!(value::PowerLoad, val::Union{Nothing, LoadModels.LoadModel}) = value.model = val
"""Set PowerLoad active_power."""
set_active_power!(value::PowerLoad, val::Float64) = value.active_power = val
"""Set PowerLoad reactive_power."""
set_reactive_power!(value::PowerLoad, val::Float64) = value.reactive_power = val
"""Set PowerLoad max_active_power."""
set_max_active_power!(value::PowerLoad, val::Float64) = value.max_active_power = val
"""Set PowerLoad max_reactive_power."""
set_max_reactive_power!(value::PowerLoad, val::Float64) = value.max_reactive_power = val
"""Set PowerLoad services."""
set_services!(value::PowerLoad, val::Vector{Service}) = value.services = val
"""Set PowerLoad ext."""
set_ext!(value::PowerLoad, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::PowerLoad, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set PowerLoad internal."""
set_internal!(value::PowerLoad, val::InfrastructureSystemsInternal) = value.internal = val
