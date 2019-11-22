#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PowerLoad <: StaticLoad
        name::String
        available::Bool
        bus::Bus
        model::Union{Nothing, LoadModel}
        activepower::Float64
        reactivepower::Float64
        maxactivepower::Float64
        maxreactivepower::Float64
        ext::Dict{String, Any}
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data structure for a static power load.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `model::Union{Nothing, LoadModel}`
- `activepower::Float64`
- `reactivepower::Float64`
- `maxactivepower::Float64`
- `maxreactivepower::Float64`
- `ext::Dict{String, Any}`
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PowerLoad <: StaticLoad
    name::String
    available::Bool
    bus::Bus
    model::Union{Nothing, LoadModel}
    activepower::Float64
    reactivepower::Float64
    maxactivepower::Float64
    maxreactivepower::Float64
    ext::Dict{String, Any}
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PowerLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    PowerLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, ext, _forecasts, InfrastructureSystemsInternal())
end

function PowerLoad(; name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    PowerLoad(name, available, bus, model, activepower, reactivepower, maxactivepower, maxreactivepower, ext, _forecasts, )
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
        ext=Dict{String, Any}(),
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get PowerLoad name."""
get_name(value::PowerLoad) = value.name
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
"""Get PowerLoad ext."""
get_ext(value::PowerLoad) = value.ext
"""Get PowerLoad _forecasts."""
get__forecasts(value::PowerLoad) = value._forecasts
"""Get PowerLoad internal."""
get_internal(value::PowerLoad) = value.internal
