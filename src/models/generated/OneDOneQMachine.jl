#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct OneDOneQMachine <: Machine
        R::Float64
        Xd::Float64
        Xq::Float64
        Xd_p::Float64
        Xq_p::Float64
        Td0_p::Float64
        Tq0_p::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 4-states synchronous machine: Simplified Marconato model
 The derivative of stator fluxes (ψd and ψq) is neglected and ωψd = ψd and
 ωψq = ψq is assumed (i.e. ω=1.0). This is standard when
 transmission network dynamics is neglected.

# Arguments
- `R::Float64`: Resistance after EMF in machine per unit, validation range: (0, nothing)
- `Xd::Float64`: Reactance after EMF in d-axis per unit, validation range: (0, nothing)
- `Xq::Float64`: Reactance after EMF in q-axis per unit, validation range: (0, nothing)
- `Xd_p::Float64`: Transient reactance after EMF in d-axis per unit, validation range: (0, nothing)
- `Xq_p::Float64`: Transient reactance after EMF in q-axis per unit, validation range: (0, nothing)
- `Td0_p::Float64`: Time constant of transient d-axis voltage, validation range: (0, nothing)
- `Tq0_p::Float64`: Time constant of transient q-axis voltage, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	eq_p: q-axis transient voltage,
	ed_p: d-axis transient voltage
- `n_states::Int64`: OneDOneQMachine has 2 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct OneDOneQMachine <: Machine
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
    "Time constant of transient d-axis voltage"
    Td0_p::Float64
    "Time constant of transient q-axis voltage"
    Tq0_p::Float64
    ext::Dict{String, Any}
    "The states are:
	eq_p: q-axis transient voltage,
	ed_p: d-axis transient voltage"
    states::Vector{Symbol}
    "OneDOneQMachine has 2 states"
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function OneDOneQMachine(R, Xd, Xq, Xd_p, Xq_p, Td0_p, Tq0_p, ext=Dict{String, Any}(), )
    OneDOneQMachine(R, Xd, Xq, Xd_p, Xq_p, Td0_p, Tq0_p, ext, [:eq_p, :ed_p], 2, InfrastructureSystemsInternal(), )
end

function OneDOneQMachine(; R, Xd, Xq, Xd_p, Xq_p, Td0_p, Tq0_p, ext=Dict{String, Any}(), )
    OneDOneQMachine(R, Xd, Xq, Xd_p, Xq_p, Td0_p, Tq0_p, ext, )
end

# Constructor for demo purposes; non-functional.
function OneDOneQMachine(::Nothing)
    OneDOneQMachine(;
        R=0.0,
        Xd=0.0,
        Xq=0.0,
        Xd_p=0.0,
        Xq_p=0.0,
        Td0_p=0.0,
        Tq0_p=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get OneDOneQMachine R."""
get_R(value::OneDOneQMachine) = value.R
"""Get OneDOneQMachine Xd."""
get_Xd(value::OneDOneQMachine) = value.Xd
"""Get OneDOneQMachine Xq."""
get_Xq(value::OneDOneQMachine) = value.Xq
"""Get OneDOneQMachine Xd_p."""
get_Xd_p(value::OneDOneQMachine) = value.Xd_p
"""Get OneDOneQMachine Xq_p."""
get_Xq_p(value::OneDOneQMachine) = value.Xq_p
"""Get OneDOneQMachine Td0_p."""
get_Td0_p(value::OneDOneQMachine) = value.Td0_p
"""Get OneDOneQMachine Tq0_p."""
get_Tq0_p(value::OneDOneQMachine) = value.Tq0_p
"""Get OneDOneQMachine ext."""
get_ext(value::OneDOneQMachine) = value.ext
"""Get OneDOneQMachine states."""
get_states(value::OneDOneQMachine) = value.states
"""Get OneDOneQMachine n_states."""
get_n_states(value::OneDOneQMachine) = value.n_states
"""Get OneDOneQMachine internal."""
get_internal(value::OneDOneQMachine) = value.internal

"""Set OneDOneQMachine R."""
set_R!(value::OneDOneQMachine, val::Float64) = value.R = val
"""Set OneDOneQMachine Xd."""
set_Xd!(value::OneDOneQMachine, val::Float64) = value.Xd = val
"""Set OneDOneQMachine Xq."""
set_Xq!(value::OneDOneQMachine, val::Float64) = value.Xq = val
"""Set OneDOneQMachine Xd_p."""
set_Xd_p!(value::OneDOneQMachine, val::Float64) = value.Xd_p = val
"""Set OneDOneQMachine Xq_p."""
set_Xq_p!(value::OneDOneQMachine, val::Float64) = value.Xq_p = val
"""Set OneDOneQMachine Td0_p."""
set_Td0_p!(value::OneDOneQMachine, val::Float64) = value.Td0_p = val
"""Set OneDOneQMachine Tq0_p."""
set_Tq0_p!(value::OneDOneQMachine, val::Float64) = value.Tq0_p = val
"""Set OneDOneQMachine ext."""
set_ext!(value::OneDOneQMachine, val::Dict{String, Any}) = value.ext = val
"""Set OneDOneQMachine states."""
set_states!(value::OneDOneQMachine, val::Vector{Symbol}) = value.states = val
"""Set OneDOneQMachine n_states."""
set_n_states!(value::OneDOneQMachine, val::Int64) = value.n_states = val
"""Set OneDOneQMachine internal."""
set_internal!(value::OneDOneQMachine, val::InfrastructureSystemsInternal) = value.internal = val
