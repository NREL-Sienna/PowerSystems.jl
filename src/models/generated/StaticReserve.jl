#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct StaticReserve{T <: ReserveDirection} <: Reserve{T}
        name::String
        available::Bool
        time_frame::Float64
        sustained_time::Float64
        max_participation_factor::Float64
        requirement::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Data Structure for a proportional reserve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the saturation time_frame in minutes to provide reserve contribution, validation range: `(0, nothing)`, action if invalid: `error`
- `sustained_time::Float64`: the time in secounds reserve contribution must sustained at a specified level, validation range: `(0, nothing)`, action if invalid: `error`
- `max_participation_factor::Float64`: the maximum limit of reserve contribution per device, validation range: `(0, 1)`, action if invalid: `error`
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: `(0, nothing)`, action if invalid: `error`
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct StaticReserve{T <: ReserveDirection} <: Reserve{T}
    name::String
    available::Bool
    "the saturation time_frame in minutes to provide reserve contribution"
    time_frame::Float64
    "the time in secounds reserve contribution must sustained at a specified level"
    sustained_time::Float64
    "the maximum limit of reserve contribution per device"
    max_participation_factor::Float64
    "the static value of required reserves in system p.u."
    requirement::Float64
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function StaticReserve{T}(name, available, time_frame, sustained_time, max_participation_factor=1.0, requirement, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    StaticReserve{T}(name, available, time_frame, sustained_time, max_participation_factor, requirement, ext, InfrastructureSystemsInternal(), )
end

function StaticReserve{T}(; name, available, time_frame, sustained_time, max_participation_factor=1.0, requirement, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), ) where T <: ReserveDirection
    StaticReserve{T}(name, available, time_frame, sustained_time, max_participation_factor, requirement, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function StaticReserve{T}(::Nothing) where T <: ReserveDirection
    StaticReserve{T}(;
        name="init",
        available=false,
        time_frame=0.0,
        sustained_time=0.0,
        max_participation_factor=1.0,
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
"""Get [`StaticReserve`](@ref) `sustained_time`."""
get_sustained_time(value::StaticReserve) = value.sustained_time
"""Get [`StaticReserve`](@ref) `max_participation_factor`."""
get_max_participation_factor(value::StaticReserve) = value.max_participation_factor
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
"""Set [`StaticReserve`](@ref) `sustained_time`."""
set_sustained_time!(value::StaticReserve, val) = value.sustained_time = val
"""Set [`StaticReserve`](@ref) `max_participation_factor`."""
set_max_participation_factor!(value::StaticReserve, val) = value.max_participation_factor = val
"""Set [`StaticReserve`](@ref) `requirement`."""
set_requirement!(value::StaticReserve, val) = value.requirement = set_value(value, val)
"""Set [`StaticReserve`](@ref) `ext`."""
set_ext!(value::StaticReserve, val) = value.ext = val
