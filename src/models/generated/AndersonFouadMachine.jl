#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AndersonFouadMachine <: Machine
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

Parameters of 6-states synchronous machine: Anderson-Fouad model

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
- `MVABase::Float64`: Nominal Capacity in MVA, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AndersonFouadMachine <: Machine
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

function AndersonFouadMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, MVABase, ext=Dict{String, Any}(), )
    AndersonFouadMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, MVABase, ext, [:ψq, :ψd, :eq_p, :ed_p, :eq_pp, :ed_pp], 6, InfrastructureSystemsInternal(), )
end

function AndersonFouadMachine(; R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, MVABase, ext=Dict{String, Any}(), )
    AndersonFouadMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, MVABase, ext, )
end

# Constructor for demo purposes; non-functional.
function AndersonFouadMachine(::Nothing)
    AndersonFouadMachine(;
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

"""Get AndersonFouadMachine R."""
get_R(value::AndersonFouadMachine) = value.R
"""Get AndersonFouadMachine Xd."""
get_Xd(value::AndersonFouadMachine) = value.Xd
"""Get AndersonFouadMachine Xq."""
get_Xq(value::AndersonFouadMachine) = value.Xq
"""Get AndersonFouadMachine Xd_p."""
get_Xd_p(value::AndersonFouadMachine) = value.Xd_p
"""Get AndersonFouadMachine Xq_p."""
get_Xq_p(value::AndersonFouadMachine) = value.Xq_p
"""Get AndersonFouadMachine Xd_pp."""
get_Xd_pp(value::AndersonFouadMachine) = value.Xd_pp
"""Get AndersonFouadMachine Xq_pp."""
get_Xq_pp(value::AndersonFouadMachine) = value.Xq_pp
"""Get AndersonFouadMachine Td0_p."""
get_Td0_p(value::AndersonFouadMachine) = value.Td0_p
"""Get AndersonFouadMachine Tq0_p."""
get_Tq0_p(value::AndersonFouadMachine) = value.Tq0_p
"""Get AndersonFouadMachine Td0_pp."""
get_Td0_pp(value::AndersonFouadMachine) = value.Td0_pp
"""Get AndersonFouadMachine Tq0_pp."""
get_Tq0_pp(value::AndersonFouadMachine) = value.Tq0_pp
"""Get AndersonFouadMachine MVABase."""
get_MVABase(value::AndersonFouadMachine) = value.MVABase
"""Get AndersonFouadMachine ext."""
get_ext(value::AndersonFouadMachine) = value.ext
"""Get AndersonFouadMachine states."""
get_states(value::AndersonFouadMachine) = value.states
"""Get AndersonFouadMachine n_states."""
get_n_states(value::AndersonFouadMachine) = value.n_states
"""Get AndersonFouadMachine internal."""
get_internal(value::AndersonFouadMachine) = value.internal

"""Set AndersonFouadMachine R."""
set_R!(value::AndersonFouadMachine, val) = value.R = val
"""Set AndersonFouadMachine Xd."""
set_Xd!(value::AndersonFouadMachine, val) = value.Xd = val
"""Set AndersonFouadMachine Xq."""
set_Xq!(value::AndersonFouadMachine, val) = value.Xq = val
"""Set AndersonFouadMachine Xd_p."""
set_Xd_p!(value::AndersonFouadMachine, val) = value.Xd_p = val
"""Set AndersonFouadMachine Xq_p."""
set_Xq_p!(value::AndersonFouadMachine, val) = value.Xq_p = val
"""Set AndersonFouadMachine Xd_pp."""
set_Xd_pp!(value::AndersonFouadMachine, val) = value.Xd_pp = val
"""Set AndersonFouadMachine Xq_pp."""
set_Xq_pp!(value::AndersonFouadMachine, val) = value.Xq_pp = val
"""Set AndersonFouadMachine Td0_p."""
set_Td0_p!(value::AndersonFouadMachine, val) = value.Td0_p = val
"""Set AndersonFouadMachine Tq0_p."""
set_Tq0_p!(value::AndersonFouadMachine, val) = value.Tq0_p = val
"""Set AndersonFouadMachine Td0_pp."""
set_Td0_pp!(value::AndersonFouadMachine, val) = value.Td0_pp = val
"""Set AndersonFouadMachine Tq0_pp."""
set_Tq0_pp!(value::AndersonFouadMachine, val) = value.Tq0_pp = val
"""Set AndersonFouadMachine MVABase."""
set_MVABase!(value::AndersonFouadMachine, val) = value.MVABase = val
"""Set AndersonFouadMachine ext."""
set_ext!(value::AndersonFouadMachine, val) = value.ext = val
"""Set AndersonFouadMachine states."""
set_states!(value::AndersonFouadMachine, val) = value.states = val
"""Set AndersonFouadMachine n_states."""
set_n_states!(value::AndersonFouadMachine, val) = value.n_states = val
"""Set AndersonFouadMachine internal."""
set_internal!(value::AndersonFouadMachine, val) = value.internal = val
