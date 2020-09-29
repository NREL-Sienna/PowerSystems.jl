#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct BaseMachine <: Machine
        R::Float64
        Xd_p::Float64
        eq_p::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of a Classic Machine: GENCLS in PSSE and PSLF

# Arguments
- `R::Float64`: Resistance after EMF in machine per unit, validation range: `(0, nothing)`
- `Xd_p::Float64`: Reactance after EMF in machine per unit, validation range: `(0, nothing)`
- `eq_p::Float64`: Fixed EMF behind the impedance, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: BaseMachine has no states
- `n_states::Int`: BaseMachine has no states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct BaseMachine <: Machine
    "Resistance after EMF in machine per unit"
    R::Float64
    "Reactance after EMF in machine per unit"
    Xd_p::Float64
    "Fixed EMF behind the impedance"
    eq_p::Float64
    ext::Dict{String, Any}
    "BaseMachine has no states"
    states::Vector{Symbol}
    "BaseMachine has no states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function BaseMachine(R, Xd_p, eq_p, ext=Dict{String, Any}(), )
    BaseMachine(R, Xd_p, eq_p, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function BaseMachine(; R, Xd_p, eq_p, ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, internal=InfrastructureSystemsInternal(), )
    BaseMachine(R, Xd_p, eq_p, ext, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function BaseMachine(::Nothing)
    BaseMachine(;
        R=0,
        Xd_p=0,
        eq_p=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`BaseMachine`](@ref) `R`."""
get_R(value::BaseMachine) = value.R
"""Get [`BaseMachine`](@ref) `Xd_p`."""
get_Xd_p(value::BaseMachine) = value.Xd_p
"""Get [`BaseMachine`](@ref) `eq_p`."""
get_eq_p(value::BaseMachine) = value.eq_p
"""Get [`BaseMachine`](@ref) `ext`."""
get_ext(value::BaseMachine) = value.ext
"""Get [`BaseMachine`](@ref) `states`."""
get_states(value::BaseMachine) = value.states
"""Get [`BaseMachine`](@ref) `n_states`."""
get_n_states(value::BaseMachine) = value.n_states
"""Get [`BaseMachine`](@ref) `internal`."""
get_internal(value::BaseMachine) = value.internal

"""Set [`BaseMachine`](@ref) `R`."""
set_R!(value::BaseMachine, val) = value.R = val
"""Set [`BaseMachine`](@ref) `Xd_p`."""
set_Xd_p!(value::BaseMachine, val) = value.Xd_p = val
"""Set [`BaseMachine`](@ref) `eq_p`."""
set_eq_p!(value::BaseMachine, val) = value.eq_p = val
"""Set [`BaseMachine`](@ref) `ext`."""
set_ext!(value::BaseMachine, val) = value.ext = val
"""Set [`BaseMachine`](@ref) `internal`."""
set_internal!(value::BaseMachine, val) = value.internal = val

