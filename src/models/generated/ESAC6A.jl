#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ESAC6A <: AVR
        Tr::Float64
        Ka::Float64
        Ta::Float64
        Tk::Float64
        Tb::Float64
        Tc::Float64
        Va_lim::Tuple{Float64, Float64}
        Vr_lim::Tuple{Float64, Float64}
        Te::Float64
        VFE_lim::Float64
        Kh::Float64
        VH_max::Float64
        Th::Float64
        Tj::Float64
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

Modified AC6A. Used to represent field-controlled alternator-rectifier excitation systems with system-supplied electronic voltage regulators. 
Parameters of IEEE Std 421.5 Type AC6A Excitacion System. ESAC6A in PSSE and PSLF.

# Arguments
- `Tr::Float64`: Regulator input filter time constant in s, validation range: (0, nothing)
- `Ka::Float64`: Regulator output gain, validation range: (0, nothing)
- `Ta::Float64`: Regulator output lag time constant in s, validation range: (0, nothing)
- `Tk::Float64`: Voltage Regulator lead time xonstant, validation range: (0, nothing)
- `Tb::Float64`: Regulator denominator (lag) time constant in s, validation range: (0, nothing)
- `Tc::Float64`: Regulator numerator (lead) time constant in s, validation range: (0, nothing)
- `Va_lim::Tuple{Float64, Float64}`: Limits for regulator output (Va_min, Va_max)
- `Vr_lim::Tuple{Float64, Float64}`: Limits for exciter field voltage (Vr_min, Vr_max)
- `Te::Float64`: Exciter field time constant, validation range: (&quot;eps()&quot;, nothing)
- `VFE_lim::Float64`: Exciter field current limiter reference, validation range: (0, nothing)
- `Kh::Float64`: Exciter field current regulator feedback gain, validation range: (0, nothing)
- `VH_max::Float64`: Exciter field current limiter maximum output, validation range: (0, nothing)
- `Th::Float64`: Exciter field current limiter denominator (lag) time constant, validation range: (0.0, nothing)
- `Tj::Float64`: Exciter field current limiter numerator (lead) time constant, validation range: (0.0, nothing)
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
- `states_types::Vector{StateTypes.StateType}`: ESAC6A has 5 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ESAC6A <: AVR
    "Regulator input filter time constant in s"
    Tr::Float64
    "Regulator output gain"
    Ka::Float64
    "Regulator output lag time constant in s"
    Ta::Float64
    "Voltage Regulator lead time xonstant"
    Tk::Float64
    "Regulator denominator (lag) time constant in s"
    Tb::Float64
    "Regulator numerator (lead) time constant in s"
    Tc::Float64
    "Limits for regulator output (Va_min, Va_max)"
    Va_lim::Tuple{Float64, Float64}
    "Limits for exciter field voltage (Vr_min, Vr_max)"
    Vr_lim::Tuple{Float64, Float64}
    "Exciter field time constant"
    Te::Float64
    "Exciter field current limiter reference"
    VFE_lim::Float64
    "Exciter field current regulator feedback gain"
    Kh::Float64
    "Exciter field current limiter maximum output"
    VH_max::Float64
    "Exciter field current limiter denominator (lag) time constant"
    Th::Float64
    "Exciter field current limiter numerator (lead) time constant"
    Tj::Float64
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
    "ESAC6A has 5 states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ESAC6A(Tr, Ka, Ta, Tk, Tb, Tc, Va_lim, Vr_lim, Te, VFE_lim, Kh, VH_max, Th, Tj, Kc, Kd, Ke, E_sat, Se, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    ESAC6A(Tr, Ka, Ta, Tk, Tb, Tc, Va_lim, Vr_lim, Te, VFE_lim, Kh, VH_max, Th, Tj, Kc, Kd, Ke, E_sat, Se, V_ref, saturation_coeffs, ext, [:Vm, :Vr1, :Vr2, :Ve, :Vr3], 5, [StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Differential, StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function ESAC6A(; Tr, Ka, Ta, Tk, Tb, Tc, Va_lim, Vr_lim, Te, VFE_lim, Kh, VH_max, Th, Tj, Kc, Kd, Ke, E_sat, Se, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    ESAC6A(Tr, Ka, Ta, Tk, Tb, Tc, Va_lim, Vr_lim, Te, VFE_lim, Kh, VH_max, Th, Tj, Kc, Kd, Ke, E_sat, Se, V_ref, saturation_coeffs, ext, )
end

# Constructor for demo purposes; non-functional.
function ESAC6A(::Nothing)
    ESAC6A(;
        Tr=0,
        Ka=0,
        Ta=0,
        Tk=0,
        Tb=0,
        Tc=0,
        Va_lim=(0.0, 0.0),
        Vr_lim=(0.0, 0.0),
        Te=0,
        VFE_lim=0,
        Kh=0,
        VH_max=0,
        Th=0,
        Tj=0,
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

"""Get ESAC6A Tr."""
get_Tr(value::ESAC6A) = value.Tr
"""Get ESAC6A Ka."""
get_Ka(value::ESAC6A) = value.Ka
"""Get ESAC6A Ta."""
get_Ta(value::ESAC6A) = value.Ta
"""Get ESAC6A Tk."""
get_Tk(value::ESAC6A) = value.Tk
"""Get ESAC6A Tb."""
get_Tb(value::ESAC6A) = value.Tb
"""Get ESAC6A Tc."""
get_Tc(value::ESAC6A) = value.Tc
"""Get ESAC6A Va_lim."""
get_Va_lim(value::ESAC6A) = value.Va_lim
"""Get ESAC6A Vr_lim."""
get_Vr_lim(value::ESAC6A) = value.Vr_lim
"""Get ESAC6A Te."""
get_Te(value::ESAC6A) = value.Te
"""Get ESAC6A VFE_lim."""
get_VFE_lim(value::ESAC6A) = value.VFE_lim
"""Get ESAC6A Kh."""
get_Kh(value::ESAC6A) = value.Kh
"""Get ESAC6A VH_max."""
get_VH_max(value::ESAC6A) = value.VH_max
"""Get ESAC6A Th."""
get_Th(value::ESAC6A) = value.Th
"""Get ESAC6A Tj."""
get_Tj(value::ESAC6A) = value.Tj
"""Get ESAC6A Kc."""
get_Kc(value::ESAC6A) = value.Kc
"""Get ESAC6A Kd."""
get_Kd(value::ESAC6A) = value.Kd
"""Get ESAC6A Ke."""
get_Ke(value::ESAC6A) = value.Ke
"""Get ESAC6A E_sat."""
get_E_sat(value::ESAC6A) = value.E_sat
"""Get ESAC6A Se."""
get_Se(value::ESAC6A) = value.Se
"""Get ESAC6A V_ref."""
get_V_ref(value::ESAC6A) = value.V_ref
"""Get ESAC6A saturation_coeffs."""
get_saturation_coeffs(value::ESAC6A) = value.saturation_coeffs
"""Get ESAC6A ext."""
get_ext(value::ESAC6A) = value.ext
"""Get ESAC6A states."""
get_states(value::ESAC6A) = value.states
"""Get ESAC6A n_states."""
get_n_states(value::ESAC6A) = value.n_states
"""Get ESAC6A states_types."""
get_states_types(value::ESAC6A) = value.states_types
"""Get ESAC6A internal."""
get_internal(value::ESAC6A) = value.internal

"""Set ESAC6A Tr."""
set_Tr!(value::ESAC6A, val::Float64) = value.Tr = val
"""Set ESAC6A Ka."""
set_Ka!(value::ESAC6A, val::Float64) = value.Ka = val
"""Set ESAC6A Ta."""
set_Ta!(value::ESAC6A, val::Float64) = value.Ta = val
"""Set ESAC6A Tk."""
set_Tk!(value::ESAC6A, val::Float64) = value.Tk = val
"""Set ESAC6A Tb."""
set_Tb!(value::ESAC6A, val::Float64) = value.Tb = val
"""Set ESAC6A Tc."""
set_Tc!(value::ESAC6A, val::Float64) = value.Tc = val
"""Set ESAC6A Va_lim."""
set_Va_lim!(value::ESAC6A, val::Tuple{Float64, Float64}) = value.Va_lim = val
"""Set ESAC6A Vr_lim."""
set_Vr_lim!(value::ESAC6A, val::Tuple{Float64, Float64}) = value.Vr_lim = val
"""Set ESAC6A Te."""
set_Te!(value::ESAC6A, val::Float64) = value.Te = val
"""Set ESAC6A VFE_lim."""
set_VFE_lim!(value::ESAC6A, val::Float64) = value.VFE_lim = val
"""Set ESAC6A Kh."""
set_Kh!(value::ESAC6A, val::Float64) = value.Kh = val
"""Set ESAC6A VH_max."""
set_VH_max!(value::ESAC6A, val::Float64) = value.VH_max = val
"""Set ESAC6A Th."""
set_Th!(value::ESAC6A, val::Float64) = value.Th = val
"""Set ESAC6A Tj."""
set_Tj!(value::ESAC6A, val::Float64) = value.Tj = val
"""Set ESAC6A Kc."""
set_Kc!(value::ESAC6A, val::Float64) = value.Kc = val
"""Set ESAC6A Kd."""
set_Kd!(value::ESAC6A, val::Float64) = value.Kd = val
"""Set ESAC6A Ke."""
set_Ke!(value::ESAC6A, val::Float64) = value.Ke = val
"""Set ESAC6A E_sat."""
set_E_sat!(value::ESAC6A, val::Tuple{Float64, Float64}) = value.E_sat = val
"""Set ESAC6A Se."""
set_Se!(value::ESAC6A, val::Tuple{Float64, Float64}) = value.Se = val
"""Set ESAC6A V_ref."""
set_V_ref!(value::ESAC6A, val::Float64) = value.V_ref = val
"""Set ESAC6A saturation_coeffs."""
set_saturation_coeffs!(value::ESAC6A, val::Tuple{Float64, Float64}) = value.saturation_coeffs = val
"""Set ESAC6A ext."""
set_ext!(value::ESAC6A, val::Dict{String, Any}) = value.ext = val
"""Set ESAC6A states."""
set_states!(value::ESAC6A, val::Vector{Symbol}) = value.states = val
"""Set ESAC6A n_states."""
set_n_states!(value::ESAC6A, val::Int) = value.n_states = val
"""Set ESAC6A states_types."""
set_states_types!(value::ESAC6A, val::Vector{StateTypes.StateType}) = value.states_types = val
"""Set ESAC6A internal."""
set_internal!(value::ESAC6A, val::InfrastructureSystemsInternal) = value.internal = val
