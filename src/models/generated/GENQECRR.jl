#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct GENQECRR <: Machine
        sat_flag::Int
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
        Xq_pp::Float64
        Xl::Float64
        Se::Tuple{Float64, Float64}
        Kw::Float64
        ext::Dict{String, Any}
        γ_d1::Float64
        γ_q1::Float64
        γ_d2::Float64
        γ_q2::Float64
        γ_qd::Float64
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of 4-states round-rotor synchronous machine with optional saturation characteristic:
Based on WECC Report: GENQEC Generator Dynamic Model Specification, www.wecc.org

# Arguments
- `sat_flag::Int`: Flag for saturation characteristic. 0 Exponential saturation, 1 scaled quadratic saturation, 2 quadratic saturation, validation range: `(0, 2)`
- `R::Float64`: Armature resistance, validation range: `(0, nothing)`
- `Td0_p::Float64`: d-axis transient rotor time constant, in s, validation range: `(0, nothing)`
- `Td0_pp::Float64`: d-axis sub-transient rotor time constant, in s, validation range: `(0, nothing)`
- `Tq0_p::Float64`: q-axis transient rotor time constant, in s, validation range: `(0, nothing)`
- `Tq0_pp::Float64`: q-axis sub-transient rotor time constant, in s, validation range: `(0, nothing)`
- `Xd::Float64`: d-axis synchronous reactance, validation range: `(0, nothing)`
- `Xq::Float64`: q-axis synchronous reactance, validation range: `(0, nothing)`
- `Xd_p::Float64`: d-axis transient reactance, validation range: `(0, nothing)`
- `Xq_p::Float64`: q-axis transient reactance, validation range: `(0, nothing)`
- `Xd_pp::Float64`: d-axis subtransient reactance, validation range: `(0, nothing)`
- `Xq_pp::Float64`: q-axis subtransient reactance, validation range: `(0, nothing)`
- `Xl::Float64`: Stator leakage reactance, validation range: `(0, nothing)`
- `Se::Tuple{Float64, Float64}`: Saturation factor at 1 and 1.2 pu flux
- `Kw::Float64`: field current compensation factor, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `γ_d1::Float64`: γ_d1 parameter
- `γ_q1::Float64`: γ_q1 parameter
- `γ_d2::Float64`: γ_d2 parameter
- `γ_q2::Float64`: γ_q2 parameter
- `γ_qd::Float64`: γ_qd parameter
- `states::Vector{Symbol}`: The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ed_p: d-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψ_kq: flux linkage in the first equivalent damping circuit in the d-axis
- `n_states::Int`: GENQECRR has 4 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct GENQECRR <: Machine
    "Flag for saturation characteristic. 0 Exponential saturation, 1 scaled quadratic saturation, 2 quadratic saturation"
    sat_flag::Int
    "Armature resistance"
    R::Float64
    "d-axis transient rotor time constant, in s"
    Td0_p::Float64
    "d-axis sub-transient rotor time constant, in s"
    Td0_pp::Float64
    "q-axis transient rotor time constant, in s"
    Tq0_p::Float64
    "q-axis sub-transient rotor time constant, in s"
    Tq0_pp::Float64
    "d-axis synchronous reactance"
    Xd::Float64
    "q-axis synchronous reactance"
    Xq::Float64
    "d-axis transient reactance"
    Xd_p::Float64
    "q-axis transient reactance"
    Xq_p::Float64
    "d-axis subtransient reactance"
    Xd_pp::Float64
    "q-axis subtransient reactance"
    Xq_pp::Float64
    "Stator leakage reactance"
    Xl::Float64
    "Saturation factor at 1 and 1.2 pu flux"
    Se::Tuple{Float64, Float64}
    "field current compensation factor"
    Kw::Float64
    ext::Dict{String, Any}
    "γ_d1 parameter"
    γ_d1::Float64
    "γ_q1 parameter"
    γ_q1::Float64
    "γ_d2 parameter"
    γ_d2::Float64
    "γ_q2 parameter"
    γ_q2::Float64
    "γ_qd parameter"
    γ_qd::Float64
    "The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ed_p: d-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψ_kq: flux linkage in the first equivalent damping circuit in the d-axis"
    states::Vector{Symbol}
    "GENQECRR has 4 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function GENQECRR(sat_flag, R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Xl, Se, Kw, ext=Dict{String, Any}(), )
    GENQECRR(sat_flag, R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Xl, Se, Kw, ext, (Xd_pp - Xl) / (Xd_p - Xl), (Xd_pp - Xl) / (Xq_p - Xl), (Xd_p - Xd_pp) / (Xd_p - Xl)^2, (Xq_p - Xd_pp) / (Xq_p - Xl)^2, (Xq - Xl) / (Xd - Xl), [:eq_p, :ed_p, :ψ_kd, :ψ_kq], 4, InfrastructureSystemsInternal(), )
end

function GENQECRR(; sat_flag, R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Xl, Se, Kw, ext=Dict{String, Any}(), γ_d1=(Xd_pp - Xl) / (Xd_p - Xl), γ_q1=(Xd_pp - Xl) / (Xq_p - Xl), γ_d2=(Xd_p - Xd_pp) / (Xd_p - Xl)^2, γ_q2=(Xq_p - Xd_pp) / (Xq_p - Xl)^2, γ_qd=(Xq - Xl) / (Xd - Xl), states=[:eq_p, :ed_p, :ψ_kd, :ψ_kq], n_states=4, internal=InfrastructureSystemsInternal(), )
    GENQECRR(sat_flag, R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Xl, Se, Kw, ext, γ_d1, γ_q1, γ_d2, γ_q2, γ_qd, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function GENQECRR(::Nothing)
    GENQECRR(;
        sat_flag=0,
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
        Xq_pp=0,
        Xl=0,
        Se=(0.0, 0.0),
        Kw=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`GENQECRR`](@ref) `sat_flag`."""
get_sat_flag(value::GENQECRR) = value.sat_flag
"""Get [`GENQECRR`](@ref) `R`."""
get_R(value::GENQECRR) = value.R
"""Get [`GENQECRR`](@ref) `Td0_p`."""
get_Td0_p(value::GENQECRR) = value.Td0_p
"""Get [`GENQECRR`](@ref) `Td0_pp`."""
get_Td0_pp(value::GENQECRR) = value.Td0_pp
"""Get [`GENQECRR`](@ref) `Tq0_p`."""
get_Tq0_p(value::GENQECRR) = value.Tq0_p
"""Get [`GENQECRR`](@ref) `Tq0_pp`."""
get_Tq0_pp(value::GENQECRR) = value.Tq0_pp
"""Get [`GENQECRR`](@ref) `Xd`."""
get_Xd(value::GENQECRR) = value.Xd
"""Get [`GENQECRR`](@ref) `Xq`."""
get_Xq(value::GENQECRR) = value.Xq
"""Get [`GENQECRR`](@ref) `Xd_p`."""
get_Xd_p(value::GENQECRR) = value.Xd_p
"""Get [`GENQECRR`](@ref) `Xq_p`."""
get_Xq_p(value::GENQECRR) = value.Xq_p
"""Get [`GENQECRR`](@ref) `Xd_pp`."""
get_Xd_pp(value::GENQECRR) = value.Xd_pp
"""Get [`GENQECRR`](@ref) `Xq_pp`."""
get_Xq_pp(value::GENQECRR) = value.Xq_pp
"""Get [`GENQECRR`](@ref) `Xl`."""
get_Xl(value::GENQECRR) = value.Xl
"""Get [`GENQECRR`](@ref) `Se`."""
get_Se(value::GENQECRR) = value.Se
"""Get [`GENQECRR`](@ref) `Kw`."""
get_Kw(value::GENQECRR) = value.Kw
"""Get [`GENQECRR`](@ref) `ext`."""
get_ext(value::GENQECRR) = value.ext
"""Get [`GENQECRR`](@ref) `γ_d1`."""
get_γ_d1(value::GENQECRR) = value.γ_d1
"""Get [`GENQECRR`](@ref) `γ_q1`."""
get_γ_q1(value::GENQECRR) = value.γ_q1
"""Get [`GENQECRR`](@ref) `γ_d2`."""
get_γ_d2(value::GENQECRR) = value.γ_d2
"""Get [`GENQECRR`](@ref) `γ_q2`."""
get_γ_q2(value::GENQECRR) = value.γ_q2
"""Get [`GENQECRR`](@ref) `γ_qd`."""
get_γ_qd(value::GENQECRR) = value.γ_qd
"""Get [`GENQECRR`](@ref) `states`."""
get_states(value::GENQECRR) = value.states
"""Get [`GENQECRR`](@ref) `n_states`."""
get_n_states(value::GENQECRR) = value.n_states
"""Get [`GENQECRR`](@ref) `internal`."""
get_internal(value::GENQECRR) = value.internal

"""Set [`GENQECRR`](@ref) `sat_flag`."""
set_sat_flag!(value::GENQECRR, val) = value.sat_flag = val
"""Set [`GENQECRR`](@ref) `R`."""
set_R!(value::GENQECRR, val) = value.R = val
"""Set [`GENQECRR`](@ref) `Td0_p`."""
set_Td0_p!(value::GENQECRR, val) = value.Td0_p = val
"""Set [`GENQECRR`](@ref) `Td0_pp`."""
set_Td0_pp!(value::GENQECRR, val) = value.Td0_pp = val
"""Set [`GENQECRR`](@ref) `Tq0_p`."""
set_Tq0_p!(value::GENQECRR, val) = value.Tq0_p = val
"""Set [`GENQECRR`](@ref) `Tq0_pp`."""
set_Tq0_pp!(value::GENQECRR, val) = value.Tq0_pp = val
"""Set [`GENQECRR`](@ref) `Xd`."""
set_Xd!(value::GENQECRR, val) = value.Xd = val
"""Set [`GENQECRR`](@ref) `Xq`."""
set_Xq!(value::GENQECRR, val) = value.Xq = val
"""Set [`GENQECRR`](@ref) `Xd_p`."""
set_Xd_p!(value::GENQECRR, val) = value.Xd_p = val
"""Set [`GENQECRR`](@ref) `Xq_p`."""
set_Xq_p!(value::GENQECRR, val) = value.Xq_p = val
"""Set [`GENQECRR`](@ref) `Xd_pp`."""
set_Xd_pp!(value::GENQECRR, val) = value.Xd_pp = val
"""Set [`GENQECRR`](@ref) `Xq_pp`."""
set_Xq_pp!(value::GENQECRR, val) = value.Xq_pp = val
"""Set [`GENQECRR`](@ref) `Xl`."""
set_Xl!(value::GENQECRR, val) = value.Xl = val
"""Set [`GENQECRR`](@ref) `Se`."""
set_Se!(value::GENQECRR, val) = value.Se = val
"""Set [`GENQECRR`](@ref) `Kw`."""
set_Kw!(value::GENQECRR, val) = value.Kw = val
"""Set [`GENQECRR`](@ref) `ext`."""
set_ext!(value::GENQECRR, val) = value.ext = val
"""Set [`GENQECRR`](@ref) `γ_d1`."""
set_γ_d1!(value::GENQECRR, val) = value.γ_d1 = val
"""Set [`GENQECRR`](@ref) `γ_q1`."""
set_γ_q1!(value::GENQECRR, val) = value.γ_q1 = val
"""Set [`GENQECRR`](@ref) `γ_d2`."""
set_γ_d2!(value::GENQECRR, val) = value.γ_d2 = val
"""Set [`GENQECRR`](@ref) `γ_q2`."""
set_γ_q2!(value::GENQECRR, val) = value.γ_q2 = val
"""Set [`GENQECRR`](@ref) `γ_qd`."""
set_γ_qd!(value::GENQECRR, val) = value.γ_qd = val
