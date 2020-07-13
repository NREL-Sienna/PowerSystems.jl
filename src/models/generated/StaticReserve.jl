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
        internal::InfrastructureSystemsInternal
    end

Data Structure for a proportional reserve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the relative saturation time_frame, validation range: (0, nothing), action if invalid: error
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: (0, nothing), action if invalid: error
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

function StaticReserve{T}(; name, available, time_frame, requirement, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    StaticReserve{T}(name, available, time_frame, requirement, ext, )
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


InfrastructureSystems.get_name(value::StaticReserve) = value.name
"""Get StaticReserve available."""
get_available(value::StaticReserve) = value.available
"""Get StaticReserve time_frame."""
get_time_frame(value::StaticReserve) = value.time_frame
"""Get StaticReserve requirement."""
get_requirement(value::StaticReserve) = value.requirement
"""Get StaticReserve ext."""
get_ext(value::StaticReserve) = value.ext
"""Get StaticReserve internal."""
get_internal(value::StaticReserve) = value.internal


InfrastructureSystems.set_name!(value::StaticReserve, val::String) = value.name = val
"""Set StaticReserve available."""
set_available!(value::StaticReserve, val::Bool) = value.available = val
"""Set StaticReserve time_frame."""
set_time_frame!(value::StaticReserve, val::Float64) = value.time_frame = val
"""Set StaticReserve requirement."""
set_requirement!(value::StaticReserve, val::Float64) = value.requirement = val
"""Set StaticReserve ext."""
set_ext!(value::StaticReserve, val::Dict{String, Any}) = value.ext = val
"""Set StaticReserve internal."""
set_internal!(value::StaticReserve, val::InfrastructureSystemsInternal) = value.internal = val
