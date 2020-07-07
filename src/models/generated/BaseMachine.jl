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
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a Classic Machine: GENCLS in PSSE and PSLF

# Arguments
- `R::Float64`: Resistance after EMF in machine per unit, validation range: (0, nothing)
- `Xd_p::Float64`: Reactance after EMF in machine per unit, validation range: (0, nothing)
- `eq_p::Float64`: Fixed EMF behind the impedance, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: BaseMachine has no states
- `n_states::Int64`: BaseMachine has no states
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
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function BaseMachine(R, Xd_p, eq_p, ext=Dict{String, Any}(), )
    BaseMachine(R, Xd_p, eq_p, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function BaseMachine(; R, Xd_p, eq_p, ext=Dict{String, Any}(), )
    BaseMachine(R, Xd_p, eq_p, ext, )
end

# Constructor for demo purposes; non-functional.
function BaseMachine(::Nothing)
    BaseMachine(;
        R=0.0,
        Xd_p=0.0,
        eq_p=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get BaseMachine R."""
get_R(value::BaseMachine) = value.R
"""Get BaseMachine Xd_p."""
get_Xd_p(value::BaseMachine) = value.Xd_p
"""Get BaseMachine eq_p."""
get_eq_p(value::BaseMachine) = value.eq_p
"""Get BaseMachine ext."""
get_ext(value::BaseMachine) = value.ext
"""Get BaseMachine states."""
get_states(value::BaseMachine) = value.states
"""Get BaseMachine n_states."""
get_n_states(value::BaseMachine) = value.n_states
"""Get BaseMachine internal."""
get_internal(value::BaseMachine) = value.internal

"""Set BaseMachine R."""
set_R!(value::BaseMachine, val::Float64) = value.R = val
"""Set BaseMachine Xd_p."""
set_Xd_p!(value::BaseMachine, val::Float64) = value.Xd_p = val
"""Set BaseMachine eq_p."""
set_eq_p!(value::BaseMachine, val::Float64) = value.eq_p = val
"""Set BaseMachine ext."""
set_ext!(value::BaseMachine, val::Dict{String, Any}) = value.ext = val
"""Set BaseMachine states."""
set_states!(value::BaseMachine, val::Vector{Symbol}) = value.states = val
"""Set BaseMachine n_states."""
set_n_states!(value::BaseMachine, val::Int64) = value.n_states = val
"""Set BaseMachine internal."""
set_internal!(value::BaseMachine, val::InfrastructureSystemsInternal) = value.internal = val
