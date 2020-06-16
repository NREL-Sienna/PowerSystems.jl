#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ST1A <: AVR
        UEL_inputs::Int64
        PSS_inputs::Int64
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
        internal::InfrastructureSystemsInternal
    end

This excitation system supplies power through a transformer from the generator terminals and its regulated by a controlled rectifier (via thyristors).
Parameters of IEEE Std 421.5 Type ST1A Excitacion System. ESST1A in PSSE and PSLF

# Arguments
- `UEL_inputs::Int64`: Code input for Underexcitization limiter (UEL) entry. Not supported., validation range: (1, 3)
- `PSS_inputs::Int64`: Code input for Power System Stabilizer (PSS) or (VOS) entry., validation range: (1, 3)
- `Tr::Float64`: Regulator input filter time constant in s, validation range: (0, nothing)
- `Vi_lim::Tuple{Float64, Float64}`: Voltage error limits (regulator input) (Vi_min, Vi_max)
- `Tc::Float64`: First regulator denominator (lead) time constant in s, validation range: (0, nothing)
- `Tb::Float64`: First regulator denominator (lag) time constant in s, validation range: (0, nothing)
- `Tc1::Float64`: Second regulator denominator (lead) time constant in s, validation range: (0, nothing)
- `Tb1::Float64`: Second regulator denominator (lead) time constant in s, validation range: (0, nothing)
- `Ka::Float64`: Voltage regulator gain, validation range: (0, nothing)
- `Ta::Float64`: Voltage regulator time constant in s, validation range: (0, nothing)
- `Va_lim::Tuple{Float64, Float64}`: Limits for regulator output (Va_min, Va_max)
- `Vr_lim::Tuple{Float64, Float64}`: Limits for exciter output (Vr_min, Vr_max)
- `Kc::Float64`: Rectifier loading factor proportional to commutating reactance, validation range: (0, nothing)
- `Kf::Float64`: Rate feedback gain, validation range: (0, nothing)
- `Tf::Float64`: Rate feedback time constant in s, validation range: (0, nothing)
- `K_lr::Float64`: Exciter output current limiter gain, validation range: (0, nothing)
- `I_lr::Float64`: Exciter output current limit reference, validation range: (0, nothing)
- `V_ref::Float64`: Reference Voltage Set-point, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	Vm: Sensed terminal voltage,
	Vr1: First Lead-lag state,
	Vr2: Second lead-lag state,
	Va: Regulator output state,
	Vr3: Feedback output state
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ST1A <: AVR
    "Code input for Underexcitization limiter (UEL) entry. Not supported."
    UEL_inputs::Int64
    "Code input for Power System Stabilizer (PSS) or (VOS) entry."
    PSS_inputs::Int64
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
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ST1A(UEL_inputs, PSS_inputs, Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref=1.0, ext=Dict{String, Any}(), )
    ST1A(UEL_inputs, PSS_inputs, Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref, ext, [:Vm, :Vr1, :Vr2, :Va, :Vr3], 5, InfrastructureSystemsInternal(), )
end

function ST1A(; UEL_inputs, PSS_inputs, Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref=1.0, ext=Dict{String, Any}(), )
    ST1A(UEL_inputs, PSS_inputs, Tr, Vi_lim, Tc, Tb, Tc1, Tb1, Ka, Ta, Va_lim, Vr_lim, Kc, Kf, Tf, K_lr, I_lr, V_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function ST1A(::Nothing)
    ST1A(;
        UEL_inputs=1,
        PSS_inputs=1,
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

"""Get ST1A UEL_inputs."""
get_UEL_inputs(value::ST1A) = value.UEL_inputs
"""Get ST1A PSS_inputs."""
get_PSS_inputs(value::ST1A) = value.PSS_inputs
"""Get ST1A Tr."""
get_Tr(value::ST1A) = value.Tr
"""Get ST1A Vi_lim."""
get_Vi_lim(value::ST1A) = value.Vi_lim
"""Get ST1A Tc."""
get_Tc(value::ST1A) = value.Tc
"""Get ST1A Tb."""
get_Tb(value::ST1A) = value.Tb
"""Get ST1A Tc1."""
get_Tc1(value::ST1A) = value.Tc1
"""Get ST1A Tb1."""
get_Tb1(value::ST1A) = value.Tb1
"""Get ST1A Ka."""
get_Ka(value::ST1A) = value.Ka
"""Get ST1A Ta."""
get_Ta(value::ST1A) = value.Ta
"""Get ST1A Va_lim."""
get_Va_lim(value::ST1A) = value.Va_lim
"""Get ST1A Vr_lim."""
get_Vr_lim(value::ST1A) = value.Vr_lim
"""Get ST1A Kc."""
get_Kc(value::ST1A) = value.Kc
"""Get ST1A Kf."""
get_Kf(value::ST1A) = value.Kf
"""Get ST1A Tf."""
get_Tf(value::ST1A) = value.Tf
"""Get ST1A K_lr."""
get_K_lr(value::ST1A) = value.K_lr
"""Get ST1A I_lr."""
get_I_lr(value::ST1A) = value.I_lr
"""Get ST1A V_ref."""
get_V_ref(value::ST1A) = value.V_ref
"""Get ST1A ext."""
get_ext(value::ST1A) = value.ext
"""Get ST1A states."""
get_states(value::ST1A) = value.states
"""Get ST1A n_states."""
get_n_states(value::ST1A) = value.n_states
"""Get ST1A internal."""
get_internal(value::ST1A) = value.internal

"""Set ST1A UEL_inputs."""
set_UEL_inputs!(value::ST1A, val::Int64) = value.UEL_inputs = val
"""Set ST1A PSS_inputs."""
set_PSS_inputs!(value::ST1A, val::Int64) = value.PSS_inputs = val
"""Set ST1A Tr."""
set_Tr!(value::ST1A, val::Float64) = value.Tr = val
"""Set ST1A Vi_lim."""
set_Vi_lim!(value::ST1A, val::Tuple{Float64, Float64}) = value.Vi_lim = val
"""Set ST1A Tc."""
set_Tc!(value::ST1A, val::Float64) = value.Tc = val
"""Set ST1A Tb."""
set_Tb!(value::ST1A, val::Float64) = value.Tb = val
"""Set ST1A Tc1."""
set_Tc1!(value::ST1A, val::Float64) = value.Tc1 = val
"""Set ST1A Tb1."""
set_Tb1!(value::ST1A, val::Float64) = value.Tb1 = val
"""Set ST1A Ka."""
set_Ka!(value::ST1A, val::Float64) = value.Ka = val
"""Set ST1A Ta."""
set_Ta!(value::ST1A, val::Float64) = value.Ta = val
"""Set ST1A Va_lim."""
set_Va_lim!(value::ST1A, val::Tuple{Float64, Float64}) = value.Va_lim = val
"""Set ST1A Vr_lim."""
set_Vr_lim!(value::ST1A, val::Tuple{Float64, Float64}) = value.Vr_lim = val
"""Set ST1A Kc."""
set_Kc!(value::ST1A, val::Float64) = value.Kc = val
"""Set ST1A Kf."""
set_Kf!(value::ST1A, val::Float64) = value.Kf = val
"""Set ST1A Tf."""
set_Tf!(value::ST1A, val::Float64) = value.Tf = val
"""Set ST1A K_lr."""
set_K_lr!(value::ST1A, val::Float64) = value.K_lr = val
"""Set ST1A I_lr."""
set_I_lr!(value::ST1A, val::Float64) = value.I_lr = val
"""Set ST1A V_ref."""
set_V_ref!(value::ST1A, val::Float64) = value.V_ref = val
"""Set ST1A ext."""
set_ext!(value::ST1A, val::Dict{String, Any}) = value.ext = val
"""Set ST1A states."""
set_states!(value::ST1A, val::Vector{Symbol}) = value.states = val
"""Set ST1A n_states."""
set_n_states!(value::ST1A, val::Int64) = value.n_states = val
"""Set ST1A internal."""
set_internal!(value::ST1A, val::InfrastructureSystemsInternal) = value.internal = val
