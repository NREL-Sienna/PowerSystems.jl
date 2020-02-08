#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HydroEnergyReservoir <: HydroGen
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        tech::TechHydro
        op_cost::TwoPartCost
        storage_capacity::Float64
        inflow::Float64
        initial_storage::Float64
        services::Vector{Service}
        ext::Dict{String, Any}
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`
- `reactivepower::Float64`, validation range: tech.reactivepowerlimits, action if invalid: warn
- `tech::TechHydro`
- `op_cost::TwoPartCost`
- `storage_capacity::Float64`, validation range: (0, nothing), action if invalid: error
- `inflow::Float64`, validation range: (0, nothing), action if invalid: error
- `initial_storage::Float64`, validation range: (0, nothing), action if invalid: error
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroEnergyReservoir <: HydroGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechHydro
    op_cost::TwoPartCost
    storage_capacity::Float64
    inflow::Float64
    initial_storage::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HydroEnergyReservoir(name, available, bus, activepower, reactivepower, tech, op_cost, storage_capacity, inflow, initial_storage, services=Device[], ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    HydroEnergyReservoir(name, available, bus, activepower, reactivepower, tech, op_cost, storage_capacity, inflow, initial_storage, services, ext, _forecasts, InfrastructureSystemsInternal(), )
end

function HydroEnergyReservoir(; name, available, bus, activepower, reactivepower, tech, op_cost, storage_capacity, inflow, initial_storage, services=Device[], ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    HydroEnergyReservoir(name, available, bus, activepower, reactivepower, tech, op_cost, storage_capacity, inflow, initial_storage, services, ext, _forecasts, )
end

# Constructor for demo purposes; non-functional.
function HydroEnergyReservoir(::Nothing)
    HydroEnergyReservoir(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechHydro(nothing),
        op_cost=TwoPartCost(nothing),
        storage_capacity=0.0,
        inflow=0.0,
        initial_storage=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get HydroEnergyReservoir name."""
InfrastructureSystems.get_name(value::HydroEnergyReservoir) = value.name
"""Get HydroEnergyReservoir available."""
get_available(value::HydroEnergyReservoir) = value.available
"""Get HydroEnergyReservoir bus."""
get_bus(value::HydroEnergyReservoir) = value.bus
"""Get HydroEnergyReservoir activepower."""
get_activepower(value::HydroEnergyReservoir) = value.activepower
"""Get HydroEnergyReservoir reactivepower."""
get_reactivepower(value::HydroEnergyReservoir) = value.reactivepower
"""Get HydroEnergyReservoir tech."""
get_tech(value::HydroEnergyReservoir) = value.tech
"""Get HydroEnergyReservoir op_cost."""
get_op_cost(value::HydroEnergyReservoir) = value.op_cost
"""Get HydroEnergyReservoir storage_capacity."""
get_storage_capacity(value::HydroEnergyReservoir) = value.storage_capacity
"""Get HydroEnergyReservoir inflow."""
get_inflow(value::HydroEnergyReservoir) = value.inflow
"""Get HydroEnergyReservoir initial_storage."""
get_initial_storage(value::HydroEnergyReservoir) = value.initial_storage
"""Get HydroEnergyReservoir services."""
get_services(value::HydroEnergyReservoir) = value.services
"""Get HydroEnergyReservoir ext."""
get_ext(value::HydroEnergyReservoir) = value.ext
"""Get HydroEnergyReservoir _forecasts."""
get__forecasts(value::HydroEnergyReservoir) = value._forecasts
"""Get HydroEnergyReservoir internal."""
get_internal(value::HydroEnergyReservoir) = value.internal
