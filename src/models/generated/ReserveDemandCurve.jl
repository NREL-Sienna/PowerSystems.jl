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
        internal::InfrastructureSystemsInternal
    end

Data Structure for a operating reserve with demand curve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the relative saturation time_frame, validation range: `(0, nothing)`, action if invalid: `error`
- `operation_cost::TwoPartCost`: Cost for providing reserves  [`TwoPartCost`](@ref)
- `ext::Dict{String, Any}`
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
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ReserveDemandCurve{T}(name, available, time_frame, operation_cost, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    ReserveDemandCurve{T}(name, available, time_frame, operation_cost, ext, InfrastructureSystemsInternal(), )
end

function ReserveDemandCurve{T}(; name, available, time_frame, operation_cost, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), ) where T <: ReserveDirection
    ReserveDemandCurve{T}(name, available, time_frame, operation_cost, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function ReserveDemandCurve{T}(::Nothing) where T <: ReserveDirection
    ReserveDemandCurve{T}(;
        name="init",
        available=false,
        time_frame=0.0,
        operation_cost=TwoPartCost(nothing),
        ext=Dict{String, Any}(),
    )
end


InfrastructureSystems.get_name(value::ReserveDemandCurve) = value.name
"""Get [`ReserveDemandCurve`](@ref) `available`."""
get_available(value::ReserveDemandCurve) = value.available
"""Get [`ReserveDemandCurve`](@ref) `time_frame`."""
get_time_frame(value::ReserveDemandCurve) = value.time_frame
"""Get [`ReserveDemandCurve`](@ref) `operation_cost`."""
get_operation_cost(value::ReserveDemandCurve) = value.operation_cost
"""Get [`ReserveDemandCurve`](@ref) `ext`."""
get_ext(value::ReserveDemandCurve) = value.ext
"""Get [`ReserveDemandCurve`](@ref) `internal`."""
get_internal(value::ReserveDemandCurve) = value.internal


InfrastructureSystems.set_name!(value::ReserveDemandCurve, val) = value.name = val
"""Set [`ReserveDemandCurve`](@ref) `available`."""
set_available!(value::ReserveDemandCurve, val) = value.available = val
"""Set [`ReserveDemandCurve`](@ref) `time_frame`."""
set_time_frame!(value::ReserveDemandCurve, val) = value.time_frame = val
"""Set [`ReserveDemandCurve`](@ref) `operation_cost`."""
set_operation_cost!(value::ReserveDemandCurve, val) = value.operation_cost = val
"""Set [`ReserveDemandCurve`](@ref) `ext`."""
set_ext!(value::ReserveDemandCurve, val) = value.ext = val

