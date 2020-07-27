#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SupplementalStaticReserve{T <: ReserveDirection} <: Reserve{T}
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
mutable struct SupplementalStaticReserve{T <: ReserveDirection} <: Reserve{T}
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

function SupplementalStaticReserve{T}(name, available, time_frame, requirement, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    SupplementalStaticReserve{T}(name, available, time_frame, requirement, ext, InfrastructureSystemsInternal(), )
end

function SupplementalStaticReserve{T}(; name, available, time_frame, requirement, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    SupplementalStaticReserve{T}(name, available, time_frame, requirement, ext, )
end

# Constructor for demo purposes; non-functional.
function SupplementalStaticReserve{T}(::Nothing) where T <: ReserveDirection
    SupplementalStaticReserve{T}(;
        name="init",
        available=false,
        time_frame=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
    )
end


InfrastructureSystems.get_name(value::SupplementalStaticReserve) = value.name
"""Get SupplementalStaticReserve available."""
get_available(value::SupplementalStaticReserve) = value.available
"""Get SupplementalStaticReserve time_frame."""
get_time_frame(value::SupplementalStaticReserve) = value.time_frame
"""Get SupplementalStaticReserve requirement."""
get_requirement(value::SupplementalStaticReserve) = value.requirement
"""Get SupplementalStaticReserve ext."""
get_ext(value::SupplementalStaticReserve) = value.ext
"""Get SupplementalStaticReserve internal."""
get_internal(value::SupplementalStaticReserve) = value.internal


InfrastructureSystems.set_name!(value::SupplementalStaticReserve, val::String) = value.name = val
"""Set SupplementalStaticReserve available."""
set_available!(value::SupplementalStaticReserve, val::Bool) = value.available = val
"""Set SupplementalStaticReserve time_frame."""
set_time_frame!(value::SupplementalStaticReserve, val::Float64) = value.time_frame = val
"""Set SupplementalStaticReserve requirement."""
set_requirement!(value::SupplementalStaticReserve, val::Float64) = value.requirement = val
"""Set SupplementalStaticReserve ext."""
set_ext!(value::SupplementalStaticReserve, val::Dict{String, Any}) = value.ext = val
"""Set SupplementalStaticReserve internal."""
set_internal!(value::SupplementalStaticReserve, val::InfrastructureSystemsInternal) = value.internal = val
