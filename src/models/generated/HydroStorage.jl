#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct HydroStorage <: HydroGen
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        tech::TechHydro
        op_cost::TwoPartCost
        storagecapacity::Float64
        initial_storage::Float64
        _forecasts::InfrastructureSystems.Forecasts
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
- `storagecapacity::Float64`
- `initial_storage::Float64`
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroStorage <: HydroGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    tech::TechHydro
    op_cost::TwoPartCost
    storagecapacity::Float64
    initial_storage::Float64
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HydroStorage(name, available, bus, activepower, reactivepower, tech, op_cost, storagecapacity, initial_storage, _forecasts=InfrastructureSystems.Forecasts(), )
    HydroStorage(name, available, bus, activepower, reactivepower, tech, op_cost, storagecapacity, initial_storage, _forecasts, InfrastructureSystemsInternal())
end

function HydroStorage(; name, available, bus, activepower, reactivepower, tech, op_cost, storagecapacity, initial_storage, _forecasts=InfrastructureSystems.Forecasts(), )
    HydroStorage(name, available, bus, activepower, reactivepower, tech, op_cost, storagecapacity, initial_storage, _forecasts, )
end

# Constructor for demo purposes; non-functional.

function HydroStorage(::Nothing)
    HydroStorage(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        tech=TechHydro(nothing),
        op_cost=TwoPartCost(nothing),
        storagecapacity=0.0,
        initial_storage=0.0,
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get HydroStorage name."""
get_name(value::HydroStorage) = value.name
"""Get HydroStorage available."""
get_available(value::HydroStorage) = value.available
"""Get HydroStorage bus."""
get_bus(value::HydroStorage) = value.bus
"""Get HydroStorage activepower."""
get_activepower(value::HydroStorage) = value.activepower
"""Get HydroStorage reactivepower."""
get_reactivepower(value::HydroStorage) = value.reactivepower
"""Get HydroStorage tech."""
get_tech(value::HydroStorage) = value.tech
"""Get HydroStorage op_cost."""
get_op_cost(value::HydroStorage) = value.op_cost
"""Get HydroStorage storagecapacity."""
get_storagecapacity(value::HydroStorage) = value.storagecapacity
"""Get HydroStorage initial_storage."""
get_initial_storage(value::HydroStorage) = value.initial_storage
"""Get HydroStorage _forecasts."""
get__forecasts(value::HydroStorage) = value._forecasts
"""Get HydroStorage internal."""
get_internal(value::HydroStorage) = value.internal
