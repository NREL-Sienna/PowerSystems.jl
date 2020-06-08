#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct GENROU <: Machine
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
        S1_0::Float64
        S1_2::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 4-states round-rotor synchronous machine: GENROU model

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
- `S1_0::Float64`: Saturation factor at 1 pu flux: S(1.0) = B(|ψ_pp|-A) -> S(1.2) = B(1.2-A)^2, validation range: (0, nothing)
- `S1_2::Float64`: Saturation factor at 1.2 pu flux: S(1.2) = B(|ψ_pp|-A)^2 -> S(1.2) = B(1.2-A)^2, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ed_p: d-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψ_kq: flux linkage in the first equivalent damping circuit in the d-axis
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct GENROU <: Machine
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
    "Saturation factor at 1 pu flux: S(1.0) = B(|ψ_pp|-A) -> S(1.2) = B(1.2-A)^2"
    S1_0::Float64
    "Saturation factor at 1.2 pu flux: S(1.2) = B(|ψ_pp|-A)^2 -> S(1.2) = B(1.2-A)^2"
    S1_2::Float64
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

function GENROU(R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, S1_0, S1_2, ext=Dict{String, Any}(), )
    GENROU(R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, S1_0, S1_2, ext, [:eq_p, :ed_p, :ψ_kd, :ψ_kq], 4, InfrastructureSystemsInternal(), )
end

function GENROU(; R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, S1_0, S1_2, ext=Dict{String, Any}(), )
    GENROU(R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, S1_0, S1_2, ext, )
end

# Constructor for demo purposes; non-functional.
function GENROU(::Nothing)
    GENROU(;
        R=0,
        Td0_p=0,
        Td0_pp=0,
        Tq0_p=0,
        Tq0_pp=0,
        Xd=0,
        Xq=0,
        Xd_p=0,
        Xq_p=0,
        Xd_pp=0,
        Xl=0,
        S1_0=0,
        S1_2=0,
        ext=Dict{String, Any}(),
    )
end

"""Get GENROU R."""
get_R(value::GENROU) = value.R
"""Get GENROU Td0_p."""
get_Td0_p(value::GENROU) = value.Td0_p
"""Get GENROU Td0_pp."""
get_Td0_pp(value::GENROU) = value.Td0_pp
"""Get GENROU Tq0_p."""
get_Tq0_p(value::GENROU) = value.Tq0_p
"""Get GENROU Tq0_pp."""
get_Tq0_pp(value::GENROU) = value.Tq0_pp
"""Get GENROU Xd."""
get_Xd(value::GENROU) = value.Xd
"""Get GENROU Xq."""
get_Xq(value::GENROU) = value.Xq
"""Get GENROU Xd_p."""
get_Xd_p(value::GENROU) = value.Xd_p
"""Get GENROU Xq_p."""
get_Xq_p(value::GENROU) = value.Xq_p
"""Get GENROU Xd_pp."""
get_Xd_pp(value::GENROU) = value.Xd_pp
"""Get GENROU Xl."""
get_Xl(value::GENROU) = value.Xl
"""Get GENROU S1_0."""
get_S1_0(value::GENROU) = value.S1_0
"""Get GENROU S1_2."""
get_S1_2(value::GENROU) = value.S1_2
"""Get GENROU ext."""
get_ext(value::GENROU) = value.ext
"""Get GENROU states."""
get_states(value::GENROU) = value.states
"""Get GENROU n_states."""
get_n_states(value::GENROU) = value.n_states
"""Get GENROU internal."""
get_internal(value::GENROU) = value.internal

"""Set GENROU R."""
set_R!(value::GENROU, val::Float64) = value.R = val
"""Set GENROU Td0_p."""
set_Td0_p!(value::GENROU, val::Float64) = value.Td0_p = val
"""Set GENROU Td0_pp."""
set_Td0_pp!(value::GENROU, val::Float64) = value.Td0_pp = val
"""Set GENROU Tq0_p."""
set_Tq0_p!(value::GENROU, val::Float64) = value.Tq0_p = val
"""Set GENROU Tq0_pp."""
set_Tq0_pp!(value::GENROU, val::Float64) = value.Tq0_pp = val
"""Set GENROU Xd."""
set_Xd!(value::GENROU, val::Float64) = value.Xd = val
"""Set GENROU Xq."""
set_Xq!(value::GENROU, val::Float64) = value.Xq = val
"""Set GENROU Xd_p."""
set_Xd_p!(value::GENROU, val::Float64) = value.Xd_p = val
"""Set GENROU Xq_p."""
set_Xq_p!(value::GENROU, val::Float64) = value.Xq_p = val
"""Set GENROU Xd_pp."""
set_Xd_pp!(value::GENROU, val::Float64) = value.Xd_pp = val
"""Set GENROU Xl."""
set_Xl!(value::GENROU, val::Float64) = value.Xl = val
"""Set GENROU S1_0."""
set_S1_0!(value::GENROU, val::Float64) = value.S1_0 = val
"""Set GENROU S1_2."""
set_S1_2!(value::GENROU, val::Float64) = value.S1_2 = val
"""Set GENROU ext."""
set_ext!(value::GENROU, val::Dict{String, Any}) = value.ext = val
"""Set GENROU states."""
set_states!(value::GENROU, val::Vector{Symbol}) = value.states = val
"""Set GENROU n_states."""
set_n_states!(value::GENROU, val::Int64) = value.n_states = val
"""Set GENROU internal."""
set_internal!(value::GENROU, val::InfrastructureSystemsInternal) = value.internal = val
