#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct BaseMachine <: Machine
        R::Float64
        Xd_p::Float64
        eq_p::Float64
        MVABase::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of an Automatic Voltage Regulator Type II -  Typical static exciter model

# Arguments
- `R::Float64`: Resistance after EMF in machine per unit, validation range: (0, nothing)
- `Xd_p::Float64`: Reactance after EMF in machine per unit, validation range: (0, nothing)
- `eq_p::Float64`: Fixed EMF behind the impedance, validation range: (0, nothing)
- `MVABase::Float64`: Nominal Capacity in MVA, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct BaseMachine <: Machine
    "Resistance after EMF in machine per unit"
    R::Float64
    "Reactance after EMF in machine per unit"
    Xd_p::Float64
    "Fixed EMF behind the impedance"
    eq_p::Float64
    "Nominal Capacity in MVA"
    MVABase::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function BaseMachine(R, Xd_p, eq_p, MVABase, ext=Dict{String, Any}(), )
    BaseMachine(R, Xd_p, eq_p, MVABase, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function BaseMachine(; R, Xd_p, eq_p, MVABase, ext=Dict{String, Any}(), )
    BaseMachine(R, Xd_p, eq_p, MVABase, ext, )
end

# Constructor for demo purposes; non-functional.
function BaseMachine(::Nothing)
    BaseMachine(;
        R=0,
        Xd_p=0,
        eq_p=0,
        MVABase=0,
        ext=Dict{String, Any}(),
    )
end

"""Get BaseMachine R."""
get_R(value::BaseMachine) = value.R
"""Get BaseMachine Xd_p."""
get_Xd_p(value::BaseMachine) = value.Xd_p
"""Get BaseMachine eq_p."""
get_eq_p(value::BaseMachine) = value.eq_p
"""Get BaseMachine MVABase."""
get_MVABase(value::BaseMachine) = value.MVABase
"""Get BaseMachine ext."""
get_ext(value::BaseMachine) = value.ext
"""Get BaseMachine states."""
get_states(value::BaseMachine) = value.states
"""Get BaseMachine n_states."""
get_n_states(value::BaseMachine) = value.n_states
"""Get BaseMachine internal."""
get_internal(value::BaseMachine) = value.internal
