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
        storage_capacity::Float64
        inflow::Float64
        initial_storage::Float64
        services::Vector{Service}
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
- `ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: ramp up and ramp down limits, validation range: (0, nothing), action if invalid: error
- `timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: Minimum up and Minimum down time limits in hours, validation range: (0, nothing), action if invalid: error
- `op_cost::TwoPartCost`: Operation Cost of Generation [TwoPartCost](@ref)
- `storage_capacity::Float64`, validation range: (0, nothing), action if invalid: error
- `inflow::Float64`, validation range: (0, nothing), action if invalid: error
- `initial_storage::Float64`, validation range: (0, nothing), action if invalid: error
- `services::Vector{Service}`: Services that this device contributes to
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
    "ramp up and ramp down limits"
    ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "Minimum up and Minimum down time limits in hours"
    timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    "Operation Cost of Generation [TwoPartCost](@ref)"
    op_cost::TwoPartCost
    storage_capacity::Float64
    inflow::Float64
    initial_storage::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HydroEnergyReservoir(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, op_cost, storage_capacity, inflow, initial_storage, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroEnergyReservoir(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, op_cost, storage_capacity, inflow, initial_storage, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HydroEnergyReservoir(; name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, op_cost, storage_capacity, inflow, initial_storage, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroEnergyReservoir(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, op_cost, storage_capacity, inflow, initial_storage, services, ext, forecasts, )
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
        storage_capacity=0.0,
        inflow=0.0,
        initial_storage=0.0,
        services=Device[],
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

InfrastructureSystems.get_forecasts(value::HydroEnergyReservoir) = value.forecasts
"""Get HydroEnergyReservoir internal."""
get_internal(value::HydroEnergyReservoir) = value.internal
