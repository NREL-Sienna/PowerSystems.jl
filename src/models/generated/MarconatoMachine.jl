#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct MarconatoMachine <: Machine
        R::Float64
        Xd::Float64
        Xq::Float64
        Xd_p::Float64
        Xq_p::Float64
        Xd_pp::Float64
        Xq_pp::Float64
        Td0_p::Float64
        Tq0_p::Float64
        Td0_pp::Float64
        Tq0_pp::Float64
        T_AA::Float64
        MVABase::Float64
        ext::Dict{String, Any}
        γd::Float64
        γq::Float64
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 6-states synchronous machine: Marconato model

# Arguments
- `R::Float64`: Resistance after EMF in machine per unit, validation range: (0, nothing)
- `Xd::Float64`: Reactance after EMF in d-axis per unit, validation range: (0, nothing)
- `Xq::Float64`: Reactance after EMF in q-axis per unit, validation range: (0, nothing)
- `Xd_p::Float64`: Transient reactance after EMF in d-axis per unit, validation range: (0, nothing)
- `Xq_p::Float64`: Transient reactance after EMF in q-axis per unit, validation range: (0, nothing)
- `Xd_pp::Float64`: Sub-Transient reactance after EMF in d-axis per unit, validation range: (0, nothing)
- `Xq_pp::Float64`: Sub-Transient reactance after EMF in q-axis per unit, validation range: (0, nothing)
- `Td0_p::Float64`: Time constant of transient d-axis voltage, validation range: (0, nothing)
- `Tq0_p::Float64`: Time constant of transient q-axis voltage, validation range: (0, nothing)
- `Td0_pp::Float64`: Time constant of sub-transient d-axis voltage, validation range: (0, nothing)
- `Tq0_pp::Float64`: Time constant of sub-transient q-axis voltage, validation range: (0, nothing)
- `T_AA::Float64`: Time constant of d-axis additional leakage, validation range: (0, nothing)
- `MVABase::Float64`: Nominal Capacity in MVA, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `γd::Float64`
- `γq::Float64`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct MarconatoMachine <: Machine
    "Resistance after EMF in machine per unit"
    R::Float64
    "Reactance after EMF in d-axis per unit"
    Xd::Float64
    "Reactance after EMF in q-axis per unit"
    Xq::Float64
    "Transient reactance after EMF in d-axis per unit"
    Xd_p::Float64
    "Transient reactance after EMF in q-axis per unit"
    Xq_p::Float64
    "Sub-Transient reactance after EMF in d-axis per unit"
    Xd_pp::Float64
    "Sub-Transient reactance after EMF in q-axis per unit"
    Xq_pp::Float64
    "Time constant of transient d-axis voltage"
    Td0_p::Float64
    "Time constant of transient q-axis voltage"
    Tq0_p::Float64
    "Time constant of sub-transient d-axis voltage"
    Td0_pp::Float64
    "Time constant of sub-transient q-axis voltage"
    Tq0_pp::Float64
    "Time constant of d-axis additional leakage"
    T_AA::Float64
    "Nominal Capacity in MVA"
    MVABase::Float64
    ext::Dict{String, Any}
    γd::Float64
    γq::Float64
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function MarconatoMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, T_AA, MVABase, ext=Dict{String, Any}(), )
    MarconatoMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, T_AA, MVABase, ext, ((Td0_pp*Xd_pp)/(Td0_p*Xd_p) )*(Xd-Xd_p), ((Tq0_pp*Xq_pp)/(Tq0_p*Xq_p) )*(Xq-Xq_p), [:ψq, :ψd, :eq_p, :ed_p, :eq_pp, :ed_pp], 6, InfrastructureSystemsInternal(), )
end

function MarconatoMachine(; R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, T_AA, MVABase, ext=Dict{String, Any}(), )
    MarconatoMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, T_AA, MVABase, ext, )
end

# Constructor for demo purposes; non-functional.
function MarconatoMachine(::Nothing)
    MarconatoMachine(;
        R=0,
        Xd=0,
        Xq=0,
        Xd_p=0,
        Xq_p=0,
        Xd_pp=0,
        Xq_pp=0,
        Td0_p=0,
        Tq0_p=0,
        Td0_pp=0,
        Tq0_pp=0,
        T_AA=0,
        MVABase=0,
        ext=Dict{String, Any}(),
    )
end

"""Get MarconatoMachine R."""
get_R(value::MarconatoMachine) = value.R
"""Get MarconatoMachine Xd."""
get_Xd(value::MarconatoMachine) = value.Xd
"""Get MarconatoMachine Xq."""
get_Xq(value::MarconatoMachine) = value.Xq
"""Get MarconatoMachine Xd_p."""
get_Xd_p(value::MarconatoMachine) = value.Xd_p
"""Get MarconatoMachine Xq_p."""
get_Xq_p(value::MarconatoMachine) = value.Xq_p
"""Get MarconatoMachine Xd_pp."""
get_Xd_pp(value::MarconatoMachine) = value.Xd_pp
"""Get MarconatoMachine Xq_pp."""
get_Xq_pp(value::MarconatoMachine) = value.Xq_pp
"""Get MarconatoMachine Td0_p."""
get_Td0_p(value::MarconatoMachine) = value.Td0_p
"""Get MarconatoMachine Tq0_p."""
get_Tq0_p(value::MarconatoMachine) = value.Tq0_p
"""Get MarconatoMachine Td0_pp."""
get_Td0_pp(value::MarconatoMachine) = value.Td0_pp
"""Get MarconatoMachine Tq0_pp."""
get_Tq0_pp(value::MarconatoMachine) = value.Tq0_pp
"""Get MarconatoMachine T_AA."""
get_T_AA(value::MarconatoMachine) = value.T_AA
"""Get MarconatoMachine MVABase."""
get_MVABase(value::MarconatoMachine) = value.MVABase
"""Get MarconatoMachine ext."""
get_ext(value::MarconatoMachine) = value.ext
"""Get MarconatoMachine γd."""
get_γd(value::MarconatoMachine) = value.γd
"""Get MarconatoMachine γq."""
get_γq(value::MarconatoMachine) = value.γq
"""Get MarconatoMachine states."""
get_states(value::MarconatoMachine) = value.states
"""Get MarconatoMachine n_states."""
get_n_states(value::MarconatoMachine) = value.n_states
"""Get MarconatoMachine internal."""
get_internal(value::MarconatoMachine) = value.internal

"""Set MarconatoMachine R."""
set_R!(value::MarconatoMachine, val) = value.R = val
"""Set MarconatoMachine Xd."""
set_Xd!(value::MarconatoMachine, val) = value.Xd = val
"""Set MarconatoMachine Xq."""
set_Xq!(value::MarconatoMachine, val) = value.Xq = val
"""Set MarconatoMachine Xd_p."""
set_Xd_p!(value::MarconatoMachine, val) = value.Xd_p = val
"""Set MarconatoMachine Xq_p."""
set_Xq_p!(value::MarconatoMachine, val) = value.Xq_p = val
"""Set MarconatoMachine Xd_pp."""
set_Xd_pp!(value::MarconatoMachine, val) = value.Xd_pp = val
"""Set MarconatoMachine Xq_pp."""
set_Xq_pp!(value::MarconatoMachine, val) = value.Xq_pp = val
"""Set MarconatoMachine Td0_p."""
set_Td0_p!(value::MarconatoMachine, val) = value.Td0_p = val
"""Set MarconatoMachine Tq0_p."""
set_Tq0_p!(value::MarconatoMachine, val) = value.Tq0_p = val
"""Set MarconatoMachine Td0_pp."""
set_Td0_pp!(value::MarconatoMachine, val) = value.Td0_pp = val
"""Set MarconatoMachine Tq0_pp."""
set_Tq0_pp!(value::MarconatoMachine, val) = value.Tq0_pp = val
"""Set MarconatoMachine T_AA."""
set_T_AA!(value::MarconatoMachine, val) = value.T_AA = val
"""Set MarconatoMachine MVABase."""
set_MVABase!(value::MarconatoMachine, val) = value.MVABase = val
"""Set MarconatoMachine ext."""
set_ext!(value::MarconatoMachine, val) = value.ext = val
"""Set MarconatoMachine γd."""
set_γd!(value::MarconatoMachine, val) = value.γd = val
"""Set MarconatoMachine γq."""
set_γq!(value::MarconatoMachine, val) = value.γq = val
"""Set MarconatoMachine states."""
set_states!(value::MarconatoMachine, val) = value.states = val
"""Set MarconatoMachine n_states."""
set_n_states!(value::MarconatoMachine, val) = value.n_states = val
"""Set MarconatoMachine internal."""
set_internal!(value::MarconatoMachine, val) = value.internal = val
