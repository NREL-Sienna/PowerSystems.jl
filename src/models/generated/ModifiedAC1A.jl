#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ModifiedAC1A <: AVR
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
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of Modified Type AC1A Excitacion System. EXAC1 in PSSE and PSLF

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
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ModifiedAC1A <: AVR
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
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ModifiedAC1A(Tr, Tb, Tc, Ka, Ta, Vr_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    ModifiedAC1A(Tr, Tb, Tc, Ka, Ta, Vr_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, V_ref, saturation_coeffs, ext, [:Vm, :Vr1, :Vr2, :Ve, :Vr3], 5, InfrastructureSystemsInternal(), )
end

function ModifiedAC1A(; Tr, Tb, Tc, Ka, Ta, Vr_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    ModifiedAC1A(Tr, Tb, Tc, Ka, Ta, Vr_lim, Te, Kf, Tf, Kc, Kd, Ke, E_sat, Se, V_ref, saturation_coeffs, ext, )
end

# Constructor for demo purposes; non-functional.
function ModifiedAC1A(::Nothing)
    ModifiedAC1A(;
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

"""Get ModifiedAC1A Tr."""
get_Tr(value::ModifiedAC1A) = value.Tr
"""Get ModifiedAC1A Tb."""
get_Tb(value::ModifiedAC1A) = value.Tb
"""Get ModifiedAC1A Tc."""
get_Tc(value::ModifiedAC1A) = value.Tc
"""Get ModifiedAC1A Ka."""
get_Ka(value::ModifiedAC1A) = value.Ka
"""Get ModifiedAC1A Ta."""
get_Ta(value::ModifiedAC1A) = value.Ta
"""Get ModifiedAC1A Vr_lim."""
get_Vr_lim(value::ModifiedAC1A) = value.Vr_lim
"""Get ModifiedAC1A Te."""
get_Te(value::ModifiedAC1A) = value.Te
"""Get ModifiedAC1A Kf."""
get_Kf(value::ModifiedAC1A) = value.Kf
"""Get ModifiedAC1A Tf."""
get_Tf(value::ModifiedAC1A) = value.Tf
"""Get ModifiedAC1A Kc."""
get_Kc(value::ModifiedAC1A) = value.Kc
"""Get ModifiedAC1A Kd."""
get_Kd(value::ModifiedAC1A) = value.Kd
"""Get ModifiedAC1A Ke."""
get_Ke(value::ModifiedAC1A) = value.Ke
"""Get ModifiedAC1A E_sat."""
get_E_sat(value::ModifiedAC1A) = value.E_sat
"""Get ModifiedAC1A Se."""
get_Se(value::ModifiedAC1A) = value.Se
"""Get ModifiedAC1A V_ref."""
get_V_ref(value::ModifiedAC1A) = value.V_ref
"""Get ModifiedAC1A saturation_coeffs."""
get_saturation_coeffs(value::ModifiedAC1A) = value.saturation_coeffs
"""Get ModifiedAC1A ext."""
get_ext(value::ModifiedAC1A) = value.ext
"""Get ModifiedAC1A states."""
get_states(value::ModifiedAC1A) = value.states
"""Get ModifiedAC1A n_states."""
get_n_states(value::ModifiedAC1A) = value.n_states
"""Get ModifiedAC1A internal."""
get_internal(value::ModifiedAC1A) = value.internal

"""Set ModifiedAC1A Tr."""
set_Tr!(value::ModifiedAC1A, val::Float64) = value.Tr = val
"""Set ModifiedAC1A Tb."""
set_Tb!(value::ModifiedAC1A, val::Float64) = value.Tb = val
"""Set ModifiedAC1A Tc."""
set_Tc!(value::ModifiedAC1A, val::Float64) = value.Tc = val
"""Set ModifiedAC1A Ka."""
set_Ka!(value::ModifiedAC1A, val::Float64) = value.Ka = val
"""Set ModifiedAC1A Ta."""
set_Ta!(value::ModifiedAC1A, val::Float64) = value.Ta = val
"""Set ModifiedAC1A Vr_lim."""
set_Vr_lim!(value::ModifiedAC1A, val::Tuple{Float64, Float64}) = value.Vr_lim = val
"""Set ModifiedAC1A Te."""
set_Te!(value::ModifiedAC1A, val::Float64) = value.Te = val
"""Set ModifiedAC1A Kf."""
set_Kf!(value::ModifiedAC1A, val::Float64) = value.Kf = val
"""Set ModifiedAC1A Tf."""
set_Tf!(value::ModifiedAC1A, val::Float64) = value.Tf = val
"""Set ModifiedAC1A Kc."""
set_Kc!(value::ModifiedAC1A, val::Float64) = value.Kc = val
"""Set ModifiedAC1A Kd."""
set_Kd!(value::ModifiedAC1A, val::Float64) = value.Kd = val
"""Set ModifiedAC1A Ke."""
set_Ke!(value::ModifiedAC1A, val::Float64) = value.Ke = val
"""Set ModifiedAC1A E_sat."""
set_E_sat!(value::ModifiedAC1A, val::Tuple{Float64, Float64}) = value.E_sat = val
"""Set ModifiedAC1A Se."""
set_Se!(value::ModifiedAC1A, val::Tuple{Float64, Float64}) = value.Se = val
"""Set ModifiedAC1A V_ref."""
set_V_ref!(value::ModifiedAC1A, val::Float64) = value.V_ref = val
"""Set ModifiedAC1A saturation_coeffs."""
set_saturation_coeffs!(value::ModifiedAC1A, val::Tuple{Float64, Float64}) = value.saturation_coeffs = val
"""Set ModifiedAC1A ext."""
set_ext!(value::ModifiedAC1A, val::Dict{String, Any}) = value.ext = val
"""Set ModifiedAC1A states."""
set_states!(value::ModifiedAC1A, val::Vector{Symbol}) = value.states = val
"""Set ModifiedAC1A n_states."""
set_n_states!(value::ModifiedAC1A, val::Int64) = value.n_states = val
"""Set ModifiedAC1A internal."""
set_internal!(value::ModifiedAC1A, val::InfrastructureSystemsInternal) = value.internal = val
