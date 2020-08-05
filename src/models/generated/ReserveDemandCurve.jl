#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ReserveDemandCurve{T <: ReserveDirection} <: Reserve{T}
        name::String
        available::Bool
        time_frame::Float64
        operation_cost::TwoPartCost
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for a operating reserve with demand curve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the relative saturation time_frame, validation range: (0, nothing), action if invalid: error
- `operation_cost::TwoPartCost`: Cost for providing reserves  [`TwoPartCost`](@ref)
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ReserveDemandCurve{T <: ReserveDirection} <: Reserve{T}
    name::String
    available::Bool
    "the relative saturation time_frame"
    time_frame::Float64
    "Cost for providing reserves  [`TwoPartCost`](@ref)"
    operation_cost::TwoPartCost
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ReserveDemandCurve{T}(name, available, time_frame, operation_cost, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), ) where T <: ReserveDirection
    ReserveDemandCurve{T}(name, available, time_frame, operation_cost, ext, forecasts, InfrastructureSystemsInternal(), )
end

function ReserveDemandCurve{T}(; name, available, time_frame, operation_cost, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), ) where T <: ReserveDirection
    ReserveDemandCurve{T}(name, available, time_frame, operation_cost, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function ReserveDemandCurve{T}(::Nothing) where T <: ReserveDirection
    ReserveDemandCurve{T}(;
        name="init",
        available=false,
        time_frame=0.0,
        operation_cost=TwoPartCost(nothing),
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::ReserveDemandCurve) = value.name
"""Get ReserveDemandCurve available."""
get_available(value::ReserveDemandCurve) = value.available
"""Get ReserveDemandCurve time_frame."""
get_time_frame(value::ReserveDemandCurve) = value.time_frame
"""Get ReserveDemandCurve operation_cost."""
get_operation_cost(value::ReserveDemandCurve) = value.operation_cost
"""Get ReserveDemandCurve ext."""
get_ext(value::ReserveDemandCurve) = value.ext

InfrastructureSystems.get_forecasts(value::ReserveDemandCurve) = value.forecasts
"""Get ReserveDemandCurve internal."""
get_internal(value::ReserveDemandCurve) = value.internal


InfrastructureSystems.set_name!(value::ReserveDemandCurve, val::String) = value.name = val
"""Set ReserveDemandCurve available."""
set_available!(value::ReserveDemandCurve, val::Bool) = value.available = val
"""Set ReserveDemandCurve time_frame."""
set_time_frame!(value::ReserveDemandCurve, val::Float64) = value.time_frame = val
"""Set ReserveDemandCurve operation_cost."""
set_operation_cost!(value::ReserveDemandCurve, val::TwoPartCost) = value.operation_cost = val
"""Set ReserveDemandCurve ext."""
set_ext!(value::ReserveDemandCurve, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::ReserveDemandCurve, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set ReserveDemandCurve internal."""
set_internal!(value::ReserveDemandCurve, val::InfrastructureSystemsInternal) = value.internal = val
