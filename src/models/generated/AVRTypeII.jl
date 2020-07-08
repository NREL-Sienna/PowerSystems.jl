#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AVRTypeII <: AVR
        K0::Float64
        T1::Float64
        T2::Float64
        T3::Float64
        T4::Float64
        Te::Float64
        Tr::Float64
        Vr_max::Float64
        Vr_min::Float64
        Ae::Float64
        Be::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        states_types::Vector{StateTypes.StateType}
        internal::InfrastructureSystemsInternal
    end

Parameters of an Automatic Voltage Regulator Type II -  Typical static exciter model

# Arguments
- `K0::Float64`: Regulator Gain, validation range: (0, nothing)
- `T1::Float64`: First Pole in s, validation range: (0, nothing)
- `T2::Float64`: First zero in s, validation range: (0, nothing)
- `T3::Float64`: First Pole in s, validation range: (0, nothing)
- `T4::Float64`: First zero in s, validation range: (0, nothing)
- `Te::Float64`: Field Circuit Time Constant in s, validation range: (0, nothing)
- `Tr::Float64`: Voltage Measurement Time Constant in s, validation range: (0, nothing)
- `Vr_max::Float64`: Maximum regulator voltage in pu, validation range: (0, nothing)
- `Vr_min::Float64`: Minimum regulator voltage in pu, validation range: (0, nothing)
- `Ae::Float64`: 1st ceiling coefficient, validation range: (0, nothing)
- `Be::Float64`: 2nd ceiling coefficient, validation range: (0, nothing)
- `V_ref::Float64`: Reference Voltage Set-point, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states are:
	Vf: Voltage field,
	Vr1: Amplifier State,
	Vr2: Stabilizing Feedback State,
	Vm: Measured voltage
- `n_states::Int64`: The AVR Type I has 4 states
- `states_types::Vector{StateTypes.StateType}`: AVR Type I has 4 differential states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AVRTypeII <: AVR
    "Regulator Gain"
    K0::Float64
    "First Pole in s"
    T1::Float64
    "First zero in s"
    T2::Float64
    "First Pole in s"
    T3::Float64
    "First zero in s"
    T4::Float64
    "Field Circuit Time Constant in s"
    Te::Float64
    "Voltage Measurement Time Constant in s"
    Tr::Float64
    "Maximum regulator voltage in pu"
    Vr_max::Float64
    "Minimum regulator voltage in pu"
    Vr_min::Float64
    "1st ceiling coefficient"
    Ae::Float64
    "2nd ceiling coefficient"
    Be::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    ext::Dict{String, Any}
    "The states are:
	Vf: Voltage field,
	Vr1: Amplifier State,
	Vr2: Stabilizing Feedback State,
	Vm: Measured voltage"
    states::Vector{Symbol}
    "The AVR Type I has 4 states"
    n_states::Int64
    "AVR Type I has 4 differential states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AVRTypeII(K0, T1, T2, T3, T4, Te, Tr, Vr_max, Vr_min, Ae, Be, V_ref=1.0, ext=Dict{String, Any}(), )
    AVRTypeII(K0, T1, T2, T3, T4, Te, Tr, Vr_max, Vr_min, Ae, Be, V_ref, ext, [:Vf, :Vr1, :Vr2, :Vm], 4, [StateTypes.Differential, StateTypes.Differential, StateTypes.Differential, StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function AVRTypeII(; K0, T1, T2, T3, T4, Te, Tr, Vr_max, Vr_min, Ae, Be, V_ref=1.0, ext=Dict{String, Any}(), )
    AVRTypeII(K0, T1, T2, T3, T4, Te, Tr, Vr_max, Vr_min, Ae, Be, V_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function AVRTypeII(::Nothing)
    AVRTypeII(;
        K0=0,
        T1=0,
        T2=0,
        T3=0,
        T4=0,
        Te=0,
        Tr=0,
        Vr_max=0,
        Vr_min=0,
        Ae=0,
        Be=0,
        V_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get AVRTypeII K0."""
get_K0(value::AVRTypeII) = value.K0
"""Get AVRTypeII T1."""
get_T1(value::AVRTypeII) = value.T1
"""Get AVRTypeII T2."""
get_T2(value::AVRTypeII) = value.T2
"""Get AVRTypeII T3."""
get_T3(value::AVRTypeII) = value.T3
"""Get AVRTypeII T4."""
get_T4(value::AVRTypeII) = value.T4
"""Get AVRTypeII Te."""
get_Te(value::AVRTypeII) = value.Te
"""Get AVRTypeII Tr."""
get_Tr(value::AVRTypeII) = value.Tr
"""Get AVRTypeII Vr_max."""
get_Vr_max(value::AVRTypeII) = value.Vr_max
"""Get AVRTypeII Vr_min."""
get_Vr_min(value::AVRTypeII) = value.Vr_min
"""Get AVRTypeII Ae."""
get_Ae(value::AVRTypeII) = value.Ae
"""Get AVRTypeII Be."""
get_Be(value::AVRTypeII) = value.Be
"""Get AVRTypeII V_ref."""
get_V_ref(value::AVRTypeII) = value.V_ref
"""Get AVRTypeII ext."""
get_ext(value::AVRTypeII) = value.ext
"""Get AVRTypeII states."""
get_states(value::AVRTypeII) = value.states
"""Get AVRTypeII n_states."""
get_n_states(value::AVRTypeII) = value.n_states
"""Get AVRTypeII states_types."""
get_states_types(value::AVRTypeII) = value.states_types
"""Get AVRTypeII internal."""
get_internal(value::AVRTypeII) = value.internal

"""Set AVRTypeII K0."""
set_K0!(value::AVRTypeII, val::Float64) = value.K0 = val
"""Set AVRTypeII T1."""
set_T1!(value::AVRTypeII, val::Float64) = value.T1 = val
"""Set AVRTypeII T2."""
set_T2!(value::AVRTypeII, val::Float64) = value.T2 = val
"""Set AVRTypeII T3."""
set_T3!(value::AVRTypeII, val::Float64) = value.T3 = val
"""Set AVRTypeII T4."""
set_T4!(value::AVRTypeII, val::Float64) = value.T4 = val
"""Set AVRTypeII Te."""
set_Te!(value::AVRTypeII, val::Float64) = value.Te = val
"""Set AVRTypeII Tr."""
set_Tr!(value::AVRTypeII, val::Float64) = value.Tr = val
"""Set AVRTypeII Vr_max."""
set_Vr_max!(value::AVRTypeII, val::Float64) = value.Vr_max = val
"""Set AVRTypeII Vr_min."""
set_Vr_min!(value::AVRTypeII, val::Float64) = value.Vr_min = val
"""Set AVRTypeII Ae."""
set_Ae!(value::AVRTypeII, val::Float64) = value.Ae = val
"""Set AVRTypeII Be."""
set_Be!(value::AVRTypeII, val::Float64) = value.Be = val
"""Set AVRTypeII V_ref."""
set_V_ref!(value::AVRTypeII, val::Float64) = value.V_ref = val
"""Set AVRTypeII ext."""
set_ext!(value::AVRTypeII, val::Dict{String, Any}) = value.ext = val
"""Set AVRTypeII states."""
set_states!(value::AVRTypeII, val::Vector{Symbol}) = value.states = val
"""Set AVRTypeII n_states."""
set_n_states!(value::AVRTypeII, val::Int64) = value.n_states = val
"""Set AVRTypeII states_types."""
set_states_types!(value::AVRTypeII, val::Vector{StateTypes.StateType}) = value.states_types = val
"""Set AVRTypeII internal."""
set_internal!(value::AVRTypeII, val::InfrastructureSystemsInternal) = value.internal = val
