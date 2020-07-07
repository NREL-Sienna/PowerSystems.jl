#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RoundRotorMachine <: Machine
        R::Float64
        Td0_p::Float64
        Td0_pp::Float64
        Tq0_p::Float64
        Tq0_pp::Float64
        Xd::Float64
        Xq::Float64
        Xd_p::Float64
        Xq_p::Float64
        Xd_pp::Float64
        Xl::Float64
        Se::Tuple{Float64, Float64}
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 4-states round-rotor synchronous machine with quadratic/exponential saturation:
IEEE Std 1110 §5.3.2 (Model 2.2). GENROU or GENROE model in PSSE and PSLF.

# Arguments
- `R::Float64`: Armature resistance, validation range: (0, nothing)
- `Td0_p::Float64`: Time constant of transient d-axis voltage, validation range: (0, nothing)
- `Td0_pp::Float64`: Time constant of sub-transient d-axis voltage, validation range: (0, nothing)
- `Tq0_p::Float64`: Time constant of transient q-axis voltage, validation range: (0, nothing)
- `Tq0_pp::Float64`: Time constant of sub-transient q-axis voltage, validation range: (0, nothing)
- `Xd::Float64`: Reactance after EMF in d-axis per unit, validation range: (0, nothing)
- `Xq::Float64`: Reactance after EMF in q-axis per unit, validation range: (0, nothing)
- `Xd_p::Float64`: Transient reactance after EMF in d-axis per unit, validation range: (0, nothing)
- `Xq_p::Float64`: Transient reactance after EMF in q-axis per unit, validation range: (0, nothing)
- `Xd_pp::Float64`: Sub-Transient reactance after EMF in d-axis per unit. Note: Xd_pp = Xq_pp, validation range: (0, nothing)
- `Xl::Float64`: Stator leakage reactance, validation range: (0, nothing)
- `Se::Tuple{Float64, Float64}`: Saturation factor at 1 and 1.2 pu flux: S(1.0) = B(|ψ_pp|-A)^2
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ed_p: d-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψ_kq: flux linkage in the first equivalent damping circuit in the d-axis
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RoundRotorMachine <: Machine
    "Armature resistance"
    R::Float64
    "Time constant of transient d-axis voltage"
    Td0_p::Float64
    "Time constant of sub-transient d-axis voltage"
    Td0_pp::Float64
    "Time constant of transient q-axis voltage"
    Tq0_p::Float64
    "Time constant of sub-transient q-axis voltage"
    Tq0_pp::Float64
    "Reactance after EMF in d-axis per unit"
    Xd::Float64
    "Reactance after EMF in q-axis per unit"
    Xq::Float64
    "Transient reactance after EMF in d-axis per unit"
    Xd_p::Float64
    "Transient reactance after EMF in q-axis per unit"
    Xq_p::Float64
    "Sub-Transient reactance after EMF in d-axis per unit. Note: Xd_pp = Xq_pp"
    Xd_pp::Float64
    "Stator leakage reactance"
    Xl::Float64
    "Saturation factor at 1 and 1.2 pu flux: S(1.0) = B(|ψ_pp|-A)^2"
    Se::Tuple{Float64, Float64}
    ext::Dict{String, Any}
    "The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ed_p: d-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψ_kq: flux linkage in the first equivalent damping circuit in the d-axis"
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function RoundRotorMachine(R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, Se, ext=Dict{String, Any}(), )
    RoundRotorMachine(R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, Se, ext, [:eq_p, :ed_p, :ψ_kd, :ψ_kq], 4, InfrastructureSystemsInternal(), )
end

function RoundRotorMachine(; R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, Se, ext=Dict{String, Any}(), )
    RoundRotorMachine(R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, Se, ext, )
end

# Constructor for demo purposes; non-functional.
function RoundRotorMachine(::Nothing)
    RoundRotorMachine(;
        R=0.0,
        Td0_p=0.0,
        Td0_pp=0.0,
        Tq0_p=0.0,
        Tq0_pp=0.0,
        Xd=0.0,
        Xq=0.0,
        Xd_p=0.0,
        Xq_p=0.0,
        Xd_pp=0.0,
        Xl=0.0,
        Se=(0.0, 0.0),
        ext=Dict{String, Any}(),
    )
end

"""Get RoundRotorMachine R."""
get_R(value::RoundRotorMachine) = value.R
"""Get RoundRotorMachine Td0_p."""
get_Td0_p(value::RoundRotorMachine) = value.Td0_p
"""Get RoundRotorMachine Td0_pp."""
get_Td0_pp(value::RoundRotorMachine) = value.Td0_pp
"""Get RoundRotorMachine Tq0_p."""
get_Tq0_p(value::RoundRotorMachine) = value.Tq0_p
"""Get RoundRotorMachine Tq0_pp."""
get_Tq0_pp(value::RoundRotorMachine) = value.Tq0_pp
"""Get RoundRotorMachine Xd."""
get_Xd(value::RoundRotorMachine) = value.Xd
"""Get RoundRotorMachine Xq."""
get_Xq(value::RoundRotorMachine) = value.Xq
"""Get RoundRotorMachine Xd_p."""
get_Xd_p(value::RoundRotorMachine) = value.Xd_p
"""Get RoundRotorMachine Xq_p."""
get_Xq_p(value::RoundRotorMachine) = value.Xq_p
"""Get RoundRotorMachine Xd_pp."""
get_Xd_pp(value::RoundRotorMachine) = value.Xd_pp
"""Get RoundRotorMachine Xl."""
get_Xl(value::RoundRotorMachine) = value.Xl
"""Get RoundRotorMachine Se."""
get_Se(value::RoundRotorMachine) = value.Se
"""Get RoundRotorMachine ext."""
get_ext(value::RoundRotorMachine) = value.ext
"""Get RoundRotorMachine states."""
get_states(value::RoundRotorMachine) = value.states
"""Get RoundRotorMachine n_states."""
get_n_states(value::RoundRotorMachine) = value.n_states
"""Get RoundRotorMachine internal."""
get_internal(value::RoundRotorMachine) = value.internal

"""Set RoundRotorMachine R."""
set_R!(value::RoundRotorMachine, val::Float64) = value.R = val
"""Set RoundRotorMachine Td0_p."""
set_Td0_p!(value::RoundRotorMachine, val::Float64) = value.Td0_p = val
"""Set RoundRotorMachine Td0_pp."""
set_Td0_pp!(value::RoundRotorMachine, val::Float64) = value.Td0_pp = val
"""Set RoundRotorMachine Tq0_p."""
set_Tq0_p!(value::RoundRotorMachine, val::Float64) = value.Tq0_p = val
"""Set RoundRotorMachine Tq0_pp."""
set_Tq0_pp!(value::RoundRotorMachine, val::Float64) = value.Tq0_pp = val
"""Set RoundRotorMachine Xd."""
set_Xd!(value::RoundRotorMachine, val::Float64) = value.Xd = val
"""Set RoundRotorMachine Xq."""
set_Xq!(value::RoundRotorMachine, val::Float64) = value.Xq = val
"""Set RoundRotorMachine Xd_p."""
set_Xd_p!(value::RoundRotorMachine, val::Float64) = value.Xd_p = val
"""Set RoundRotorMachine Xq_p."""
set_Xq_p!(value::RoundRotorMachine, val::Float64) = value.Xq_p = val
"""Set RoundRotorMachine Xd_pp."""
set_Xd_pp!(value::RoundRotorMachine, val::Float64) = value.Xd_pp = val
"""Set RoundRotorMachine Xl."""
set_Xl!(value::RoundRotorMachine, val::Float64) = value.Xl = val
"""Set RoundRotorMachine Se."""
set_Se!(value::RoundRotorMachine, val::Tuple{Float64, Float64}) = value.Se = val
"""Set RoundRotorMachine ext."""
set_ext!(value::RoundRotorMachine, val::Dict{String, Any}) = value.ext = val
"""Set RoundRotorMachine states."""
set_states!(value::RoundRotorMachine, val::Vector{Symbol}) = value.states = val
"""Set RoundRotorMachine n_states."""
set_n_states!(value::RoundRotorMachine, val::Int64) = value.n_states = val
"""Set RoundRotorMachine internal."""
set_internal!(value::RoundRotorMachine, val::InfrastructureSystemsInternal) = value.internal = val
