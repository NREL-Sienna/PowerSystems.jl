#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct EXPIC1 <: AVR
        Tr::Float64
        Vi_lim::Tuple{Float64, Float64}
        Tc::Float64
        Tb::Float64
        Tc1::Float64
        Tb1::Float64
        Ka::Float64
        Ta::Float64
        Va_lim::Tuple{Float64, Float64}
        Vr_lim::Tuple{Float64, Float64}
        Kc::Float64
        Kf::Float64
        Tf::Float64
        K_lr::Float64
        I_lr::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        states_types::Vector{StateTypes.StateType}
        internal::InfrastructureSystemsInternal
    end

Generic Proportional/Integral Excitation System

# Arguments
- `Tr::Float64`: Regulator input filter time constant in s, validation range: `(0, nothing)`
- `Vi_lim::Tuple{Float64, Float64}`: Voltage error limits (regulator input) (Vi_min, Vi_max)
- `Tc::Float64`: First regulator denominator (lead) time constant in s, validation range: `(0, nothing)`
- `Tb::Float64`: First regulator denominator (lag) time constant in s, validation range: `(0, nothing)`
- `Tc1::Float64`: Second regulator denominator (lead) time constant in s, validation range: `(0, nothing)`
- `Tb1::Float64`: Second regulator denominator (lead) time constant in s, validation range: `(0, nothing)`
- `Ka::Float64`: Voltage regulator gain, validation range: `(0, nothing)`
- `Ta::Float64`: Voltage regulator time constant in s, validation range: `(0, nothing)`
- `Va_lim::Tuple{Float64, Float64}`: Limits for regulator output (Va_min, Va_max)
- `Vr_lim::Tuple{Float64, Float64}`: Limits for exciter output (Vr_min, Vr_max)
- `Kc::Float64`: Rectifier loading factor proportional to commutating reactance, validation range: `(0, nothing)`
- `Kf::Float64`: Rate feedback gain, validation range: `(0, nothing)`
- `Tf::Float64`: Rate feedback time constant in s, validation range: `("eps()", nothing)`
- `K_lr::Float64`: Exciter output current limiter gain, validation range: `(0, nothing)`
- `I_lr::Float64`: Exciter output current limit reference, validation range: `(0, nothing)`
- `V_ref::Float64`: Reference Voltage Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	Vm: Sensed terminal voltage,
	Vr1: First Lead-lag state,
	Vr2: Second lead-lag state,
	Va: Regulator output state,
	Vr3: Feedback output state
- `n_states::Int64`: ST1A has 5 states
- `states_types::Vector{StateTypes.StateType}`: ST1A has 5 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct EXPIC1 <: AVR
    "Regulator input filter time constant in s"
    Tr::Float64
    "Voltage error limits (regulator input) (Vi_min, Vi_max)"
    Vi_lim::Tuple{Float64, Float64}
    "First regulator denominator (lead) time constant in s"
    Tc::Float64
    "First regulator denominator (lag) time constant in s"
    Tb::Float64
    "Second regulator denominator (lead) time constant in s"
    Tc1::Float64
    "Second regulator denominator (lead) time constant in s"
    Tb1::Float64
    "Voltage regulator gain"
    Ka::Float64
    "Voltage regulator time constant in s"
    Ta::Float64
    "Limits for regulator output (Va_min, Va_max)"
    Va_lim::Tuple{Float64, Float64}
    "Limits for exciter output (Vr_min, Vr_max)"
    Vr_lim::Tuple{Float64, Float64}
    "Rectifier loading factor proportional to commutating reactance"
    Kc::Float64
    "Rate feedback gain"
    Kf::Float64
    "Rate feedback time constant in s"
    Tf::Float64
    "Exciter output current limiter gain"
    K_lr::Float64
    "Exciter output current limit reference"
    I_lr::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    ext::Dict{String, Any}
    "The states are:
	Vm: Sensed terminal voltage,
	Vr1: First Lead-lag state,
	Vr2: Second lead-lag state,
	Va: Regulator output state,
	Vr3: Feedback output state"
    states::Vector{Symbol}
    "ST1A has 5 states"
    n_states::Int64
    "ST1A has 5 states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function EXPIC1(Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref=1.0, ext=Dict{String, Any}(), )
    EXPIC1(Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref, ext, [:Vm, :Vr1, :Vr2, :Va, :Vr3], 5, [StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function EXPIC1(; Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref=1.0, ext=Dict{String, Any}(), )
    EXPIC1(Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function EXPIC1(::Nothing)
    EXPIC1(;
        Tr=0,
        Vi_lim=(0.0, 0.0),
        Tc=0,
        Tb=0,
        Tc1=0,
        Tb1=0,
        Ka=0,
        Ta=0,
        Va_lim=(0.0, 0.0),
        Vr_lim=(0.0, 0.0),
        Kc=0,
        Kf=0,
        Tf=0,
        K_lr=0,
        I_lr=0,
        V_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`EXPIC1`](@ref) `Tr`."""
get_Tr(value::EXPIC1) = value.Tr
"""Get [`EXPIC1`](@ref) `Vi_lim`."""
get_Vi_lim(value::EXPIC1) = value.Vi_lim
"""Get [`EXPIC1`](@ref) `Tc`."""
get_Tc(value::EXPIC1) = value.Tc
"""Get [`EXPIC1`](@ref) `Tb`."""
get_Tb(value::EXPIC1) = value.Tb
"""Get [`EXPIC1`](@ref) `Tc1`."""
get_Tc1(value::EXPIC1) = value.Tc1
"""Get [`EXPIC1`](@ref) `Tb1`."""
get_Tb1(value::EXPIC1) = value.Tb1
"""Get [`EXPIC1`](@ref) `Ka`."""
get_Ka(value::EXPIC1) = value.Ka
"""Get [`EXPIC1`](@ref) `Ta`."""
get_Ta(value::EXPIC1) = value.Ta
"""Get [`EXPIC1`](@ref) `Va_lim`."""
get_Va_lim(value::EXPIC1) = value.Va_lim
"""Get [`EXPIC1`](@ref) `Vr_lim`."""
get_Vr_lim(value::EXPIC1) = value.Vr_lim
"""Get [`EXPIC1`](@ref) `Kc`."""
get_Kc(value::EXPIC1) = value.Kc
"""Get [`EXPIC1`](@ref) `Kf`."""
get_Kf(value::EXPIC1) = value.Kf
"""Get [`EXPIC1`](@ref) `Tf`."""
get_Tf(value::EXPIC1) = value.Tf
"""Get [`EXPIC1`](@ref) `K_lr`."""
get_K_lr(value::EXPIC1) = value.K_lr
"""Get [`EXPIC1`](@ref) `I_lr`."""
get_I_lr(value::EXPIC1) = value.I_lr
"""Get [`EXPIC1`](@ref) `V_ref`."""
get_V_ref(value::EXPIC1) = value.V_ref
"""Get [`EXPIC1`](@ref) `ext`."""
get_ext(value::EXPIC1) = value.ext
"""Get [`EXPIC1`](@ref) `states`."""
get_states(value::EXPIC1) = value.states
"""Get [`EXPIC1`](@ref) `n_states`."""
get_n_states(value::EXPIC1) = value.n_states
"""Get [`EXPIC1`](@ref) `states_types`."""
get_states_types(value::EXPIC1) = value.states_types
"""Get [`EXPIC1`](@ref) `internal`."""
get_internal(value::EXPIC1) = value.internal

"""Set [`EXPIC1`](@ref) `Tr`."""
set_Tr!(value::EXPIC1, val) = value.Tr = val
"""Set [`EXPIC1`](@ref) `Vi_lim`."""
set_Vi_lim!(value::EXPIC1, val) = value.Vi_lim = val
"""Set [`EXPIC1`](@ref) `Tc`."""
set_Tc!(value::EXPIC1, val) = value.Tc = val
"""Set [`EXPIC1`](@ref) `Tb`."""
set_Tb!(value::EXPIC1, val) = value.Tb = val
"""Set [`EXPIC1`](@ref) `Tc1`."""
set_Tc1!(value::EXPIC1, val) = value.Tc1 = val
"""Set [`EXPIC1`](@ref) `Tb1`."""
set_Tb1!(value::EXPIC1, val) = value.Tb1 = val
"""Set [`EXPIC1`](@ref) `Ka`."""
set_Ka!(value::EXPIC1, val) = value.Ka = val
"""Set [`EXPIC1`](@ref) `Ta`."""
set_Ta!(value::EXPIC1, val) = value.Ta = val
"""Set [`EXPIC1`](@ref) `Va_lim`."""
set_Va_lim!(value::EXPIC1, val) = value.Va_lim = val
"""Set [`EXPIC1`](@ref) `Vr_lim`."""
set_Vr_lim!(value::EXPIC1, val) = value.Vr_lim = val
"""Set [`EXPIC1`](@ref) `Kc`."""
set_Kc!(value::EXPIC1, val) = value.Kc = val
"""Set [`EXPIC1`](@ref) `Kf`."""
set_Kf!(value::EXPIC1, val) = value.Kf = val
"""Set [`EXPIC1`](@ref) `Tf`."""
set_Tf!(value::EXPIC1, val) = value.Tf = val
"""Set [`EXPIC1`](@ref) `K_lr`."""
set_K_lr!(value::EXPIC1, val) = value.K_lr = val
"""Set [`EXPIC1`](@ref) `I_lr`."""
set_I_lr!(value::EXPIC1, val) = value.I_lr = val
"""Set [`EXPIC1`](@ref) `V_ref`."""
set_V_ref!(value::EXPIC1, val) = value.V_ref = val
"""Set [`EXPIC1`](@ref) `ext`."""
set_ext!(value::EXPIC1, val) = value.ext = val
"""Set [`EXPIC1`](@ref) `states`."""
set_states!(value::EXPIC1, val) = value.states = val
"""Set [`EXPIC1`](@ref) `n_states`."""
set_n_states!(value::EXPIC1, val) = value.n_states = val
"""Set [`EXPIC1`](@ref) `states_types`."""
set_states_types!(value::EXPIC1, val) = value.states_types = val
"""Set [`EXPIC1`](@ref) `internal`."""
set_internal!(value::EXPIC1, val) = value.internal = val
