#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct SalientPoleMachine <: Machine
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
        γ_d1::Float64
        γ_q1::Float64
        γ_d2::Float64
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of 3-states salient-pole synchronous machine with quadratic/exponential saturation:
IEEE Std 1110 §5.3.1 (Model 2.1). GENSAL or GENSAE model in PSSE and PSLF.

# Arguments
- `R::Float64`: Armature resistance, validation range: `(0, nothing)`
- `Td0_p::Float64`: Time constant of transient d-axis voltage, validation range: `(0, nothing)`
- `Td0_pp::Float64`: Time constant of sub-transient d-axis voltage, validation range: `(0, nothing)`
- `Tq0_pp::Float64`: Time constant of sub-transient q-axis voltage, validation range: `(0, nothing)`
- `Xd::Float64`: Reactance after EMF in d-axis per unit, validation range: `(0, nothing)`
- `Xq::Float64`: Reactance after EMF in q-axis per unit, validation range: `(0, nothing)`
- `Xd_p::Float64`: Transient reactance after EMF in d-axis per unit, validation range: `(0, nothing)`
- `Xd_pp::Float64`: Sub-Transient reactance after EMF in d-axis per unit. Note: Xd_pp = Xq_pp, validation range: `(0, nothing)`
- `Xl::Float64`: Stator leakage reactance, validation range: `(0, nothing)`
- `Se::Tuple{Float64, Float64}`: Saturation factor at 1 and 1.2 pu flux: Se(eq_p) = B(eq_p-A)^2
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `γ_d1::Float64`: (**Do not modify.**) γ_d1 parameter
- `γ_q1::Float64`: (**Do not modify.**) γ_q1 parameter
- `γ_d2::Float64`: (**Do not modify.**) γ_d2 parameter
- `states::Vector{Symbol}`: (**Do not modify.**) The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψq_pp: phasonf of the subtransient flux linkage in the q-axis
- `n_states::Int`: (**Do not modify.**) SalientPoleMachine has 3 states
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct SalientPoleMachine <: Machine
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
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) γ_d1 parameter"
    γ_d1::Float64
    "(**Do not modify.**) γ_q1 parameter"
    γ_q1::Float64
    "(**Do not modify.**) γ_d2 parameter"
    γ_d2::Float64
    "(**Do not modify.**) The states are:
	eq_p: q-axis generator voltage behind the transient reactance,
	ψ_kd: flux linkage in the first equivalent damping circuit in the d-axis,
	ψq_pp: phasonf of the subtransient flux linkage in the q-axis"
    states::Vector{Symbol}
    "(**Do not modify.**) SalientPoleMachine has 3 states"
    n_states::Int
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function SalientPoleMachine(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext=Dict{String, Any}(), )
    SalientPoleMachine(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext, (Xd_pp - Xl) / (Xd_p - Xl), (Xd_p - Xd_pp) / (Xd_p - Xl), (Xd_p - Xd_pp) / (Xd_p - Xl)^2, [:eq_p, :ψ_kd, :ψq_pp], 3, InfrastructureSystemsInternal(), )
end

function SalientPoleMachine(; R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext=Dict{String, Any}(), γ_d1=(Xd_pp - Xl) / (Xd_p - Xl), γ_q1=(Xd_p - Xd_pp) / (Xd_p - Xl), γ_d2=(Xd_p - Xd_pp) / (Xd_p - Xl)^2, states=[:eq_p, :ψ_kd, :ψq_pp], n_states=3, internal=InfrastructureSystemsInternal(), )
    SalientPoleMachine(R, Td0_p, Td0_pp, Tq0_pp, Xd, Xq, Xd_p, Xd_pp, Xl, Se, ext, γ_d1, γ_q1, γ_d2, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function SalientPoleMachine(::Nothing)
    SalientPoleMachine(;
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

"""Get [`SalientPoleMachine`](@ref) `R`."""
get_R(value::SalientPoleMachine) = value.R
"""Get [`SalientPoleMachine`](@ref) `Td0_p`."""
get_Td0_p(value::SalientPoleMachine) = value.Td0_p
"""Get [`SalientPoleMachine`](@ref) `Td0_pp`."""
get_Td0_pp(value::SalientPoleMachine) = value.Td0_pp
"""Get [`SalientPoleMachine`](@ref) `Tq0_pp`."""
get_Tq0_pp(value::SalientPoleMachine) = value.Tq0_pp
"""Get [`SalientPoleMachine`](@ref) `Xd`."""
get_Xd(value::SalientPoleMachine) = value.Xd
"""Get [`SalientPoleMachine`](@ref) `Xq`."""
get_Xq(value::SalientPoleMachine) = value.Xq
"""Get [`SalientPoleMachine`](@ref) `Xd_p`."""
get_Xd_p(value::SalientPoleMachine) = value.Xd_p
"""Get [`SalientPoleMachine`](@ref) `Xd_pp`."""
get_Xd_pp(value::SalientPoleMachine) = value.Xd_pp
"""Get [`SalientPoleMachine`](@ref) `Xl`."""
get_Xl(value::SalientPoleMachine) = value.Xl
"""Get [`SalientPoleMachine`](@ref) `Se`."""
get_Se(value::SalientPoleMachine) = value.Se
"""Get [`SalientPoleMachine`](@ref) `ext`."""
get_ext(value::SalientPoleMachine) = value.ext
"""Get [`SalientPoleMachine`](@ref) `γ_d1`."""
get_γ_d1(value::SalientPoleMachine) = value.γ_d1
"""Get [`SalientPoleMachine`](@ref) `γ_q1`."""
get_γ_q1(value::SalientPoleMachine) = value.γ_q1
"""Get [`SalientPoleMachine`](@ref) `γ_d2`."""
get_γ_d2(value::SalientPoleMachine) = value.γ_d2
"""Get [`SalientPoleMachine`](@ref) `states`."""
get_states(value::SalientPoleMachine) = value.states
"""Get [`SalientPoleMachine`](@ref) `n_states`."""
get_n_states(value::SalientPoleMachine) = value.n_states
"""Get [`SalientPoleMachine`](@ref) `internal`."""
get_internal(value::SalientPoleMachine) = value.internal

"""Set [`SalientPoleMachine`](@ref) `R`."""
set_R!(value::SalientPoleMachine, val) = value.R = val
"""Set [`SalientPoleMachine`](@ref) `Td0_p`."""
set_Td0_p!(value::SalientPoleMachine, val) = value.Td0_p = val
"""Set [`SalientPoleMachine`](@ref) `Td0_pp`."""
set_Td0_pp!(value::SalientPoleMachine, val) = value.Td0_pp = val
"""Set [`SalientPoleMachine`](@ref) `Tq0_pp`."""
set_Tq0_pp!(value::SalientPoleMachine, val) = value.Tq0_pp = val
"""Set [`SalientPoleMachine`](@ref) `Xd`."""
set_Xd!(value::SalientPoleMachine, val) = value.Xd = val
"""Set [`SalientPoleMachine`](@ref) `Xq`."""
set_Xq!(value::SalientPoleMachine, val) = value.Xq = val
"""Set [`SalientPoleMachine`](@ref) `Xd_p`."""
set_Xd_p!(value::SalientPoleMachine, val) = value.Xd_p = val
"""Set [`SalientPoleMachine`](@ref) `Xd_pp`."""
set_Xd_pp!(value::SalientPoleMachine, val) = value.Xd_pp = val
"""Set [`SalientPoleMachine`](@ref) `Xl`."""
set_Xl!(value::SalientPoleMachine, val) = value.Xl = val
"""Set [`SalientPoleMachine`](@ref) `Se`."""
set_Se!(value::SalientPoleMachine, val) = value.Se = val
"""Set [`SalientPoleMachine`](@ref) `ext`."""
set_ext!(value::SalientPoleMachine, val) = value.ext = val
"""Set [`SalientPoleMachine`](@ref) `γ_d1`."""
set_γ_d1!(value::SalientPoleMachine, val) = value.γ_d1 = val
"""Set [`SalientPoleMachine`](@ref) `γ_q1`."""
set_γ_q1!(value::SalientPoleMachine, val) = value.γ_q1 = val
"""Set [`SalientPoleMachine`](@ref) `γ_d2`."""
set_γ_d2!(value::SalientPoleMachine, val) = value.γ_d2 = val
