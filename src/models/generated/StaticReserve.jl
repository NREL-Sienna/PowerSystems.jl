#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct StaticReserve{T <: ReserveDirection} <: Reserve{T}
        name::String
        available::Bool
        time_frame::Float64
        requirement::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Data Structure for a proportional reserve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the relative saturation time_frame, validation range: `(0, nothing)`, action if invalid: `error`
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: `(0, nothing)`, action if invalid: `error`
- `ext::Dict{String, Any}`
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
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function StaticReserve{T}(name, available, time_frame, requirement, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    StaticReserve{T}(name, available, time_frame, requirement, ext, InfrastructureSystemsInternal(), )
end

function StaticReserve{T}(; name, available, time_frame, requirement, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), ) where T <: ReserveDirection
    StaticReserve{T}(name, available, time_frame, requirement, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function StaticReserve{T}(::Nothing) where T <: ReserveDirection
    StaticReserve{T}(;
        name="init",
        available=false,
        time_frame=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`StaticReserve`](@ref) `name`."""
get_name(value::StaticReserve) = value.name
"""Get [`StaticReserve`](@ref) `available`."""
get_available(value::StaticReserve) = value.available
"""Get [`StaticReserve`](@ref) `time_frame`."""
get_time_frame(value::StaticReserve) = value.time_frame
"""Get [`StaticReserve`](@ref) `requirement`."""
get_requirement(value::StaticReserve) = get_value(value, value.requirement)
"""Get [`StaticReserve`](@ref) `ext`."""
get_ext(value::StaticReserve) = value.ext
"""Get [`StaticReserve`](@ref) `internal`."""
get_internal(value::StaticReserve) = value.internal

"""Set [`StaticReserve`](@ref) `available`."""
set_available!(value::StaticReserve, val) = value.available = val
"""Set [`StaticReserve`](@ref) `time_frame`."""
set_time_frame!(value::StaticReserve, val) = value.time_frame = val
"""Set [`StaticReserve`](@ref) `requirement`."""
set_requirement!(value::StaticReserve, val) = value.requirement = set_value(value, val)
"""Set [`StaticReserve`](@ref) `ext`."""
set_ext!(value::StaticReserve, val) = value.ext = val
