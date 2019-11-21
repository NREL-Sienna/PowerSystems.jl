#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HydroDispatch <: HydroGen
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        tech::TechHydro
        op_cost::TwoPartCost
        _forecasts::InfrastructureSystems.Forecasts
        ext::Union{Nothing, Dict{String, Any}}
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`
- `reactivepower::Float64`
- `tech::TechHydro`
- `op_cost::TwoPartCost`
- `_forecasts::InfrastructureSystems.Forecasts`
- `ext::Union{Nothing, Dict{String, Any}}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroDispatch <: HydroGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechHydro
    op_cost::TwoPartCost
    _forecasts::InfrastructureSystems.Forecasts
    ext::Union{Nothing, Dict{String, Any}}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HydroDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    HydroDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts, ext, InfrastructureSystemsInternal())
end

function HydroDispatch(; name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    HydroDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts, ext, )
end


function HydroDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, ; ext=nothing)
    _forecasts=InfrastructureSystems.Forecasts()
    HydroDispatch(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts, ext, InfrastructureSystemsInternal())
end

# Constructor for demo purposes; non-functional.

function HydroDispatch(::Nothing)
    HydroDispatch(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechHydro(nothing),
        op_cost=TwoPartCost(nothing),
        _forecasts=InfrastructureSystems.Forecasts(),
        ext=nothing,
    )
end

"""Get HydroDispatch name."""
get_name(value::HydroDispatch) = value.name
"""Get HydroDispatch available."""
get_available(value::HydroDispatch) = value.available
"""Get HydroDispatch bus."""
get_bus(value::HydroDispatch) = value.bus
"""Get HydroDispatch activepower."""
get_activepower(value::HydroDispatch) = value.activepower
"""Get HydroDispatch reactivepower."""
get_reactivepower(value::HydroDispatch) = value.reactivepower
"""Get HydroDispatch tech."""
get_tech(value::HydroDispatch) = value.tech
"""Get HydroDispatch op_cost."""
get_op_cost(value::HydroDispatch) = value.op_cost
"""Get HydroDispatch _forecasts."""
get__forecasts(value::HydroDispatch) = value._forecasts
"""Get HydroDispatch ext."""
get_ext(value::HydroDispatch) = value.ext
"""Get HydroDispatch internal."""
get_internal(value::HydroDispatch) = value.internal
