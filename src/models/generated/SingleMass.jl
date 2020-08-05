#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SingleMass <: Shaft
        H::Float64
        D::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of single mass shaft model. Typically represents the rotor mass.

# Arguments
- `H::Float64`: Rotor inertia constant in MWs/MVA, validation range: (0, nothing)
- `D::Float64`: Rotor natural damping in pu, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	δ: rotor angle,
	ω: rotor speed
- `n_states::Int64`: SingleMass has 1 state
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SingleMass <: Shaft
    "Rotor inertia constant in MWs/MVA"
    H::Float64
    "Rotor natural damping in pu"
    D::Float64
    ext::Dict{String, Any}
    "The states are:
	δ: rotor angle,
	ω: rotor speed"
    states::Vector{Symbol}
    "SingleMass has 1 state"
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SingleMass(H, D, ext=Dict{String, Any}(), )
    SingleMass(H, D, ext, [:δ, :ω], 2, InfrastructureSystemsInternal(), )
end

function SingleMass(; H, D, ext=Dict{String, Any}(), )
    SingleMass(H, D, ext, )
end

# Constructor for demo purposes; non-functional.
function SingleMass(::Nothing)
    SingleMass(;
        H=0,
        D=0,
        ext=Dict{String, Any}(),
    )
end

"""Get SingleMass H."""
get_H(value::SingleMass) = value.H
"""Get SingleMass D."""
get_D(value::SingleMass) = value.D
"""Get SingleMass ext."""
get_ext(value::SingleMass) = value.ext
"""Get SingleMass states."""
get_states(value::SingleMass) = value.states
"""Get SingleMass n_states."""
get_n_states(value::SingleMass) = value.n_states
"""Get SingleMass internal."""
get_internal(value::SingleMass) = value.internal

"""Set SingleMass H."""
set_H!(value::SingleMass, val) = value.H = val
"""Set SingleMass D."""
set_D!(value::SingleMass, val) = value.D = val
"""Set SingleMass ext."""
set_ext!(value::SingleMass, val) = value.ext = val
"""Set SingleMass states."""
set_states!(value::SingleMass, val) = value.states = val
"""Set SingleMass n_states."""
set_n_states!(value::SingleMass, val) = value.n_states = val
"""Set SingleMass internal."""
set_internal!(value::SingleMass, val) = value.internal = val
