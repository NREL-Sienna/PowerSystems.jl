#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PSSSimple <: PSS
        K_ω::Float64
        K_p::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a PSS that returns a proportional droop voltage to add to the reference for the AVR

# Arguments
- `K_ω::Float64`: Fixed voltage stabilization signal
- `K_p::Float64`: Fixed voltage stabilization signal
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PSSSimple <: PSS
    "Fixed voltage stabilization signal"
    K_ω::Float64
    "Fixed voltage stabilization signal"
    K_p::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PSSSimple(K_ω, K_p, ext=Dict{String, Any}(), )
    PSSSimple(K_ω, K_p, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function PSSSimple(; K_ω, K_p, ext=Dict{String, Any}(), )
    PSSSimple(K_ω, K_p, ext, )
end

# Constructor for demo purposes; non-functional.
function PSSSimple(::Nothing)
    PSSSimple(;
        K_ω=0,
        K_p=0,
        ext=Dict{String, Any}(),
    )
end

"""Get PSSSimple K_ω."""
get_K_ω(value::PSSSimple) = value.K_ω
"""Get PSSSimple K_p."""
get_K_p(value::PSSSimple) = value.K_p
"""Get PSSSimple ext."""
get_ext(value::PSSSimple) = value.ext
"""Get PSSSimple states."""
get_states(value::PSSSimple) = value.states
"""Get PSSSimple n_states."""
get_n_states(value::PSSSimple) = value.n_states
"""Get PSSSimple internal."""
get_internal(value::PSSSimple) = value.internal
