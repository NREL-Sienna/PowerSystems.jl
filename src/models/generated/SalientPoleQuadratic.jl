#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SalientPoleQuadratic <: Machine
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
        saturation_coeffs::Tuple{Float64, Float64}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 3-states salient-pole synchronous machine with quadratic saturation:
IEEE Std 1110 §5.3.1 (Model 2.1). GENSAL model in PSSE and PSLF.

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
- `saturation_coeffs::Tuple{Float64, Float64}`: Saturation coefficients of quadratic saturation: (A, B): Se = B(eq_p-A)^2
- `states::Vector{Symbol}`: The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψq_pp: phasonf of the subtransient flux linkage in the q-axis
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SalientPoleQuadratic <: Machine
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
    "Saturation coefficients of quadratic saturation: (A, B): Se = B(eq_p-A)^2"
    saturation_coeffs::Tuple{Float64, Float64}
    "The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψq_pp: phasonf of the subtransient flux linkage in the q-axis"
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SalientPoleQuadratic(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext=Dict{String, Any}(), )
    SalientPoleQuadratic(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext, get_quadratic_saturation(Se), [:eq_p, :ψ_kd, :ψq_pp], 3, InfrastructureSystemsInternal(), )
end

function SalientPoleQuadratic(; R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext=Dict{String, Any}(), )
    SalientPoleQuadratic(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext, )
end

# Constructor for demo purposes; non-functional.
function SalientPoleQuadratic(::Nothing)
    SalientPoleQuadratic(;
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

"""Get SalientPoleQuadratic R."""
get_R(value::SalientPoleQuadratic) = value.R
"""Get SalientPoleQuadratic Td0_p."""
get_Td0_p(value::SalientPoleQuadratic) = value.Td0_p
"""Get SalientPoleQuadratic Td0_pp."""
get_Td0_pp(value::SalientPoleQuadratic) = value.Td0_pp
"""Get SalientPoleQuadratic Tq0_pp."""
get_Tq0_pp(value::SalientPoleQuadratic) = value.Tq0_pp
"""Get SalientPoleQuadratic Xd."""
get_Xd(value::SalientPoleQuadratic) = value.Xd
"""Get SalientPoleQuadratic Xq."""
get_Xq(value::SalientPoleQuadratic) = value.Xq
"""Get SalientPoleQuadratic Xd_p."""
get_Xd_p(value::SalientPoleQuadratic) = value.Xd_p
"""Get SalientPoleQuadratic Xd_pp."""
get_Xd_pp(value::SalientPoleQuadratic) = value.Xd_pp
"""Get SalientPoleQuadratic Xl."""
get_Xl(value::SalientPoleQuadratic) = value.Xl
"""Get SalientPoleQuadratic Se."""
get_Se(value::SalientPoleQuadratic) = value.Se
"""Get SalientPoleQuadratic ext."""
get_ext(value::SalientPoleQuadratic) = value.ext
"""Get SalientPoleQuadratic saturation_coeffs."""
get_saturation_coeffs(value::SalientPoleQuadratic) = value.saturation_coeffs
"""Get SalientPoleQuadratic states."""
get_states(value::SalientPoleQuadratic) = value.states
"""Get SalientPoleQuadratic n_states."""
get_n_states(value::SalientPoleQuadratic) = value.n_states
"""Get SalientPoleQuadratic internal."""
get_internal(value::SalientPoleQuadratic) = value.internal

"""Set SalientPoleQuadratic R."""
set_R!(value::SalientPoleQuadratic, val::Float64) = value.R = val
"""Set SalientPoleQuadratic Td0_p."""
set_Td0_p!(value::SalientPoleQuadratic, val::Float64) = value.Td0_p = val
"""Set SalientPoleQuadratic Td0_pp."""
set_Td0_pp!(value::SalientPoleQuadratic, val::Float64) = value.Td0_pp = val
"""Set SalientPoleQuadratic Tq0_pp."""
set_Tq0_pp!(value::SalientPoleQuadratic, val::Float64) = value.Tq0_pp = val
"""Set SalientPoleQuadratic Xd."""
set_Xd!(value::SalientPoleQuadratic, val::Float64) = value.Xd = val
"""Set SalientPoleQuadratic Xq."""
set_Xq!(value::SalientPoleQuadratic, val::Float64) = value.Xq = val
"""Set SalientPoleQuadratic Xd_p."""
set_Xd_p!(value::SalientPoleQuadratic, val::Float64) = value.Xd_p = val
"""Set SalientPoleQuadratic Xd_pp."""
set_Xd_pp!(value::SalientPoleQuadratic, val::Float64) = value.Xd_pp = val
"""Set SalientPoleQuadratic Xl."""
set_Xl!(value::SalientPoleQuadratic, val::Float64) = value.Xl = val
"""Set SalientPoleQuadratic Se."""
set_Se!(value::SalientPoleQuadratic, val::Tuple{Float64, Float64}) = value.Se = val
"""Set SalientPoleQuadratic ext."""
set_ext!(value::SalientPoleQuadratic, val::Dict{String, Any}) = value.ext = val
"""Set SalientPoleQuadratic saturation_coeffs."""
set_saturation_coeffs!(value::SalientPoleQuadratic, val::Tuple{Float64, Float64}) = value.saturation_coeffs = val
"""Set SalientPoleQuadratic states."""
set_states!(value::SalientPoleQuadratic, val::Vector{Symbol}) = value.states = val
"""Set SalientPoleQuadratic n_states."""
set_n_states!(value::SalientPoleQuadratic, val::Int64) = value.n_states = val
"""Set SalientPoleQuadratic internal."""
set_internal!(value::SalientPoleQuadratic, val::InfrastructureSystemsInternal) = value.internal = val
