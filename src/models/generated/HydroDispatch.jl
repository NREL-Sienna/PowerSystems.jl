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
- `services::Vector{Service}`: Services that this device contributes to
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
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HydroDispatch(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroDispatch(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function HydroDispatch(; name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    HydroDispatch(name, available, bus, activepower, reactivepower, rating, primemover, activepowerlimits, reactivepowerlimits, ramplimits, timelimits, services, ext, forecasts, )
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
        services=Device[],
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
"""Get HydroDispatch services."""
get_services(value::HydroDispatch) = value.services
"""Get HydroDispatch ext."""
get_ext(value::HydroDispatch) = value.ext

InfrastructureSystems.get_forecasts(value::HydroDispatch) = value.forecasts
"""Get HydroDispatch internal."""
get_internal(value::HydroDispatch) = value.internal


InfrastructureSystems.set_name!(value::HydroDispatch, val) = value.name = val
"""Set HydroDispatch available."""
set_available!(value::HydroDispatch, val) = value.available = val
"""Set HydroDispatch bus."""
set_bus!(value::HydroDispatch, val) = value.bus = val
"""Set HydroDispatch activepower."""
set_activepower!(value::HydroDispatch, val) = value.activepower = val
"""Set HydroDispatch reactivepower."""
set_reactivepower!(value::HydroDispatch, val) = value.reactivepower = val
"""Set HydroDispatch rating."""
set_rating!(value::HydroDispatch, val) = value.rating = val
"""Set HydroDispatch primemover."""
set_primemover!(value::HydroDispatch, val) = value.primemover = val
"""Set HydroDispatch activepowerlimits."""
set_activepowerlimits!(value::HydroDispatch, val) = value.activepowerlimits = val
"""Set HydroDispatch reactivepowerlimits."""
set_reactivepowerlimits!(value::HydroDispatch, val) = value.reactivepowerlimits = val
"""Set HydroDispatch ramplimits."""
set_ramplimits!(value::HydroDispatch, val) = value.ramplimits = val
"""Set HydroDispatch timelimits."""
set_timelimits!(value::HydroDispatch, val) = value.timelimits = val
"""Set HydroDispatch services."""
set_services!(value::HydroDispatch, val) = value.services = val
"""Set HydroDispatch ext."""
set_ext!(value::HydroDispatch, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::HydroDispatch, val) = value.forecasts = val
"""Set HydroDispatch internal."""
set_internal!(value::HydroDispatch, val) = value.internal = val
