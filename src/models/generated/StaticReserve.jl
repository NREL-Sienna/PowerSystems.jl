#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct StaticReserve <: Reserve
        name::String
        contributingdevices::Vector{<:Device}
        timeframe::Float64
        requirement::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Data Structure for a proportional reserve product for system simulations.

# Arguments
- `name::String`
- `contributingdevices::Vector{<:Device}`: devices from which the product can be procured
- `timeframe::Float64`: the relative saturation timeframe
- `requirement::Float64`: the static value of required reserves
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct StaticReserve <: Reserve
    name::String
    "devices from which the product can be procured"
    contributingdevices::Vector{<:Device}
    "the relative saturation timeframe"
    timeframe::Float64
    "the static value of required reserves"
    requirement::Float64
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function StaticReserve(name, contributingdevices, timeframe, requirement, ext=Dict{String, Any}(), )
    StaticReserve(name, contributingdevices, timeframe, requirement, ext, InfrastructureSystemsInternal())
end

function StaticReserve(; name, contributingdevices, timeframe, requirement, ext=Dict{String, Any}(), )
    StaticReserve(name, contributingdevices, timeframe, requirement, ext, )
end


# Constructor for demo purposes; non-functional.

function StaticReserve(::Nothing)
    StaticReserve(;
        name="init",
        contributingdevices=[ThermalStandard(nothing)],
        timeframe=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get StaticReserve name."""
get_name(value::StaticReserve) = value.name
"""Get StaticReserve contributingdevices."""
get_contributingdevices(value::StaticReserve) = value.contributingdevices
"""Get StaticReserve timeframe."""
get_timeframe(value::StaticReserve) = value.timeframe
"""Get StaticReserve requirement."""
get_requirement(value::StaticReserve) = value.requirement
"""Get StaticReserve ext."""
get_ext(value::StaticReserve) = value.ext
"""Get StaticReserve internal."""
get_internal(value::StaticReserve) = value.internal
