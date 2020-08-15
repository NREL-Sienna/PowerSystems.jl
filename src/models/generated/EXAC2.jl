#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct EXAC2 <: AVR
        Tr::Float64
        Tb::Float64
        Tc::Float64
        Ka::Float64
        Ta::Float64
        Va_lim::Tuple{Float64, Float64}
        Kb::Float64
        Vr_lim::Tuple{Float64, Float64}
        Te::Float64
        Kl::Float64
        Kh::Float64
        Kf::Float64
        Tf::Float64
        Kc::Float64
        Kd::Float64
        Ke::Float64
        V_lr::Float64
        E_sat::Tuple{Float64, Float64}
        Se::Tuple{Float64, Float64}
        V_ref::Float64
        saturation_coeffs::Tuple{Float64, Float64}
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        states_types::Vector{StateTypes.StateType}
        internal::InfrastructureSystemsInternal
    end

Modified AC2. This excitation systems consists of an alternator main exciter feeding its output via non-controlled rectifiers.
The exciter does not employ self-excitation, and the voltage regulator power is taken from a source that is not affected by external transients.
Parameters of IEEE Std 421.5 Type AC2A Excitacion System. The alternator main exciter is used, feeding its output via non-controlled rectifiers. The Type AC2C model is similar to that of Type AC1C except for the inclusion of exciter time constant compensation and exciter field current limiting elements. EXAC2 in PSSE and PSLF.

# Arguments
- `Tr::Float64`: Regulator input filter time constant in s, validation range: (0, nothing)
- `Tb::Float64`: Regulator denominator (lag) time constant in s, validation range: (0, nothing)
- `Tc::Float64`: Regulator numerator (lead) time constant in s, validation range: (0, nothing)
- `Ka::Float64`: Regulator output gain, validation range: (0, nothing)
- `Ta::Float64`: Regulator output time constant in s, validation range: (0, nothing)
- `Va_lim::Tuple{Float64, Float64}`: Limits for regulator output (Va_min, Va_max)
- `Kb::Float64`: Second Stage regulator gain, validation range: (&quot;eps()&quot;, nothing)
- `Vr_lim::Tuple{Float64, Float64}`: Limits for exciter field voltage (Vr_min, Vr_max)
- `Te::Float64`: Exciter field time constant, validation range: (&quot;eps()&quot;, nothing)
- `Kl::Float64`: Exciter field current limiter gain, validation range: (0, nothing)
- `Kh::Float64`: Exciter field current regulator feedback gain, validation range: (0, nothing)
- `Kf::Float64`: Rate feedback excitation system stabilizer gain, validation range: (0, nothing)
- `Tf::Float64`: Rate feedback time constant, validation range: (&quot;eps()&quot;, nothing)
- `Kc::Float64`: Rectifier loading factor proportional to commutating reactance, validation range: (0, nothing)
- `Kd::Float64`: Demagnetizing factor, function of exciter alternator reactances, validation range: (0, nothing)
- `Ke::Float64`: Exciter field proportional constant, validation range: (0, nothing)
- `V_lr::Float64`: Maximum exciter field current, validation range: (0, nothing)
- `E_sat::Tuple{Float64, Float64}`: Exciter output voltage for saturation factor: (E1, E2)
- `Se::Tuple{Float64, Float64}`: Exciter saturation factor at exciter output voltage: (Se(E1), Se(E2))
- `V_ref::Float64`: Reference Voltage Set-point, validation range: (0, nothing)
- `saturation_coeffs::Tuple{Float64, Float64}`: Coefficients (A,B) of the function: Se(V) = B(V - A)^2/V
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	Vm: Sensed terminal voltage,
	Vr1: Lead-lag state,
	Vr2: Regulator output state,
	Ve: Integrator output state,
	Vr3: Feedback output state
- `n_states::Int`: EXAC2 has 5 states
- `states_types::Vector{StateTypes.StateType}`: EXAC2 has 5 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct EXAC2 <: AVR
    "Regulator input filter time constant in s"
    Tr::Float64
    "Regulator denominator (lag) time constant in s"
    Tb::Float64
    "Regulator numerator (lead) time constant in s"
    Tc::Float64
    "Regulator output gain"
    Ka::Float64
    "Regulator output time constant in s"
    Ta::Float64
    "Limits for regulator output (Va_min, Va_max)"
    Va_lim::Tuple{Float64, Float64}
    "Second Stage regulator gain"
    Kb::Float64
    "Limits for exciter field voltage (Vr_min, Vr_max)"
    Vr_lim::Tuple{Float64, Float64}
    "Exciter field time constant"
    Te::Float64
    "Exciter field current limiter gain"
    Kl::Float64
    "Exciter field current regulator feedback gain"
    Kh::Float64
    "Rate feedback excitation system stabilizer gain"
    Kf::Float64
    "Rate feedback time constant"
    Tf::Float64
    "Rectifier loading factor proportional to commutating reactance"
    Kc::Float64
    "Demagnetizing factor, function of exciter alternator reactances"
    Kd::Float64
    "Exciter field proportional constant"
    Ke::Float64
    "Maximum exciter field current"
    V_lr::Float64
    "Exciter output voltage for saturation factor: (E1, E2)"
    E_sat::Tuple{Float64, Float64}
    "Exciter saturation factor at exciter output voltage: (Se(E1), Se(E2))"
    Se::Tuple{Float64, Float64}
    "Reference Voltage Set-point"
    V_ref::Float64
    "Coefficients (A,B) of the function: Se(V) = B(V - A)^2/V"
    saturation_coeffs::Tuple{Float64, Float64}
    ext::Dict{String, Any}
    "The states are:
	Vm: Sensed terminal voltage,
	Vr1: Lead-lag state,
	Vr2: Regulator output state,
	Ve: Integrator output state,
	Vr3: Feedback output state"
    states::Vector{Symbol}
    "EXAC2 has 5 states"
    n_states::Int
    "EXAC2 has 5 states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function EXAC2(Tr, Tb, Tc, Ka, Ta, Va_lim, Kb, Vr_lim, Te, Kl, Kh, Kf, Tf, Kc, Kd, Ke, V_lr, E_sat, Se, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    EXAC2(Tr, Tb, Tc, Ka, Ta, Va_lim, Kb, Vr_lim, Te, Kl, Kh, Kf, Tf, Kc, Kd, Ke, V_lr, E_sat, Se, V_ref, saturation_coeffs, ext, [:Vm, :Vr1, :Vr2, :Ve, :Vr3], 5, [StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Differential, StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function EXAC2(; Tr, Tb, Tc, Ka, Ta, Va_lim, Kb, Vr_lim, Te, Kl, Kh, Kf, Tf, Kc, Kd, Ke, V_lr, E_sat, Se, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    EXAC2(Tr, Tb, Tc, Ka, Ta, Va_lim, Kb, Vr_lim, Te, Kl, Kh, Kf, Tf, Kc, Kd, Ke, V_lr, E_sat, Se, V_ref, saturation_coeffs, ext, )
end

# Constructor for demo purposes; non-functional.
function EXAC2(::Nothing)
    EXAC2(;
        Tr=0,
        Tb=0,
        Tc=0,
        Ka=0,
        Ta=0,
        Va_lim=(0.0, 0.0),
        Kb=0,
        Vr_lim=(0.0, 0.0),
        Te=0,
        Kl=0,
        Kh=0,
        Kf=0,
        Tf=0,
        Kc=0,
        Kd=0,
        Ke=0,
        V_lr=0,
        E_sat=(0.0, 0.0),
        Se=(0.0, 0.0),
        V_ref=0,
        saturation_coeffs=(0.0, 0.0),
        ext=Dict{String, Any}(),
    )
end

"""Get EXAC2 Tr."""
get_Tr(value::EXAC2) = value.Tr
"""Get EXAC2 Tb."""
get_Tb(value::EXAC2) = value.Tb
"""Get EXAC2 Tc."""
get_Tc(value::EXAC2) = value.Tc
"""Get EXAC2 Ka."""
get_Ka(value::EXAC2) = value.Ka
"""Get EXAC2 Ta."""
get_Ta(value::EXAC2) = value.Ta
"""Get EXAC2 Va_lim."""
get_Va_lim(value::EXAC2) = value.Va_lim
"""Get EXAC2 Kb."""
get_Kb(value::EXAC2) = value.Kb
"""Get EXAC2 Vr_lim."""
get_Vr_lim(value::EXAC2) = value.Vr_lim
"""Get EXAC2 Te."""
get_Te(value::EXAC2) = value.Te
"""Get EXAC2 Kl."""
get_Kl(value::EXAC2) = value.Kl
"""Get EXAC2 Kh."""
get_Kh(value::EXAC2) = value.Kh
"""Get EXAC2 Kf."""
get_Kf(value::EXAC2) = value.Kf
"""Get EXAC2 Tf."""
get_Tf(value::EXAC2) = value.Tf
"""Get EXAC2 Kc."""
get_Kc(value::EXAC2) = value.Kc
"""Get EXAC2 Kd."""
get_Kd(value::EXAC2) = value.Kd
"""Get EXAC2 Ke."""
get_Ke(value::EXAC2) = value.Ke
"""Get EXAC2 V_lr."""
get_V_lr(value::EXAC2) = value.V_lr
"""Get EXAC2 E_sat."""
get_E_sat(value::EXAC2) = value.E_sat
"""Get EXAC2 Se."""
get_Se(value::EXAC2) = value.Se
"""Get EXAC2 V_ref."""
get_V_ref(value::EXAC2) = value.V_ref
"""Get EXAC2 saturation_coeffs."""
get_saturation_coeffs(value::EXAC2) = value.saturation_coeffs
"""Get EXAC2 ext."""
get_ext(value::EXAC2) = value.ext
"""Get EXAC2 states."""
get_states(value::EXAC2) = value.states
"""Get EXAC2 n_states."""
get_n_states(value::EXAC2) = value.n_states
"""Get EXAC2 states_types."""
get_states_types(value::EXAC2) = value.states_types
"""Get EXAC2 internal."""
get_internal(value::EXAC2) = value.internal

"""Set EXAC2 Tr."""
set_Tr!(value::EXAC2, val::Float64) = value.Tr = val
"""Set EXAC2 Tb."""
set_Tb!(value::EXAC2, val::Float64) = value.Tb = val
"""Set EXAC2 Tc."""
set_Tc!(value::EXAC2, val::Float64) = value.Tc = val
"""Set EXAC2 Ka."""
set_Ka!(value::EXAC2, val::Float64) = value.Ka = val
"""Set EXAC2 Ta."""
set_Ta!(value::EXAC2, val::Float64) = value.Ta = val
"""Set EXAC2 Va_lim."""
set_Va_lim!(value::EXAC2, val::Tuple{Float64, Float64}) = value.Va_lim = val
"""Set EXAC2 Kb."""
set_Kb!(value::EXAC2, val::Float64) = value.Kb = val
"""Set EXAC2 Vr_lim."""
set_Vr_lim!(value::EXAC2, val::Tuple{Float64, Float64}) = value.Vr_lim = val
"""Set EXAC2 Te."""
set_Te!(value::EXAC2, val::Float64) = value.Te = val
"""Set EXAC2 Kl."""
set_Kl!(value::EXAC2, val::Float64) = value.Kl = val
"""Set EXAC2 Kh."""
set_Kh!(value::EXAC2, val::Float64) = value.Kh = val
"""Set EXAC2 Kf."""
set_Kf!(value::EXAC2, val::Float64) = value.Kf = val
"""Set EXAC2 Tf."""
set_Tf!(value::EXAC2, val::Float64) = value.Tf = val
"""Set EXAC2 Kc."""
set_Kc!(value::EXAC2, val::Float64) = value.Kc = val
"""Set EXAC2 Kd."""
set_Kd!(value::EXAC2, val::Float64) = value.Kd = val
"""Set EXAC2 Ke."""
set_Ke!(value::EXAC2, val::Float64) = value.Ke = val
"""Set EXAC2 V_lr."""
set_V_lr!(value::EXAC2, val::Float64) = value.V_lr = val
"""Set EXAC2 E_sat."""
set_E_sat!(value::EXAC2, val::Tuple{Float64, Float64}) = value.E_sat = val
"""Set EXAC2 Se."""
set_Se!(value::EXAC2, val::Tuple{Float64, Float64}) = value.Se = val
"""Set EXAC2 V_ref."""
set_V_ref!(value::EXAC2, val::Float64) = value.V_ref = val
"""Set EXAC2 saturation_coeffs."""
set_saturation_coeffs!(value::EXAC2, val::Tuple{Float64, Float64}) = value.saturation_coeffs = val
"""Set EXAC2 ext."""
set_ext!(value::EXAC2, val::Dict{String, Any}) = value.ext = val
"""Set EXAC2 states."""
set_states!(value::EXAC2, val::Vector{Symbol}) = value.states = val
"""Set EXAC2 n_states."""
set_n_states!(value::EXAC2, val::Int) = value.n_states = val
"""Set EXAC2 states_types."""
set_states_types!(value::EXAC2, val::Vector{StateTypes.StateType}) = value.states_types = val
"""Set EXAC2 internal."""
set_internal!(value::EXAC2, val::InfrastructureSystemsInternal) = value.internal = val
