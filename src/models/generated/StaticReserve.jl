#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct StaticReserve{T <: ReserveDirection} <: Reserve{T}
        name::String
        available::Bool
        time_frame::Float64
        requirement::Float64
        ext::Dict{String, Any}
        operation_cost::Union{Nothing, TwoPartCost}
        internal::InfrastructureSystemsInternal
    end

Data Structure for a proportional reserve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the relative saturation time_frame, validation range: `(0, nothing)`, action if invalid: `error`
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: `(0, nothing)`, action if invalid: `error`
- `ext::Dict{String, Any}`
- `operation_cost::Union{Nothing, TwoPartCost}`: Cost for providing reserves  [`TwoPartCost`](@ref)
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct StaticReserve{T <: ReserveDirection} <: Reserve{T}
    name::String
    available::Bool
    "the relative saturation time_frame"
    time_frame::Float64
    "the static value of required reserves in system p.u."
    requirement::Float64
    ext::Dict{String, Any}
    "Cost for providing reserves  [`TwoPartCost`](@ref)"
    operation_cost::Union{Nothing, TwoPartCost}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function StaticReserve{T}(name, available, time_frame, requirement, ext=Dict{String, Any}(), operation_cost=nothing, ) where T <: ReserveDirection
    StaticReserve{T}(name, available, time_frame, requirement, ext, operation_cost, InfrastructureSystemsInternal(), )
end

function StaticReserve{T}(; name, available, time_frame, requirement, ext=Dict{String, Any}(), operation_cost=nothing, internal=InfrastructureSystemsInternal(), ) where T <: ReserveDirection
    StaticReserve{T}(name, available, time_frame, requirement, ext, operation_cost, internal, )
end

# Constructor for demo purposes; non-functional.
function StaticReserve{T}(::Nothing) where T <: ReserveDirection
    StaticReserve{T}(;
        name="init",
        available=false,
        time_frame=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
        operation_cost=TwoPartCost(nothing),
    )
end


InfrastructureSystems.get_name(value::StaticReserve) = value.name
"""Get [`StaticReserve`](@ref) `available`."""
get_available(value::StaticReserve) = value.available
"""Get [`StaticReserve`](@ref) `time_frame`."""
get_time_frame(value::StaticReserve) = value.time_frame
"""Get [`StaticReserve`](@ref) `requirement`."""
get_requirement(value::StaticReserve) = value.requirement
"""Get [`StaticReserve`](@ref) `ext`."""
get_ext(value::StaticReserve) = value.ext
"""Get [`StaticReserve`](@ref) `operation_cost`."""
get_operation_cost(value::StaticReserve) = value.operation_cost
"""Get [`StaticReserve`](@ref) `internal`."""
get_internal(value::StaticReserve) = value.internal


InfrastructureSystems.set_name!(value::StaticReserve, val) = value.name = val
"""Set [`StaticReserve`](@ref) `available`."""
set_available!(value::StaticReserve, val) = value.available = val
"""Set [`StaticReserve`](@ref) `time_frame`."""
set_time_frame!(value::StaticReserve, val) = value.time_frame = val
"""Set [`StaticReserve`](@ref) `requirement`."""
set_requirement!(value::StaticReserve, val) = value.requirement = val
"""Set [`StaticReserve`](@ref) `ext`."""
set_ext!(value::StaticReserve, val) = value.ext = val
"""Set [`StaticReserve`](@ref) `operation_cost`."""
set_operation_cost!(value::StaticReserve, val) = value.operation_cost = val

