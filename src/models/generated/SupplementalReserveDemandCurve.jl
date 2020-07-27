#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SupplementalReserveDemandCurve{T <: ReserveDirection} <: Reserve{T}
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
mutable struct SupplementalReserveDemandCurve{T <: ReserveDirection} <: Reserve{T}
    name::String
    available::Bool
    "the relative saturation time_frame"
    time_frame::Float64
    "Cost for providing reserves  [`TwoPartCost`](@ref)"
    operation_cost::TwoPartCost
    operation_cost_off::TwoPartCost
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SupplementalReserveDemandCurve{T}(name, available, time_frame, operation_cost, operation_cost_off, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), ) where T <: ReserveDirection
    SupplementalReserveDemandCurve{T}(name, available, time_frame, operation_cost, operation_cost_off, ext, forecasts, InfrastructureSystemsInternal(), )
end

function SupplementalReserveDemandCurve{T}(; name, available, time_frame, operation_cost, operation_cost_off, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), ) where T <: ReserveDirection
    SupplementalReserveDemandCurve{T}(name, available, time_frame, operation_cost, operation_cost_off, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function SupplementalReserveDemandCurve{T}(::Nothing) where T <: ReserveDirection
    SupplementalReserveDemandCurve{T}(;
        name="init",
        available=false,
        time_frame=0.0,
        operation_cost=TwoPartCost(nothing),
        operation_cost_off=TwoPartCost(nothing),
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::SupplementalReserveDemandCurve) = value.name
"""Get SupplementalReserveDemandCurve available."""
get_available(value::SupplementalReserveDemandCurve) = value.available
"""Get SupplementalReserveDemandCurve time_frame."""
get_time_frame(value::SupplementalReserveDemandCurve) = value.time_frame
"""Get SupplementalReserveDemandCurve operation_cost."""
get_operation_cost(value::SupplementalReserveDemandCurve) = value.operation_cost
get_operation_cost_off(value::SupplementalReserveDemandCurve) = value.operation_cost_off
"""Get SupplementalReserveDemandCurve ext."""
get_ext(value::SupplementalReserveDemandCurve) = value.ext

InfrastructureSystems.get_forecasts(value::SupplementalReserveDemandCurve) = value.forecasts
"""Get SupplementalReserveDemandCurve internal."""
get_internal(value::SupplementalReserveDemandCurve) = value.internal


InfrastructureSystems.set_name!(value::SupplementalReserveDemandCurve, val::String) = value.name = val
"""Set SupplementalReserveDemandCurve available."""
set_available!(value::SupplementalReserveDemandCurve, val::Bool) = value.available = val
"""Set SupplementalReserveDemandCurve time_frame."""
set_time_frame!(value::SupplementalReserveDemandCurve, val::Float64) = value.time_frame = val
"""Set SupplementalReserveDemandCurve operation_cost."""
set_operation_cost!(value::SupplementalReserveDemandCurve, val::TwoPartCost) = value.operation_cost = val
set_operation_cost_off!(value::SupplementalReserveDemandCurve, val::TwoPartCost) = value.operation_cost_off = val
"""Set SupplementalReserveDemandCurve ext."""
set_ext!(value::SupplementalReserveDemandCurve, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::SupplementalReserveDemandCurve, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set SupplementalReserveDemandCurve internal."""
set_internal!(value::SupplementalReserveDemandCurve, val::InfrastructureSystemsInternal) = value.internal = val
