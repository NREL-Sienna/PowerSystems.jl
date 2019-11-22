#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SimpleMarconatoMachine <: Machine
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
        γd::Float64
        γq::Float64
        MVABase::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 4-states synchronous machine: Simplified Marconato model
 The derivative of stator fluxes (ψd and ψq) is neglected and ωψd = ψd and
 ωψq = ψq is assumed (i.e. ω=1.0). This is standard when transmission network
 dynamics is neglected.

# Arguments
- `R::Float64`: Resistance after EMF in machine per unit
- `Xd::Float64`: Reactance after EMF in d-axis per unit
- `Xq::Float64`: Reactance after EMF in q-axis per unit
- `Xd_p::Float64`: Transient reactance after EMF in d-axis per unit
- `Xq_p::Float64`: Transient reactance after EMF in q-axis per unit
- `Xd_pp::Float64`: Sub-Transient reactance after EMF in d-axis per unit
- `Xq_pp::Float64`: Sub-Transient reactance after EMF in q-axis per unit
- `Td0_p::Float64`: Time constant of transient d-axis voltage
- `Tq0_p::Float64`: Time constant of transient q-axis voltage
- `Td0_pp::Float64`: Time constant of sub-transient d-axis voltage
- `Tq0_pp::Float64`: Time constant of sub-transient q-axis voltage
- `T_AA::Float64`: Time constant of d-axis additional leakage
- `γd::Float64`
- `γq::Float64`
- `MVABase::Float64`: Nominal Capacity in MVA
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SimpleMarconatoMachine <: Machine
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
    γd::Float64
    γq::Float64
    "Nominal Capacity in MVA"
    MVABase::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SimpleMarconatoMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, T_AA, MVABase, ext=Dict{String, Any}(), )
    SimpleMarconatoMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, T_AA, MVABase, ext, ((Td0_pp*Xd_pp)/(Td0_p*Xd_p) )*(Xd-Xd_p), ((Tq0_pp*Xq_pp)/(Tq0_p*Xq_p) )*(Xq-Xq_p), [:eq_p, :ed_p, :eq_pp, :ed_pp], 4, InfrastructureSystemsInternal(), )
end

function SimpleMarconatoMachine(; R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, T_AA, MVABase, ext=Dict{String, Any}(), )
    SimpleMarconatoMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, T_AA, MVABase, ext, )
end

# Constructor for demo purposes; non-functional.
function SimpleMarconatoMachine(::Nothing)
    SimpleMarconatoMachine(;
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

"""Get SimpleMarconatoMachine R."""
get_R(value::SimpleMarconatoMachine) = value.R
"""Get SimpleMarconatoMachine Xd."""
get_Xd(value::SimpleMarconatoMachine) = value.Xd
"""Get SimpleMarconatoMachine Xq."""
get_Xq(value::SimpleMarconatoMachine) = value.Xq
"""Get SimpleMarconatoMachine Xd_p."""
get_Xd_p(value::SimpleMarconatoMachine) = value.Xd_p
"""Get SimpleMarconatoMachine Xq_p."""
get_Xq_p(value::SimpleMarconatoMachine) = value.Xq_p
"""Get SimpleMarconatoMachine Xd_pp."""
get_Xd_pp(value::SimpleMarconatoMachine) = value.Xd_pp
"""Get SimpleMarconatoMachine Xq_pp."""
get_Xq_pp(value::SimpleMarconatoMachine) = value.Xq_pp
"""Get SimpleMarconatoMachine Td0_p."""
get_Td0_p(value::SimpleMarconatoMachine) = value.Td0_p
"""Get SimpleMarconatoMachine Tq0_p."""
get_Tq0_p(value::SimpleMarconatoMachine) = value.Tq0_p
"""Get SimpleMarconatoMachine Td0_pp."""
get_Td0_pp(value::SimpleMarconatoMachine) = value.Td0_pp
"""Get SimpleMarconatoMachine Tq0_pp."""
get_Tq0_pp(value::SimpleMarconatoMachine) = value.Tq0_pp
"""Get SimpleMarconatoMachine T_AA."""
get_T_AA(value::SimpleMarconatoMachine) = value.T_AA
"""Get SimpleMarconatoMachine γd."""
get_γd(value::SimpleMarconatoMachine) = value.γd
"""Get SimpleMarconatoMachine γq."""
get_γq(value::SimpleMarconatoMachine) = value.γq
"""Get SimpleMarconatoMachine MVABase."""
get_MVABase(value::SimpleMarconatoMachine) = value.MVABase
"""Get SimpleMarconatoMachine ext."""
get_ext(value::SimpleMarconatoMachine) = value.ext
"""Get SimpleMarconatoMachine states."""
get_states(value::SimpleMarconatoMachine) = value.states
"""Get SimpleMarconatoMachine n_states."""
get_n_states(value::SimpleMarconatoMachine) = value.n_states
"""Get SimpleMarconatoMachine internal."""
get_internal(value::SimpleMarconatoMachine) = value.internal
