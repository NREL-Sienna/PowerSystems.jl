#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct RoundRotorQuadratic <: Machine
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
        saturation_coeffs::Tuple{Float64, Float64}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 4-states round-rotor synchronous machine with quadratic saturation:
IEEE Std 1110 §5.3.2 (Model 2.2). GENROU model in PSSE and PSLF.

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
- `saturation_coeffs::Tuple{Float64, Float64}`: Saturation coefficients of quadratic saturation: (A, B): Se = B(|ψ_pp|-A)^2
- `states::Vector{Symbol}`: The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ed_p: d-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψ_kq: flux linkage in the first equivalent damping circuit in the d-axis
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct RoundRotorQuadratic <: Machine
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
    "Saturation coefficients of quadratic saturation: (A, B): Se = B(|ψ_pp|-A)^2"
    saturation_coeffs::Tuple{Float64, Float64}
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

function RoundRotorQuadratic(R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, Se, ext=Dict{String, Any}(), )
    RoundRotorQuadratic(R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, Se, ext, get_quadratic_saturation(Se), [:eq_p, :ed_p, :ψ_kd, :ψ_kq], 4, InfrastructureSystemsInternal(), )
end

function RoundRotorQuadratic(; R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, Se, ext=Dict{String, Any}(), )
    RoundRotorQuadratic(R, Td0_p, Td0_pp, Tq0_p, Tq0_pp, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xl, Se, ext, )
end

# Constructor for demo purposes; non-functional.
function RoundRotorQuadratic(::Nothing)
    RoundRotorQuadratic(;
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
        Se=(0.0, 0.0),
        ext=Dict{String, Any}(),
    )
end

"""Get RoundRotorQuadratic R."""
get_R(value::RoundRotorQuadratic) = value.R
"""Get RoundRotorQuadratic Td0_p."""
get_Td0_p(value::RoundRotorQuadratic) = value.Td0_p
"""Get RoundRotorQuadratic Td0_pp."""
get_Td0_pp(value::RoundRotorQuadratic) = value.Td0_pp
"""Get RoundRotorQuadratic Tq0_p."""
get_Tq0_p(value::RoundRotorQuadratic) = value.Tq0_p
"""Get RoundRotorQuadratic Tq0_pp."""
get_Tq0_pp(value::RoundRotorQuadratic) = value.Tq0_pp
"""Get RoundRotorQuadratic Xd."""
get_Xd(value::RoundRotorQuadratic) = value.Xd
"""Get RoundRotorQuadratic Xq."""
get_Xq(value::RoundRotorQuadratic) = value.Xq
"""Get RoundRotorQuadratic Xd_p."""
get_Xd_p(value::RoundRotorQuadratic) = value.Xd_p
"""Get RoundRotorQuadratic Xq_p."""
get_Xq_p(value::RoundRotorQuadratic) = value.Xq_p
"""Get RoundRotorQuadratic Xd_pp."""
get_Xd_pp(value::RoundRotorQuadratic) = value.Xd_pp
"""Get RoundRotorQuadratic Xl."""
get_Xl(value::RoundRotorQuadratic) = value.Xl
"""Get RoundRotorQuadratic Se."""
get_Se(value::RoundRotorQuadratic) = value.Se
"""Get RoundRotorQuadratic ext."""
get_ext(value::RoundRotorQuadratic) = value.ext
"""Get RoundRotorQuadratic saturation_coeffs."""
get_saturation_coeffs(value::RoundRotorQuadratic) = value.saturation_coeffs
"""Get RoundRotorQuadratic states."""
get_states(value::RoundRotorQuadratic) = value.states
"""Get RoundRotorQuadratic n_states."""
get_n_states(value::RoundRotorQuadratic) = value.n_states
"""Get RoundRotorQuadratic internal."""
get_internal(value::RoundRotorQuadratic) = value.internal

"""Set RoundRotorQuadratic R."""
set_R!(value::RoundRotorQuadratic, val::Float64) = value.R = val
"""Set RoundRotorQuadratic Td0_p."""
set_Td0_p!(value::RoundRotorQuadratic, val::Float64) = value.Td0_p = val
"""Set RoundRotorQuadratic Td0_pp."""
set_Td0_pp!(value::RoundRotorQuadratic, val::Float64) = value.Td0_pp = val
"""Set RoundRotorQuadratic Tq0_p."""
set_Tq0_p!(value::RoundRotorQuadratic, val::Float64) = value.Tq0_p = val
"""Set RoundRotorQuadratic Tq0_pp."""
set_Tq0_pp!(value::RoundRotorQuadratic, val::Float64) = value.Tq0_pp = val
"""Set RoundRotorQuadratic Xd."""
set_Xd!(value::RoundRotorQuadratic, val::Float64) = value.Xd = val
"""Set RoundRotorQuadratic Xq."""
set_Xq!(value::RoundRotorQuadratic, val::Float64) = value.Xq = val
"""Set RoundRotorQuadratic Xd_p."""
set_Xd_p!(value::RoundRotorQuadratic, val::Float64) = value.Xd_p = val
"""Set RoundRotorQuadratic Xq_p."""
set_Xq_p!(value::RoundRotorQuadratic, val::Float64) = value.Xq_p = val
"""Set RoundRotorQuadratic Xd_pp."""
set_Xd_pp!(value::RoundRotorQuadratic, val::Float64) = value.Xd_pp = val
"""Set RoundRotorQuadratic Xl."""
set_Xl!(value::RoundRotorQuadratic, val::Float64) = value.Xl = val
"""Set RoundRotorQuadratic Se."""
set_Se!(value::RoundRotorQuadratic, val::Tuple{Float64, Float64}) = value.Se = val
"""Set RoundRotorQuadratic ext."""
set_ext!(value::RoundRotorQuadratic, val::Dict{String, Any}) = value.ext = val
"""Set RoundRotorQuadratic saturation_coeffs."""
set_saturation_coeffs!(value::RoundRotorQuadratic, val::Tuple{Float64, Float64}) = value.saturation_coeffs = val
"""Set RoundRotorQuadratic states."""
set_states!(value::RoundRotorQuadratic, val::Vector{Symbol}) = value.states = val
"""Set RoundRotorQuadratic n_states."""
set_n_states!(value::RoundRotorQuadratic, val::Int64) = value.n_states = val
"""Set RoundRotorQuadratic internal."""
set_internal!(value::RoundRotorQuadratic, val::InfrastructureSystemsInternal) = value.internal = val
