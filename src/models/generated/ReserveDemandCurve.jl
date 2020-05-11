#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ReserveDemandCurve{T <: ReserveDirection} <: Reserve{T}
        name::String
        available::Bool
        timeframe::Float64
        op_cost::TwoPartCost
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Data Structure for a operating reserve with demand curve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `timeframe::Float64`: the relative saturation timeframe, validation range: (0, nothing), action if invalid: error
- `op_cost::TwoPartCost`: Cost for providing reserves  [`TwoPartCost`](@ref)
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ReserveDemandCurve{T <: ReserveDirection} <: Reserve{T}
    name::String
    available::Bool
    "the relative saturation timeframe"
    timeframe::Float64
    "Cost for providing reserves  [`TwoPartCost`](@ref)"
    op_cost::TwoPartCost
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ReserveDemandCurve{T}(name, available, timeframe, op_cost, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    ReserveDemandCurve{T}(name, available, timeframe, op_cost, ext, InfrastructureSystemsInternal(), )
end

function ReserveDemandCurve{T}(; name, available, timeframe, op_cost, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    ReserveDemandCurve{T}(name, available, timeframe, op_cost, ext, )
end

# Constructor for demo purposes; non-functional.
function ReserveDemandCurve{T}(::Nothing) where T <: ReserveDirection
    ReserveDemandCurve{T}(;
        name="init",
        available=false,
        timeframe=0.0,
        op_cost=TwoPartCost(nothing),
        ext=Dict{String, Any}(),
    )
end


InfrastructureSystems.get_name(value::ReserveDemandCurve) = value.name
"""Get ReserveDemandCurve available."""
get_available(value::ReserveDemandCurve) = value.available
"""Get ReserveDemandCurve timeframe."""
get_timeframe(value::ReserveDemandCurve) = value.timeframe
"""Get ReserveDemandCurve op_cost."""
get_op_cost(value::ReserveDemandCurve) = value.op_cost
"""Get ReserveDemandCurve ext."""
get_ext(value::ReserveDemandCurve) = value.ext
"""Get ReserveDemandCurve internal."""
get_internal(value::ReserveDemandCurve) = value.internal


InfrastructureSystems.set_name!(value::ReserveDemandCurve, val::String) = value.name = val
"""Set ReserveDemandCurve available."""
set_available!(value::ReserveDemandCurve, val::Bool) = value.available = val
"""Set ReserveDemandCurve timeframe."""
set_timeframe!(value::ReserveDemandCurve, val::Float64) = value.timeframe = val
"""Set ReserveDemandCurve op_cost."""
set_op_cost!(value::ReserveDemandCurve, val::TwoPartCost) = value.op_cost = val
"""Set ReserveDemandCurve ext."""
set_ext!(value::ReserveDemandCurve, val::Dict{String, Any}) = value.ext = val
"""Set ReserveDemandCurve internal."""
set_internal!(value::ReserveDemandCurve, val::InfrastructureSystemsInternal) = value.internal = val
