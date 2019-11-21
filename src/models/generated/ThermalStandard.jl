#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ThermalStandard <: ThermalGen
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        tech::Union{Nothing, TechThermal}
        op_cost::ThreePartCost
        _forecasts::InfrastructureSystems.Forecasts
        ext::Union{Nothing, Dict{String, Any}}
        internal::InfrastructureSystemsInternal
    end

Data Structure for thermal generation technologies.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`
- `reactivepower::Float64`
- `tech::Union{Nothing, TechThermal}`
- `op_cost::ThreePartCost`
- `_forecasts::InfrastructureSystems.Forecasts`
- `ext::Union{Nothing, Dict{String, Any}}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ThermalStandard <: ThermalGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::Union{Nothing, TechThermal}
    op_cost::ThreePartCost
    _forecasts::InfrastructureSystems.Forecasts
    ext::Union{Nothing, Dict{String, Any}}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ThermalStandard(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    ThermalStandard(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts, ext, InfrastructureSystemsInternal())
end

function ThermalStandard(; name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts=InfrastructureSystems.Forecasts(), ext=nothing, )
    ThermalStandard(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts, ext, )
end


function ThermalStandard(name, available, bus, activepower, reactivepower, tech, op_cost, ; ext=nothing)
    _forecasts=InfrastructureSystems.Forecasts()
    ThermalStandard(name, available, bus, activepower, reactivepower, tech, op_cost, _forecasts, ext, InfrastructureSystemsInternal())
end

# Constructor for demo purposes; non-functional.

function ThermalStandard(::Nothing)
    ThermalStandard(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechThermal(nothing),
        op_cost=ThreePartCost(nothing),
        _forecasts=InfrastructureSystems.Forecasts(),
        ext=nothing,
    )
end

"""Get ThermalStandard name."""
get_name(value::ThermalStandard) = value.name
"""Get ThermalStandard available."""
get_available(value::ThermalStandard) = value.available
"""Get ThermalStandard bus."""
get_bus(value::ThermalStandard) = value.bus
"""Get ThermalStandard activepower."""
get_activepower(value::ThermalStandard) = value.activepower
"""Get ThermalStandard reactivepower."""
get_reactivepower(value::ThermalStandard) = value.reactivepower
"""Get ThermalStandard tech."""
get_tech(value::ThermalStandard) = value.tech
"""Get ThermalStandard op_cost."""
get_op_cost(value::ThermalStandard) = value.op_cost
"""Get ThermalStandard _forecasts."""
get__forecasts(value::ThermalStandard) = value._forecasts
"""Get ThermalStandard ext."""
get_ext(value::ThermalStandard) = value.ext
"""Get ThermalStandard internal."""
get_internal(value::ThermalStandard) = value.internal
