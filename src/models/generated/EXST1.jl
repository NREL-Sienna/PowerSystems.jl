#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct EXST1 <: AVR
        Tr::Float64
        Vi_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        Tc::Float64
        Tb::Float64
        Ka::Float64
        Ta::Float64
        Vr_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        Kc::Float64
        Kf::Float64
        Tf::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

IEEE Type ST1 Excitation System (PTI version)

# Arguments
- `Tr::Float64`: Voltage Measurement Time Constant in s, validation range: `(0, nothing)`, action if invalid: `warn`
- `Vi_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Voltage input limits (Vi_min, Vi_max)
- `Tc::Float64`: Numerator lead-lag (lead) time constant in s, validation range: `(0, nothing)`, action if invalid: `warn`
- `Tb::Float64`: Denominator lead-lag (lag) time constant in s, validation range: `(0, nothing)`, action if invalid: `warn`
- `Ka::Float64`: Amplifier Gain, validation range: `(0, nothing)`, action if invalid: `warn`
- `Ta::Float64`: Amplifier Time Constant in s, validation range: `(0, nothing)`, action if invalid: `warn`
- `Vr_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Voltage regulator limits (regulator output) (Vr_min, Vr_max)
- `Kc::Float64`: Current field constant limiter multiplier, validation range: `(0, nothing)`
- `Kf::Float64`: Excitation control system stabilizer gain, validation range: `(eps(), 0.3)`, action if invalid: `warn`
- `Tf::Float64`: Excitation control system stabilizer time constant, validation range: `(eps(), nothing)`, action if invalid: `error`
- `V_ref::Float64`: Reference Voltage Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	Vm: Sensed Terminal Voltage,
	Vrll: Lead-Lag state,
	Vr: Regulator Output, 
	Vfb: Feedback state
- `n_states::Int`: The EXST1 has 4 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct EXST1 <: AVR
    "Voltage Measurement Time Constant in s"
    Tr::Float64
    "Voltage input limits (Vi_min, Vi_max)"
    Vi_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Numerator lead-lag (lead) time constant in s"
    Tc::Float64
    "Denominator lead-lag (lag) time constant in s"
    Tb::Float64
    "Amplifier Gain"
    Ka::Float64
    "Amplifier Time Constant in s"
    Ta::Float64
    "Voltage regulator limits (regulator output) (Vr_min, Vr_max)"
    Vr_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Current field constant limiter multiplier"
    Kc::Float64
    "Excitation control system stabilizer gain"
    Kf::Float64
    "Excitation control system stabilizer time constant"
    Tf::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    ext::Dict{String, Any}
    "The states are:
	Vm: Sensed Terminal Voltage,
	Vrll: Lead-Lag state,
	Vr: Regulator Output, 
	Vfb: Feedback state"
    states::Vector{Symbol}
    "The EXST1 has 4 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function EXST1(Tr, Vi_lim, Tc, Tb, Ka, Ta, Vr_lim, Kc, Kf, Tf, V_ref=1.0, ext=Dict{String, Any}(), )
    EXST1(Tr, Vi_lim, Tc, Tb, Ka, Ta, Vr_lim, Kc, Kf, Tf, V_ref, ext, [:Vm, :Vrll, :Vr, :Vfb], 4, InfrastructureSystemsInternal(), )
end

function EXST1(; Tr, Vi_lim, Tc, Tb, Ka, Ta, Vr_lim, Kc, Kf, Tf, V_ref=1.0, ext=Dict{String, Any}(), states=[:Vm, :Vrll, :Vr, :Vfb], n_states=4, internal=InfrastructureSystemsInternal(), )
    EXST1(Tr, Vi_lim, Tc, Tb, Ka, Ta, Vr_lim, Kc, Kf, Tf, V_ref, ext, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function EXST1(::Nothing)
    EXST1(;
        Tr=0,
        Vi_lim=(min=0.0, max=0.0),
        Tc=0,
        Tb=0,
        Ka=0,
        Ta=0,
        Vr_lim=(min=0.0, max=0.0),
        Kc=0,
        Kf=0,
        Tf=0,
        V_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`EXST1`](@ref) `Tr`."""
get_Tr(value::EXST1) = value.Tr
"""Get [`EXST1`](@ref) `Vi_lim`."""
get_Vi_lim(value::EXST1) = value.Vi_lim
"""Get [`EXST1`](@ref) `Tc`."""
get_Tc(value::EXST1) = value.Tc
"""Get [`EXST1`](@ref) `Tb`."""
get_Tb(value::EXST1) = value.Tb
"""Get [`EXST1`](@ref) `Ka`."""
get_Ka(value::EXST1) = value.Ka
"""Get [`EXST1`](@ref) `Ta`."""
get_Ta(value::EXST1) = value.Ta
"""Get [`EXST1`](@ref) `Vr_lim`."""
get_Vr_lim(value::EXST1) = value.Vr_lim
"""Get [`EXST1`](@ref) `Kc`."""
get_Kc(value::EXST1) = value.Kc
"""Get [`EXST1`](@ref) `Kf`."""
get_Kf(value::EXST1) = value.Kf
"""Get [`EXST1`](@ref) `Tf`."""
get_Tf(value::EXST1) = value.Tf
"""Get [`EXST1`](@ref) `V_ref`."""
get_V_ref(value::EXST1) = value.V_ref
"""Get [`EXST1`](@ref) `ext`."""
get_ext(value::EXST1) = value.ext
"""Get [`EXST1`](@ref) `states`."""
get_states(value::EXST1) = value.states
"""Get [`EXST1`](@ref) `n_states`."""
get_n_states(value::EXST1) = value.n_states
"""Get [`EXST1`](@ref) `internal`."""
get_internal(value::EXST1) = value.internal

"""Set [`EXST1`](@ref) `Tr`."""
set_Tr!(value::EXST1, val) = value.Tr = val
"""Set [`EXST1`](@ref) `Vi_lim`."""
set_Vi_lim!(value::EXST1, val) = value.Vi_lim = val
"""Set [`EXST1`](@ref) `Tc`."""
set_Tc!(value::EXST1, val) = value.Tc = val
"""Set [`EXST1`](@ref) `Tb`."""
set_Tb!(value::EXST1, val) = value.Tb = val
"""Set [`EXST1`](@ref) `Ka`."""
set_Ka!(value::EXST1, val) = value.Ka = val
"""Set [`EXST1`](@ref) `Ta`."""
set_Ta!(value::EXST1, val) = value.Ta = val
"""Set [`EXST1`](@ref) `Vr_lim`."""
set_Vr_lim!(value::EXST1, val) = value.Vr_lim = val
"""Set [`EXST1`](@ref) `Kc`."""
set_Kc!(value::EXST1, val) = value.Kc = val
"""Set [`EXST1`](@ref) `Kf`."""
set_Kf!(value::EXST1, val) = value.Kf = val
"""Set [`EXST1`](@ref) `Tf`."""
set_Tf!(value::EXST1, val) = value.Tf = val
"""Set [`EXST1`](@ref) `V_ref`."""
set_V_ref!(value::EXST1, val) = value.V_ref = val
"""Set [`EXST1`](@ref) `ext`."""
set_ext!(value::EXST1, val) = value.ext = val
