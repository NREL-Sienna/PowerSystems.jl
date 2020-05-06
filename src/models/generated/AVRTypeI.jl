#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct AVRTypeI <: AVR
        Ka::Float64
        Ke::Float64
        Kf::Float64
        Ta::Float64
        Te::Float64
        Tf::Float64
        Tr::Float64
        Vr_max::Float64
        Vr_min::Float64
        Ae::Float64
        Be::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of an Automatic Voltage Regulator Type I - Resembles IEEE Type DC1

# Arguments
- `Ka::Float64`: Amplifier Gain, validation range: (0, nothing)
- `Ke::Float64`: Field circuit integral deviation, validation range: (0, nothing)
- `Kf::Float64`: Stabilizer Gain in s * pu/pu, validation range: (0, nothing)
- `Ta::Float64`: Amplifier Time Constant in s, validation range: (0, nothing)
- `Te::Float64`: Field Circuit Time Constant in s, validation range: (0, nothing)
- `Tf::Float64`: Stabilizer Time Constant in s, validation range: (0, nothing)
- `Tr::Float64`: Voltage Measurement Time Constant in s, validation range: (0, nothing)
- `Vr_max::Float64`: Maximum regulator voltage in pu, validation range: (0, nothing)
- `Vr_min::Float64`: Minimum regulator voltage in pu, validation range: (0, nothing)
- `Ae::Float64`: 1st ceiling coefficient, validation range: (0, nothing)
- `Be::Float64`: 2nd ceiling coefficient, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct AVRTypeI <: AVR
    "Amplifier Gain"
    Ka::Float64
    "Field circuit integral deviation"
    Ke::Float64
    "Stabilizer Gain in s * pu/pu"
    Kf::Float64
    "Amplifier Time Constant in s"
    Ta::Float64
    "Field Circuit Time Constant in s"
    Te::Float64
    "Stabilizer Time Constant in s"
    Tf::Float64
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
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function AVRTypeI(Ka, Ke, Kf, Ta, Te, Tf, Tr, Vr_max, Vr_min, Ae, Be, ext=Dict{String, Any}(), )
    AVRTypeI(Ka, Ke, Kf, Ta, Te, Tf, Tr, Vr_max, Vr_min, Ae, Be, ext, [:Vf, :Vr1, :Vr2, :Vm], 4, InfrastructureSystemsInternal(), )
end

function AVRTypeI(; Ka, Ke, Kf, Ta, Te, Tf, Tr, Vr_max, Vr_min, Ae, Be, ext=Dict{String, Any}(), )
    AVRTypeI(Ka, Ke, Kf, Ta, Te, Tf, Tr, Vr_max, Vr_min, Ae, Be, ext, )
end

# Constructor for demo purposes; non-functional.
function AVRTypeI(::Nothing)
    AVRTypeI(;
        Ka=0,
        Ke=0,
        Kf=0,
        Ta=0,
        Te=0,
        Tf=0,
        Tr=0,
        Vr_max=0,
        Vr_min=0,
        Ae=0,
        Be=0,
        ext=Dict{String, Any}(),
    )
end

"""Get AVRTypeI Ka."""
get_Ka(value::AVRTypeI) = value.Ka
"""Get AVRTypeI Ke."""
get_Ke(value::AVRTypeI) = value.Ke
"""Get AVRTypeI Kf."""
get_Kf(value::AVRTypeI) = value.Kf
"""Get AVRTypeI Ta."""
get_Ta(value::AVRTypeI) = value.Ta
"""Get AVRTypeI Te."""
get_Te(value::AVRTypeI) = value.Te
"""Get AVRTypeI Tf."""
get_Tf(value::AVRTypeI) = value.Tf
"""Get AVRTypeI Tr."""
get_Tr(value::AVRTypeI) = value.Tr
"""Get AVRTypeI Vr_max."""
get_Vr_max(value::AVRTypeI) = value.Vr_max
"""Get AVRTypeI Vr_min."""
get_Vr_min(value::AVRTypeI) = value.Vr_min
"""Get AVRTypeI Ae."""
get_Ae(value::AVRTypeI) = value.Ae
"""Get AVRTypeI Be."""
get_Be(value::AVRTypeI) = value.Be
"""Get AVRTypeI ext."""
get_ext(value::AVRTypeI) = value.ext
"""Get AVRTypeI states."""
get_states(value::AVRTypeI) = value.states
"""Get AVRTypeI n_states."""
get_n_states(value::AVRTypeI) = value.n_states
"""Get AVRTypeI internal."""
get_internal(value::AVRTypeI) = value.internal

"""Set AVRTypeI Ka."""
set_Ka(value::AVRTypeI, val) = value.Ka = val
"""Set AVRTypeI Ke."""
set_Ke(value::AVRTypeI, val) = value.Ke = val
"""Set AVRTypeI Kf."""
set_Kf(value::AVRTypeI, val) = value.Kf = val
"""Set AVRTypeI Ta."""
set_Ta(value::AVRTypeI, val) = value.Ta = val
"""Set AVRTypeI Te."""
set_Te(value::AVRTypeI, val) = value.Te = val
"""Set AVRTypeI Tf."""
set_Tf(value::AVRTypeI, val) = value.Tf = val
"""Set AVRTypeI Tr."""
set_Tr(value::AVRTypeI, val) = value.Tr = val
"""Set AVRTypeI Vr_max."""
set_Vr_max(value::AVRTypeI, val) = value.Vr_max = val
"""Set AVRTypeI Vr_min."""
set_Vr_min(value::AVRTypeI, val) = value.Vr_min = val
"""Set AVRTypeI Ae."""
set_Ae(value::AVRTypeI, val) = value.Ae = val
"""Set AVRTypeI Be."""
set_Be(value::AVRTypeI, val) = value.Be = val
"""Set AVRTypeI ext."""
set_ext(value::AVRTypeI, val) = value.ext = val
"""Set AVRTypeI states."""
set_states(value::AVRTypeI, val) = value.states = val
"""Set AVRTypeI n_states."""
set_n_states(value::AVRTypeI, val) = value.n_states = val
"""Set AVRTypeI internal."""
set_internal(value::AVRTypeI, val) = value.internal = val
