#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct EST1A <: AVR
        UEL_flags::Int64
        PSS_flags::Int64
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

This excitation system supplies power through a transformer from the generator terminals and its regulated by a controlled rectifier (via thyristors).
Parameters of IEEE Std 421.5 Type ST1A Excitacion System. ESST1A in PSSE and PSLF

# Arguments
- `UEL_flags::Int64`: Code input for Underexcitization limiter (UEL) entry. Not supported., validation range: `(1, 3)`
- `PSS_flags::Int64`: Code input for Power System Stabilizer (PSS) or (VOS) entry., validation range: `(1, 2)`
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
mutable struct EST1A <: AVR
    "Code input for Underexcitization limiter (UEL) entry. Not supported."
    UEL_flags::Int64
    "Code input for Power System Stabilizer (PSS) or (VOS) entry."
    PSS_flags::Int64
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

function EST1A(UEL_flags, PSS_flags, Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref=1.0, ext=Dict{String, Any}(), )
    EST1A(UEL_flags, PSS_flags, Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref, ext, [:Vm, :Vr1, :Vr2, :Va, :Vr3], 5, [StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function EST1A(; UEL_flags, PSS_flags, Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref=1.0, ext=Dict{String, Any}(), )
    EST1A(UEL_flags, PSS_flags, Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function EST1A(::Nothing)
    EST1A(;
        UEL_flags=1,
        PSS_flags=1,
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

"""Get [`EST1A`](@ref) `UEL_flags`."""
get_UEL_flags(value::EST1A) = value.UEL_flags
"""Get [`EST1A`](@ref) `PSS_flags`."""
get_PSS_flags(value::EST1A) = value.PSS_flags
"""Get [`EST1A`](@ref) `Tr`."""
get_Tr(value::EST1A) = value.Tr
"""Get [`EST1A`](@ref) `Vi_lim`."""
get_Vi_lim(value::EST1A) = value.Vi_lim
"""Get [`EST1A`](@ref) `Tc`."""
get_Tc(value::EST1A) = value.Tc
"""Get [`EST1A`](@ref) `Tb`."""
get_Tb(value::EST1A) = value.Tb
"""Get [`EST1A`](@ref) `Tc1`."""
get_Tc1(value::EST1A) = value.Tc1
"""Get [`EST1A`](@ref) `Tb1`."""
get_Tb1(value::EST1A) = value.Tb1
"""Get [`EST1A`](@ref) `Ka`."""
get_Ka(value::EST1A) = value.Ka
"""Get [`EST1A`](@ref) `Ta`."""
get_Ta(value::EST1A) = value.Ta
"""Get [`EST1A`](@ref) `Va_lim`."""
get_Va_lim(value::EST1A) = value.Va_lim
"""Get [`EST1A`](@ref) `Vr_lim`."""
get_Vr_lim(value::EST1A) = value.Vr_lim
"""Get [`EST1A`](@ref) `Kc`."""
get_Kc(value::EST1A) = value.Kc
"""Get [`EST1A`](@ref) `Kf`."""
get_Kf(value::EST1A) = value.Kf
"""Get [`EST1A`](@ref) `Tf`."""
get_Tf(value::EST1A) = value.Tf
"""Get [`EST1A`](@ref) `K_lr`."""
get_K_lr(value::EST1A) = value.K_lr
"""Get [`EST1A`](@ref) `I_lr`."""
get_I_lr(value::EST1A) = value.I_lr
"""Get [`EST1A`](@ref) `V_ref`."""
get_V_ref(value::EST1A) = value.V_ref
"""Get [`EST1A`](@ref) `ext`."""
get_ext(value::EST1A) = value.ext
"""Get [`EST1A`](@ref) `states`."""
get_states(value::EST1A) = value.states
"""Get [`EST1A`](@ref) `n_states`."""
get_n_states(value::EST1A) = value.n_states
"""Get [`EST1A`](@ref) `states_types`."""
get_states_types(value::EST1A) = value.states_types
"""Get [`EST1A`](@ref) `internal`."""
get_internal(value::EST1A) = value.internal

"""Set [`EST1A`](@ref) `UEL_flags`."""
set_UEL_flags!(value::EST1A, val) = value.UEL_flags = val
"""Set [`EST1A`](@ref) `PSS_flags`."""
set_PSS_flags!(value::EST1A, val) = value.PSS_flags = val
"""Set [`EST1A`](@ref) `Tr`."""
set_Tr!(value::EST1A, val) = value.Tr = val
"""Set [`EST1A`](@ref) `Vi_lim`."""
set_Vi_lim!(value::EST1A, val) = value.Vi_lim = val
"""Set [`EST1A`](@ref) `Tc`."""
set_Tc!(value::EST1A, val) = value.Tc = val
"""Set [`EST1A`](@ref) `Tb`."""
set_Tb!(value::EST1A, val) = value.Tb = val
"""Set [`EST1A`](@ref) `Tc1`."""
set_Tc1!(value::EST1A, val) = value.Tc1 = val
"""Set [`EST1A`](@ref) `Tb1`."""
set_Tb1!(value::EST1A, val) = value.Tb1 = val
"""Set [`EST1A`](@ref) `Ka`."""
set_Ka!(value::EST1A, val) = value.Ka = val
"""Set [`EST1A`](@ref) `Ta`."""
set_Ta!(value::EST1A, val) = value.Ta = val
"""Set [`EST1A`](@ref) `Va_lim`."""
set_Va_lim!(value::EST1A, val) = value.Va_lim = val
"""Set [`EST1A`](@ref) `Vr_lim`."""
set_Vr_lim!(value::EST1A, val) = value.Vr_lim = val
"""Set [`EST1A`](@ref) `Kc`."""
set_Kc!(value::EST1A, val) = value.Kc = val
"""Set [`EST1A`](@ref) `Kf`."""
set_Kf!(value::EST1A, val) = value.Kf = val
"""Set [`EST1A`](@ref) `Tf`."""
set_Tf!(value::EST1A, val) = value.Tf = val
"""Set [`EST1A`](@ref) `K_lr`."""
set_K_lr!(value::EST1A, val) = value.K_lr = val
"""Set [`EST1A`](@ref) `I_lr`."""
set_I_lr!(value::EST1A, val) = value.I_lr = val
"""Set [`EST1A`](@ref) `V_ref`."""
set_V_ref!(value::EST1A, val) = value.V_ref = val
"""Set [`EST1A`](@ref) `ext`."""
set_ext!(value::EST1A, val) = value.ext = val
"""Set [`EST1A`](@ref) `states`."""
set_states!(value::EST1A, val) = value.states = val
"""Set [`EST1A`](@ref) `n_states`."""
set_n_states!(value::EST1A, val) = value.n_states = val
"""Set [`EST1A`](@ref) `states_types`."""
set_states_types!(value::EST1A, val) = value.states_types = val
"""Set [`EST1A`](@ref) `internal`."""
set_internal!(value::EST1A, val) = value.internal = val
