#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct FiveMassShaft <: Shaft
        H::Float64
        H_hp::Float64
        H_ip::Float64
        H_lp::Float64
        H_ex::Float64
        D::Float64
        D_hp::Float64
        D_ip::Float64
        D_lp::Float64
        D_ex::Float64
        D_12::Float64
        D_23::Float64
        D_34::Float64
        D_45::Float64
        K_hp::Float64
        K_ip::Float64
        K_lp::Float64
        K_ex::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of 5 mass-spring shaft model.
 It contains a High-Pressure (HP) steam turbine, Intermediate-Pressure (IP)
 steam turbine, Low-Pressure (LP) steam turbine, the Rotor and an Exciter (EX) mover.

# Arguments
- `H::Float64`: Rotor inertia constant in MWs/MVA, validation range: (0, nothing)
- `H_hp::Float64`: High pressure turbine inertia constant in MWs/MVA, validation range: (0, nothing)
- `H_ip::Float64`: Intermediate pressure turbine inertia constant in MWs/MVA, validation range: (0, nothing)
- `H_lp::Float64`: Low pressure turbine inertia constant in MWs/MVA, validation range: (0, nothing)
- `H_ex::Float64`:  Exciter inertia constant in MWs/MVA, validation range: (0, nothing)
- `D::Float64`: Rotor natural damping in pu, validation range: (0, nothing)
- `D_hp::Float64`: High pressure turbine natural damping in pu, validation range: (0, nothing)
- `D_ip::Float64`: Intermediate pressure turbine natural damping in pu, validation range: (0, nothing)
- `D_lp::Float64`: Low pressure turbine natural damping in pu, validation range: (0, nothing)
- `D_ex::Float64`: Exciter natural damping in pu, validation range: (0, nothing)
- `D_12::Float64`: High-Intermediate pressure turbine damping, validation range: (0, nothing)
- `D_23::Float64`: Intermediate-Low pressure turbine damping, validation range: (0, nothing)
- `D_34::Float64`: Low pressure turbine-Rotor damping, validation range: (0, nothing)
- `D_45::Float64`: Rotor-Exciter damping, validation range: (0, nothing)
- `K_hp::Float64`: High pressure turbine angle coefficient, validation range: (0, nothing)
- `K_ip::Float64`: Intermediate pressure turbine angle coefficient, validation range: (0, nothing)
- `K_lp::Float64`: Low pressure turbine angle coefficient, validation range: (0, nothing)
- `K_ex::Float64`: Exciter angle coefficient, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct FiveMassShaft <: Shaft
    "Rotor inertia constant in MWs/MVA"
    H::Float64
    "High pressure turbine inertia constant in MWs/MVA"
    H_hp::Float64
    "Intermediate pressure turbine inertia constant in MWs/MVA"
    H_ip::Float64
    "Low pressure turbine inertia constant in MWs/MVA"
    H_lp::Float64
    " Exciter inertia constant in MWs/MVA"
    H_ex::Float64
    "Rotor natural damping in pu"
    D::Float64
    "High pressure turbine natural damping in pu"
    D_hp::Float64
    "Intermediate pressure turbine natural damping in pu"
    D_ip::Float64
    "Low pressure turbine natural damping in pu"
    D_lp::Float64
    "Exciter natural damping in pu"
    D_ex::Float64
    "High-Intermediate pressure turbine damping"
    D_12::Float64
    "Intermediate-Low pressure turbine damping"
    D_23::Float64
    "Low pressure turbine-Rotor damping"
    D_34::Float64
    "Rotor-Exciter damping"
    D_45::Float64
    "High pressure turbine angle coefficient"
    K_hp::Float64
    "Intermediate pressure turbine angle coefficient"
    K_ip::Float64
    "Low pressure turbine angle coefficient"
    K_lp::Float64
    "Exciter angle coefficient"
    K_ex::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function FiveMassShaft(H, H_hp, H_ip, H_lp, H_ex, D, D_hp, D_ip, D_lp, D_ex, D_12, D_23, D_34, D_45, K_hp, K_ip, K_lp, K_ex, ext=Dict{String, Any}(), )
    FiveMassShaft(H, H_hp, H_ip, H_lp, H_ex, D, D_hp, D_ip, D_lp, D_ex, D_12, D_23, D_34, D_45, K_hp, K_ip, K_lp, K_ex, ext, [:δ, :ω, :δ_hp, :ω_hp, :δ_ip, :ω_ip, :δ_lp, :ω_lp, :δ_ex, :ω_ex], 10, InfrastructureSystemsInternal(), )
end

function FiveMassShaft(; H, H_hp, H_ip, H_lp, H_ex, D, D_hp, D_ip, D_lp, D_ex, D_12, D_23, D_34, D_45, K_hp, K_ip, K_lp, K_ex, ext=Dict{String, Any}(), )
    FiveMassShaft(H, H_hp, H_ip, H_lp, H_ex, D, D_hp, D_ip, D_lp, D_ex, D_12, D_23, D_34, D_45, K_hp, K_ip, K_lp, K_ex, ext, )
end

# Constructor for demo purposes; non-functional.
function FiveMassShaft(::Nothing)
    FiveMassShaft(;
        H=0,
        H_hp=0,
        H_ip=0,
        H_lp=0,
        H_ex=0,
        D=0,
        D_hp=0,
        D_ip=0,
        D_lp=0,
        D_ex=0,
        D_12=0,
        D_23=0,
        D_34=0,
        D_45=0,
        K_hp=0,
        K_ip=0,
        K_lp=0,
        K_ex=0,
        ext=Dict{String, Any}(),
    )
end

"""Get FiveMassShaft H."""
get_H(value::FiveMassShaft) = value.H
"""Get FiveMassShaft H_hp."""
get_H_hp(value::FiveMassShaft) = value.H_hp
"""Get FiveMassShaft H_ip."""
get_H_ip(value::FiveMassShaft) = value.H_ip
"""Get FiveMassShaft H_lp."""
get_H_lp(value::FiveMassShaft) = value.H_lp
"""Get FiveMassShaft H_ex."""
get_H_ex(value::FiveMassShaft) = value.H_ex
"""Get FiveMassShaft D."""
get_D(value::FiveMassShaft) = value.D
"""Get FiveMassShaft D_hp."""
get_D_hp(value::FiveMassShaft) = value.D_hp
"""Get FiveMassShaft D_ip."""
get_D_ip(value::FiveMassShaft) = value.D_ip
"""Get FiveMassShaft D_lp."""
get_D_lp(value::FiveMassShaft) = value.D_lp
"""Get FiveMassShaft D_ex."""
get_D_ex(value::FiveMassShaft) = value.D_ex
"""Get FiveMassShaft D_12."""
get_D_12(value::FiveMassShaft) = value.D_12
"""Get FiveMassShaft D_23."""
get_D_23(value::FiveMassShaft) = value.D_23
"""Get FiveMassShaft D_34."""
get_D_34(value::FiveMassShaft) = value.D_34
"""Get FiveMassShaft D_45."""
get_D_45(value::FiveMassShaft) = value.D_45
"""Get FiveMassShaft K_hp."""
get_K_hp(value::FiveMassShaft) = value.K_hp
"""Get FiveMassShaft K_ip."""
get_K_ip(value::FiveMassShaft) = value.K_ip
"""Get FiveMassShaft K_lp."""
get_K_lp(value::FiveMassShaft) = value.K_lp
"""Get FiveMassShaft K_ex."""
get_K_ex(value::FiveMassShaft) = value.K_ex
"""Get FiveMassShaft ext."""
get_ext(value::FiveMassShaft) = value.ext
"""Get FiveMassShaft states."""
get_states(value::FiveMassShaft) = value.states
"""Get FiveMassShaft n_states."""
get_n_states(value::FiveMassShaft) = value.n_states
"""Get FiveMassShaft internal."""
get_internal(value::FiveMassShaft) = value.internal

"""Set FiveMassShaft H."""
set_H(value::FiveMassShaft, val) = value.H = val
"""Set FiveMassShaft H_hp."""
set_H_hp(value::FiveMassShaft, val) = value.H_hp = val
"""Set FiveMassShaft H_ip."""
set_H_ip(value::FiveMassShaft, val) = value.H_ip = val
"""Set FiveMassShaft H_lp."""
set_H_lp(value::FiveMassShaft, val) = value.H_lp = val
"""Set FiveMassShaft H_ex."""
set_H_ex(value::FiveMassShaft, val) = value.H_ex = val
"""Set FiveMassShaft D."""
set_D(value::FiveMassShaft, val) = value.D = val
"""Set FiveMassShaft D_hp."""
set_D_hp(value::FiveMassShaft, val) = value.D_hp = val
"""Set FiveMassShaft D_ip."""
set_D_ip(value::FiveMassShaft, val) = value.D_ip = val
"""Set FiveMassShaft D_lp."""
set_D_lp(value::FiveMassShaft, val) = value.D_lp = val
"""Set FiveMassShaft D_ex."""
set_D_ex(value::FiveMassShaft, val) = value.D_ex = val
"""Set FiveMassShaft D_12."""
set_D_12(value::FiveMassShaft, val) = value.D_12 = val
"""Set FiveMassShaft D_23."""
set_D_23(value::FiveMassShaft, val) = value.D_23 = val
"""Set FiveMassShaft D_34."""
set_D_34(value::FiveMassShaft, val) = value.D_34 = val
"""Set FiveMassShaft D_45."""
set_D_45(value::FiveMassShaft, val) = value.D_45 = val
"""Set FiveMassShaft K_hp."""
set_K_hp(value::FiveMassShaft, val) = value.K_hp = val
"""Set FiveMassShaft K_ip."""
set_K_ip(value::FiveMassShaft, val) = value.K_ip = val
"""Set FiveMassShaft K_lp."""
set_K_lp(value::FiveMassShaft, val) = value.K_lp = val
"""Set FiveMassShaft K_ex."""
set_K_ex(value::FiveMassShaft, val) = value.K_ex = val
"""Set FiveMassShaft ext."""
set_ext(value::FiveMassShaft, val) = value.ext = val
"""Set FiveMassShaft states."""
set_states(value::FiveMassShaft, val) = value.states = val
"""Set FiveMassShaft n_states."""
set_n_states(value::FiveMassShaft, val) = value.n_states = val
"""Set FiveMassShaft internal."""
set_internal(value::FiveMassShaft, val) = value.internal = val
