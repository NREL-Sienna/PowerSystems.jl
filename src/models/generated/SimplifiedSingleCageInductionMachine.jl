#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct SimplifiedSingleCageInductionMachine <: DynamicInjection
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

Parameters of 3-states three-phase single cage induction machine with quadratic torque-speed relationship.

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
	ψ_qr: rotor flux in the q-axis,
	ψ_dr: rotor flux in the d-axis, 
	ωr: Rotor speed [pu],
- `n_states::Int`: SimplifiedSingleCageInductionMachine has 3 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SimplifiedSingleCageInductionMachine <: DynamicInjection
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
	ψ_qr: rotor flux in the q-axis,
	ψ_dr: rotor flux in the d-axis, 
	ωr: Rotor speed [pu],"
    states::Vector{Symbol}
    "SimplifiedSingleCageInductionMachine has 3 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SimplifiedSingleCageInductionMachine(name, Rs, Rr, Xs, Xr, Xm, H, A, B, base_power=100.0, ext=Dict{String, Any}(), )
    SimplifiedSingleCageInductionMachine(name, Rs, Rr, Xs, Xr, Xm, H, A, B, base_power, ext, PowerSystems.calculate_IM_torque_params(A, B), 1.0, 0.0, [:ψ_qr, :ψ_dr, :ωr], 3, InfrastructureSystemsInternal(), )
end

function SimplifiedSingleCageInductionMachine(; name, Rs, Rr, Xs, Xr, Xm, H, A, B, base_power=100.0, ext=Dict{String, Any}(), C=PowerSystems.calculate_IM_torque_params(A, B), τ_ref=1.0, B_shunt=0.0, states=[:ψ_qr, :ψ_dr, :ωr], n_states=3, internal=InfrastructureSystemsInternal(), )
    SimplifiedSingleCageInductionMachine(name, Rs, Rr, Xs, Xr, Xm, H, A, B, base_power, ext, C, τ_ref, B_shunt, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function SimplifiedSingleCageInductionMachine(::Nothing)
    SimplifiedSingleCageInductionMachine(;
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

"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `name`."""
get_name(value::SimplifiedSingleCageInductionMachine) = value.name
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `Rs`."""
get_Rs(value::SimplifiedSingleCageInductionMachine) = value.Rs
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `Rr`."""
get_Rr(value::SimplifiedSingleCageInductionMachine) = value.Rr
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `Xs`."""
get_Xs(value::SimplifiedSingleCageInductionMachine) = value.Xs
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `Xr`."""
get_Xr(value::SimplifiedSingleCageInductionMachine) = value.Xr
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `Xm`."""
get_Xm(value::SimplifiedSingleCageInductionMachine) = value.Xm
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `H`."""
get_H(value::SimplifiedSingleCageInductionMachine) = value.H
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `A`."""
get_A(value::SimplifiedSingleCageInductionMachine) = value.A
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `B`."""
get_B(value::SimplifiedSingleCageInductionMachine) = value.B
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `base_power`."""
get_base_power(value::SimplifiedSingleCageInductionMachine) = value.base_power
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `ext`."""
get_ext(value::SimplifiedSingleCageInductionMachine) = value.ext
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `C`."""
get_C(value::SimplifiedSingleCageInductionMachine) = value.C
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `τ_ref`."""
get_τ_ref(value::SimplifiedSingleCageInductionMachine) = value.τ_ref
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `B_shunt`."""
get_B_shunt(value::SimplifiedSingleCageInductionMachine) = value.B_shunt
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `states`."""
get_states(value::SimplifiedSingleCageInductionMachine) = value.states
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `n_states`."""
get_n_states(value::SimplifiedSingleCageInductionMachine) = value.n_states
"""Get [`SimplifiedSingleCageInductionMachine`](@ref) `internal`."""
get_internal(value::SimplifiedSingleCageInductionMachine) = value.internal

"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `Rs`."""
set_Rs!(value::SimplifiedSingleCageInductionMachine, val) = value.Rs = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `Rr`."""
set_Rr!(value::SimplifiedSingleCageInductionMachine, val) = value.Rr = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `Xs`."""
set_Xs!(value::SimplifiedSingleCageInductionMachine, val) = value.Xs = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `Xr`."""
set_Xr!(value::SimplifiedSingleCageInductionMachine, val) = value.Xr = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `Xm`."""
set_Xm!(value::SimplifiedSingleCageInductionMachine, val) = value.Xm = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `H`."""
set_H!(value::SimplifiedSingleCageInductionMachine, val) = value.H = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `A`."""
set_A!(value::SimplifiedSingleCageInductionMachine, val) = value.A = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `B`."""
set_B!(value::SimplifiedSingleCageInductionMachine, val) = value.B = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `base_power`."""
set_base_power!(value::SimplifiedSingleCageInductionMachine, val) = value.base_power = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `ext`."""
set_ext!(value::SimplifiedSingleCageInductionMachine, val) = value.ext = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `C`."""
set_C!(value::SimplifiedSingleCageInductionMachine, val) = value.C = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `τ_ref`."""
set_τ_ref!(value::SimplifiedSingleCageInductionMachine, val) = value.τ_ref = val
"""Set [`SimplifiedSingleCageInductionMachine`](@ref) `B_shunt`."""
set_B_shunt!(value::SimplifiedSingleCageInductionMachine, val) = value.B_shunt = val
