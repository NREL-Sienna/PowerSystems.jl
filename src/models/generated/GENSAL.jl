#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct GENSAL <: Machine
        R::Float64
        Td0_p::Float64
        Td0_pp::Float64
        Tq0_pp::Float64
        Xd::Float64
        Xq::Float64
        Xd_p::Float64
        Xd_pp::Float64
        Xl::Float64
        S1_0::Float64
        S1_2::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 3-states salient-pole synchronous machine: GENSAL model

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
- `S1_0::Float64`: Saturation factor at 1 pu flux, validation range: (0, nothing)
- `S1_2::Float64`: Saturation factor at 1 pu flux, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψq_pp: phasonf of the subtransient flux linkage in the q-axis
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct GENSAL <: Machine
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
    "Saturation factor at 1 pu flux"
    S1_0::Float64
    "Saturation factor at 1 pu flux"
    S1_2::Float64
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

function GENSAL(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, S1_0, S1_2, ext=Dict{String, Any}(), )
    GENSAL(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, S1_0, S1_2, ext, [:eq_p, :ψ_kd, :ψq_pp], 3, InfrastructureSystemsInternal(), )
end

function GENSAL(; R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, S1_0, S1_2, ext=Dict{String, Any}(), )
    GENSAL(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, S1_0, S1_2, ext, )
end

# Constructor for demo purposes; non-functional.
function GENSAL(::Nothing)
    GENSAL(;
        R=0,
        Td0_p=0,
        Td0_pp=0,
        Tq0_pp=0,
        Xd=0,
        Xq=0,
        Xd_p=0,
        Xd_pp=0,
        Xl=0,
        S1_0=0,
        S1_2=0,
        ext=Dict{String, Any}(),
    )
end

"""Get GENSAL R."""
get_R(value::GENSAL) = value.R
"""Get GENSAL Td0_p."""
get_Td0_p(value::GENSAL) = value.Td0_p
"""Get GENSAL Td0_pp."""
get_Td0_pp(value::GENSAL) = value.Td0_pp
"""Get GENSAL Tq0_pp."""
get_Tq0_pp(value::GENSAL) = value.Tq0_pp
"""Get GENSAL Xd."""
get_Xd(value::GENSAL) = value.Xd
"""Get GENSAL Xq."""
get_Xq(value::GENSAL) = value.Xq
"""Get GENSAL Xd_p."""
get_Xd_p(value::GENSAL) = value.Xd_p
"""Get GENSAL Xd_pp."""
get_Xd_pp(value::GENSAL) = value.Xd_pp
"""Get GENSAL Xl."""
get_Xl(value::GENSAL) = value.Xl
"""Get GENSAL S1_0."""
get_S1_0(value::GENSAL) = value.S1_0
"""Get GENSAL S1_2."""
get_S1_2(value::GENSAL) = value.S1_2
"""Get GENSAL ext."""
get_ext(value::GENSAL) = value.ext
"""Get GENSAL states."""
get_states(value::GENSAL) = value.states
"""Get GENSAL n_states."""
get_n_states(value::GENSAL) = value.n_states
"""Get GENSAL internal."""
get_internal(value::GENSAL) = value.internal

"""Set GENSAL R."""
set_R!(value::GENSAL, val::Float64) = value.R = val
"""Set GENSAL Td0_p."""
set_Td0_p!(value::GENSAL, val::Float64) = value.Td0_p = val
"""Set GENSAL Td0_pp."""
set_Td0_pp!(value::GENSAL, val::Float64) = value.Td0_pp = val
"""Set GENSAL Tq0_pp."""
set_Tq0_pp!(value::GENSAL, val::Float64) = value.Tq0_pp = val
"""Set GENSAL Xd."""
set_Xd!(value::GENSAL, val::Float64) = value.Xd = val
"""Set GENSAL Xq."""
set_Xq!(value::GENSAL, val::Float64) = value.Xq = val
"""Set GENSAL Xd_p."""
set_Xd_p!(value::GENSAL, val::Float64) = value.Xd_p = val
"""Set GENSAL Xd_pp."""
set_Xd_pp!(value::GENSAL, val::Float64) = value.Xd_pp = val
"""Set GENSAL Xl."""
set_Xl!(value::GENSAL, val::Float64) = value.Xl = val
"""Set GENSAL S1_0."""
set_S1_0!(value::GENSAL, val::Float64) = value.S1_0 = val
"""Set GENSAL S1_2."""
set_S1_2!(value::GENSAL, val::Float64) = value.S1_2 = val
"""Set GENSAL ext."""
set_ext!(value::GENSAL, val::Dict{String, Any}) = value.ext = val
"""Set GENSAL states."""
set_states!(value::GENSAL, val::Vector{Symbol}) = value.states = val
"""Set GENSAL n_states."""
set_n_states!(value::GENSAL, val::Int64) = value.n_states = val
"""Set GENSAL internal."""
set_internal!(value::GENSAL, val::InfrastructureSystemsInternal) = value.internal = val
