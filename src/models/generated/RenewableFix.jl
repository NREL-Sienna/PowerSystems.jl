#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RenewableFix <: RenewableGen
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        rating::Float64
        primemover::PrimeMovers.PrimeMover
        powerfactor::Float64
        services::Vector{Service}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for fixed renewable generation technologies.

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `activepower::Float64`
- `reactivepower::Float64`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `primemover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `powerfactor::Float64`, validation range: (0, 1), action if invalid: error
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RenewableFix <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "PrimeMover Technology according to EIA 923"
    primemover::PrimeMovers.PrimeMover
    powerfactor::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function RenewableFix(name, available, bus, activepower, reactivepower, rating, primemover, powerfactor, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableFix(name, available, bus, activepower, reactivepower, rating, primemover, powerfactor, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function RenewableFix(; name, available, bus, activepower, reactivepower, rating, primemover, powerfactor, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableFix(name, available, bus, activepower, reactivepower, rating, primemover, powerfactor, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function RenewableFix(::Nothing)
    RenewableFix(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        rating=0.0,
        primemover=PrimeMovers.OT,
        powerfactor=1.0,
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::RenewableFix) = value.name
"""Get RenewableFix available."""
get_available(value::RenewableFix) = value.available
"""Get RenewableFix bus."""
get_bus(value::RenewableFix) = value.bus
"""Get RenewableFix activepower."""
get_activepower(value::RenewableFix) = value.activepower
"""Get RenewableFix reactivepower."""
get_reactivepower(value::RenewableFix) = value.reactivepower
"""Get RenewableFix rating."""
get_rating(value::RenewableFix) = value.rating
"""Get RenewableFix primemover."""
get_primemover(value::RenewableFix) = value.primemover
"""Get RenewableFix powerfactor."""
get_powerfactor(value::RenewableFix) = value.powerfactor
"""Get RenewableFix services."""
get_services(value::RenewableFix) = value.services
"""Get RenewableFix ext."""
get_ext(value::RenewableFix) = value.ext

InfrastructureSystems.get_forecasts(value::RenewableFix) = value.forecasts
"""Get RenewableFix internal."""
get_internal(value::RenewableFix) = value.internal


InfrastructureSystems.set_name!(value::RenewableFix, val) = value.name = val
"""Set RenewableFix available."""
set_available!(value::RenewableFix, val) = value.available = val
"""Set RenewableFix bus."""
set_bus!(value::RenewableFix, val) = value.bus = val
"""Set RenewableFix activepower."""
set_activepower!(value::RenewableFix, val) = value.activepower = val
"""Set RenewableFix reactivepower."""
set_reactivepower!(value::RenewableFix, val) = value.reactivepower = val
"""Set RenewableFix rating."""
set_rating!(value::RenewableFix, val) = value.rating = val
"""Set RenewableFix primemover."""
set_primemover!(value::RenewableFix, val) = value.primemover = val
"""Set RenewableFix powerfactor."""
set_powerfactor!(value::RenewableFix, val) = value.powerfactor = val
"""Set RenewableFix services."""
set_services!(value::RenewableFix, val) = value.services = val
"""Set RenewableFix ext."""
set_ext!(value::RenewableFix, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::RenewableFix, val) = value.forecasts = val
"""Set RenewableFix internal."""
set_internal!(value::RenewableFix, val) = value.internal = val
