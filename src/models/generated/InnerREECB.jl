#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct InnerREECB <: InnerControl
        Q_Flag::Int
        PQ_Flag::Int
        Vdip_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        T_rv::Float64
        dbd1::Float64
        dbd2::Float64
        K_qv::Float64
        Iqinj_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        V_ref0::Float64
        K_vp::Float64
        K_vi::Float64
        T_iq::Float64
        I_max::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of the Inner Control part of the REECB model

# Arguments
- `Q_Flag::Int`: Q Flag used for I_qinj, validation range: `(0, 1)`
- `PQ_Flag::Int`: PQ Flag used for the Current Limit Logic, validation range: `(0, 1)`
- `Vdip_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Limits for Voltage Dip Logic `(Vdip, Vup)`
- `T_rv::Float64`: Voltage Filter Time Constant, validation range: `(0, nothing)`
- `dbd1::Float64`: Voltage error dead band lower threshold, validation range: `(nothing, 0)`
- `dbd2::Float64`: Voltage error dead band upper threshold, validation range: `(0, nothing)`
- `K_qv::Float64`: Reactive current injection gain during over and undervoltage conditions, validation range: `(0, nothing)`
- `Iqinj_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Limits for Iqinj `(I_qh1, I_ql1)`
- `V_ref0::Float64`: User defined reference. If 0, PSID initializes to initial terminal voltage, validation range: `(0, nothing)`
- `K_vp::Float64`: Voltage regulator proportional gain (used when QFlag = 1), validation range: `(0, nothing)`
- `K_vi::Float64`: Voltage regulator integral gain (used when QFlag = 1), validation range: `(0, nothing)`
- `T_iq::Float64`: Time constant for low-pass filter for state q_V when QFlag = 0, validation range: `(0, nothing)`
- `I_max::Float64`: Maximum limit on total converter current, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the InnerREECB depends on the Flags
- `n_states::Int`: The states of the InnerREECB depends on the Flags
"""
mutable struct InnerREECB <: InnerControl
    "Q Flag used for I_qinj"
    Q_Flag::Int
    "PQ Flag used for the Current Limit Logic"
    PQ_Flag::Int
    "Limits for Voltage Dip Logic `(Vdip, Vup)`"
    Vdip_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Voltage Filter Time Constant"
    T_rv::Float64
    "Voltage error dead band lower threshold"
    dbd1::Float64
    "Voltage error dead band upper threshold"
    dbd2::Float64
    "Reactive current injection gain during over and undervoltage conditions"
    K_qv::Float64
    "Limits for Iqinj `(I_qh1, I_ql1)`"
    Iqinj_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "User defined reference. If 0, PSID initializes to initial terminal voltage"
    V_ref0::Float64
    "Voltage regulator proportional gain (used when QFlag = 1)"
    K_vp::Float64
    "Voltage regulator integral gain (used when QFlag = 1)"
    K_vi::Float64
    "Time constant for low-pass filter for state q_V when QFlag = 0"
    T_iq::Float64
    "Maximum limit on total converter current"
    I_max::Float64
    ext::Dict{String, Any}
    "The states of the InnerREECB depends on the Flags"
    states::Vector{Symbol}
    "The states of the InnerREECB depends on the Flags"
    n_states::Int
end

function InnerREECB(Q_Flag, PQ_Flag, Vdip_lim, T_rv, dbd1, dbd2, K_qv, Iqinj_lim, V_ref0, K_vp, K_vi, T_iq, I_max, ext=Dict{String, Any}(), )
    InnerREECB(Q_Flag, PQ_Flag, Vdip_lim, T_rv, dbd1, dbd2, K_qv, Iqinj_lim, V_ref0, K_vp, K_vi, T_iq, I_max, ext, PowerSystems.get_innerREECB_states(Q_Flag), 2, )
end

function InnerREECB(; Q_Flag, PQ_Flag, Vdip_lim, T_rv, dbd1, dbd2, K_qv, Iqinj_lim, V_ref0, K_vp, K_vi, T_iq, I_max, ext=Dict{String, Any}(), states=PowerSystems.get_innerREECB_states(Q_Flag), n_states=2, )
    InnerREECB(Q_Flag, PQ_Flag, Vdip_lim, T_rv, dbd1, dbd2, K_qv, Iqinj_lim, V_ref0, K_vp, K_vi, T_iq, I_max, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function InnerREECB(::Nothing)
    InnerREECB(;
        Q_Flag=0,
        PQ_Flag=0,
        Vdip_lim=(min=0.0, max=0.0),
        T_rv=0,
        dbd1=0,
        dbd2=0,
        K_qv=0,
        Iqinj_lim=(min=0.0, max=0.0),
        V_ref0=0,
        K_vp=0,
        K_vi=0,
        T_iq=0,
        I_max=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`InnerREECB`](@ref) `Q_Flag`."""
get_Q_Flag(value::InnerREECB) = value.Q_Flag
"""Get [`InnerREECB`](@ref) `PQ_Flag`."""
get_PQ_Flag(value::InnerREECB) = value.PQ_Flag
"""Get [`InnerREECB`](@ref) `Vdip_lim`."""
get_Vdip_lim(value::InnerREECB) = value.Vdip_lim
"""Get [`InnerREECB`](@ref) `T_rv`."""
get_T_rv(value::InnerREECB) = value.T_rv
"""Get [`InnerREECB`](@ref) `dbd1`."""
get_dbd1(value::InnerREECB) = value.dbd1
"""Get [`InnerREECB`](@ref) `dbd2`."""
get_dbd2(value::InnerREECB) = value.dbd2
"""Get [`InnerREECB`](@ref) `K_qv`."""
get_K_qv(value::InnerREECB) = value.K_qv
"""Get [`InnerREECB`](@ref) `Iqinj_lim`."""
get_Iqinj_lim(value::InnerREECB) = value.Iqinj_lim
"""Get [`InnerREECB`](@ref) `V_ref0`."""
get_V_ref0(value::InnerREECB) = value.V_ref0
"""Get [`InnerREECB`](@ref) `K_vp`."""
get_K_vp(value::InnerREECB) = value.K_vp
"""Get [`InnerREECB`](@ref) `K_vi`."""
get_K_vi(value::InnerREECB) = value.K_vi
"""Get [`InnerREECB`](@ref) `T_iq`."""
get_T_iq(value::InnerREECB) = value.T_iq
"""Get [`InnerREECB`](@ref) `I_max`."""
get_I_max(value::InnerREECB) = value.I_max
"""Get [`InnerREECB`](@ref) `ext`."""
get_ext(value::InnerREECB) = value.ext
"""Get [`InnerREECB`](@ref) `states`."""
get_states(value::InnerREECB) = value.states
"""Get [`InnerREECB`](@ref) `n_states`."""
get_n_states(value::InnerREECB) = value.n_states

"""Set [`InnerREECB`](@ref) `Q_Flag`."""
set_Q_Flag!(value::InnerREECB, val) = value.Q_Flag = val
"""Set [`InnerREECB`](@ref) `PQ_Flag`."""
set_PQ_Flag!(value::InnerREECB, val) = value.PQ_Flag = val
"""Set [`InnerREECB`](@ref) `Vdip_lim`."""
set_Vdip_lim!(value::InnerREECB, val) = value.Vdip_lim = val
"""Set [`InnerREECB`](@ref) `T_rv`."""
set_T_rv!(value::InnerREECB, val) = value.T_rv = val
"""Set [`InnerREECB`](@ref) `dbd1`."""
set_dbd1!(value::InnerREECB, val) = value.dbd1 = val
"""Set [`InnerREECB`](@ref) `dbd2`."""
set_dbd2!(value::InnerREECB, val) = value.dbd2 = val
"""Set [`InnerREECB`](@ref) `K_qv`."""
set_K_qv!(value::InnerREECB, val) = value.K_qv = val
"""Set [`InnerREECB`](@ref) `Iqinj_lim`."""
set_Iqinj_lim!(value::InnerREECB, val) = value.Iqinj_lim = val
"""Set [`InnerREECB`](@ref) `V_ref0`."""
set_V_ref0!(value::InnerREECB, val) = value.V_ref0 = val
"""Set [`InnerREECB`](@ref) `K_vp`."""
set_K_vp!(value::InnerREECB, val) = value.K_vp = val
"""Set [`InnerREECB`](@ref) `K_vi`."""
set_K_vi!(value::InnerREECB, val) = value.K_vi = val
"""Set [`InnerREECB`](@ref) `T_iq`."""
set_T_iq!(value::InnerREECB, val) = value.T_iq = val
"""Set [`InnerREECB`](@ref) `I_max`."""
set_I_max!(value::InnerREECB, val) = value.I_max = val
"""Set [`InnerREECB`](@ref) `ext`."""
set_ext!(value::InnerREECB, val) = value.ext = val

