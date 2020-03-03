#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AvgCnvFixedDC <: Converter
        v_rated::Float64
        s_rated::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of an average converter model

# Arguments
- `v_rated::Float64`: rated voltage, validation range: (0, nothing)
- `s_rated::Float64`: rated VA, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AvgCnvFixedDC <: Converter
    "rated voltage"
    v_rated::Float64
    "rated VA"
    s_rated::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AvgCnvFixedDC(v_rated, s_rated, ext=Dict{String, Any}(), )
    AvgCnvFixedDC(v_rated, s_rated, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function AvgCnvFixedDC(; v_rated, s_rated, ext=Dict{String, Any}(), )
    AvgCnvFixedDC(v_rated, s_rated, ext, )
end

# Constructor for demo purposes; non-functional.
function AvgCnvFixedDC(::Nothing)
    AvgCnvFixedDC(;
        v_rated=0,
        s_rated=0,
        ext=Dict{String, Any}(),
    )
end

"""Get AvgCnvFixedDC v_rated."""
get_v_rated(value::AvgCnvFixedDC) = value.v_rated
"""Get AvgCnvFixedDC s_rated."""
get_s_rated(value::AvgCnvFixedDC) = value.s_rated
"""Get AvgCnvFixedDC ext."""
get_ext(value::AvgCnvFixedDC) = value.ext
"""Get AvgCnvFixedDC states."""
get_states(value::AvgCnvFixedDC) = value.states
"""Get AvgCnvFixedDC n_states."""
get_n_states(value::AvgCnvFixedDC) = value.n_states
"""Get AvgCnvFixedDC internal."""
get_internal(value::AvgCnvFixedDC) = value.internal
