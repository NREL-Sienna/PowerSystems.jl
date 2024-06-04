#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct PSSSimple <: PSS
        K_ω::Float64
        K_p::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of a PSS that returns a proportional droop voltage to add to the reference for the AVR

# Arguments
- `K_ω::Float64`: Proportional gain for frequency, validation range: `(0, nothing)`
- `K_p::Float64`: Proportional gain for active power, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)
- `states::Vector{Symbol}`: (**Do not modify.**) PSSSimple has no [states](@ref S)
- `n_states::Int`: (**Do not modify.**) PSSSimple has no states
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct PSSSimple <: PSS
    "Proportional gain for frequency"
    K_ω::Float64
    "Proportional gain for active power"
    K_p::Float64
    "An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)"
    ext::Dict{String, Any}
    "(**Do not modify.**) PSSSimple has no [states](@ref S)"
    states::Vector{Symbol}
    "(**Do not modify.**) PSSSimple has no states"
    n_states::Int
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function PSSSimple(K_ω, K_p, ext=Dict{String, Any}(), )
    PSSSimple(K_ω, K_p, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function PSSSimple(; K_ω, K_p, ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, internal=InfrastructureSystemsInternal(), )
    PSSSimple(K_ω, K_p, ext, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function PSSSimple(::Nothing)
    PSSSimple(;
        K_ω=0,
        K_p=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`PSSSimple`](@ref) `K_ω`."""
get_K_ω(value::PSSSimple) = value.K_ω
"""Get [`PSSSimple`](@ref) `K_p`."""
get_K_p(value::PSSSimple) = value.K_p
"""Get [`PSSSimple`](@ref) `ext`."""
get_ext(value::PSSSimple) = value.ext
"""Get [`PSSSimple`](@ref) `states`."""
get_states(value::PSSSimple) = value.states
"""Get [`PSSSimple`](@ref) `n_states`."""
get_n_states(value::PSSSimple) = value.n_states
"""Get [`PSSSimple`](@ref) `internal`."""
get_internal(value::PSSSimple) = value.internal

"""Set [`PSSSimple`](@ref) `K_ω`."""
set_K_ω!(value::PSSSimple, val) = value.K_ω = val
"""Set [`PSSSimple`](@ref) `K_p`."""
set_K_p!(value::PSSSimple, val) = value.K_p = val
"""Set [`PSSSimple`](@ref) `ext`."""
set_ext!(value::PSSSimple, val) = value.ext = val
