#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct EXPIC <: AVR
        Tr::Float64
        Ka::Float64
        Ta::Float64
        Va_lim::Tuple{Float64, Float64}
        Ta_2::Float64
        Ta_3::Float64
        Ta_4::Float64
        Vr_lim::Tuple{Float64, Float64}
        Kf::Float64
        Tf_1::Float64
        Tf_2::Float64
        Efd_lim::Tuple{Float64, Float64}
        Ke::Float64
        Te::Float64
        E_sat::Tuple{Float64, Float64}
        Se::Tuple{Float64, Float64}
        Kp::Float64
        Ki::Float64
        Kc::Float64
        V_ref::Float64
        saturation_coeffs::Tuple{Float64, Float64}
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        states_types::Vector{StateTypes.StateType}
        internal::InfrastructureSystemsInternal
    end

Generic Proportional/Integral Excitation System

# Arguments
- `Tr::Float64`: Regulator input filter time constant in s, validation range: `(0, nothing)`
- `Ka::Float64`: Voltage regulator gain, validation range: `(0, nothing)`
- `Ta::Float64`: Voltage regulator time constant in s, validation range: `(0, nothing)`
- `Va_lim::Tuple{Float64, Float64}`: Limits for pi controler (Vr_min, Vr_max)
- `Ta_2::Float64`: Voltage regulator time constant in s, validation range: `(0, nothing)`
- `Ta_3::Float64`: Voltage regulator time constant in s, validation range: `(0, nothing)`
- `Ta_4::Float64`: Voltage regulator time constant in s, validation range: `(0, nothing)`
- `Vr_lim::Tuple{Float64, Float64}`: Voltage regulator limits (regulator output) (Vi_min, Vi_max)
- `Kf::Float64`: Rate feedback gain, validation range: `(0, nothing)`
- `Tf_1::Float64`: Rate Feedback time constant in s, validation range: `("eps()", nothing)`
- `Tf_2::Float64`: Rate Feedback time constant in s, validation range: `(0, nothing)`
- `Efd_lim::Tuple{Float64, Float64}`: Field Voltage regulator limits (regulator output) (Efd_min, Efd_max)
- `Ke::Float64`: Exciter constant, validation range: `(0, nothing)`
- `Te::Float64`: Exciter time constant, validation range: `(0, nothing)`
- `E_sat::Tuple{Float64, Float64}`: Exciter output voltage for saturation factor: (E1, E2)
- `Se::Tuple{Float64, Float64}`: Exciter saturation factor at exciter output voltage: (Se(E1), Se(E2))
- `Kp::Float64`: Potential source gain, validation range: `(0, nothing)`
- `Ki::Float64`: current source gain, validation range: `(0, nothing)`
- `Kc::Float64`: Exciter regulation factor, validation range: `(0, nothing)`
- `V_ref::Float64`: Reference Voltage Set-point, validation range: `(0, nothing)`
- `saturation_coeffs::Tuple{Float64, Float64}`: Coefficients (A,B) of the function: Se(V) = B(V - A)^2/V
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	Vm: Sensed terminal voltage,
	Vr1: First Lead-lag state,
	Vr2: Second regulator lead-lag state,
	Vr2: Third regulator lead-lag state 
	Efd: Exciter output 
	Vr3: First feedback integrator,
	Vr4: second feedback integrator
- `n_states::Int64`: EXPIC has 6 states
- `states_types::Vector{StateTypes.StateType}`: EXPIC has 6 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct EXPIC <: AVR
    "Regulator input filter time constant in s"
    Tr::Float64
    "Voltage regulator gain"
    Ka::Float64
    "Voltage regulator time constant in s"
    Ta::Float64
    "Limits for pi controler (Vr_min, Vr_max)"
    Va_lim::Tuple{Float64, Float64}
    "Voltage regulator time constant in s"
    Ta_2::Float64
    "Voltage regulator time constant in s"
    Ta_3::Float64
    "Voltage regulator time constant in s"
    Ta_4::Float64
    "Voltage regulator limits (regulator output) (Vi_min, Vi_max)"
    Vr_lim::Tuple{Float64, Float64}
    "Rate feedback gain"
    Kf::Float64
    "Rate Feedback time constant in s"
    Tf_1::Float64
    "Rate Feedback time constant in s"
    Tf_2::Float64
    "Field Voltage regulator limits (regulator output) (Efd_min, Efd_max)"
    Efd_lim::Tuple{Float64, Float64}
    "Exciter constant"
    Ke::Float64
    "Exciter time constant"
    Te::Float64
    "Exciter output voltage for saturation factor: (E1, E2)"
    E_sat::Tuple{Float64, Float64}
    "Exciter saturation factor at exciter output voltage: (Se(E1), Se(E2))"
    Se::Tuple{Float64, Float64}
    "Potential source gain"
    Kp::Float64
    "current source gain"
    Ki::Float64
    "Exciter regulation factor"
    Kc::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    "Coefficients (A,B) of the function: Se(V) = B(V - A)^2/V"
    saturation_coeffs::Tuple{Float64, Float64}
    ext::Dict{String, Any}
    "The states are:
	Vm: Sensed terminal voltage,
	Vr1: First Lead-lag state,
	Vr2: Second regulator lead-lag state,
	Vr2: Third regulator lead-lag state 
	Efd: Exciter output 
	Vr3: First feedback integrator,
	Vr4: second feedback integrator"
    states::Vector{Symbol}
    "EXPIC has 6 states"
    n_states::Int64
    "EXPIC has 6 states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function EXPIC(Tr, Ka, Ta, Va_lim, Ta_2, Ta_3, Ta_4, Vr_lim, Kf, Tf_1, Tf_2, Efd_lim, Ke, Te, E_sat, Se, Kp, Ki, Kc, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    EXPIC(Tr, Ka, Ta, Va_lim, Ta_2, Ta_3, Ta_4, Vr_lim, Kf, Tf_1, Tf_2, Efd_lim, Ke, Te, E_sat, Se, Kp, Ki, Kc, V_ref, saturation_coeffs, ext, [:Vm, :Vr1, :Vr2, :Efd, :Vr3, :Vr4], 6, [StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function EXPIC(; Tr, Ka, Ta, Va_lim, Ta_2, Ta_3, Ta_4, Vr_lim, Kf, Tf_1, Tf_2, Efd_lim, Ke, Te, E_sat, Se, Kp, Ki, Kc, V_ref=1.0, saturation_coeffs=PowerSystems.get_avr_saturation(E_sat, Se), ext=Dict{String, Any}(), )
    EXPIC(Tr, Ka, Ta, Va_lim, Ta_2, Ta_3, Ta_4, Vr_lim, Kf, Tf_1, Tf_2, Efd_lim, Ke, Te, E_sat, Se, Kp, Ki, Kc, V_ref, saturation_coeffs, ext, )
end

# Constructor for demo purposes; non-functional.
function EXPIC(::Nothing)
    EXPIC(;
        Tr=0,
        Ka=0,
        Ta=0,
        Va_lim=(0.0, 0.0),
        Ta_2=0,
        Ta_3=0,
        Ta_4=0,
        Vr_lim=(0.0, 0.0),
        Kf=0,
        Tf_1=0,
        Tf_2=0,
        Efd_lim=(0.0, 0.0),
        Ke=0,
        Te=0,
        E_sat=(0.0, 0.0),
        Se=(0.0, 0.0),
        Kp=0,
        Ki=0,
        Kc=0,
        V_ref=0,
        saturation_coeffs=(0.0, 0.0),
        ext=Dict{String, Any}(),
    )
end

"""Get [`EXPIC`](@ref) `Tr`."""
get_Tr(value::EXPIC) = value.Tr
"""Get [`EXPIC`](@ref) `Ka`."""
get_Ka(value::EXPIC) = value.Ka
"""Get [`EXPIC`](@ref) `Ta`."""
get_Ta(value::EXPIC) = value.Ta
"""Get [`EXPIC`](@ref) `Va_lim`."""
get_Va_lim(value::EXPIC) = value.Va_lim
"""Get [`EXPIC`](@ref) `Ta_2`."""
get_Ta_2(value::EXPIC) = value.Ta_2
"""Get [`EXPIC`](@ref) `Ta_3`."""
get_Ta_3(value::EXPIC) = value.Ta_3
"""Get [`EXPIC`](@ref) `Ta_4`."""
get_Ta_4(value::EXPIC) = value.Ta_4
"""Get [`EXPIC`](@ref) `Vr_lim`."""
get_Vr_lim(value::EXPIC) = value.Vr_lim
"""Get [`EXPIC`](@ref) `Kf`."""
get_Kf(value::EXPIC) = value.Kf
"""Get [`EXPIC`](@ref) `Tf_1`."""
get_Tf_1(value::EXPIC) = value.Tf_1
"""Get [`EXPIC`](@ref) `Tf_2`."""
get_Tf_2(value::EXPIC) = value.Tf_2
"""Get [`EXPIC`](@ref) `Efd_lim`."""
get_Efd_lim(value::EXPIC) = value.Efd_lim
"""Get [`EXPIC`](@ref) `Ke`."""
get_Ke(value::EXPIC) = value.Ke
"""Get [`EXPIC`](@ref) `Te`."""
get_Te(value::EXPIC) = value.Te
"""Get [`EXPIC`](@ref) `E_sat`."""
get_E_sat(value::EXPIC) = value.E_sat
"""Get [`EXPIC`](@ref) `Se`."""
get_Se(value::EXPIC) = value.Se
"""Get [`EXPIC`](@ref) `Kp`."""
get_Kp(value::EXPIC) = value.Kp
"""Get [`EXPIC`](@ref) `Ki`."""
get_Ki(value::EXPIC) = value.Ki
"""Get [`EXPIC`](@ref) `Kc`."""
get_Kc(value::EXPIC) = value.Kc
"""Get [`EXPIC`](@ref) `V_ref`."""
get_V_ref(value::EXPIC) = value.V_ref
"""Get [`EXPIC`](@ref) `saturation_coeffs`."""
get_saturation_coeffs(value::EXPIC) = value.saturation_coeffs
"""Get [`EXPIC`](@ref) `ext`."""
get_ext(value::EXPIC) = value.ext
"""Get [`EXPIC`](@ref) `states`."""
get_states(value::EXPIC) = value.states
"""Get [`EXPIC`](@ref) `n_states`."""
get_n_states(value::EXPIC) = value.n_states
"""Get [`EXPIC`](@ref) `states_types`."""
get_states_types(value::EXPIC) = value.states_types
"""Get [`EXPIC`](@ref) `internal`."""
get_internal(value::EXPIC) = value.internal

"""Set [`EXPIC`](@ref) `Tr`."""
set_Tr!(value::EXPIC, val) = value.Tr = val
"""Set [`EXPIC`](@ref) `Ka`."""
set_Ka!(value::EXPIC, val) = value.Ka = val
"""Set [`EXPIC`](@ref) `Ta`."""
set_Ta!(value::EXPIC, val) = value.Ta = val
"""Set [`EXPIC`](@ref) `Va_lim`."""
set_Va_lim!(value::EXPIC, val) = value.Va_lim = val
"""Set [`EXPIC`](@ref) `Ta_2`."""
set_Ta_2!(value::EXPIC, val) = value.Ta_2 = val
"""Set [`EXPIC`](@ref) `Ta_3`."""
set_Ta_3!(value::EXPIC, val) = value.Ta_3 = val
"""Set [`EXPIC`](@ref) `Ta_4`."""
set_Ta_4!(value::EXPIC, val) = value.Ta_4 = val
"""Set [`EXPIC`](@ref) `Vr_lim`."""
set_Vr_lim!(value::EXPIC, val) = value.Vr_lim = val
"""Set [`EXPIC`](@ref) `Kf`."""
set_Kf!(value::EXPIC, val) = value.Kf = val
"""Set [`EXPIC`](@ref) `Tf_1`."""
set_Tf_1!(value::EXPIC, val) = value.Tf_1 = val
"""Set [`EXPIC`](@ref) `Tf_2`."""
set_Tf_2!(value::EXPIC, val) = value.Tf_2 = val
"""Set [`EXPIC`](@ref) `Efd_lim`."""
set_Efd_lim!(value::EXPIC, val) = value.Efd_lim = val
"""Set [`EXPIC`](@ref) `Ke`."""
set_Ke!(value::EXPIC, val) = value.Ke = val
"""Set [`EXPIC`](@ref) `Te`."""
set_Te!(value::EXPIC, val) = value.Te = val
"""Set [`EXPIC`](@ref) `E_sat`."""
set_E_sat!(value::EXPIC, val) = value.E_sat = val
"""Set [`EXPIC`](@ref) `Se`."""
set_Se!(value::EXPIC, val) = value.Se = val
"""Set [`EXPIC`](@ref) `Kp`."""
set_Kp!(value::EXPIC, val) = value.Kp = val
"""Set [`EXPIC`](@ref) `Ki`."""
set_Ki!(value::EXPIC, val) = value.Ki = val
"""Set [`EXPIC`](@ref) `Kc`."""
set_Kc!(value::EXPIC, val) = value.Kc = val
"""Set [`EXPIC`](@ref) `V_ref`."""
set_V_ref!(value::EXPIC, val) = value.V_ref = val
"""Set [`EXPIC`](@ref) `saturation_coeffs`."""
set_saturation_coeffs!(value::EXPIC, val) = value.saturation_coeffs = val
"""Set [`EXPIC`](@ref) `ext`."""
set_ext!(value::EXPIC, val) = value.ext = val
"""Set [`EXPIC`](@ref) `states`."""
set_states!(value::EXPIC, val) = value.states = val
"""Set [`EXPIC`](@ref) `n_states`."""
set_n_states!(value::EXPIC, val) = value.n_states = val
"""Set [`EXPIC`](@ref) `states_types`."""
set_states_types!(value::EXPIC, val) = value.states_types = val
"""Set [`EXPIC`](@ref) `internal`."""
set_internal!(value::EXPIC, val) = value.internal = val
