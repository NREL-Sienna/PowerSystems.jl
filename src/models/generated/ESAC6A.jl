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
        Va_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        Vr_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
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
- `Tr::Float64`: Regulator input filter time constant in s, validation range: `(0, 0.5)`, action if invalid: `warn`
- `Ka::Float64`: Regulator output gain, validation range: `(0, 1000)`, action if invalid: `warn`
- `Ta::Float64`: Regulator output lag time constant in s, validation range: `(0, 10)`, action if invalid: `warn`
- `Tk::Float64`: Voltage Regulator lead time constant, validation range: `(0, 10)`, action if invalid: `warn`
- `Tb::Float64`: Regulator denominator (lag) time constant in s, validation range: `(0, 20)`, action if invalid: `warn`
- `Tc::Float64`: Regulator numerator (lead) time constant in s, validation range: `(0, 20)`, action if invalid: `warn`
- `Va_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Limits for regulator output `(Va_min, Va_max)`
- `Vr_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Limits for exciter field voltage `(Vr_min, Vr_max)`
- `Te::Float64`: Exciter field time constant, validation range: `("eps()", 2.0)`, action if invalid: `error`
- `VFE_lim::Float64`: Exciter field current limiter reference, validation range: `(-5, 20)`, action if invalid: `warn`
- `Kh::Float64`: Exciter field current regulator feedback gain, validation range: `(0, 100)`, action if invalid: `warn`
- `VH_max::Float64`: Exciter field current limiter maximum output, validation range: `(0, 100)`, action if invalid: `warn`
- `Th::Float64`: Exciter field current limiter denominator (lag) time constant, validation range: `(0, 1)`
- `Tj::Float64`: Exciter field current limiter numerator (lead) time constant, validation range: `(0, 1)`, action if invalid: `warn`
- `Kc::Float64`: Rectifier loading factor proportional to commutating reactance, validation range: `(0, 1)`
- `Kd::Float64`: Demagnetizing factor, function of exciter alternator reactances, validation range: `(0, 2)`, action if invalid: `warn`
- `Ke::Float64`: Exciter field proportional constant, validation range: `(0, 2)`, action if invalid: `warn`
- `E_sat::Tuple{Float64, Float64}`: Exciter output voltage for saturation factor: (E1, E2)
- `Se::Tuple{Float64, Float64}`: Exciter saturation factor at exciter output voltage: (Se(E1), Se(E2))
- `V_ref::Float64`: Reference Voltage Set-point, validation range: `(0, nothing)`
- `saturation_coeffs::Tuple{Float64, Float64}`: Coefficients (A,B) of the function: Se(V) = B(V - A)^2/V
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	Vm: Sensed terminal voltage,
	Vr1: Lead-lag state,
	Vr2: Regulator output state,
	Ve: Integrator output state,
	Vr3: Feedback output state
- `n_states::Int`: ESAC6A has 5 states
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
    "Voltage Regulator lead time constant"
    Tk::Float64
    "Regulator denominator (lag) time constant in s"
    Tb::Float64
    "Regulator numerator (lead) time constant in s"
    Tc::Float64
    "Limits for regulator output `(Va_min, Va_max)`"
    Va_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Limits for exciter field voltage `(Vr_min, Vr_max)`"
    Vr_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
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
    "ESAC6A has 5 states"
    n_states::Int
    "ESAC6A has 5 states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ESAC6A(Tr, Ka, Ta, Tk, Tb, Tc, Va_lim, Vr_lim, Te, VFE_lim, Kh, VH_max, Th, Tj, Kc, Kd, Ke, E_sat, Se, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    ESAC6A(Tr, Ka, Ta, Tk, Tb, Tc, Va_lim, Vr_lim, Te, VFE_lim, Kh, VH_max, Th, Tj, Kc, Kd, Ke, E_sat, Se, V_ref, saturation_coeffs, ext, [:Vm, :Vr1, :Vr2, :Ve, :Vr3], 5, [StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Differential, StateTypes.Hybrid], InfrastructureSystemsInternal(), )
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
        Va_lim=(min=0.0, max=0.0),
        Vr_lim=(min=0.0, max=0.0),
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

"""Get [`ESAC6A`](@ref) `Tr`."""
get_Tr(value::ESAC6A) = value.Tr
"""Get [`ESAC6A`](@ref) `Ka`."""
get_Ka(value::ESAC6A) = value.Ka
"""Get [`ESAC6A`](@ref) `Ta`."""
get_Ta(value::ESAC6A) = value.Ta
"""Get [`ESAC6A`](@ref) `Tk`."""
get_Tk(value::ESAC6A) = value.Tk
"""Get [`ESAC6A`](@ref) `Tb`."""
get_Tb(value::ESAC6A) = value.Tb
"""Get [`ESAC6A`](@ref) `Tc`."""
get_Tc(value::ESAC6A) = value.Tc
"""Get [`ESAC6A`](@ref) `Va_lim`."""
get_Va_lim(value::ESAC6A) = value.Va_lim
"""Get [`ESAC6A`](@ref) `Vr_lim`."""
get_Vr_lim(value::ESAC6A) = value.Vr_lim
"""Get [`ESAC6A`](@ref) `Te`."""
get_Te(value::ESAC6A) = value.Te
"""Get [`ESAC6A`](@ref) `VFE_lim`."""
get_VFE_lim(value::ESAC6A) = value.VFE_lim
"""Get [`ESAC6A`](@ref) `Kh`."""
get_Kh(value::ESAC6A) = value.Kh
"""Get [`ESAC6A`](@ref) `VH_max`."""
get_VH_max(value::ESAC6A) = value.VH_max
"""Get [`ESAC6A`](@ref) `Th`."""
get_Th(value::ESAC6A) = value.Th
"""Get [`ESAC6A`](@ref) `Tj`."""
get_Tj(value::ESAC6A) = value.Tj
"""Get [`ESAC6A`](@ref) `Kc`."""
get_Kc(value::ESAC6A) = value.Kc
"""Get [`ESAC6A`](@ref) `Kd`."""
get_Kd(value::ESAC6A) = value.Kd
"""Get [`ESAC6A`](@ref) `Ke`."""
get_Ke(value::ESAC6A) = value.Ke
"""Get [`ESAC6A`](@ref) `E_sat`."""
get_E_sat(value::ESAC6A) = value.E_sat
"""Get [`ESAC6A`](@ref) `Se`."""
get_Se(value::ESAC6A) = value.Se
"""Get [`ESAC6A`](@ref) `V_ref`."""
get_V_ref(value::ESAC6A) = value.V_ref
"""Get [`ESAC6A`](@ref) `saturation_coeffs`."""
get_saturation_coeffs(value::ESAC6A) = value.saturation_coeffs
"""Get [`ESAC6A`](@ref) `ext`."""
get_ext(value::ESAC6A) = value.ext
"""Get [`ESAC6A`](@ref) `states`."""
get_states(value::ESAC6A) = value.states
"""Get [`ESAC6A`](@ref) `n_states`."""
get_n_states(value::ESAC6A) = value.n_states
"""Get [`ESAC6A`](@ref) `states_types`."""
get_states_types(value::ESAC6A) = value.states_types
"""Get [`ESAC6A`](@ref) `internal`."""
get_internal(value::ESAC6A) = value.internal

"""Set [`ESAC6A`](@ref) `Tr`."""
set_Tr!(value::ESAC6A, val) = value.Tr = val
"""Set [`ESAC6A`](@ref) `Ka`."""
set_Ka!(value::ESAC6A, val) = value.Ka = val
"""Set [`ESAC6A`](@ref) `Ta`."""
set_Ta!(value::ESAC6A, val) = value.Ta = val
"""Set [`ESAC6A`](@ref) `Tk`."""
set_Tk!(value::ESAC6A, val) = value.Tk = val
"""Set [`ESAC6A`](@ref) `Tb`."""
set_Tb!(value::ESAC6A, val) = value.Tb = val
"""Set [`ESAC6A`](@ref) `Tc`."""
set_Tc!(value::ESAC6A, val) = value.Tc = val
"""Set [`ESAC6A`](@ref) `Va_lim`."""
set_Va_lim!(value::ESAC6A, val) = value.Va_lim = val
"""Set [`ESAC6A`](@ref) `Vr_lim`."""
set_Vr_lim!(value::ESAC6A, val) = value.Vr_lim = val
"""Set [`ESAC6A`](@ref) `Te`."""
set_Te!(value::ESAC6A, val) = value.Te = val
"""Set [`ESAC6A`](@ref) `VFE_lim`."""
set_VFE_lim!(value::ESAC6A, val) = value.VFE_lim = val
"""Set [`ESAC6A`](@ref) `Kh`."""
set_Kh!(value::ESAC6A, val) = value.Kh = val
"""Set [`ESAC6A`](@ref) `VH_max`."""
set_VH_max!(value::ESAC6A, val) = value.VH_max = val
"""Set [`ESAC6A`](@ref) `Th`."""
set_Th!(value::ESAC6A, val) = value.Th = val
"""Set [`ESAC6A`](@ref) `Tj`."""
set_Tj!(value::ESAC6A, val) = value.Tj = val
"""Set [`ESAC6A`](@ref) `Kc`."""
set_Kc!(value::ESAC6A, val) = value.Kc = val
"""Set [`ESAC6A`](@ref) `Kd`."""
set_Kd!(value::ESAC6A, val) = value.Kd = val
"""Set [`ESAC6A`](@ref) `Ke`."""
set_Ke!(value::ESAC6A, val) = value.Ke = val
"""Set [`ESAC6A`](@ref) `E_sat`."""
set_E_sat!(value::ESAC6A, val) = value.E_sat = val
"""Set [`ESAC6A`](@ref) `Se`."""
set_Se!(value::ESAC6A, val) = value.Se = val
"""Set [`ESAC6A`](@ref) `V_ref`."""
set_V_ref!(value::ESAC6A, val) = value.V_ref = val
"""Set [`ESAC6A`](@ref) `saturation_coeffs`."""
set_saturation_coeffs!(value::ESAC6A, val) = value.saturation_coeffs = val
"""Set [`ESAC6A`](@ref) `ext`."""
set_ext!(value::ESAC6A, val) = value.ext = val
"""Set [`ESAC6A`](@ref) `states`."""
set_states!(value::ESAC6A, val) = value.states = val
"""Set [`ESAC6A`](@ref) `n_states`."""
set_n_states!(value::ESAC6A, val) = value.n_states = val
"""Set [`ESAC6A`](@ref) `states_types`."""
set_states_types!(value::ESAC6A, val) = value.states_types = val
"""Set [`ESAC6A`](@ref) `internal`."""
set_internal!(value::ESAC6A, val) = value.internal = val
