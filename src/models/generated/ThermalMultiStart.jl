#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ThermalMultiStart <: ThermalGen
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
        power_trajectory::Union{Nothing, NamedTuple{(:startup, :shutdown), Tuple{Float64, Float64}}}
        timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        start_time_limits::Union{Nothing, NamedTuple{(:hot, :warm, :cold), Tuple{Float64, Float64, Float64}}}
        start_types::Int
        op_cost::MultiStartCost
        basepower::Float64
        services::Vector{Service}
        participation_factor::Float64
        time_at_status::Float64
        must_run::Bool
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
- `power_trajectory::Union{Nothing, NamedTuple{(:startup, :shutdown), Tuple{Float64, Float64}}}`, validation range: (0, nothing), action if invalid: error
- `timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: Minimum up and Minimum down time limits in hours, validation range: (0, nothing), action if invalid: error
- `start_time_limits::Union{Nothing, NamedTuple{(:hot, :warm, :cold), Tuple{Float64, Float64, Float64}}}`:  Time limits for startup based on turbine temperature in hours
- `start_types::Int`:  Number of startup based on turbine temperature, validation range: (1, 3), action if invalid: error
- `op_cost::MultiStartCost`
- `basepower::Float64`: Base power of the unit in system base per unit, validation range: (0, nothing), action if invalid: warn
- `services::Vector{Service}`: Services that this device contributes to
- `participation_factor::Float64`: AGC Participation Factor, validation range: (0, 1.0), action if invalid: error
- `time_at_status::Float64`
- `must_run::Bool`
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ThermalMultiStart <: ThermalGen
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
    power_trajectory::Union{Nothing, NamedTuple{(:startup, :shutdown), Tuple{Float64, Float64}}}
    "Minimum up and Minimum down time limits in hours"
    timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
    " Time limits for startup based on turbine temperature in hours"
    start_time_limits::Union{Nothing, NamedTuple{(:hot, :warm, :cold), Tuple{Float64, Float64, Float64}}}
    " Number of startup based on turbine temperature"
    start_types::Int
    op_cost::MultiStartCost
    "Base power of the unit in system base per unit"
    basepower::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "AGC Participation Factor"
    participation_factor::Float64
    time_at_status::Float64
    must_run::Bool
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ThermalMultiStart(name, available, status, bus, activepower, reactivepower, rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, power_trajectory, timelimits, start_time_limits, start_types, op_cost, basepower, services=Device[], participation_factor=0.0, time_at_status=INFINITE_TIME, must_run=false, dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    ThermalMultiStart(name, available, status, bus, activepower, reactivepower, rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, power_trajectory, timelimits, start_time_limits, start_types, op_cost, basepower, services, participation_factor, time_at_status, must_run, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function ThermalMultiStart(; name, available, status, bus, activepower, reactivepower, rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, power_trajectory, timelimits, start_time_limits, start_types, op_cost, basepower, services=Device[], participation_factor=0.0, time_at_status=INFINITE_TIME, must_run=false, dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    ThermalMultiStart(name, available, status, bus, activepower, reactivepower, rating, primemover, fuel, activepowerlimits, reactivepowerlimits, ramplimits, power_trajectory, timelimits, start_time_limits, start_types, op_cost, basepower, services, participation_factor, time_at_status, must_run, dynamic_injector, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function ThermalMultiStart(::Nothing)
    ThermalMultiStart(;
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
        power_trajectory=nothing,
        timelimits=nothing,
        start_time_limits=nothing,
        start_types=1,
        op_cost=MultiStartCost(nothing),
        basepower=0.0,
        services=Device[],
        participation_factor=0.0,
        time_at_status=INFINITE_TIME,
        must_run=false,
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::ThermalMultiStart) = value.name
"""Get ThermalMultiStart available."""
get_available(value::ThermalMultiStart) = value.available
"""Get ThermalMultiStart status."""
get_status(value::ThermalMultiStart) = value.status
"""Get ThermalMultiStart bus."""
get_bus(value::ThermalMultiStart) = value.bus
"""Get ThermalMultiStart activepower."""
get_activepower(value::ThermalMultiStart) = value.activepower
"""Get ThermalMultiStart reactivepower."""
get_reactivepower(value::ThermalMultiStart) = value.reactivepower
"""Get ThermalMultiStart rating."""
get_rating(value::ThermalMultiStart) = value.rating
"""Get ThermalMultiStart primemover."""
get_primemover(value::ThermalMultiStart) = value.primemover
"""Get ThermalMultiStart fuel."""
get_fuel(value::ThermalMultiStart) = value.fuel
"""Get ThermalMultiStart activepowerlimits."""
get_activepowerlimits(value::ThermalMultiStart) = value.activepowerlimits
"""Get ThermalMultiStart reactivepowerlimits."""
get_reactivepowerlimits(value::ThermalMultiStart) = value.reactivepowerlimits
"""Get ThermalMultiStart ramplimits."""
get_ramplimits(value::ThermalMultiStart) = value.ramplimits
"""Get ThermalMultiStart power_trajectory."""
get_power_trajectory(value::ThermalMultiStart) = value.power_trajectory
"""Get ThermalMultiStart timelimits."""
get_timelimits(value::ThermalMultiStart) = value.timelimits
"""Get ThermalMultiStart start_time_limits."""
get_start_time_limits(value::ThermalMultiStart) = value.start_time_limits
"""Get ThermalMultiStart start_types."""
get_start_types(value::ThermalMultiStart) = value.start_types
"""Get ThermalMultiStart op_cost."""
get_op_cost(value::ThermalMultiStart) = value.op_cost
"""Get ThermalMultiStart basepower."""
get_basepower(value::ThermalMultiStart) = value.basepower
"""Get ThermalMultiStart services."""
get_services(value::ThermalMultiStart) = value.services
"""Get ThermalMultiStart participation_factor."""
get_participation_factor(value::ThermalMultiStart) = value.participation_factor
"""Get ThermalMultiStart time_at_status."""
get_time_at_status(value::ThermalMultiStart) = value.time_at_status
"""Get ThermalMultiStart must_run."""
get_must_run(value::ThermalMultiStart) = value.must_run
"""Get ThermalMultiStart dynamic_injector."""
get_dynamic_injector(value::ThermalMultiStart) = value.dynamic_injector
"""Get ThermalMultiStart ext."""
get_ext(value::ThermalMultiStart) = value.ext

InfrastructureSystems.get_forecasts(value::ThermalMultiStart) = value.forecasts
"""Get ThermalMultiStart internal."""
get_internal(value::ThermalMultiStart) = value.internal


InfrastructureSystems.set_name!(value::ThermalMultiStart, val::String) = value.name = val
"""Set ThermalMultiStart available."""
set_available!(value::ThermalMultiStart, val::Bool) = value.available = val
"""Set ThermalMultiStart status."""
set_status!(value::ThermalMultiStart, val::Bool) = value.status = val
"""Set ThermalMultiStart bus."""
set_bus!(value::ThermalMultiStart, val::Bus) = value.bus = val
"""Set ThermalMultiStart activepower."""
set_activepower!(value::ThermalMultiStart, val::Float64) = value.activepower = val
"""Set ThermalMultiStart reactivepower."""
set_reactivepower!(value::ThermalMultiStart, val::Float64) = value.reactivepower = val
"""Set ThermalMultiStart rating."""
set_rating!(value::ThermalMultiStart, val::Float64) = value.rating = val
"""Set ThermalMultiStart primemover."""
set_primemover!(value::ThermalMultiStart, val::PrimeMovers.PrimeMover) = value.primemover = val
"""Set ThermalMultiStart fuel."""
set_fuel!(value::ThermalMultiStart, val::ThermalFuels.ThermalFuel) = value.fuel = val
"""Set ThermalMultiStart activepowerlimits."""
set_activepowerlimits!(value::ThermalMultiStart, val::Min_Max) = value.activepowerlimits = val
"""Set ThermalMultiStart reactivepowerlimits."""
set_reactivepowerlimits!(value::ThermalMultiStart, val::Union{Nothing, Min_Max}) = value.reactivepowerlimits = val
"""Set ThermalMultiStart ramplimits."""
set_ramplimits!(value::ThermalMultiStart, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.ramplimits = val
"""Set ThermalMultiStart power_trajectory."""
set_power_trajectory!(value::ThermalMultiStart, val::Union{Nothing, NamedTuple{(:startup, :shutdown), Tuple{Float64, Float64}}}) = value.power_trajectory = val
"""Set ThermalMultiStart timelimits."""
set_timelimits!(value::ThermalMultiStart, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.timelimits = val
"""Set ThermalMultiStart start_time_limits."""
set_start_time_limits!(value::ThermalMultiStart, val::Union{Nothing, NamedTuple{(:hot, :warm, :cold), Tuple{Float64, Float64, Float64}}}) = value.start_time_limits = val
"""Set ThermalMultiStart start_types."""
set_start_types!(value::ThermalMultiStart, val::Int) = value.start_types = val
"""Set ThermalMultiStart op_cost."""
set_op_cost!(value::ThermalMultiStart, val::MultiStartCost) = value.op_cost = val
"""Set ThermalMultiStart basepower."""
set_basepower!(value::ThermalMultiStart, val::Float64) = value.basepower = val
"""Set ThermalMultiStart services."""
set_services!(value::ThermalMultiStart, val::Vector{Service}) = value.services = val
"""Set ThermalMultiStart participation_factor."""
set_participation_factor!(value::ThermalMultiStart, val::Float64) = value.participation_factor = val
"""Set ThermalMultiStart time_at_status."""
set_time_at_status!(value::ThermalMultiStart, val::Float64) = value.time_at_status = val
"""Set ThermalMultiStart must_run."""
set_must_run!(value::ThermalMultiStart, val::Bool) = value.must_run = val
"""Set ThermalMultiStart ext."""
set_ext!(value::ThermalMultiStart, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::ThermalMultiStart, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set ThermalMultiStart internal."""
set_internal!(value::ThermalMultiStart, val::InfrastructureSystemsInternal) = value.internal = val
