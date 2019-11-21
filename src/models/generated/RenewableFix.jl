#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RenewableFix <: RenewableGen
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        tech::TechRenewable
        _forecasts::InfrastructureSystems.Forecasts
        ext::Union{Nothing, Dict{String, Any}}
        internal::InfrastructureSystemsInternal
    end

Data Structure for fixed renewable generation technologies.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`
- `reactivepower::Float64`
- `tech::TechRenewable`
- `_forecasts::InfrastructureSystems.Forecasts`
- `ext::Union{Nothing, Dict{String, Any}}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RenewableFix <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechRenewable
    _forecasts::InfrastructureSystems.Forecasts
    ext::Union{Nothing, Dict{String, Any}}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function RenewableFix(name, available, bus, activepower, reactivepower, tech, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    RenewableFix(name, available, bus, activepower, reactivepower, tech, _forecasts, ext, InfrastructureSystemsInternal())
end

function RenewableFix(; name, available, bus, activepower, reactivepower, tech, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    RenewableFix(name, available, bus, activepower, reactivepower, tech, _forecasts, ext, )
end


function RenewableFix(name, available, bus, activepower, reactivepower, tech, ; ext=nothing)
    _forecasts=InfrastructureSystems.Forecasts()
    RenewableFix(name, available, bus, activepower, reactivepower, tech, _forecasts, ext, InfrastructureSystemsInternal())
end

# Constructor for demo purposes; non-functional.

function RenewableFix(::Nothing)
    RenewableFix(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechRenewable(nothing),
        _forecasts=InfrastructureSystems.Forecasts(),
        ext=nothing,
    )
end

"""Get RenewableFix name."""
get_name(value::RenewableFix) = value.name
"""Get RenewableFix available."""
get_available(value::RenewableFix) = value.available
"""Get RenewableFix bus."""
get_bus(value::RenewableFix) = value.bus
"""Get RenewableFix activepower."""
get_activepower(value::RenewableFix) = value.activepower
"""Get RenewableFix reactivepower."""
get_reactivepower(value::RenewableFix) = value.reactivepower
"""Get RenewableFix tech."""
get_tech(value::RenewableFix) = value.tech
"""Get RenewableFix _forecasts."""
get__forecasts(value::RenewableFix) = value._forecasts
"""Get RenewableFix ext."""
get_ext(value::RenewableFix) = value.ext
"""Get RenewableFix internal."""
get_internal(value::RenewableFix) = value.internal
