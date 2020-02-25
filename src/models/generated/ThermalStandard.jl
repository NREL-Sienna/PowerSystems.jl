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
        services::Vector{Service}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for thermal generation technologies.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`, validation range: tech.activepowerlimits, action if invalid: warn
- `reactivepower::Float64`, validation range: tech.reactivepowerlimits, action if invalid: warn
- `tech::Union{Nothing, TechThermal}`
- `op_cost::ThreePartCost`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
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
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ThermalStandard(name, available, bus, activepower, reactivepower, tech, op_cost, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    ThermalStandard(name, available, bus, activepower, reactivepower, tech, op_cost, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function ThermalStandard(; name, available, bus, activepower, reactivepower, tech, op_cost, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    ThermalStandard(name, available, bus, activepower, reactivepower, tech, op_cost, services, ext, forecasts, )
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
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::ThermalStandard) = value.name
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
"""Get ThermalStandard services."""
get_services(value::ThermalStandard) = value.services
"""Get ThermalStandard ext."""
get_ext(value::ThermalStandard) = value.ext

InfrastructureSystems.get_forecasts(value::ThermalStandard) = value.forecasts
"""Get ThermalStandard internal."""
get_internal(value::ThermalStandard) = value.internal
