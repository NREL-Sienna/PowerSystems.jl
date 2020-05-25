#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ThermalPGLIB <: ThermalGen
        name::String
        available::Bool
        status::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        rating::Float64
        primemover::PrimeMovers.PrimeMover
        fuel::ThermalFuels.ThermalFuel
        activepowerlimits::Min_Max
        reactivepowerlimits::Union{Nothing, Min_Max}
        ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        powertrajectory::Union{Nothing, NamedTuple{(:startup, :shutdown), Tuple{Float64, Float64}}}
        timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        starttimelimits::Union{Nothing, NamedTuple{(:cold, :warm, :hot), Tuple{Float64, Float64, Float64}}}
        op_cost::PGLIBCost
        services::Vector{Service}
        participation_factor::Float64
        time_at_status::Float64
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for thermal generation technologies.

# Arguments
- `name::String`
- `available::Bool`
- `status::Bool`
- `bus::Bus`
- `activepower::Float64`, validation range: activepowerlimits, action if invalid: warn
- `reactivepower::Float64`, validation range: reactivepowerlimits, action if invalid: warn
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `primemover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `fuel::ThermalFuels.ThermalFuel`: PrimeMover Fuel according to EIA 923
- `activepowerlimits::Min_Max`
- `reactivepowerlimits::Union{Nothing, Min_Max}`
- `ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`, validation range: (0, nothing), action if invalid: error
- `powertrajectory::Union{Nothing, NamedTuple{(:startup, :shutdown), Tuple{Float64, Float64}}}`, validation range: (0, nothing), action if invalid: error
- `timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: Minimum up and Minimum down time limits in hours, validation range: (0, nothing), action if invalid: error
- `starttimelimits::Union{Nothing, NamedTuple{(:cold, :warm, :hot), Tuple{Float64, Float64, Float64}}}`:  Time limits for startup based on turbine temperature in hours, validation range: (0, nothing), action if invalid: error
- `op_cost::PGLIBCost`
- `services::Vector{Service}`: Services that this device contributes to
- `participation_factor::Float64`: AGC Participation Factor, validation range: (0, 1.0), action if invalid: error
- `time_at_status::Float64`
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ThermalPGLIB <: ThermalGen
    name::String
    available::Bool
    status::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "PrimeMover Technology according to EIA 923"
    primemover::PrimeMovers.PrimeMover
    "PrimeMover Fuel according to EIA 923"
    fuel::ThermalFuels.ThermalFuel
    activepowerlimits::Min_Max
    reactivepowerlimits::Union{Nothing, Min_Max}
    ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    powertrajectory::Union{Nothing, NamedTuple{(:startup, :shutdown), Tuple{Float64, Float64}}}
    "Minimum up and Minimum down time limits in hours"
    timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    " Time limits for startup based on turbine temperature in hours"
    starttimelimits::Union{Nothing, NamedTuple{(:cold, :warm, :hot), Tuple{Float64, Float64, Float64}}}
    op_cost::PGLIBCost
    "Services that this device contributes to"
    services::Vector{Service}
    "AGC Participation Factor"
    participation_factor::Float64
    time_at_status::Float64
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ThermalPGLIB(name, available, status, bus, activepower, reactivepower, rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, powertrajectory, timelimits, starttimelimits, op_cost, services=Device[], participation_factor=0.0, time_at_status=INFINITE_TIME, dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    ThermalPGLIB(name, available, status, bus, activepower, reactivepower, rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, powertrajectory, timelimits, starttimelimits, op_cost, services, participation_factor, time_at_status, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function ThermalPGLIB(; name, available, status, bus, activepower, reactivepower, rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, powertrajectory, timelimits, starttimelimits, op_cost, services=Device[], participation_factor=0.0, time_at_status=INFINITE_TIME, dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    ThermalPGLIB(name, available, status, bus, activepower, reactivepower, rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, powertrajectory, timelimits, starttimelimits, op_cost, services, participation_factor, time_at_status, dynamic_injector, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function ThermalPGLIB(::Nothing)
    ThermalPGLIB(;
        name="init",
        available=false,
        status=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        rating=0.0,
        primemover=PrimeMovers.OT,
        fuel=ThermalFuels.OTHER,
        activepowerlimits=(min=0.0, max=0.0),
        reactivepowerlimits=nothing,
        ramplimits=nothing,
        powertrajectory=nothing,
        timelimits=nothing,
        starttimelimits=nothing,
        op_cost=PGLIBCost(nothing),
        services=Device[],
        participation_factor=0.0,
        time_at_status=INFINITE_TIME,
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::ThermalPGLIB) = value.name
"""Get ThermalPGLIB available."""
get_available(value::ThermalPGLIB) = value.available
"""Get ThermalPGLIB status."""
get_status(value::ThermalPGLIB) = value.status
"""Get ThermalPGLIB bus."""
get_bus(value::ThermalPGLIB) = value.bus
"""Get ThermalPGLIB activepower."""
get_activepower(value::ThermalPGLIB) = value.activepower
"""Get ThermalPGLIB reactivepower."""
get_reactivepower(value::ThermalPGLIB) = value.reactivepower
"""Get ThermalPGLIB rating."""
get_rating(value::ThermalPGLIB) = value.rating
"""Get ThermalPGLIB primemover."""
get_primemover(value::ThermalPGLIB) = value.primemover
"""Get ThermalPGLIB fuel."""
get_fuel(value::ThermalPGLIB) = value.fuel
"""Get ThermalPGLIB activepowerlimits."""
get_activepowerlimits(value::ThermalPGLIB) = value.activepowerlimits
"""Get ThermalPGLIB reactivepowerlimits."""
get_reactivepowerlimits(value::ThermalPGLIB) = value.reactivepowerlimits
"""Get ThermalPGLIB ramplimits."""
get_ramplimits(value::ThermalPGLIB) = value.ramplimits
"""Get ThermalPGLIB powertrajectory."""
get_powertrajectory(value::ThermalPGLIB) = value.powertrajectory
"""Get ThermalPGLIB timelimits."""
get_timelimits(value::ThermalPGLIB) = value.timelimits
"""Get ThermalPGLIB starttimelimits."""
get_starttimelimits(value::ThermalPGLIB) = value.starttimelimits
"""Get ThermalPGLIB op_cost."""
get_op_cost(value::ThermalPGLIB) = value.op_cost
"""Get ThermalPGLIB services."""
get_services(value::ThermalPGLIB) = value.services
"""Get ThermalPGLIB participation_factor."""
get_participation_factor(value::ThermalPGLIB) = value.participation_factor
"""Get ThermalPGLIB time_at_status."""
get_time_at_status(value::ThermalPGLIB) = value.time_at_status
"""Get ThermalPGLIB dynamic_injector."""
get_dynamic_injector(value::ThermalPGLIB) = value.dynamic_injector
"""Get ThermalPGLIB ext."""
get_ext(value::ThermalPGLIB) = value.ext

InfrastructureSystems.get_forecasts(value::ThermalPGLIB) = value.forecasts
"""Get ThermalPGLIB internal."""
get_internal(value::ThermalPGLIB) = value.internal


InfrastructureSystems.set_name!(value::ThermalPGLIB, val::String) = value.name = val
"""Set ThermalPGLIB available."""
set_available!(value::ThermalPGLIB, val::Bool) = value.available = val
"""Set ThermalPGLIB status."""
set_status!(value::ThermalPGLIB, val::Bool) = value.status = val
"""Set ThermalPGLIB bus."""
set_bus!(value::ThermalPGLIB, val::Bus) = value.bus = val
"""Set ThermalPGLIB activepower."""
set_activepower!(value::ThermalPGLIB, val::Float64) = value.activepower = val
"""Set ThermalPGLIB reactivepower."""
set_reactivepower!(value::ThermalPGLIB, val::Float64) = value.reactivepower = val
"""Set ThermalPGLIB rating."""
set_rating!(value::ThermalPGLIB, val::Float64) = value.rating = val
"""Set ThermalPGLIB primemover."""
set_primemover!(value::ThermalPGLIB, val::PrimeMovers.PrimeMover) = value.primemover = val
"""Set ThermalPGLIB fuel."""
set_fuel!(value::ThermalPGLIB, val::ThermalFuels.ThermalFuel) = value.fuel = val
"""Set ThermalPGLIB activepowerlimits."""
set_activepowerlimits!(value::ThermalPGLIB, val::Min_Max) = value.activepowerlimits = val
"""Set ThermalPGLIB reactivepowerlimits."""
set_reactivepowerlimits!(value::ThermalPGLIB, val::Union{Nothing, Min_Max}) = value.reactivepowerlimits = val
"""Set ThermalPGLIB ramplimits."""
set_ramplimits!(value::ThermalPGLIB, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.ramplimits = val
"""Set ThermalPGLIB powertrajectory."""
set_powertrajectory!(value::ThermalPGLIB, val::Union{Nothing, NamedTuple{(:startup, :shutdown), Tuple{Float64, Float64}}}) = value.powertrajectory = val
"""Set ThermalPGLIB timelimits."""
set_timelimits!(value::ThermalPGLIB, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.timelimits = val
"""Set ThermalPGLIB starttimelimits."""
set_starttimelimits!(value::ThermalPGLIB, val::Union{Nothing, NamedTuple{(:cold, :warm, :hot), Tuple{Float64, Float64, Float64}}}) = value.starttimelimits = val
"""Set ThermalPGLIB op_cost."""
set_op_cost!(value::ThermalPGLIB, val::PGLIBCost) = value.op_cost = val
"""Set ThermalPGLIB services."""
set_services!(value::ThermalPGLIB, val::Vector{Service}) = value.services = val
"""Set ThermalPGLIB participation_factor."""
set_participation_factor!(value::ThermalPGLIB, val::Float64) = value.participation_factor = val
"""Set ThermalPGLIB time_at_status."""
set_time_at_status!(value::ThermalPGLIB, val::Float64) = value.time_at_status = val
"""Set ThermalPGLIB ext."""
set_ext!(value::ThermalPGLIB, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::ThermalPGLIB, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set ThermalPGLIB internal."""
set_internal!(value::ThermalPGLIB, val::InfrastructureSystemsInternal) = value.internal = val
