#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct EXAC1A <: AVR
        Tr::Float64
        Tb::Float64
        Tc::Float64
        Ka::Float64
        Ta::Float64
        Va_lim::Tuple{Float64, Float64}
        Te::Float64
        Kf::Float64
        Tf::Float64
        Kc::Float64
        Kd::Float64
        Ke::Float64
        E_sat::Tuple{Float64, Float64}
        Se::Tuple{Float64, Float64}
        Vr_lim::Tuple{Float64, Float64}
        V_ref::Float64
        saturation_coeffs::Tuple{Float64, Float64}
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        states_types::Vector{StateTypes.StateType}
        internal::InfrastructureSystemsInternal
    end

Modified ESAC1A. This excitation systems consists of an alternator main exciter feeding its output via non-controlled rectifiers.
The exciter does not employ self-excitation, and the voltage regulator power is taken from a source that is not affected by external transients.
Parameters of IEEE Std 421.5 Type AC1A Excitacion System. EXAC1A in PSSE and PSLF

# Arguments
- `Tr::Float64`: Regulator input filter time constant in s, validation range: (0, nothing)
- `Tb::Float64`: Regulator denominator (lag) time constant in s, validation range: (0, nothing)
- `Tc::Float64`: Regulator numerator (lead) time constant in s, validation range: (0, nothing)
- `Ka::Float64`: Regulator output gain, validation range: (0, nothing)
- `Ta::Float64`: Regulator output time constant in s, validation range: (0, nothing)
- `Va_lim::Tuple{Float64, Float64}`: Limits for regulator output (Va_min, Va_max)
- `Te::Float64`: Exciter field time constant in s, validation range: (&quot;eps()&quot;, nothing)
- `Kf::Float64`: Rate feedback excitation system stabilizer gain, validation range: (0, nothing)
- `Tf::Float64`: Rate feedback time constant, validation range: (&quot;eps()&quot;, nothing)
- `Kc::Float64`: Rectifier loading factor proportional to commutating reactance, validation range: (0, nothing)
- `Kd::Float64`: Demagnetizing factor, function of exciter alternator reactances, validation range: (0, nothing)
- `Ke::Float64`: Exciter field proportional constant, validation range: (0, nothing)
- `E_sat::Tuple{Float64, Float64}`: Exciter output voltage for saturation factor: (E1, E2)
- `Se::Tuple{Float64, Float64}`: Exciter saturation factor at exciter output voltage: (Se(E1), Se(E2))
- `Vr_lim::Tuple{Float64, Float64}`: Limits for exciter field voltage: (Vr_min, Vr_max)
- `V_ref::Float64`: Reference Voltage Set-point, validation range: (0, nothing)
- `saturation_coeffs::Tuple{Float64, Float64}`: Coefficients (A,B) of the function: Se(x) = B(x - A)^2/x
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	Vm: Sensed terminal voltage,
	Vr1: Lead-lag state,
	Vr2: Regulator output state,
	Ve: Integrator output state,
	Vr3: Feedback output state
- `n_states::Int`: EXAC1 has 5 states
- `states_types::Vector{StateTypes.StateType}`: EXAC1 has 5 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct EXAC1A <: AVR
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
    "Exciter field time constant in s"
    Te::Float64
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
    "Exciter output voltage for saturation factor: (E1, E2)"
    E_sat::Tuple{Float64, Float64}
    "Exciter saturation factor at exciter output voltage: (Se(E1), Se(E2))"
    Se::Tuple{Float64, Float64}
    "Limits for exciter field voltage: (Vr_min, Vr_max)"
    Vr_lim::Tuple{Float64, Float64}
    "Reference Voltage Set-point"
    V_ref::Float64
    "Coefficients (A,B) of the function: Se(x) = B(x - A)^2/x"
    saturation_coeffs::Tuple{Float64, Float64}
    ext::Dict{String, Any}
    "The states are:
	Vm: Sensed terminal voltage,
	Vr1: Lead-lag state,
	Vr2: Regulator output state,
	Ve: Integrator output state,
	Vr3: Feedback output state"
    states::Vector{Symbol}
    "EXAC1 has 5 states"
    n_states::Int
    "EXAC1 has 5 states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function EXAC1A(Tr, Tb, Tc, Ka, Ta, Va_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, Vr_lim, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    EXAC1A(Tr, Tb, Tc, Ka, Ta, Va_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, Vr_lim, V_ref, saturation_coeffs, ext, [:Vm, :Vr1, :Vr2, :Ve, :Vr3], 5, [StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Differential, StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function EXAC1A(; Tr, Tb, Tc, Ka, Ta, Va_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, Vr_lim, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    EXAC1A(Tr, Tb, Tc, Ka, Ta, Va_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, Vr_lim, V_ref, saturation_coeffs, ext, )
end

# Constructor for demo purposes; non-functional.
function EXAC1A(::Nothing)
    EXAC1A(;
        Tr=0,
        Tb=0,
        Tc=0,
        Ka=0,
        Ta=0,
        Va_lim=(0.0, 0.0),
        Te=0,
        Kf=0,
        Tf=0,
        Kc=0,
        Kd=0,
        Ke=0,
        E_sat=(0.0, 0.0),
        Se=(0.0, 0.0),
        Vr_lim=(0.0, 0.0),
        V_ref=0,
        saturation_coeffs=(0.0, 0.0),
        ext=Dict{String, Any}(),
    )
end

"""Get EXAC1A Tr."""
get_Tr(value::EXAC1A) = value.Tr
"""Get EXAC1A Tb."""
get_Tb(value::EXAC1A) = value.Tb
"""Get EXAC1A Tc."""
get_Tc(value::EXAC1A) = value.Tc
"""Get EXAC1A Ka."""
get_Ka(value::EXAC1A) = value.Ka
"""Get EXAC1A Ta."""
get_Ta(value::EXAC1A) = value.Ta
"""Get EXAC1A Va_lim."""
get_Va_lim(value::EXAC1A) = value.Va_lim
"""Get EXAC1A Te."""
get_Te(value::EXAC1A) = value.Te
"""Get EXAC1A Kf."""
get_Kf(value::EXAC1A) = value.Kf
"""Get EXAC1A Tf."""
get_Tf(value::EXAC1A) = value.Tf
"""Get EXAC1A Kc."""
get_Kc(value::EXAC1A) = value.Kc
"""Get EXAC1A Kd."""
get_Kd(value::EXAC1A) = value.Kd
"""Get EXAC1A Ke."""
get_Ke(value::EXAC1A) = value.Ke
"""Get EXAC1A E_sat."""
get_E_sat(value::EXAC1A) = value.E_sat
"""Get EXAC1A Se."""
get_Se(value::EXAC1A) = value.Se
"""Get EXAC1A Vr_lim."""
get_Vr_lim(value::EXAC1A) = value.Vr_lim
"""Get EXAC1A V_ref."""
get_V_ref(value::EXAC1A) = value.V_ref
"""Get EXAC1A saturation_coeffs."""
get_saturation_coeffs(value::EXAC1A) = value.saturation_coeffs
"""Get EXAC1A ext."""
get_ext(value::EXAC1A) = value.ext
"""Get EXAC1A states."""
get_states(value::EXAC1A) = value.states
"""Get EXAC1A n_states."""
get_n_states(value::EXAC1A) = value.n_states
"""Get EXAC1A states_types."""
get_states_types(value::EXAC1A) = value.states_types
"""Get EXAC1A internal."""
get_internal(value::EXAC1A) = value.internal

"""Set EXAC1A Tr."""
set_Tr!(value::EXAC1A, val::Float64) = value.Tr = val
"""Set EXAC1A Tb."""
set_Tb!(value::EXAC1A, val::Float64) = value.Tb = val
"""Set EXAC1A Tc."""
set_Tc!(value::EXAC1A, val::Float64) = value.Tc = val
"""Set EXAC1A Ka."""
set_Ka!(value::EXAC1A, val::Float64) = value.Ka = val
"""Set EXAC1A Ta."""
set_Ta!(value::EXAC1A, val::Float64) = value.Ta = val
"""Set EXAC1A Va_lim."""
set_Va_lim!(value::EXAC1A, val::Tuple{Float64, Float64}) = value.Va_lim = val
"""Set EXAC1A Te."""
set_Te!(value::EXAC1A, val::Float64) = value.Te = val
"""Set EXAC1A Kf."""
set_Kf!(value::EXAC1A, val::Float64) = value.Kf = val
"""Set EXAC1A Tf."""
set_Tf!(value::EXAC1A, val::Float64) = value.Tf = val
"""Set EXAC1A Kc."""
set_Kc!(value::EXAC1A, val::Float64) = value.Kc = val
"""Set EXAC1A Kd."""
set_Kd!(value::EXAC1A, val::Float64) = value.Kd = val
"""Set EXAC1A Ke."""
set_Ke!(value::EXAC1A, val::Float64) = value.Ke = val
"""Set EXAC1A E_sat."""
set_E_sat!(value::EXAC1A, val::Tuple{Float64, Float64}) = value.E_sat = val
"""Set EXAC1A Se."""
set_Se!(value::EXAC1A, val::Tuple{Float64, Float64}) = value.Se = val
"""Set EXAC1A Vr_lim."""
set_Vr_lim!(value::EXAC1A, val::Tuple{Float64, Float64}) = value.Vr_lim = val
"""Set EXAC1A V_ref."""
set_V_ref!(value::EXAC1A, val::Float64) = value.V_ref = val
"""Set EXAC1A saturation_coeffs."""
set_saturation_coeffs!(value::EXAC1A, val::Tuple{Float64, Float64}) = value.saturation_coeffs = val
"""Set EXAC1A ext."""
set_ext!(value::EXAC1A, val::Dict{String, Any}) = value.ext = val
"""Set EXAC1A states."""
set_states!(value::EXAC1A, val::Vector{Symbol}) = value.states = val
"""Set EXAC1A n_states."""
set_n_states!(value::EXAC1A, val::Int) = value.n_states = val
"""Set EXAC1A states_types."""
set_states_types!(value::EXAC1A, val::Vector{StateTypes.StateType}) = value.states_types = val
"""Set EXAC1A internal."""
set_internal!(value::EXAC1A, val::InfrastructureSystemsInternal) = value.internal = val
