#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ESST4B <: AVR
        Tr::Float64
        Kp_r::Float64
        Ki_r::Float64
        Vr_lim::Tuple{Float64, Float64}
        Ta::Float64
        Kp_m::Float64
        Ki_m::Float64
        Vm_lim::Tuple{Float64, Float64}
        Kg::Float64
        Kp::Float64
        Ki::Float64
        VB_max::Float64
        Kc::Float64
        Xl::Float64
        θp::Float64
        V_ref::Float64
        θp_rad::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        states_types::Vector{StateTypes.StateType}
        internal::InfrastructureSystemsInternal
    end

In these excitation systems, voltage (and also current in compounded systems) is transformed to an appropriate level. Rectifiers, either controlled or non-controlled, provide the necessary direct current for the generator field.
Parameters of IEEE Std 421.5 Type ST4B Excitacion System. ESST4B in PSSE and PSLF

# Arguments
- `Tr::Float64`: Regulator input filter time constant in s, validation range: `(0, nothing)`
- `Kp_r::Float64`: Regulator propotional gain, validation range: `(0, nothing)`
- `Ki_r::Float64`: Regulator integral gain, validation range: `(0, nothing)`
- `Vr_lim::Tuple{Float64, Float64}`: Voltage regulator limits (Vi_min, Vi_max)
- `Ta::Float64`: Voltage regulator time constant in s, validation range: `(0, nothing)`
- `Kp_m::Float64`: Voltage regulator proportional gain output, validation range: `(0, nothing)`
- `Ki_m::Float64`: Voltage regulator integral gain output, validation range: `(0, nothing)`
- `Vm_lim::Tuple{Float64, Float64}`: Limits for inner loop output (Va_min, Va_max)
- `Kg::Float64`: Feedback gain constant of the inner loop field regulator, validation range: `(0, nothing)`
- `Kp::Float64`: Potential circuit (voltage) gain coefficient, validation range: `(0, nothing)`
- `Ki::Float64`: Compound circuit (current) gain coefficient, validation range: `("eps()", nothing)`
- `VB_max::Float64`: Maximum available exciter voltage, validation range: `(0, nothing)`
- `Kc::Float64`: Rectifier loading factor proportional to commutating reactance, validation range: `(0, nothing)`
- `Xl::Float64`: Reactance associated with potential source, validation range: `(0, nothing)`
- `θp::Float64`: Potential circuit phase angle (degrees)
- `V_ref::Float64`: Reference Voltage Set-point, validation range: `(0, nothing)`
- `θp_rad::Float64`: Potential circuit phase angle (radians)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	Vm: Sensed terminal voltage,
	Vt: Sensed Terminal Voltage,
	Vr1: Regulator Integrator,
	Vr2: Regulator Output,
	Vm: Output integrator
- `n_states::Int64`: ST4B has 4 states
- `states_types::Vector{StateTypes.StateType}`: ST4B has 4 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ESST4B <: AVR
    "Regulator input filter time constant in s"
    Tr::Float64
    "Regulator propotional gain"
    Kp_r::Float64
    "Regulator integral gain"
    Ki_r::Float64
    "Voltage regulator limits (Vi_min, Vi_max)"
    Vr_lim::Tuple{Float64, Float64}
    "Voltage regulator time constant in s"
    Ta::Float64
    "Voltage regulator proportional gain output"
    Kp_m::Float64
    "Voltage regulator integral gain output"
    Ki_m::Float64
    "Limits for inner loop output (Va_min, Va_max)"
    Vm_lim::Tuple{Float64, Float64}
    "Feedback gain constant of the inner loop field regulator"
    Kg::Float64
    "Potential circuit (voltage) gain coefficient"
    Kp::Float64
    "Compound circuit (current) gain coefficient"
    Ki::Float64
    "Maximum available exciter voltage"
    VB_max::Float64
    "Rectifier loading factor proportional to commutating reactance"
    Kc::Float64
    "Reactance associated with potential source"
    Xl::Float64
    "Potential circuit phase angle (degrees)"
    θp::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    "Potential circuit phase angle (radians)"
    θp_rad::Float64
    ext::Dict{String, Any}
    "The states are:
	Vm: Sensed terminal voltage,
	Vt: Sensed Terminal Voltage,
	Vr1: Regulator Integrator,
	Vr2: Regulator Output,
	Vm: Output integrator"
    states::Vector{Symbol}
    "ST4B has 4 states"
    n_states::Int64
    "ST4B has 4 states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ESST4B(Tr, Kp_r, Ki_r, Vr_lim, Ta, Kp_m, Ki_m, Vm_lim, Kg, Kp, Ki, VB_max, Kc, Xl, θp, V_ref=1.0, θp_rad=θp*(pi()&#x2F;180), ext=Dict{String, Any}(), )
    ESST4B(Tr, Kp_r, Ki_r, Vr_lim, Ta, Kp_m, Ki_m, Vm_lim, Kg, Kp, Ki, VB_max, Kc, Xl, θp, V_ref, θp_rad, ext, [:Vt, :Vr1, :Vr2, :Vm], 4, [StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Hybrid, StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function ESST4B(; Tr, Kp_r, Ki_r, Vr_lim, Ta, Kp_m, Ki_m, Vm_lim, Kg, Kp, Ki, VB_max, Kc, Xl, θp, V_ref=1.0, θp_rad=θp*(pi()&#x2F;180), ext=Dict{String, Any}(), )
    ESST4B(Tr, Kp_r, Ki_r, Vr_lim, Ta, Kp_m, Ki_m, Vm_lim, Kg, Kp, Ki, VB_max, Kc, Xl, θp, V_ref, θp_rad, ext, )
end

# Constructor for demo purposes; non-functional.
function ESST4B(::Nothing)
    ESST4B(;
        Tr=0,
        Kp_r=0,
        Ki_r=0,
        Vr_lim=(0.0, 0.0),
        Ta=0,
        Kp_m=0,
        Ki_m=0,
        Vm_lim=(0.0, 0.0),
        Kg=0,
        Kp=0,
        Ki=0,
        VB_max=0,
        Kc=0,
        Xl=0,
        θp=0,
        V_ref=0,
        θp_rad=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ESST4B`](@ref) `Tr`."""
get_Tr(value::ESST4B) = value.Tr
"""Get [`ESST4B`](@ref) `Kp_r`."""
get_Kp_r(value::ESST4B) = value.Kp_r
"""Get [`ESST4B`](@ref) `Ki_r`."""
get_Ki_r(value::ESST4B) = value.Ki_r
"""Get [`ESST4B`](@ref) `Vr_lim`."""
get_Vr_lim(value::ESST4B) = value.Vr_lim
"""Get [`ESST4B`](@ref) `Ta`."""
get_Ta(value::ESST4B) = value.Ta
"""Get [`ESST4B`](@ref) `Kp_m`."""
get_Kp_m(value::ESST4B) = value.Kp_m
"""Get [`ESST4B`](@ref) `Ki_m`."""
get_Ki_m(value::ESST4B) = value.Ki_m
"""Get [`ESST4B`](@ref) `Vm_lim`."""
get_Vm_lim(value::ESST4B) = value.Vm_lim
"""Get [`ESST4B`](@ref) `Kg`."""
get_Kg(value::ESST4B) = value.Kg
"""Get [`ESST4B`](@ref) `Kp`."""
get_Kp(value::ESST4B) = value.Kp
"""Get [`ESST4B`](@ref) `Ki`."""
get_Ki(value::ESST4B) = value.Ki
"""Get [`ESST4B`](@ref) `VB_max`."""
get_VB_max(value::ESST4B) = value.VB_max
"""Get [`ESST4B`](@ref) `Kc`."""
get_Kc(value::ESST4B) = value.Kc
"""Get [`ESST4B`](@ref) `Xl`."""
get_Xl(value::ESST4B) = value.Xl
"""Get [`ESST4B`](@ref) `θp`."""
get_θp(value::ESST4B) = value.θp
"""Get [`ESST4B`](@ref) `V_ref`."""
get_V_ref(value::ESST4B) = value.V_ref
"""Get [`ESST4B`](@ref) `θp_rad`."""
get_θp_rad(value::ESST4B) = value.θp_rad
"""Get [`ESST4B`](@ref) `ext`."""
get_ext(value::ESST4B) = value.ext
"""Get [`ESST4B`](@ref) `states`."""
get_states(value::ESST4B) = value.states
"""Get [`ESST4B`](@ref) `n_states`."""
get_n_states(value::ESST4B) = value.n_states
"""Get [`ESST4B`](@ref) `states_types`."""
get_states_types(value::ESST4B) = value.states_types
"""Get [`ESST4B`](@ref) `internal`."""
get_internal(value::ESST4B) = value.internal

"""Set [`ESST4B`](@ref) `Tr`."""
set_Tr!(value::ESST4B, val) = value.Tr = val
"""Set [`ESST4B`](@ref) `Kp_r`."""
set_Kp_r!(value::ESST4B, val) = value.Kp_r = val
"""Set [`ESST4B`](@ref) `Ki_r`."""
set_Ki_r!(value::ESST4B, val) = value.Ki_r = val
"""Set [`ESST4B`](@ref) `Vr_lim`."""
set_Vr_lim!(value::ESST4B, val) = value.Vr_lim = val
"""Set [`ESST4B`](@ref) `Ta`."""
set_Ta!(value::ESST4B, val) = value.Ta = val
"""Set [`ESST4B`](@ref) `Kp_m`."""
set_Kp_m!(value::ESST4B, val) = value.Kp_m = val
"""Set [`ESST4B`](@ref) `Ki_m`."""
set_Ki_m!(value::ESST4B, val) = value.Ki_m = val
"""Set [`ESST4B`](@ref) `Vm_lim`."""
set_Vm_lim!(value::ESST4B, val) = value.Vm_lim = val
"""Set [`ESST4B`](@ref) `Kg`."""
set_Kg!(value::ESST4B, val) = value.Kg = val
"""Set [`ESST4B`](@ref) `Kp`."""
set_Kp!(value::ESST4B, val) = value.Kp = val
"""Set [`ESST4B`](@ref) `Ki`."""
set_Ki!(value::ESST4B, val) = value.Ki = val
"""Set [`ESST4B`](@ref) `VB_max`."""
set_VB_max!(value::ESST4B, val) = value.VB_max = val
"""Set [`ESST4B`](@ref) `Kc`."""
set_Kc!(value::ESST4B, val) = value.Kc = val
"""Set [`ESST4B`](@ref) `Xl`."""
set_Xl!(value::ESST4B, val) = value.Xl = val
"""Set [`ESST4B`](@ref) `θp`."""
set_θp!(value::ESST4B, val) = value.θp = val
"""Set [`ESST4B`](@ref) `V_ref`."""
set_V_ref!(value::ESST4B, val) = value.V_ref = val
"""Set [`ESST4B`](@ref) `θp_rad`."""
set_θp_rad!(value::ESST4B, val) = value.θp_rad = val
"""Set [`ESST4B`](@ref) `ext`."""
set_ext!(value::ESST4B, val) = value.ext = val
"""Set [`ESST4B`](@ref) `states`."""
set_states!(value::ESST4B, val) = value.states = val
"""Set [`ESST4B`](@ref) `n_states`."""
set_n_states!(value::ESST4B, val) = value.n_states = val
"""Set [`ESST4B`](@ref) `states_types`."""
set_states_types!(value::ESST4B, val) = value.states_types = val
"""Set [`ESST4B`](@ref) `internal`."""
set_internal!(value::ESST4B, val) = value.internal = val
