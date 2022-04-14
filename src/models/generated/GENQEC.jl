#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct GENQEC <: Machine
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
        saturation_coeffs::Tuple{Float64, Float64}
        ext::Dict{String, Any}
        γ_d1::Float64
        γ_q1::Float64
        γ_d2::Float64
        γ_q2::Float64
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of 4-states synchronous machine with optional saturation characteristic:
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
- `Kw::Float64`: Rotor field current compensation factor, validation range: `(0, nothing)`
- `saturation_coeffs::Tuple{Float64, Float64}`: Coefficients (A,B) of the saturation function
- `ext::Dict{String, Any}`
- `γ_d1::Float64`: γ_d1 parameter
- `γ_q1::Float64`: γ_q1 parameter
- `γ_d2::Float64`: γ_d2 parameter
- `γ_q2::Float64`: γ_q2 parameter
- `states::Vector{Symbol}`: The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ed_p: d-axis generator voltage behind the transient reactance,
	ψd_p: flux linkage in the first equivalent damping circuit in the d-axis,
	ψq_p: flux linkage in the first equivalent damping circuit in the q-axis
- `n_states::Int`: GENQEC has 4 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct GENQEC <: Machine
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
    "Rotor field current compensation factor"
    Kw::Float64
    "Coefficients (A,B) of the saturation function"
    saturation_coeffs::Tuple{Float64, Float64}
    ext::Dict{String, Any}
    "γ_d1 parameter"
    γ_d1::Float64
    "γ_q1 parameter"
    γ_q1::Float64
    "γ_d2 parameter"
    γ_d2::Float64
    "γ_q2 parameter"
    γ_q2::Float64
    "The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ed_p: d-axis generator voltage behind the transient reactance,
	ψd_p: flux linkage in the first equivalent damping circuit in the d-axis,
	ψq_p: flux linkage in the first equivalent damping circuit in the q-axis"
    states::Vector{Symbol}
    "GENQEC has 4 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function GENQEC(sat_flag, R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Xl, Se, Kw, saturation_coeffs=PowerSystems.get_genqec_saturation(Se, sat_flag), ext=Dict{String, Any}(), )
    GENQEC(sat_flag, R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Xl, Se, Kw, saturation_coeffs, ext, (Xd_pp - Xl) / (Xd_p - Xl), (Xq_pp - Xl) / (Xq_p - Xl), (Xd_p - Xd_pp) / (Xd_p - Xl)^2, (Xq_p - Xq_pp) / (Xq_p - Xl)^2, [:eq_p, :ed_p, :ψd_p, :ψq_p], 4, InfrastructureSystemsInternal(), )
end

function GENQEC(; sat_flag, R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Xl, Se, Kw, saturation_coeffs=PowerSystems.get_genqec_saturation(Se, sat_flag), ext=Dict{String, Any}(), γ_d1=(Xd_pp - Xl) / (Xd_p - Xl), γ_q1=(Xq_pp - Xl) / (Xq_p - Xl), γ_d2=(Xd_p - Xd_pp) / (Xd_p - Xl)^2, γ_q2=(Xq_p - Xq_pp) / (Xq_p - Xl)^2, states=[:eq_p, :ed_p, :ψd_p, :ψq_p], n_states=4, internal=InfrastructureSystemsInternal(), )
    GENQEC(sat_flag, R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Xl, Se, Kw, saturation_coeffs, ext, γ_d1, γ_q1, γ_d2, γ_q2, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function GENQEC(::Nothing)
    GENQEC(;
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
        saturation_coeffs=(0.0, 0.0),
        ext=Dict{String, Any}(),
    )
end

"""Get [`GENQEC`](@ref) `sat_flag`."""
get_sat_flag(value::GENQEC) = value.sat_flag
"""Get [`GENQEC`](@ref) `R`."""
get_R(value::GENQEC) = value.R
"""Get [`GENQEC`](@ref) `Td0_p`."""
get_Td0_p(value::GENQEC) = value.Td0_p
"""Get [`GENQEC`](@ref) `Td0_pp`."""
get_Td0_pp(value::GENQEC) = value.Td0_pp
"""Get [`GENQEC`](@ref) `Tq0_p`."""
get_Tq0_p(value::GENQEC) = value.Tq0_p
"""Get [`GENQEC`](@ref) `Tq0_pp`."""
get_Tq0_pp(value::GENQEC) = value.Tq0_pp
"""Get [`GENQEC`](@ref) `Xd`."""
get_Xd(value::GENQEC) = value.Xd
"""Get [`GENQEC`](@ref) `Xq`."""
get_Xq(value::GENQEC) = value.Xq
"""Get [`GENQEC`](@ref) `Xd_p`."""
get_Xd_p(value::GENQEC) = value.Xd_p
"""Get [`GENQEC`](@ref) `Xq_p`."""
get_Xq_p(value::GENQEC) = value.Xq_p
"""Get [`GENQEC`](@ref) `Xd_pp`."""
get_Xd_pp(value::GENQEC) = value.Xd_pp
"""Get [`GENQEC`](@ref) `Xq_pp`."""
get_Xq_pp(value::GENQEC) = value.Xq_pp
"""Get [`GENQEC`](@ref) `Xl`."""
get_Xl(value::GENQEC) = value.Xl
"""Get [`GENQEC`](@ref) `Se`."""
get_Se(value::GENQEC) = value.Se
"""Get [`GENQEC`](@ref) `Kw`."""
get_Kw(value::GENQEC) = value.Kw
"""Get [`GENQEC`](@ref) `saturation_coeffs`."""
get_saturation_coeffs(value::GENQEC) = value.saturation_coeffs
"""Get [`GENQEC`](@ref) `ext`."""
get_ext(value::GENQEC) = value.ext
"""Get [`GENQEC`](@ref) `γ_d1`."""
get_γ_d1(value::GENQEC) = value.γ_d1
"""Get [`GENQEC`](@ref) `γ_q1`."""
get_γ_q1(value::GENQEC) = value.γ_q1
"""Get [`GENQEC`](@ref) `γ_d2`."""
get_γ_d2(value::GENQEC) = value.γ_d2
"""Get [`GENQEC`](@ref) `γ_q2`."""
get_γ_q2(value::GENQEC) = value.γ_q2
"""Get [`GENQEC`](@ref) `states`."""
get_states(value::GENQEC) = value.states
"""Get [`GENQEC`](@ref) `n_states`."""
get_n_states(value::GENQEC) = value.n_states
"""Get [`GENQEC`](@ref) `internal`."""
get_internal(value::GENQEC) = value.internal

"""Set [`GENQEC`](@ref) `sat_flag`."""
set_sat_flag!(value::GENQEC, val) = value.sat_flag = val
"""Set [`GENQEC`](@ref) `R`."""
set_R!(value::GENQEC, val) = value.R = val
"""Set [`GENQEC`](@ref) `Td0_p`."""
set_Td0_p!(value::GENQEC, val) = value.Td0_p = val
"""Set [`GENQEC`](@ref) `Td0_pp`."""
set_Td0_pp!(value::GENQEC, val) = value.Td0_pp = val
"""Set [`GENQEC`](@ref) `Tq0_p`."""
set_Tq0_p!(value::GENQEC, val) = value.Tq0_p = val
"""Set [`GENQEC`](@ref) `Tq0_pp`."""
set_Tq0_pp!(value::GENQEC, val) = value.Tq0_pp = val
"""Set [`GENQEC`](@ref) `Xd`."""
set_Xd!(value::GENQEC, val) = value.Xd = val
"""Set [`GENQEC`](@ref) `Xq`."""
set_Xq!(value::GENQEC, val) = value.Xq = val
"""Set [`GENQEC`](@ref) `Xd_p`."""
set_Xd_p!(value::GENQEC, val) = value.Xd_p = val
"""Set [`GENQEC`](@ref) `Xq_p`."""
set_Xq_p!(value::GENQEC, val) = value.Xq_p = val
"""Set [`GENQEC`](@ref) `Xd_pp`."""
set_Xd_pp!(value::GENQEC, val) = value.Xd_pp = val
"""Set [`GENQEC`](@ref) `Xq_pp`."""
set_Xq_pp!(value::GENQEC, val) = value.Xq_pp = val
"""Set [`GENQEC`](@ref) `Xl`."""
set_Xl!(value::GENQEC, val) = value.Xl = val
"""Set [`GENQEC`](@ref) `Se`."""
set_Se!(value::GENQEC, val) = value.Se = val
"""Set [`GENQEC`](@ref) `Kw`."""
set_Kw!(value::GENQEC, val) = value.Kw = val
"""Set [`GENQEC`](@ref) `saturation_coeffs`."""
set_saturation_coeffs!(value::GENQEC, val) = value.saturation_coeffs = val
"""Set [`GENQEC`](@ref) `ext`."""
set_ext!(value::GENQEC, val) = value.ext = val
"""Set [`GENQEC`](@ref) `γ_d1`."""
set_γ_d1!(value::GENQEC, val) = value.γ_d1 = val
"""Set [`GENQEC`](@ref) `γ_q1`."""
set_γ_q1!(value::GENQEC, val) = value.γ_q1 = val
"""Set [`GENQEC`](@ref) `γ_d2`."""
set_γ_d2!(value::GENQEC, val) = value.γ_d2 = val
"""Set [`GENQEC`](@ref) `γ_q2`."""
set_γ_q2!(value::GENQEC, val) = value.γ_q2 = val
