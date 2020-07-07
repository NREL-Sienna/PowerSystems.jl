#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SalientPoleMachine <: Machine
        R::Float64
        Td0_p::Float64
        Td0_pp::Float64
        Tq0_pp::Float64
        Xd::Float64
        Xq::Float64
        Xd_p::Float64
        Xd_pp::Float64
        Xl::Float64
        Se::Tuple{Float64, Float64}
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 3-states salient-pole synchronous machine with quadratic/exponential saturation:
IEEE Std 1110 §5.3.1 (Model 2.1). GENSAL or GENSAE model in PSSE and PSLF.

# Arguments
- `R::Float64`: Armature resistance, validation range: (0, nothing)
- `Td0_p::Float64`: Time constant of transient d-axis voltage, validation range: (0, nothing)
- `Td0_pp::Float64`: Time constant of sub-transient d-axis voltage, validation range: (0, nothing)
- `Tq0_pp::Float64`: Time constant of sub-transient q-axis voltage, validation range: (0, nothing)
- `Xd::Float64`: Reactance after EMF in d-axis per unit, validation range: (0, nothing)
- `Xq::Float64`: Reactance after EMF in q-axis per unit, validation range: (0, nothing)
- `Xd_p::Float64`: Transient reactance after EMF in d-axis per unit, validation range: (0, nothing)
- `Xd_pp::Float64`: Sub-Transient reactance after EMF in d-axis per unit. Note: Xd_pp = Xq_pp, validation range: (0, nothing)
- `Xl::Float64`: Stator leakage reactance, validation range: (0, nothing)
- `Se::Tuple{Float64, Float64}`: Saturation factor at 1 and 1.2 pu flux: Se(eq_p) = B(eq_p-A)^2
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψq_pp: phasonf of the subtransient flux linkage in the q-axis
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SalientPoleMachine <: Machine
    "Armature resistance"
    R::Float64
    "Time constant of transient d-axis voltage"
    Td0_p::Float64
    "Time constant of sub-transient d-axis voltage"
    Td0_pp::Float64
    "Time constant of sub-transient q-axis voltage"
    Tq0_pp::Float64
    "Reactance after EMF in d-axis per unit"
    Xd::Float64
    "Reactance after EMF in q-axis per unit"
    Xq::Float64
    "Transient reactance after EMF in d-axis per unit"
    Xd_p::Float64
    "Sub-Transient reactance after EMF in d-axis per unit. Note: Xd_pp = Xq_pp"
    Xd_pp::Float64
    "Stator leakage reactance"
    Xl::Float64
    "Saturation factor at 1 and 1.2 pu flux: Se(eq_p) = B(eq_p-A)^2"
    Se::Tuple{Float64, Float64}
    ext::Dict{String, Any}
    "The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψq_pp: phasonf of the subtransient flux linkage in the q-axis"
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SalientPoleMachine(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext=Dict{String, Any}(), )
    SalientPoleMachine(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext, [:eq_p, :ψ_kd, :ψq_pp], 3, InfrastructureSystemsInternal(), )
end

function SalientPoleMachine(; R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext=Dict{String, Any}(), )
    SalientPoleMachine(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext, )
end

# Constructor for demo purposes; non-functional.
function SalientPoleMachine(::Nothing)
    SalientPoleMachine(;
        R=0,
        Td0_p=0,
        Td0_pp=0,
        Tq0_pp=0,
        Xd=0,
        Xq=0,
        Xd_p=0,
        Xd_pp=0,
        Xl=0,
        Se=(0.0, 0.0),
        ext=Dict{String, Any}(),
    )
end

"""Get SalientPoleMachine R."""
get_R(value::SalientPoleMachine) = value.R
"""Get SalientPoleMachine Td0_p."""
get_Td0_p(value::SalientPoleMachine) = value.Td0_p
"""Get SalientPoleMachine Td0_pp."""
get_Td0_pp(value::SalientPoleMachine) = value.Td0_pp
"""Get SalientPoleMachine Tq0_pp."""
get_Tq0_pp(value::SalientPoleMachine) = value.Tq0_pp
"""Get SalientPoleMachine Xd."""
get_Xd(value::SalientPoleMachine) = value.Xd
"""Get SalientPoleMachine Xq."""
get_Xq(value::SalientPoleMachine) = value.Xq
"""Get SalientPoleMachine Xd_p."""
get_Xd_p(value::SalientPoleMachine) = value.Xd_p
"""Get SalientPoleMachine Xd_pp."""
get_Xd_pp(value::SalientPoleMachine) = value.Xd_pp
"""Get SalientPoleMachine Xl."""
get_Xl(value::SalientPoleMachine) = value.Xl
"""Get SalientPoleMachine Se."""
get_Se(value::SalientPoleMachine) = value.Se
"""Get SalientPoleMachine ext."""
get_ext(value::SalientPoleMachine) = value.ext
"""Get SalientPoleMachine states."""
get_states(value::SalientPoleMachine) = value.states
"""Get SalientPoleMachine n_states."""
get_n_states(value::SalientPoleMachine) = value.n_states
"""Get SalientPoleMachine internal."""
get_internal(value::SalientPoleMachine) = value.internal

"""Set SalientPoleMachine R."""
set_R!(value::SalientPoleMachine, val::Float64) = value.R = val
"""Set SalientPoleMachine Td0_p."""
set_Td0_p!(value::SalientPoleMachine, val::Float64) = value.Td0_p = val
"""Set SalientPoleMachine Td0_pp."""
set_Td0_pp!(value::SalientPoleMachine, val::Float64) = value.Td0_pp = val
"""Set SalientPoleMachine Tq0_pp."""
set_Tq0_pp!(value::SalientPoleMachine, val::Float64) = value.Tq0_pp = val
"""Set SalientPoleMachine Xd."""
set_Xd!(value::SalientPoleMachine, val::Float64) = value.Xd = val
"""Set SalientPoleMachine Xq."""
set_Xq!(value::SalientPoleMachine, val::Float64) = value.Xq = val
"""Set SalientPoleMachine Xd_p."""
set_Xd_p!(value::SalientPoleMachine, val::Float64) = value.Xd_p = val
"""Set SalientPoleMachine Xd_pp."""
set_Xd_pp!(value::SalientPoleMachine, val::Float64) = value.Xd_pp = val
"""Set SalientPoleMachine Xl."""
set_Xl!(value::SalientPoleMachine, val::Float64) = value.Xl = val
"""Set SalientPoleMachine Se."""
set_Se!(value::SalientPoleMachine, val::Tuple{Float64, Float64}) = value.Se = val
"""Set SalientPoleMachine ext."""
set_ext!(value::SalientPoleMachine, val::Dict{String, Any}) = value.ext = val
"""Set SalientPoleMachine states."""
set_states!(value::SalientPoleMachine, val::Vector{Symbol}) = value.states = val
"""Set SalientPoleMachine n_states."""
set_n_states!(value::SalientPoleMachine, val::Int64) = value.n_states = val
"""Set SalientPoleMachine internal."""
set_internal!(value::SalientPoleMachine, val::InfrastructureSystemsInternal) = value.internal = val
