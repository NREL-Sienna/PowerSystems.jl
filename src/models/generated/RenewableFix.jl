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
        ext::Dict{String, Any}
        _forecasts::InfrastructureSystems.Forecasts
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
- `ext::Dict{String, Any}`
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RenewableFix <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechRenewable
    ext::Dict{String, Any}
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function RenewableFix(name, available, bus, activepower, reactivepower, tech, ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    RenewableFix(name, available, bus, activepower, reactivepower, tech, ext, _forecasts, InfrastructureSystemsInternal())
end

function RenewableFix(; name, available, bus, activepower, reactivepower, tech, ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    RenewableFix(name, available, bus, activepower, reactivepower, tech, ext, _forecasts, )
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
        ext=Dict{String, Any}(),
        _forecasts=InfrastructureSystems.Forecasts(),
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
"""Get RenewableFix ext."""
get_ext(value::RenewableFix) = value.ext
"""Get RenewableFix _forecasts."""
get__forecasts(value::RenewableFix) = value._forecasts
"""Get RenewableFix internal."""
get_internal(value::RenewableFix) = value.internal
