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
        rating::Float64
        primemover::PrimeMovers.PrimeMover
        activepowerlimits::Min_Max
        reactivepowerlimits::Union{Nothing, Min_Max}
        ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        op_cost::TwoPartCost
        basepower::Float64
        storage_capacity::Float64
        inflow::Float64
        initial_storage::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`
- `reactivepower::Float64`, validation range: reactivepowerlimits, action if invalid: warn
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `primemover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `activepowerlimits::Min_Max`
- `reactivepowerlimits::Union{Nothing, Min_Max}`, action if invalid: warn
- `ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: ramp up and ramp down limits in MW (in component base per unit) per minute, validation range: (0, nothing), action if invalid: error
- `timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: Minimum up and Minimum down time limits in hours, validation range: (0, nothing), action if invalid: error
- `op_cost::TwoPartCost`: Operation Cost of Generation [`TwoPartCost`](@ref)
- `basepower::Float64`: Base power of the unit in system base per unit, validation range: (0, nothing), action if invalid: warn
- `storage_capacity::Float64`, validation range: (0, nothing), action if invalid: error
- `inflow::Float64`, validation range: (0, nothing), action if invalid: error
- `initial_storage::Float64`, validation range: (0, nothing), action if invalid: error
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroEnergyReservoir <: HydroGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "PrimeMover Technology according to EIA 923"
    primemover::PrimeMovers.PrimeMover
    activepowerlimits::Min_Max
    reactivepowerlimits::Union{Nothing, Min_Max}
    "ramp up and ramp down limits in MW (in component base per unit) per minute"
    ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "Minimum up and Minimum down time limits in hours"
    timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "Operation Cost of Generation [`TwoPartCost`](@ref)"
    op_cost::TwoPartCost
    "Base power of the unit in system base per unit"
    basepower::Float64
    storage_capacity::Float64
    inflow::Float64
    initial_storage::Float64
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

function HydroEnergyReservoir(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, op_cost, basepower, storage_capacity, inflow, initial_storage, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroEnergyReservoir(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, op_cost, basepower, storage_capacity, inflow, initial_storage, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HydroEnergyReservoir(; name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, op_cost, basepower, storage_capacity, inflow, initial_storage, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroEnergyReservoir(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, op_cost, basepower, storage_capacity, inflow, initial_storage, services, dynamic_injector, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function HydroEnergyReservoir(::Nothing)
    HydroEnergyReservoir(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        rating=0.0,
        primemover=PrimeMovers.HY,
        activepowerlimits=(min=0.0, max=0.0),
        reactivepowerlimits=nothing,
        ramplimits=nothing,
        timelimits=nothing,
        op_cost=TwoPartCost(nothing),
        basepower=0.0,
        storage_capacity=0.0,
        inflow=0.0,
        initial_storage=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::HydroEnergyReservoir) = value.name
"""Get HydroEnergyReservoir available."""
get_available(value::HydroEnergyReservoir) = value.available
"""Get HydroEnergyReservoir bus."""
get_bus(value::HydroEnergyReservoir) = value.bus
"""Get HydroEnergyReservoir activepower."""
get_activepower(value::HydroEnergyReservoir) = value.activepower
"""Get HydroEnergyReservoir reactivepower."""
get_reactivepower(value::HydroEnergyReservoir) = value.reactivepower
"""Get HydroEnergyReservoir rating."""
get_rating(value::HydroEnergyReservoir) = value.rating
"""Get HydroEnergyReservoir primemover."""
get_primemover(value::HydroEnergyReservoir) = value.primemover
"""Get HydroEnergyReservoir activepowerlimits."""
get_activepowerlimits(value::HydroEnergyReservoir) = value.activepowerlimits
"""Get HydroEnergyReservoir reactivepowerlimits."""
get_reactivepowerlimits(value::HydroEnergyReservoir) = value.reactivepowerlimits
"""Get HydroEnergyReservoir ramplimits."""
get_ramplimits(value::HydroEnergyReservoir) = value.ramplimits
"""Get HydroEnergyReservoir timelimits."""
get_timelimits(value::HydroEnergyReservoir) = value.timelimits
"""Get HydroEnergyReservoir op_cost."""
get_op_cost(value::HydroEnergyReservoir) = value.op_cost
"""Get HydroEnergyReservoir basepower."""
get_basepower(value::HydroEnergyReservoir) = value.basepower
"""Get HydroEnergyReservoir storage_capacity."""
get_storage_capacity(value::HydroEnergyReservoir) = value.storage_capacity
"""Get HydroEnergyReservoir inflow."""
get_inflow(value::HydroEnergyReservoir) = value.inflow
"""Get HydroEnergyReservoir initial_storage."""
get_initial_storage(value::HydroEnergyReservoir) = value.initial_storage
"""Get HydroEnergyReservoir services."""
get_services(value::HydroEnergyReservoir) = value.services
"""Get HydroEnergyReservoir dynamic_injector."""
get_dynamic_injector(value::HydroEnergyReservoir) = value.dynamic_injector
"""Get HydroEnergyReservoir ext."""
get_ext(value::HydroEnergyReservoir) = value.ext

InfrastructureSystems.get_forecasts(value::HydroEnergyReservoir) = value.forecasts
"""Get HydroEnergyReservoir internal."""
get_internal(value::HydroEnergyReservoir) = value.internal


InfrastructureSystems.set_name!(value::HydroEnergyReservoir, val::String) = value.name = val
"""Set HydroEnergyReservoir available."""
set_available!(value::HydroEnergyReservoir, val::Bool) = value.available = val
"""Set HydroEnergyReservoir bus."""
set_bus!(value::HydroEnergyReservoir, val::Bus) = value.bus = val
"""Set HydroEnergyReservoir activepower."""
set_activepower!(value::HydroEnergyReservoir, val::Float64) = value.activepower = val
"""Set HydroEnergyReservoir reactivepower."""
set_reactivepower!(value::HydroEnergyReservoir, val::Float64) = value.reactivepower = val
"""Set HydroEnergyReservoir rating."""
set_rating!(value::HydroEnergyReservoir, val::Float64) = value.rating = val
"""Set HydroEnergyReservoir primemover."""
set_primemover!(value::HydroEnergyReservoir, val::PrimeMovers.PrimeMover) = value.primemover = val
"""Set HydroEnergyReservoir activepowerlimits."""
set_activepowerlimits!(value::HydroEnergyReservoir, val::Min_Max) = value.activepowerlimits = val
"""Set HydroEnergyReservoir reactivepowerlimits."""
set_reactivepowerlimits!(value::HydroEnergyReservoir, val::Union{Nothing, Min_Max}) = value.reactivepowerlimits = val
"""Set HydroEnergyReservoir ramplimits."""
set_ramplimits!(value::HydroEnergyReservoir, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.ramplimits = val
"""Set HydroEnergyReservoir timelimits."""
set_timelimits!(value::HydroEnergyReservoir, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.timelimits = val
"""Set HydroEnergyReservoir op_cost."""
set_op_cost!(value::HydroEnergyReservoir, val::TwoPartCost) = value.op_cost = val
"""Set HydroEnergyReservoir basepower."""
set_basepower!(value::HydroEnergyReservoir, val::Float64) = value.basepower = val
"""Set HydroEnergyReservoir storage_capacity."""
set_storage_capacity!(value::HydroEnergyReservoir, val::Float64) = value.storage_capacity = val
"""Set HydroEnergyReservoir inflow."""
set_inflow!(value::HydroEnergyReservoir, val::Float64) = value.inflow = val
"""Set HydroEnergyReservoir initial_storage."""
set_initial_storage!(value::HydroEnergyReservoir, val::Float64) = value.initial_storage = val
"""Set HydroEnergyReservoir services."""
set_services!(value::HydroEnergyReservoir, val::Vector{Service}) = value.services = val
"""Set HydroEnergyReservoir ext."""
set_ext!(value::HydroEnergyReservoir, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::HydroEnergyReservoir, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set HydroEnergyReservoir internal."""
set_internal!(value::HydroEnergyReservoir, val::InfrastructureSystemsInternal) = value.internal = val
