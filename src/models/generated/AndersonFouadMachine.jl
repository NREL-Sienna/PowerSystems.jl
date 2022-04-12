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
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of 6-states synchronous machine: Anderson-Fouad model

# Arguments
- `R::Float64`: Resistance after EMF in machine per unit, validation range: `(0, nothing)`
- `Xd::Float64`: Reactance after EMF in d-axis per unit, validation range: `(0, nothing)`
- `Xq::Float64`: Reactance after EMF in q-axis per unit, validation range: `(0, nothing)`
- `Xd_p::Float64`: Transient reactance after EMF in d-axis per unit, validation range: `(0, nothing)`
- `Xq_p::Float64`: Transient reactance after EMF in q-axis per unit, validation range: `(0, nothing)`
- `Xd_pp::Float64`: Sub-Transient reactance after EMF in d-axis per unit, validation range: `(0, nothing)`
- `Xq_pp::Float64`: Sub-Transient reactance after EMF in q-axis per unit, validation range: `(0, nothing)`
- `Td0_p::Float64`: Time constant of transient d-axis voltage, validation range: `(0, nothing)`
- `Tq0_p::Float64`: Time constant of transient q-axis voltage, validation range: `(0, nothing)`
- `Td0_pp::Float64`: Time constant of sub-transient d-axis voltage, validation range: `(0, nothing)`
- `Tq0_pp::Float64`: Time constant of sub-transient q-axis voltage, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	ψq: q-axis stator flux,
	ψd: d-axis stator flux,
	eq_p: q-axis transient voltage,
	ed_p: d-axis transient voltage,
	eq_pp: q-axis subtransient voltage,
	ed_pp: d-axis subtransient voltage
- `n_states::Int`: AndersonFouadMachine has 6 states
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
    ext::Dict{String, Any}
    "The states are:
	ψq: q-axis stator flux,
	ψd: d-axis stator flux,
	eq_p: q-axis transient voltage,
	ed_p: d-axis transient voltage,
	eq_pp: q-axis subtransient voltage,
	ed_pp: d-axis subtransient voltage"
    states::Vector{Symbol}
    "AndersonFouadMachine has 6 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AndersonFouadMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, ext=Dict{String, Any}(), )
    AndersonFouadMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, ext, [:ψq, :ψd, :eq_p, :ed_p, :eq_pp, :ed_pp], 6, InfrastructureSystemsInternal(), )
end

function AndersonFouadMachine(; R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, ext=Dict{String, Any}(), states=[:ψq, :ψd, :eq_p, :ed_p, :eq_pp, :ed_pp], n_states=6, internal=InfrastructureSystemsInternal(), )
    AndersonFouadMachine(R, Xd, Xq, Xd_p, Xq_p, Xd_pp, Xq_pp, Td0_p, Tq0_p, Td0_pp, Tq0_pp, ext, states, n_states, internal, )
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
        ext=Dict{String, Any}(),
    )
end

"""Get [`AndersonFouadMachine`](@ref) `R`."""
get_R(value::AndersonFouadMachine) = value.R
"""Get [`AndersonFouadMachine`](@ref) `Xd`."""
get_Xd(value::AndersonFouadMachine) = value.Xd
"""Get [`AndersonFouadMachine`](@ref) `Xq`."""
get_Xq(value::AndersonFouadMachine) = value.Xq
"""Get [`AndersonFouadMachine`](@ref) `Xd_p`."""
get_Xd_p(value::AndersonFouadMachine) = value.Xd_p
"""Get [`AndersonFouadMachine`](@ref) `Xq_p`."""
get_Xq_p(value::AndersonFouadMachine) = value.Xq_p
"""Get [`AndersonFouadMachine`](@ref) `Xd_pp`."""
get_Xd_pp(value::AndersonFouadMachine) = value.Xd_pp
"""Get [`AndersonFouadMachine`](@ref) `Xq_pp`."""
get_Xq_pp(value::AndersonFouadMachine) = value.Xq_pp
"""Get [`AndersonFouadMachine`](@ref) `Td0_p`."""
get_Td0_p(value::AndersonFouadMachine) = value.Td0_p
"""Get [`AndersonFouadMachine`](@ref) `Tq0_p`."""
get_Tq0_p(value::AndersonFouadMachine) = value.Tq0_p
"""Get [`AndersonFouadMachine`](@ref) `Td0_pp`."""
get_Td0_pp(value::AndersonFouadMachine) = value.Td0_pp
"""Get [`AndersonFouadMachine`](@ref) `Tq0_pp`."""
get_Tq0_pp(value::AndersonFouadMachine) = value.Tq0_pp
"""Get [`AndersonFouadMachine`](@ref) `ext`."""
get_ext(value::AndersonFouadMachine) = value.ext
"""Get [`AndersonFouadMachine`](@ref) `states`."""
get_states(value::AndersonFouadMachine) = value.states
"""Get [`AndersonFouadMachine`](@ref) `n_states`."""
get_n_states(value::AndersonFouadMachine) = value.n_states
"""Get [`AndersonFouadMachine`](@ref) `internal`."""
get_internal(value::AndersonFouadMachine) = value.internal

"""Set [`AndersonFouadMachine`](@ref) `R`."""
set_R!(value::AndersonFouadMachine, val) = value.R = val
"""Set [`AndersonFouadMachine`](@ref) `Xd`."""
set_Xd!(value::AndersonFouadMachine, val) = value.Xd = val
"""Set [`AndersonFouadMachine`](@ref) `Xq`."""
set_Xq!(value::AndersonFouadMachine, val) = value.Xq = val
"""Set [`AndersonFouadMachine`](@ref) `Xd_p`."""
set_Xd_p!(value::AndersonFouadMachine, val) = value.Xd_p = val
"""Set [`AndersonFouadMachine`](@ref) `Xq_p`."""
set_Xq_p!(value::AndersonFouadMachine, val) = value.Xq_p = val
"""Set [`AndersonFouadMachine`](@ref) `Xd_pp`."""
set_Xd_pp!(value::AndersonFouadMachine, val) = value.Xd_pp = val
"""Set [`AndersonFouadMachine`](@ref) `Xq_pp`."""
set_Xq_pp!(value::AndersonFouadMachine, val) = value.Xq_pp = val
"""Set [`AndersonFouadMachine`](@ref) `Td0_p`."""
set_Td0_p!(value::AndersonFouadMachine, val) = value.Td0_p = val
"""Set [`AndersonFouadMachine`](@ref) `Tq0_p`."""
set_Tq0_p!(value::AndersonFouadMachine, val) = value.Tq0_p = val
"""Set [`AndersonFouadMachine`](@ref) `Td0_pp`."""
set_Td0_pp!(value::AndersonFouadMachine, val) = value.Td0_pp = val
"""Set [`AndersonFouadMachine`](@ref) `Tq0_pp`."""
set_Tq0_pp!(value::AndersonFouadMachine, val) = value.Tq0_pp = val
"""Set [`AndersonFouadMachine`](@ref) `ext`."""
set_ext!(value::AndersonFouadMachine, val) = value.ext = val

