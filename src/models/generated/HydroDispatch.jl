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
        rating::Float64
        primemover::PrimeMovers.PrimeMover
        activepowerlimits::Min_Max
        reactivepowerlimits::Union{Nothing, Min_Max}
        ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}
        basepower::Float64
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
- `ramplimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: ramp up and ramp down limits, validation range: (0, nothing), action if invalid: error
- `timelimits::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}`: Minimum up and Minimum down time limits in hours, validation range: (0, nothing), action if invalid: error
- `basepower::Float64`: Base power of the unit in system base per unit, validation range: (0, nothing), action if invalid: warn
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct HydroDispatch <: HydroGen
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
    "Base power of the unit in system base per unit"
    basepower::Float64
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

function HydroDispatch(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, basepower, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroDispatch(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, basepower, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HydroDispatch(; name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, basepower, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroDispatch(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, basepower, services, dynamic_injector, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function HydroDispatch(::Nothing)
    HydroDispatch(;
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
        basepower=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::HydroDispatch) = value.name
"""Get HydroDispatch available."""
get_available(value::HydroDispatch) = value.available
"""Get HydroDispatch bus."""
get_bus(value::HydroDispatch) = value.bus
"""Get HydroDispatch activepower."""
get_activepower(value::HydroDispatch) = value.activepower
"""Get HydroDispatch reactivepower."""
get_reactivepower(value::HydroDispatch) = value.reactivepower
"""Get HydroDispatch rating."""
get_rating(value::HydroDispatch) = value.rating
"""Get HydroDispatch primemover."""
get_primemover(value::HydroDispatch) = value.primemover
"""Get HydroDispatch activepowerlimits."""
get_activepowerlimits(value::HydroDispatch) = value.activepowerlimits
"""Get HydroDispatch reactivepowerlimits."""
get_reactivepowerlimits(value::HydroDispatch) = value.reactivepowerlimits
"""Get HydroDispatch ramplimits."""
get_ramplimits(value::HydroDispatch) = value.ramplimits
"""Get HydroDispatch timelimits."""
get_timelimits(value::HydroDispatch) = value.timelimits
"""Get HydroDispatch basepower."""
get_basepower(value::HydroDispatch) = value.basepower
"""Get HydroDispatch services."""
get_services(value::HydroDispatch) = value.services
"""Get HydroDispatch dynamic_injector."""
get_dynamic_injector(value::HydroDispatch) = value.dynamic_injector
"""Get HydroDispatch ext."""
get_ext(value::HydroDispatch) = value.ext

InfrastructureSystems.get_forecasts(value::HydroDispatch) = value.forecasts
"""Get HydroDispatch internal."""
get_internal(value::HydroDispatch) = value.internal


InfrastructureSystems.set_name!(value::HydroDispatch, val::String) = value.name = val
"""Set HydroDispatch available."""
set_available!(value::HydroDispatch, val::Bool) = value.available = val
"""Set HydroDispatch bus."""
set_bus!(value::HydroDispatch, val::Bus) = value.bus = val
"""Set HydroDispatch activepower."""
set_activepower!(value::HydroDispatch, val::Float64) = value.activepower = val
"""Set HydroDispatch reactivepower."""
set_reactivepower!(value::HydroDispatch, val::Float64) = value.reactivepower = val
"""Set HydroDispatch rating."""
set_rating!(value::HydroDispatch, val::Float64) = value.rating = val
"""Set HydroDispatch primemover."""
set_primemover!(value::HydroDispatch, val::PrimeMovers.PrimeMover) = value.primemover = val
"""Set HydroDispatch activepowerlimits."""
set_activepowerlimits!(value::HydroDispatch, val::Min_Max) = value.activepowerlimits = val
"""Set HydroDispatch reactivepowerlimits."""
set_reactivepowerlimits!(value::HydroDispatch, val::Union{Nothing, Min_Max}) = value.reactivepowerlimits = val
"""Set HydroDispatch ramplimits."""
set_ramplimits!(value::HydroDispatch, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.ramplimits = val
"""Set HydroDispatch timelimits."""
set_timelimits!(value::HydroDispatch, val::Union{Nothing, NamedTuple{(:up, :down), Tuple{Float64, Float64}}}) = value.timelimits = val
"""Set HydroDispatch basepower."""
set_basepower!(value::HydroDispatch, val::Float64) = value.basepower = val
"""Set HydroDispatch services."""
set_services!(value::HydroDispatch, val::Vector{Service}) = value.services = val
"""Set HydroDispatch ext."""
set_ext!(value::HydroDispatch, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::HydroDispatch, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set HydroDispatch internal."""
set_internal!(value::HydroDispatch, val::InfrastructureSystemsInternal) = value.internal = val
