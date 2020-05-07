#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RenewableDispatch <: RenewableGen
        name::String
        available::Bool
        bus::Bus
        activepower::Float64
        reactivepower::Float64
        rating::Float64
        primemover::PrimeMovers.PrimeMover
        reactivepowerlimits::Union{Nothing, Min_Max}
        powerfactor::Float64
        op_cost::TwoPartCost
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
- `reactivepower::Float64`
- `rating::Float64`: Thermal limited MVA Power Output of the unit. <= Capacity, validation range: (0, nothing), action if invalid: error
- `primemover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `reactivepowerlimits::Union{Nothing, Min_Max}`
- `powerfactor::Float64`, validation range: (0, 1), action if invalid: error
- `op_cost::TwoPartCost`: Operation Cost of Generation [TwoPartCost](@ref)
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RenewableDispatch <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    activepower::Float64
    reactivepower::Float64
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    rating::Float64
    "PrimeMover Technology according to EIA 923"
    primemover::PrimeMovers.PrimeMover
    reactivepowerlimits::Union{Nothing, Min_Max}
    powerfactor::Float64
    "Operation Cost of Generation [TwoPartCost](@ref)"
    op_cost::TwoPartCost
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function RenewableDispatch(name, available, bus, activepower, reactivepower, rating, primemover, reactivepowerlimits, powerfactor, op_cost, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableDispatch(name, available, bus, activepower, reactivepower, rating, primemover, reactivepowerlimits, powerfactor, op_cost, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function RenewableDispatch(; name, available, bus, activepower, reactivepower, rating, primemover, reactivepowerlimits, powerfactor, op_cost, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    RenewableDispatch(name, available, bus, activepower, reactivepower, rating, primemover, reactivepowerlimits, powerfactor, op_cost, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function RenewableDispatch(::Nothing)
    RenewableDispatch(;
        name="init",
        available=false,
        bus=Bus(nothing),
        activepower=0.0,
        reactivepower=0.0,
        rating=0.0,
        primemover=PrimeMovers.OT,
        reactivepowerlimits=nothing,
        powerfactor=1.0,
        op_cost=TwoPartCost(nothing),
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::RenewableDispatch) = value.name
"""Get RenewableDispatch available."""
get_available(value::RenewableDispatch) = value.available
"""Get RenewableDispatch bus."""
get_bus(value::RenewableDispatch) = value.bus
"""Get RenewableDispatch activepower."""
get_activepower(value::RenewableDispatch) = value.activepower
"""Get RenewableDispatch reactivepower."""
get_reactivepower(value::RenewableDispatch) = value.reactivepower
"""Get RenewableDispatch rating."""
get_rating(value::RenewableDispatch) = value.rating
"""Get RenewableDispatch primemover."""
get_primemover(value::RenewableDispatch) = value.primemover
"""Get RenewableDispatch reactivepowerlimits."""
get_reactivepowerlimits(value::RenewableDispatch) = value.reactivepowerlimits
"""Get RenewableDispatch powerfactor."""
get_powerfactor(value::RenewableDispatch) = value.powerfactor
"""Get RenewableDispatch op_cost."""
get_op_cost(value::RenewableDispatch) = value.op_cost
"""Get RenewableDispatch services."""
get_services(value::RenewableDispatch) = value.services
"""Get RenewableDispatch ext."""
get_ext(value::RenewableDispatch) = value.ext

InfrastructureSystems.get_forecasts(value::RenewableDispatch) = value.forecasts
"""Get RenewableDispatch internal."""
get_internal(value::RenewableDispatch) = value.internal


InfrastructureSystems.set_name!(value::RenewableDispatch, val) = value.name = val
"""Set RenewableDispatch available."""
set_available!(value::RenewableDispatch, val) = value.available = val
"""Set RenewableDispatch bus."""
set_bus!(value::RenewableDispatch, val) = value.bus = val
"""Set RenewableDispatch activepower."""
set_activepower!(value::RenewableDispatch, val) = value.activepower = val
"""Set RenewableDispatch reactivepower."""
set_reactivepower!(value::RenewableDispatch, val) = value.reactivepower = val
"""Set RenewableDispatch rating."""
set_rating!(value::RenewableDispatch, val) = value.rating = val
"""Set RenewableDispatch primemover."""
set_primemover!(value::RenewableDispatch, val) = value.primemover = val
"""Set RenewableDispatch reactivepowerlimits."""
set_reactivepowerlimits!(value::RenewableDispatch, val) = value.reactivepowerlimits = val
"""Set RenewableDispatch powerfactor."""
set_powerfactor!(value::RenewableDispatch, val) = value.powerfactor = val
"""Set RenewableDispatch op_cost."""
set_op_cost!(value::RenewableDispatch, val) = value.op_cost = val
"""Set RenewableDispatch services."""
set_services!(value::RenewableDispatch, val) = value.services = val
"""Set RenewableDispatch ext."""
set_ext!(value::RenewableDispatch, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::RenewableDispatch, val) = value.forecasts = val
"""Set RenewableDispatch internal."""
set_internal!(value::RenewableDispatch, val) = value.internal = val
