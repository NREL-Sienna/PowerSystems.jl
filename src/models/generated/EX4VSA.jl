#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct EX4VSA <: AVR
        Iflim::Float64
        d::Float64
        f::Float64
        Spar::Float64
        K1::Float64
        K2::Float64
        Oel_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        G::Float64
        Ta::Float64
        Tb::Float64
        Te::Float64
        E_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

IEEE Excitation System for Voltage Security Assesment

# Arguments
- `Iflim::Float64`: OEL Field current limit, validation range: `(0, nothing)`, action if invalid: `warn`
- `d::Float64`: OEL parameter d, validation range: `(0, nothing)`, action if invalid: `warn`
- `f::Float64`: OEL parameter f, validation range: `(0, nothing)`, action if invalid: `warn`
- `Spar::Float64`: OEL parameter Spar, validation range: `(0, nothing)`, action if invalid: `warn`
- `K1::Float64`: OEL delay time constant, validation range: `(0, nothing)`, action if invalid: `warn`
- `K2::Float64`: OEL parameter K2, validation range: `(0, nothing)`, action if invalid: `warn`
- `Oel_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Oel integrator limits (Oel_min, Oel_max)
- `G::Float64`: AVR Exciter Gain, validation range: `(0, nothing)`, action if invalid: `warn`
- `Ta::Float64`: Numerator lead-lag (lag) time constant in s, validation range: `(0, nothing)`, action if invalid: `warn`
- `Tb::Float64`: Denominator lead-lag (lag) time constant in s, validation range: `(0, nothing)`, action if invalid: `warn`
- `Te::Float64`: Exciter Time Constant in s, validation range: `(0, nothing)`, action if invalid: `warn`
- `E_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Voltage regulator limits (regulator output) (E_min, E_max)
- `V_ref::Float64`: Reference Voltage Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	Vll: Lead-lag internal state,
	Vex: Exciter Output, 
	oel: OEL integrator state
- `n_states::Int`: The EX4VSA has 3 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct EX4VSA <: AVR
    "OEL Field current limit"
    Iflim::Float64
    "OEL parameter d"
    d::Float64
    "OEL parameter f"
    f::Float64
    "OEL parameter Spar"
    Spar::Float64
    "OEL delay time constant"
    K1::Float64
    "OEL parameter K2"
    K2::Float64
    "Oel integrator limits (Oel_min, Oel_max)"
    Oel_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "AVR Exciter Gain"
    G::Float64
    "Numerator lead-lag (lag) time constant in s"
    Ta::Float64
    "Denominator lead-lag (lag) time constant in s"
    Tb::Float64
    "Exciter Time Constant in s"
    Te::Float64
    "Voltage regulator limits (regulator output) (E_min, E_max)"
    E_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Reference Voltage Set-point"
    V_ref::Float64
    ext::Dict{String, Any}
    "The states are:
	Vll: Lead-lag internal state,
	Vex: Exciter Output, 
	oel: OEL integrator state"
    states::Vector{Symbol}
    "The EX4VSA has 3 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function EX4VSA(Iflim, d, f, Spar, K1, K2, Oel_lim, G, Ta, Tb, Te, E_lim, V_ref=1.0, ext=Dict{String, Any}(), )
    EX4VSA(Iflim, d, f, Spar, K1, K2, Oel_lim, G, Ta, Tb, Te, E_lim, V_ref, ext, [:Vll, :Vex, :oel], 3, InfrastructureSystemsInternal(), )
end

function EX4VSA(; Iflim, d, f, Spar, K1, K2, Oel_lim, G, Ta, Tb, Te, E_lim, V_ref=1.0, ext=Dict{String, Any}(), states=[:Vll, :Vex, :oel], n_states=3, internal=InfrastructureSystemsInternal(), )
    EX4VSA(Iflim, d, f, Spar, K1, K2, Oel_lim, G, Ta, Tb, Te, E_lim, V_ref, ext, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function EX4VSA(::Nothing)
    EX4VSA(;
        Iflim=0,
        d=0,
        f=0,
        Spar=0,
        K1=0,
        K2=0,
        Oel_lim=(min=0.0, max=0.0),
        G=0,
        Ta=0,
        Tb=0,
        Te=0,
        E_lim=(min=0.0, max=0.0),
        V_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`EX4VSA`](@ref) `Iflim`."""
get_Iflim(value::EX4VSA) = value.Iflim
"""Get [`EX4VSA`](@ref) `d`."""
get_d(value::EX4VSA) = value.d
"""Get [`EX4VSA`](@ref) `f`."""
get_f(value::EX4VSA) = value.f
"""Get [`EX4VSA`](@ref) `Spar`."""
get_Spar(value::EX4VSA) = value.Spar
"""Get [`EX4VSA`](@ref) `K1`."""
get_K1(value::EX4VSA) = value.K1
"""Get [`EX4VSA`](@ref) `K2`."""
get_K2(value::EX4VSA) = value.K2
"""Get [`EX4VSA`](@ref) `Oel_lim`."""
get_Oel_lim(value::EX4VSA) = value.Oel_lim
"""Get [`EX4VSA`](@ref) `G`."""
get_G(value::EX4VSA) = value.G
"""Get [`EX4VSA`](@ref) `Ta`."""
get_Ta(value::EX4VSA) = value.Ta
"""Get [`EX4VSA`](@ref) `Tb`."""
get_Tb(value::EX4VSA) = value.Tb
"""Get [`EX4VSA`](@ref) `Te`."""
get_Te(value::EX4VSA) = value.Te
"""Get [`EX4VSA`](@ref) `E_lim`."""
get_E_lim(value::EX4VSA) = value.E_lim
"""Get [`EX4VSA`](@ref) `V_ref`."""
get_V_ref(value::EX4VSA) = value.V_ref
"""Get [`EX4VSA`](@ref) `ext`."""
get_ext(value::EX4VSA) = value.ext
"""Get [`EX4VSA`](@ref) `states`."""
get_states(value::EX4VSA) = value.states
"""Get [`EX4VSA`](@ref) `n_states`."""
get_n_states(value::EX4VSA) = value.n_states
"""Get [`EX4VSA`](@ref) `internal`."""
get_internal(value::EX4VSA) = value.internal

"""Set [`EX4VSA`](@ref) `Iflim`."""
set_Iflim!(value::EX4VSA, val) = value.Iflim = val
"""Set [`EX4VSA`](@ref) `d`."""
set_d!(value::EX4VSA, val) = value.d = val
"""Set [`EX4VSA`](@ref) `f`."""
set_f!(value::EX4VSA, val) = value.f = val
"""Set [`EX4VSA`](@ref) `Spar`."""
set_Spar!(value::EX4VSA, val) = value.Spar = val
"""Set [`EX4VSA`](@ref) `K1`."""
set_K1!(value::EX4VSA, val) = value.K1 = val
"""Set [`EX4VSA`](@ref) `K2`."""
set_K2!(value::EX4VSA, val) = value.K2 = val
"""Set [`EX4VSA`](@ref) `Oel_lim`."""
set_Oel_lim!(value::EX4VSA, val) = value.Oel_lim = val
"""Set [`EX4VSA`](@ref) `G`."""
set_G!(value::EX4VSA, val) = value.G = val
"""Set [`EX4VSA`](@ref) `Ta`."""
set_Ta!(value::EX4VSA, val) = value.Ta = val
"""Set [`EX4VSA`](@ref) `Tb`."""
set_Tb!(value::EX4VSA, val) = value.Tb = val
"""Set [`EX4VSA`](@ref) `Te`."""
set_Te!(value::EX4VSA, val) = value.Te = val
"""Set [`EX4VSA`](@ref) `E_lim`."""
set_E_lim!(value::EX4VSA, val) = value.E_lim = val
"""Set [`EX4VSA`](@ref) `V_ref`."""
set_V_ref!(value::EX4VSA, val) = value.V_ref = val
"""Set [`EX4VSA`](@ref) `ext`."""
set_ext!(value::EX4VSA, val) = value.ext = val
