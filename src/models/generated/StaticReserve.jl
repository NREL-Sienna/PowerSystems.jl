#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct StaticReserve{T <: ReserveDirection} <: Reserve{T}
        name::String
        timeframe::Float64
        requirement::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Data Structure for a proportional reserve product for system simulations.

# Arguments
- `name::String`
- `timeframe::Float64`: the relative saturation timeframe, validation range: (0, nothing), action if invalid: error
- `requirement::Float64`: the static value of required reserves, validation range: (0, nothing), action if invalid: error
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct StaticReserve{T <: ReserveDirection} <: Reserve{T}
    name::String
    "the relative saturation timeframe"
    timeframe::Float64
    "the static value of required reserves"
    requirement::Float64
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function StaticReserve{T}(name, timeframe, requirement, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    StaticReserve{T}(name, timeframe, requirement, ext, InfrastructureSystemsInternal(), )
end

function StaticReserve{T}(; name, timeframe, requirement, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    StaticReserve{T}(name, timeframe, requirement, ext, )
end

# Constructor for demo purposes; non-functional.
function StaticReserve{T}(::Nothing) where T <: ReserveDirection
    StaticReserve{T}(;
        name="init",
        timeframe=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get StaticReserve name."""
get_name(value::StaticReserve) = value.name
"""Get StaticReserve timeframe."""
get_timeframe(value::StaticReserve) = value.timeframe
"""Get StaticReserve requirement."""
get_requirement(value::StaticReserve) = value.requirement
"""Get StaticReserve ext."""
get_ext(value::StaticReserve) = value.ext
"""Get StaticReserve internal."""
get_internal(value::StaticReserve) = value.internal
