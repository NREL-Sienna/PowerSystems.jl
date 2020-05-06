#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PowerLoad <: StaticLoad
        name::String
        available::Bool
        bus::Bus
        model::Union{Nothing, LoadModels.LoadModel}
        activepower::Float64
        reactivepower::Float64
        maxactivepower::Float64
        maxreactivepower::Float64
        services::Vector{Service}
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
- `activepower::Float64`
- `reactivepower::Float64`
- `maxactivepower::Float64`
- `maxreactivepower::Float64`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PowerLoad <: StaticLoad
    name::String
    available::Bool
    bus::Bus
    model::Union{Nothing, LoadModels.LoadModel}
    activepower::Float64
    reactivepower::Float64
    maxactivepower::Float64
    maxreactivepower::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PowerLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    PowerLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function PowerLoad(; name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    PowerLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function PowerLoad(::Nothing)
    PowerLoad(;
        name="init",
        available=false,
        bus=Bus(nothing),
        model=nothing,
        activepower=0.0,
        reactivepower=0.0,
        maxactivepower=0.0,
        maxreactivepower=0.0,
        services=Device[],
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
"""Get PowerLoad activepower."""
get_activepower(value::PowerLoad) = value.activepower
"""Get PowerLoad reactivepower."""
get_reactivepower(value::PowerLoad) = value.reactivepower
"""Get PowerLoad maxactivepower."""
get_maxactivepower(value::PowerLoad) = value.maxactivepower
"""Get PowerLoad maxreactivepower."""
get_maxreactivepower(value::PowerLoad) = value.maxreactivepower
"""Get PowerLoad services."""
get_services(value::PowerLoad) = value.services
"""Get PowerLoad ext."""
get_ext(value::PowerLoad) = value.ext

InfrastructureSystems.get_forecasts(value::PowerLoad) = value.forecasts
"""Get PowerLoad internal."""
get_internal(value::PowerLoad) = value.internal


InfrastructureSystems.set_name(value::PowerLoad, val) = value.name = val
"""Set PowerLoad available."""
set_available(value::PowerLoad, val) = value.available = val
"""Set PowerLoad bus."""
set_bus(value::PowerLoad, val) = value.bus = val
"""Set PowerLoad model."""
set_model(value::PowerLoad, val) = value.model = val
"""Set PowerLoad activepower."""
set_activepower(value::PowerLoad, val) = value.activepower = val
"""Set PowerLoad reactivepower."""
set_reactivepower(value::PowerLoad, val) = value.reactivepower = val
"""Set PowerLoad maxactivepower."""
set_maxactivepower(value::PowerLoad, val) = value.maxactivepower = val
"""Set PowerLoad maxreactivepower."""
set_maxreactivepower(value::PowerLoad, val) = value.maxreactivepower = val
"""Set PowerLoad services."""
set_services(value::PowerLoad, val) = value.services = val
"""Set PowerLoad ext."""
set_ext(value::PowerLoad, val) = value.ext = val

InfrastructureSystems.set_forecasts(value::PowerLoad, val) = value.forecasts = val
"""Set PowerLoad internal."""
set_internal(value::PowerLoad, val) = value.internal = val
