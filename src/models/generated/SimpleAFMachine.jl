#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SimpleAFMachine <: Machine
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
        MVABase::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 4-states simplified Anderson-Fouad (SimpleAFMachine) model.
 The derivative of stator fluxes (ψd and ψq) is neglected and ωψd = ψd and
 ωψq = ψq is assumed (i.e. ω=1.0). This is standard when transmission network
 dynamics is neglected.
 If transmission dynamics is considered use the full order Anderson Fouad model.

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
- `MVABase::Float64`: Nominal Capacity in MVA
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SimpleAFMachine <: Machine
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
    "Nominal Capacity in MVA"
    MVABase::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SimpleAFMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, MVABase, ext=Dict{String, Any}(), )
    SimpleAFMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, MVABase, ext, [:eq_p, :ed_p, :eq_pp, :ed_pp], 4, InfrastructureSystemsInternal(), )
end

function SimpleAFMachine(; R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, MVABase, ext=Dict{String, Any}(), )
    SimpleAFMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, MVABase, ext, )
end

# Constructor for demo purposes; non-functional.
function SimpleAFMachine(::Nothing)
    SimpleAFMachine(;
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
        MVABase=0,
        ext=Dict{String, Any}(),
    )
end

"""Get SimpleAFMachine R."""
get_R(value::SimpleAFMachine) = value.R
"""Get SimpleAFMachine Xd."""
get_Xd(value::SimpleAFMachine) = value.Xd
"""Get SimpleAFMachine Xq."""
get_Xq(value::SimpleAFMachine) = value.Xq
"""Get SimpleAFMachine Xd_p."""
get_Xd_p(value::SimpleAFMachine) = value.Xd_p
"""Get SimpleAFMachine Xq_p."""
get_Xq_p(value::SimpleAFMachine) = value.Xq_p
"""Get SimpleAFMachine Xd_pp."""
get_Xd_pp(value::SimpleAFMachine) = value.Xd_pp
"""Get SimpleAFMachine Xq_pp."""
get_Xq_pp(value::SimpleAFMachine) = value.Xq_pp
"""Get SimpleAFMachine Td0_p."""
get_Td0_p(value::SimpleAFMachine) = value.Td0_p
"""Get SimpleAFMachine Tq0_p."""
get_Tq0_p(value::SimpleAFMachine) = value.Tq0_p
"""Get SimpleAFMachine Td0_pp."""
get_Td0_pp(value::SimpleAFMachine) = value.Td0_pp
"""Get SimpleAFMachine Tq0_pp."""
get_Tq0_pp(value::SimpleAFMachine) = value.Tq0_pp
"""Get SimpleAFMachine MVABase."""
get_MVABase(value::SimpleAFMachine) = value.MVABase
"""Get SimpleAFMachine ext."""
get_ext(value::SimpleAFMachine) = value.ext
"""Get SimpleAFMachine states."""
get_states(value::SimpleAFMachine) = value.states
"""Get SimpleAFMachine n_states."""
get_n_states(value::SimpleAFMachine) = value.n_states
"""Get SimpleAFMachine internal."""
get_internal(value::SimpleAFMachine) = value.internal
