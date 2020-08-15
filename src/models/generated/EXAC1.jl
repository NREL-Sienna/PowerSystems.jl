#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct EXAC1 <: AVR
        Tr::Float64
        Tb::Float64
        Tc::Float64
        Ka::Float64
        Ta::Float64
        Vr_lim::Tuple{Float64, Float64}
        Te::Float64
        Kf::Float64
        Tf::Float64
        Kc::Float64
        Kd::Float64
        Ke::Float64
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

Modified ESAC1A. This excitation systems consists of an alternator main exciter feeding its output via non-controlled rectifiers.
The exciter does not employ self-excitation, and the voltage regulator power is taken from a source that is not affected by external transients.
Parameters of IEEE Std 421.5 Type AC1A.  EXAC1 in PSSE and PSLF

# Arguments
- `Tr::Float64`: Regulator input filter time constant in s, validation range: (0, nothing)
- `Tb::Float64`: Regulator denominator (lag) time constant in s, validation range: (0, nothing)
- `Tc::Float64`: Regulator numerator (lead) time constant in s, validation range: (0, nothing)
- `Ka::Float64`: Regulator output gain, validation range: (0, nothing)
- `Ta::Float64`: Regulator output time constant in s, validation range: (0, nothing)
- `Vr_lim::Tuple{Float64, Float64}`: Limits for regulator output (Vr_min, Vr_max)
- `Te::Float64`: Exciter field time constant in s, validation range: (&quot;eps()&quot;, nothing)
- `Kf::Float64`: Rate feedback excitation system stabilizer gain, validation range: (0, nothing)
- `Tf::Float64`: Rate feedback time constant, validation range: (&quot;eps()&quot;, nothing)
- `Kc::Float64`: Rectifier loading factor proportional to commutating reactance, validation range: (0, nothing)
- `Kd::Float64`: Demagnetizing factor, function of exciter alternator reactances, validation range: (0, nothing)
- `Ke::Float64`: Exciter field proportional constant, validation range: (0, nothing)
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
- `n_states::Int`
- `states_types::Vector{StateTypes.StateType}`: EXAC1 has 5 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct EXAC1 <: AVR
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
    "Limits for regulator output (Vr_min, Vr_max)"
    Vr_lim::Tuple{Float64, Float64}
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
    n_states::Int
    "EXAC1 has 5 states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function EXAC1(Tr, Tb, Tc, Ka, Ta, Vr_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    EXAC1(Tr, Tb, Tc, Ka, Ta, Vr_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, V_ref, saturation_coeffs, ext, [:Vm, :Vr1, :Vr2, :Ve, :Vr3], 5, [StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Differential, StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function EXAC1(; Tr, Tb, Tc, Ka, Ta, Vr_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    EXAC1(Tr, Tb, Tc, Ka, Ta, Vr_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, V_ref, saturation_coeffs, ext, )
end

# Constructor for demo purposes; non-functional.
function EXAC1(::Nothing)
    EXAC1(;
        Tr=0,
        Tb=0,
        Tc=0,
        Ka=0,
        Ta=0,
        Vr_lim=(0.0, 0.0),
        Te=0,
        Kf=0,
        Tf=0,
        Kc=0,
        Kd=0,
        Ke=0,
        E_sat=(0.0, 0.0),
        Se=(0.0, 0.0),
        V_ref=0,
        saturation_coeffs=(0.0, 0.0),
        ext=Dict{String, Any}(),
    )
end

"""Get EXAC1 Tr."""
get_Tr(value::EXAC1) = value.Tr
"""Get EXAC1 Tb."""
get_Tb(value::EXAC1) = value.Tb
"""Get EXAC1 Tc."""
get_Tc(value::EXAC1) = value.Tc
"""Get EXAC1 Ka."""
get_Ka(value::EXAC1) = value.Ka
"""Get EXAC1 Ta."""
get_Ta(value::EXAC1) = value.Ta
"""Get EXAC1 Vr_lim."""
get_Vr_lim(value::EXAC1) = value.Vr_lim
"""Get EXAC1 Te."""
get_Te(value::EXAC1) = value.Te
"""Get EXAC1 Kf."""
get_Kf(value::EXAC1) = value.Kf
"""Get EXAC1 Tf."""
get_Tf(value::EXAC1) = value.Tf
"""Get EXAC1 Kc."""
get_Kc(value::EXAC1) = value.Kc
"""Get EXAC1 Kd."""
get_Kd(value::EXAC1) = value.Kd
"""Get EXAC1 Ke."""
get_Ke(value::EXAC1) = value.Ke
"""Get EXAC1 E_sat."""
get_E_sat(value::EXAC1) = value.E_sat
"""Get EXAC1 Se."""
get_Se(value::EXAC1) = value.Se
"""Get EXAC1 V_ref."""
get_V_ref(value::EXAC1) = value.V_ref
"""Get EXAC1 saturation_coeffs."""
get_saturation_coeffs(value::EXAC1) = value.saturation_coeffs
"""Get EXAC1 ext."""
get_ext(value::EXAC1) = value.ext
"""Get EXAC1 states."""
get_states(value::EXAC1) = value.states
"""Get EXAC1 n_states."""
get_n_states(value::EXAC1) = value.n_states
"""Get EXAC1 states_types."""
get_states_types(value::EXAC1) = value.states_types
"""Get EXAC1 internal."""
get_internal(value::EXAC1) = value.internal

"""Set EXAC1 Tr."""
set_Tr!(value::EXAC1, val::Float64) = value.Tr = val
"""Set EXAC1 Tb."""
set_Tb!(value::EXAC1, val::Float64) = value.Tb = val
"""Set EXAC1 Tc."""
set_Tc!(value::EXAC1, val::Float64) = value.Tc = val
"""Set EXAC1 Ka."""
set_Ka!(value::EXAC1, val::Float64) = value.Ka = val
"""Set EXAC1 Ta."""
set_Ta!(value::EXAC1, val::Float64) = value.Ta = val
"""Set EXAC1 Vr_lim."""
set_Vr_lim!(value::EXAC1, val::Tuple{Float64, Float64}) = value.Vr_lim = val
"""Set EXAC1 Te."""
set_Te!(value::EXAC1, val::Float64) = value.Te = val
"""Set EXAC1 Kf."""
set_Kf!(value::EXAC1, val::Float64) = value.Kf = val
"""Set EXAC1 Tf."""
set_Tf!(value::EXAC1, val::Float64) = value.Tf = val
"""Set EXAC1 Kc."""
set_Kc!(value::EXAC1, val::Float64) = value.Kc = val
"""Set EXAC1 Kd."""
set_Kd!(value::EXAC1, val::Float64) = value.Kd = val
"""Set EXAC1 Ke."""
set_Ke!(value::EXAC1, val::Float64) = value.Ke = val
"""Set EXAC1 E_sat."""
set_E_sat!(value::EXAC1, val::Tuple{Float64, Float64}) = value.E_sat = val
"""Set EXAC1 Se."""
set_Se!(value::EXAC1, val::Tuple{Float64, Float64}) = value.Se = val
"""Set EXAC1 V_ref."""
set_V_ref!(value::EXAC1, val::Float64) = value.V_ref = val
"""Set EXAC1 saturation_coeffs."""
set_saturation_coeffs!(value::EXAC1, val::Tuple{Float64, Float64}) = value.saturation_coeffs = val
"""Set EXAC1 ext."""
set_ext!(value::EXAC1, val::Dict{String, Any}) = value.ext = val
"""Set EXAC1 states."""
set_states!(value::EXAC1, val::Vector{Symbol}) = value.states = val
"""Set EXAC1 n_states."""
set_n_states!(value::EXAC1, val::Int) = value.n_states = val
"""Set EXAC1 states_types."""
set_states_types!(value::EXAC1, val::Vector{StateTypes.StateType}) = value.states_types = val
"""Set EXAC1 internal."""
set_internal!(value::EXAC1, val::InfrastructureSystemsInternal) = value.internal = val
