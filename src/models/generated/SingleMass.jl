#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct SingleMass <: Shaft
        H::Float64
        D::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of single mass shaft model. Typically represents the rotor mass.

# Arguments
- `H::Float64`: Rotor inertia constant in MWs/MVA, validation range: `(0, nothing)`
- `D::Float64`: Rotor natural damping in pu, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `states::Vector{Symbol}`: The states are:
	δ: rotor angle,
	ω: rotor speed
- `n_states::Int`: SingleMass has 1 state
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SingleMass <: Shaft
    "Rotor inertia constant in MWs/MVA"
    H::Float64
    "Rotor natural damping in pu"
    D::Float64
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "The states are:
	δ: rotor angle,
	ω: rotor speed"
    states::Vector{Symbol}
    "SingleMass has 1 state"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SingleMass(H, D, ext=Dict{String, Any}(), )
    SingleMass(H, D, ext, [:δ, :ω], 2, InfrastructureSystemsInternal(), )
end

function SingleMass(; H, D, ext=Dict{String, Any}(), states=[:δ, :ω], n_states=2, internal=InfrastructureSystemsInternal(), )
    SingleMass(H, D, ext, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function SingleMass(::Nothing)
    SingleMass(;
        H=0,
        D=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`SingleMass`](@ref) `H`."""
get_H(value::SingleMass) = value.H
"""Get [`SingleMass`](@ref) `D`."""
get_D(value::SingleMass) = value.D
"""Get [`SingleMass`](@ref) `ext`."""
get_ext(value::SingleMass) = value.ext
"""Get [`SingleMass`](@ref) `states`."""
get_states(value::SingleMass) = value.states
"""Get [`SingleMass`](@ref) `n_states`."""
get_n_states(value::SingleMass) = value.n_states
"""Get [`SingleMass`](@ref) `internal`."""
get_internal(value::SingleMass) = value.internal

"""Set [`SingleMass`](@ref) `H`."""
set_H!(value::SingleMass, val) = value.H = val
"""Set [`SingleMass`](@ref) `D`."""
set_D!(value::SingleMass, val) = value.D = val
"""Set [`SingleMass`](@ref) `ext`."""
set_ext!(value::SingleMass, val) = value.ext = val
