#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct SingleCageInductionMachine <: DynamicInjection
        name::String
        Rs::Float64
        Rr::Float64
        Xs::Float64
        Xr::Float64
        Xm::Float64
        H::Float64
        A::Float64
        B::Float64
        base_power::Float64
        ext::Dict{String, Any}
        C::Float64
        τ_ref::Float64
        B_shunt::Float64
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of 5-states three-phase single cage induction machine with quadratic torque-speed relationship.

# Arguments
- `name::String`
- `Rs::Float64`: Armature stator resistance, validation range: `(0, nothing)`
- `Rr::Float64`: Rotor resistance, validation range: `(0, nothing)`
- `Xs::Float64`: Stator Self Reactance, validation range: `(0, nothing)`
- `Xr::Float64`: Rotor Self Reactance, validation range: `(0, nothing)`
- `Xm::Float64`: Stator-Rotor Mutual Reactance, validation range: `(0, nothing)`
- `H::Float64`: Motor Inertia Constant [s], validation range: `(0, nothing)`
- `A::Float64`: Torque-Speed Quadratic Term, validation range: `(0, 1)`
- `B::Float64`: Torque-Speed Linear Term, validation range: `(0, 1)`
- `base_power::Float64`: Base power
- `ext::Dict{String, Any}`
- `C::Float64`: Torque-Speed Constant Term
- `τ_ref::Float64`: Reference torque parameter
- `B_shunt::Float64`: Susceptance Initialization Corrector Term
- `states::Vector{Symbol}`: The states are:
	ψ_sq: stator flux in the q-axis,
	ψ_sd: stator flux in the d-axis,
	ψ_rq: rotor flux in the q-axis,
	ψ_rd: rotor flux in the d-axis, 
	ωr: Rotor speed [pu],
- `n_states::Int`: SingleCageInductionMachine has 5 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SingleCageInductionMachine <: DynamicInjection
    name::String
    "Armature stator resistance"
    Rs::Float64
    "Rotor resistance"
    Rr::Float64
    "Stator Self Reactance"
    Xs::Float64
    "Rotor Self Reactance"
    Xr::Float64
    "Stator-Rotor Mutual Reactance"
    Xm::Float64
    "Motor Inertia Constant [s]"
    H::Float64
    "Torque-Speed Quadratic Term"
    A::Float64
    "Torque-Speed Linear Term"
    B::Float64
    "Base power"
    base_power::Float64
    ext::Dict{String, Any}
    "Torque-Speed Constant Term"
    C::Float64
    "Reference torque parameter"
    τ_ref::Float64
    "Susceptance Initialization Corrector Term"
    B_shunt::Float64
    "The states are:
	ψ_sq: stator flux in the q-axis,
	ψ_sd: stator flux in the d-axis,
	ψ_rq: rotor flux in the q-axis,
	ψ_rd: rotor flux in the d-axis, 
	ωr: Rotor speed [pu],"
    states::Vector{Symbol}
    "SingleCageInductionMachine has 5 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SingleCageInductionMachine(name, Rs, Rr, Xs, Xr, Xm, H, A, B, base_power=100.0, ext=Dict{String, Any}(), )
    SingleCageInductionMachine(name, Rs, Rr, Xs, Xr, Xm, H, A, B, base_power, ext, PowerSystems.calculate_IM_torque_params(A, B), 1.0, 0.0, [:ψ_sq, :ψ_sd, :ψ_rq, :ψ_rd, :ωr], 5, InfrastructureSystemsInternal(), )
end

function SingleCageInductionMachine(; name, Rs, Rr, Xs, Xr, Xm, H, A, B, base_power=100.0, ext=Dict{String, Any}(), C=PowerSystems.calculate_IM_torque_params(A, B), τ_ref=1.0, B_shunt=0.0, states=[:ψ_sq, :ψ_sd, :ψ_rq, :ψ_rd, :ωr], n_states=5, internal=InfrastructureSystemsInternal(), )
    SingleCageInductionMachine(name, Rs, Rr, Xs, Xr, Xm, H, A, B, base_power, ext, C, τ_ref, B_shunt, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function SingleCageInductionMachine(::Nothing)
    SingleCageInductionMachine(;
        name="init",
        Rs=0,
        Rr=0,
        Xs=0,
        Xr=0,
        Xm=0,
        H=0,
        A=0.0,
        B=0.0,
        base_power=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`SingleCageInductionMachine`](@ref) `name`."""
get_name(value::SingleCageInductionMachine) = value.name
"""Get [`SingleCageInductionMachine`](@ref) `Rs`."""
get_Rs(value::SingleCageInductionMachine) = value.Rs
"""Get [`SingleCageInductionMachine`](@ref) `Rr`."""
get_Rr(value::SingleCageInductionMachine) = value.Rr
"""Get [`SingleCageInductionMachine`](@ref) `Xs`."""
get_Xs(value::SingleCageInductionMachine) = value.Xs
"""Get [`SingleCageInductionMachine`](@ref) `Xr`."""
get_Xr(value::SingleCageInductionMachine) = value.Xr
"""Get [`SingleCageInductionMachine`](@ref) `Xm`."""
get_Xm(value::SingleCageInductionMachine) = value.Xm
"""Get [`SingleCageInductionMachine`](@ref) `H`."""
get_H(value::SingleCageInductionMachine) = value.H
"""Get [`SingleCageInductionMachine`](@ref) `A`."""
get_A(value::SingleCageInductionMachine) = value.A
"""Get [`SingleCageInductionMachine`](@ref) `B`."""
get_B(value::SingleCageInductionMachine) = value.B
"""Get [`SingleCageInductionMachine`](@ref) `base_power`."""
get_base_power(value::SingleCageInductionMachine) = value.base_power
"""Get [`SingleCageInductionMachine`](@ref) `ext`."""
get_ext(value::SingleCageInductionMachine) = value.ext
"""Get [`SingleCageInductionMachine`](@ref) `C`."""
get_C(value::SingleCageInductionMachine) = value.C
"""Get [`SingleCageInductionMachine`](@ref) `τ_ref`."""
get_τ_ref(value::SingleCageInductionMachine) = value.τ_ref
"""Get [`SingleCageInductionMachine`](@ref) `B_shunt`."""
get_B_shunt(value::SingleCageInductionMachine) = value.B_shunt
"""Get [`SingleCageInductionMachine`](@ref) `states`."""
get_states(value::SingleCageInductionMachine) = value.states
"""Get [`SingleCageInductionMachine`](@ref) `n_states`."""
get_n_states(value::SingleCageInductionMachine) = value.n_states
"""Get [`SingleCageInductionMachine`](@ref) `internal`."""
get_internal(value::SingleCageInductionMachine) = value.internal

"""Set [`SingleCageInductionMachine`](@ref) `Rs`."""
set_Rs!(value::SingleCageInductionMachine, val) = value.Rs = val
"""Set [`SingleCageInductionMachine`](@ref) `Rr`."""
set_Rr!(value::SingleCageInductionMachine, val) = value.Rr = val
"""Set [`SingleCageInductionMachine`](@ref) `Xs`."""
set_Xs!(value::SingleCageInductionMachine, val) = value.Xs = val
"""Set [`SingleCageInductionMachine`](@ref) `Xr`."""
set_Xr!(value::SingleCageInductionMachine, val) = value.Xr = val
"""Set [`SingleCageInductionMachine`](@ref) `Xm`."""
set_Xm!(value::SingleCageInductionMachine, val) = value.Xm = val
"""Set [`SingleCageInductionMachine`](@ref) `H`."""
set_H!(value::SingleCageInductionMachine, val) = value.H = val
"""Set [`SingleCageInductionMachine`](@ref) `A`."""
set_A!(value::SingleCageInductionMachine, val) = value.A = val
"""Set [`SingleCageInductionMachine`](@ref) `B`."""
set_B!(value::SingleCageInductionMachine, val) = value.B = val
"""Set [`SingleCageInductionMachine`](@ref) `base_power`."""
set_base_power!(value::SingleCageInductionMachine, val) = value.base_power = val
"""Set [`SingleCageInductionMachine`](@ref) `ext`."""
set_ext!(value::SingleCageInductionMachine, val) = value.ext = val
"""Set [`SingleCageInductionMachine`](@ref) `C`."""
set_C!(value::SingleCageInductionMachine, val) = value.C = val
"""Set [`SingleCageInductionMachine`](@ref) `τ_ref`."""
set_τ_ref!(value::SingleCageInductionMachine, val) = value.τ_ref = val
"""Set [`SingleCageInductionMachine`](@ref) `B_shunt`."""
set_B_shunt!(value::SingleCageInductionMachine, val) = value.B_shunt = val
