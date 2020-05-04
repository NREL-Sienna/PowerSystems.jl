#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ORDC{T <: ReserveDirection} <: Reserve{T}
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
- `op_cost::TwoPartCost`: Cost for providing reserves  [TwoPartCost](@ref)
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ORDC{T <: ReserveDirection} <: Reserve{T}
    name::String
    available::Bool
    "the relative saturation timeframe"
    timeframe::Float64
    "Cost for providing reserves  [TwoPartCost](@ref)"
    op_cost::TwoPartCost
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ORDC{T}(name, available, timeframe, op_cost, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    ORDC{T}(name, available, timeframe, op_cost, ext, InfrastructureSystemsInternal(), )
end

function ORDC{T}(; name, available, timeframe, op_cost, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    ORDC{T}(name, available, timeframe, op_cost, ext, )
end

# Constructor for demo purposes; non-functional.
function ORDC{T}(::Nothing) where T <: ReserveDirection
    ORDC{T}(;
        name="init",
        available=false,
        timeframe=0.0,
        op_cost=TwoPartCost(nothing),
        ext=Dict{String, Any}(),
    )
end


InfrastructureSystems.get_name(value::ORDC) = value.name
"""Get ORDC available."""
get_available(value::ORDC) = value.available
"""Get ORDC timeframe."""
get_timeframe(value::ORDC) = value.timeframe
"""Get ORDC op_cost."""
get_op_cost(value::ORDC) = value.op_cost
"""Get ORDC ext."""
get_ext(value::ORDC) = value.ext
"""Get ORDC internal."""
get_internal(value::ORDC) = value.internal
