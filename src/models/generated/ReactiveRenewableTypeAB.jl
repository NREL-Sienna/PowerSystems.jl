#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ReactiveRenewableTypeAB <: ReactivePowerControl
        bus_control::Int
        from_branch_control::Int
        to_branch_control::Int
        branch_id_control::String
        VC_Flag::Int
        Ref_Flag::Int
        PF_Flag::Int
        V_Flag::Int
        T_fltr::Float64
        K_p::Float64
        K_i::Float64
        T_ft::Float64
        T_fv::Float64
        V_frz::Float64
        R_c::Float64
        X_c::Float64
        e_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        dbd1::Float64
        dbd2::Float64
        Q_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        T_p::Float64
        Q_lim_inner::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        V_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        K_qp::Float64
        K_qi::Float64
        Q_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of Reactive Power Controller including REPCA1 and REECB1

# Arguments
- `bus_control::Int`: Bus Number for voltage control; , validation range: `(0, nothing)`
- `from_branch_control::Int`: Monitored branch FROM bus number for line drop compensation (if 0 generator power will be used), validation range: `(0, nothing)`
- `to_branch_control::Int`: Monitored branch TO bus number for line drop compensation (if 0 generator power will be used), validation range: `(0, nothing)`
- `branch_id_control::String`: Branch circuit id for line drop compensation (as a string). If 0 generator power will be used
- `VC_Flag::Int`: Voltage Compensator Flag for REPCA1, validation range: `(0, 1)`
- `Ref_Flag::Int`: Flag for Reactive Power Control for REPCA1. 0: Q-control, 1: V-control, validation range: `(0, 1)`
- `PF_Flag::Int`: Flag for Power Factor Control for Outer Control of REECB1. 0: Q-control, 1: Power Factor Control, validation range: `(0, 1)`
- `V_Flag::Int`: Flag for Voltage Control for Outer Control of REECB1. 0: Voltage Control, 1: Q-Control, validation range: `(0, 1)`
- `T_fltr::Float64`: Voltage or Q-power of REPCA Filter Time Constant, validation range: `(0, nothing)`
- `K_p::Float64`: Reactive power PI control proportional gain, validation range: `(0, nothing)`
- `K_i::Float64`: Reactive power PI control integral gain, validation range: `(0, nothing)`
- `T_ft::Float64`: Reactive power lead time constant (s), validation range: `(0, nothing)`
- `T_fv::Float64`: Reactive power lag time constant (s), validation range: `(0, nothing)`
- `V_frz::Float64`: Voltage below which state ξq_oc (integrator state) is freeze, validation range: `(0, nothing)`
- `R_c::Float64`: Line drop compensation resistance (used when VC_Flag = 1), validation range: `(0, nothing)`
- `X_c::Float64`: Line drop compensation reactance (used when VC_Flag = 1), validation range: `(0, nothing)`
- `e_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Upper/Lower limit on Voltage or Q-power deadband output `(e_min, e_max)`
- `dbd1::Float64`: Voltage or Q-power error dead band lower threshold, validation range: `(nothing, 0)`
- `dbd2::Float64`: Voltage or Q-power dead band upper threshold, validation range: `(0, nothing)`
- `Q_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Upper/Lower limit on reactive power V/Q control in REPCA `(Q_min, Q_max)`
- `T_p::Float64`: Active power lag time constant in REECB (s). Used only when PF_Flag = 1, validation range: `(0, nothing)`
- `Q_lim_inner::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Upper/Lower limit on reactive power input in REECB `(Q_min_inner, Q_max_inner)`. Only used when V_Flag = 1
- `V_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Upper/Lower limit on reactive power PI controller in REECB `(V_min, V_max)`. Only used when V_Flag = 1
- `K_qp::Float64`: Reactive power regulator proportional gain (used when V_Flag = 1), validation range: `(0, nothing)`
- `K_qi::Float64`: Reactive power regulator integral gain (used when V_Flag = 1), validation range: `(0, nothing)`
- `Q_ref::Float64`: Reference Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the ReactiveRenewableTypeAB model depends on the Flag
- `n_states::Int`: The states of the ReactiveRenewableTypeAB model depends on the Flag
"""
mutable struct ReactiveRenewableTypeAB <: ReactivePowerControl
    "Bus Number for voltage control; "
    bus_control::Int
    "Monitored branch FROM bus number for line drop compensation (if 0 generator power will be used)"
    from_branch_control::Int
    "Monitored branch TO bus number for line drop compensation (if 0 generator power will be used)"
    to_branch_control::Int
    "Branch circuit id for line drop compensation (as a string). If 0 generator power will be used"
    branch_id_control::String
    "Voltage Compensator Flag for REPCA1"
    VC_Flag::Int
    "Flag for Reactive Power Control for REPCA1. 0: Q-control, 1: V-control"
    Ref_Flag::Int
    "Flag for Power Factor Control for Outer Control of REECB1. 0: Q-control, 1: Power Factor Control"
    PF_Flag::Int
    "Flag for Voltage Control for Outer Control of REECB1. 0: Voltage Control, 1: Q-Control"
    V_Flag::Int
    "Voltage or Q-power of REPCA Filter Time Constant"
    T_fltr::Float64
    "Reactive power PI control proportional gain"
    K_p::Float64
    "Reactive power PI control integral gain"
    K_i::Float64
    "Reactive power lead time constant (s)"
    T_ft::Float64
    "Reactive power lag time constant (s)"
    T_fv::Float64
    "Voltage below which state ξq_oc (integrator state) is freeze"
    V_frz::Float64
    "Line drop compensation resistance (used when VC_Flag = 1)"
    R_c::Float64
    "Line drop compensation reactance (used when VC_Flag = 1)"
    X_c::Float64
    "Upper/Lower limit on Voltage or Q-power deadband output `(e_min, e_max)`"
    e_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Voltage or Q-power error dead band lower threshold"
    dbd1::Float64
    "Voltage or Q-power dead band upper threshold"
    dbd2::Float64
    "Upper/Lower limit on reactive power V/Q control in REPCA `(Q_min, Q_max)`"
    Q_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Active power lag time constant in REECB (s). Used only when PF_Flag = 1"
    T_p::Float64
    "Upper/Lower limit on reactive power input in REECB `(Q_min_inner, Q_max_inner)`. Only used when V_Flag = 1"
    Q_lim_inner::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Upper/Lower limit on reactive power PI controller in REECB `(V_min, V_max)`. Only used when V_Flag = 1"
    V_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Reactive power regulator proportional gain (used when V_Flag = 1)"
    K_qp::Float64
    "Reactive power regulator integral gain (used when V_Flag = 1)"
    K_qi::Float64
    "Reference Power Set-point"
    Q_ref::Float64
    ext::Dict{String, Any}
    "The states of the ReactiveRenewableTypeAB model depends on the Flag"
    states::Vector{Symbol}
    "The states of the ReactiveRenewableTypeAB model depends on the Flag"
    n_states::Int
end

function ReactiveRenewableTypeAB(bus_control, from_branch_control, to_branch_control, branch_id_control, VC_Flag, Ref_Flag, PF_Flag, V_Flag, T_fltr, K_p, K_i, T_ft, T_fv, V_frz, R_c, X_c, e_lim, dbd1, dbd2, Q_lim, T_p, Q_lim_inner, V_lim, K_qp, K_qi, Q_ref=1.0, ext=Dict{String, Any}(), )
    ReactiveRenewableTypeAB(bus_control, from_branch_control, to_branch_control, branch_id_control, VC_Flag, Ref_Flag, PF_Flag, V_Flag, T_fltr, K_p, K_i, T_ft, T_fv, V_frz, R_c, X_c, e_lim, dbd1, dbd2, Q_lim, T_p, Q_lim_inner, V_lim, K_qp, K_qi, Q_ref, ext, PowerSystems.get_reactiveRETypeAB_states(Ref_Flag, PF_Flag, V_Flag)[1], PowerSystems.get_reactiveRETypeAB_states(Ref_Flag, PF_Flag, V_Flag)[2], )
end

function ReactiveRenewableTypeAB(; bus_control, from_branch_control, to_branch_control, branch_id_control, VC_Flag, Ref_Flag, PF_Flag, V_Flag, T_fltr, K_p, K_i, T_ft, T_fv, V_frz, R_c, X_c, e_lim, dbd1, dbd2, Q_lim, T_p, Q_lim_inner, V_lim, K_qp, K_qi, Q_ref=1.0, ext=Dict{String, Any}(), states=PowerSystems.get_reactiveRETypeAB_states(Ref_Flag, PF_Flag, V_Flag)[1], n_states=PowerSystems.get_reactiveRETypeAB_states(Ref_Flag, PF_Flag, V_Flag)[2], )
    ReactiveRenewableTypeAB(bus_control, from_branch_control, to_branch_control, branch_id_control, VC_Flag, Ref_Flag, PF_Flag, V_Flag, T_fltr, K_p, K_i, T_ft, T_fv, V_frz, R_c, X_c, e_lim, dbd1, dbd2, Q_lim, T_p, Q_lim_inner, V_lim, K_qp, K_qi, Q_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ReactiveRenewableTypeAB(::Nothing)
    ReactiveRenewableTypeAB(;
        bus_control=0,
        from_branch_control=0,
        to_branch_control=0,
        branch_id_control="0",
        VC_Flag=0,
        Ref_Flag=0,
        PF_Flag=0,
        V_Flag=0,
        T_fltr=0,
        K_p=0,
        K_i=0,
        T_ft=0,
        T_fv=0,
        V_frz=0,
        R_c=0,
        X_c=0,
        e_lim=(min=0.0, max=0.0),
        dbd1=0,
        dbd2=0,
        Q_lim=(min=0.0, max=0.0),
        T_p=0,
        Q_lim_inner=(min=0.0, max=0.0),
        V_lim=(min=0.0, max=0.0),
        K_qp=0,
        K_qi=0,
        Q_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ReactiveRenewableTypeAB`](@ref) `bus_control`."""
get_bus_control(value::ReactiveRenewableTypeAB) = value.bus_control
"""Get [`ReactiveRenewableTypeAB`](@ref) `from_branch_control`."""
get_from_branch_control(value::ReactiveRenewableTypeAB) = value.from_branch_control
"""Get [`ReactiveRenewableTypeAB`](@ref) `to_branch_control`."""
get_to_branch_control(value::ReactiveRenewableTypeAB) = value.to_branch_control
"""Get [`ReactiveRenewableTypeAB`](@ref) `branch_id_control`."""
get_branch_id_control(value::ReactiveRenewableTypeAB) = value.branch_id_control
"""Get [`ReactiveRenewableTypeAB`](@ref) `VC_Flag`."""
get_VC_Flag(value::ReactiveRenewableTypeAB) = value.VC_Flag
"""Get [`ReactiveRenewableTypeAB`](@ref) `Ref_Flag`."""
get_Ref_Flag(value::ReactiveRenewableTypeAB) = value.Ref_Flag
"""Get [`ReactiveRenewableTypeAB`](@ref) `PF_Flag`."""
get_PF_Flag(value::ReactiveRenewableTypeAB) = value.PF_Flag
"""Get [`ReactiveRenewableTypeAB`](@ref) `V_Flag`."""
get_V_Flag(value::ReactiveRenewableTypeAB) = value.V_Flag
"""Get [`ReactiveRenewableTypeAB`](@ref) `T_fltr`."""
get_T_fltr(value::ReactiveRenewableTypeAB) = value.T_fltr
"""Get [`ReactiveRenewableTypeAB`](@ref) `K_p`."""
get_K_p(value::ReactiveRenewableTypeAB) = value.K_p
"""Get [`ReactiveRenewableTypeAB`](@ref) `K_i`."""
get_K_i(value::ReactiveRenewableTypeAB) = value.K_i
"""Get [`ReactiveRenewableTypeAB`](@ref) `T_ft`."""
get_T_ft(value::ReactiveRenewableTypeAB) = value.T_ft
"""Get [`ReactiveRenewableTypeAB`](@ref) `T_fv`."""
get_T_fv(value::ReactiveRenewableTypeAB) = value.T_fv
"""Get [`ReactiveRenewableTypeAB`](@ref) `V_frz`."""
get_V_frz(value::ReactiveRenewableTypeAB) = value.V_frz
"""Get [`ReactiveRenewableTypeAB`](@ref) `R_c`."""
get_R_c(value::ReactiveRenewableTypeAB) = value.R_c
"""Get [`ReactiveRenewableTypeAB`](@ref) `X_c`."""
get_X_c(value::ReactiveRenewableTypeAB) = value.X_c
"""Get [`ReactiveRenewableTypeAB`](@ref) `e_lim`."""
get_e_lim(value::ReactiveRenewableTypeAB) = value.e_lim
"""Get [`ReactiveRenewableTypeAB`](@ref) `dbd1`."""
get_dbd1(value::ReactiveRenewableTypeAB) = value.dbd1
"""Get [`ReactiveRenewableTypeAB`](@ref) `dbd2`."""
get_dbd2(value::ReactiveRenewableTypeAB) = value.dbd2
"""Get [`ReactiveRenewableTypeAB`](@ref) `Q_lim`."""
get_Q_lim(value::ReactiveRenewableTypeAB) = value.Q_lim
"""Get [`ReactiveRenewableTypeAB`](@ref) `T_p`."""
get_T_p(value::ReactiveRenewableTypeAB) = value.T_p
"""Get [`ReactiveRenewableTypeAB`](@ref) `Q_lim_inner`."""
get_Q_lim_inner(value::ReactiveRenewableTypeAB) = value.Q_lim_inner
"""Get [`ReactiveRenewableTypeAB`](@ref) `V_lim`."""
get_V_lim(value::ReactiveRenewableTypeAB) = value.V_lim
"""Get [`ReactiveRenewableTypeAB`](@ref) `K_qp`."""
get_K_qp(value::ReactiveRenewableTypeAB) = value.K_qp
"""Get [`ReactiveRenewableTypeAB`](@ref) `K_qi`."""
get_K_qi(value::ReactiveRenewableTypeAB) = value.K_qi
"""Get [`ReactiveRenewableTypeAB`](@ref) `Q_ref`."""
get_Q_ref(value::ReactiveRenewableTypeAB) = value.Q_ref
"""Get [`ReactiveRenewableTypeAB`](@ref) `ext`."""
get_ext(value::ReactiveRenewableTypeAB) = value.ext
"""Get [`ReactiveRenewableTypeAB`](@ref) `states`."""
get_states(value::ReactiveRenewableTypeAB) = value.states
"""Get [`ReactiveRenewableTypeAB`](@ref) `n_states`."""
get_n_states(value::ReactiveRenewableTypeAB) = value.n_states

"""Set [`ReactiveRenewableTypeAB`](@ref) `bus_control`."""
set_bus_control!(value::ReactiveRenewableTypeAB, val) = value.bus_control = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `from_branch_control`."""
set_from_branch_control!(value::ReactiveRenewableTypeAB, val) = value.from_branch_control = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `to_branch_control`."""
set_to_branch_control!(value::ReactiveRenewableTypeAB, val) = value.to_branch_control = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `branch_id_control`."""
set_branch_id_control!(value::ReactiveRenewableTypeAB, val) = value.branch_id_control = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `VC_Flag`."""
set_VC_Flag!(value::ReactiveRenewableTypeAB, val) = value.VC_Flag = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `Ref_Flag`."""
set_Ref_Flag!(value::ReactiveRenewableTypeAB, val) = value.Ref_Flag = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `PF_Flag`."""
set_PF_Flag!(value::ReactiveRenewableTypeAB, val) = value.PF_Flag = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `V_Flag`."""
set_V_Flag!(value::ReactiveRenewableTypeAB, val) = value.V_Flag = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `T_fltr`."""
set_T_fltr!(value::ReactiveRenewableTypeAB, val) = value.T_fltr = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `K_p`."""
set_K_p!(value::ReactiveRenewableTypeAB, val) = value.K_p = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `K_i`."""
set_K_i!(value::ReactiveRenewableTypeAB, val) = value.K_i = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `T_ft`."""
set_T_ft!(value::ReactiveRenewableTypeAB, val) = value.T_ft = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `T_fv`."""
set_T_fv!(value::ReactiveRenewableTypeAB, val) = value.T_fv = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `V_frz`."""
set_V_frz!(value::ReactiveRenewableTypeAB, val) = value.V_frz = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `R_c`."""
set_R_c!(value::ReactiveRenewableTypeAB, val) = value.R_c = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `X_c`."""
set_X_c!(value::ReactiveRenewableTypeAB, val) = value.X_c = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `e_lim`."""
set_e_lim!(value::ReactiveRenewableTypeAB, val) = value.e_lim = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `dbd1`."""
set_dbd1!(value::ReactiveRenewableTypeAB, val) = value.dbd1 = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `dbd2`."""
set_dbd2!(value::ReactiveRenewableTypeAB, val) = value.dbd2 = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `Q_lim`."""
set_Q_lim!(value::ReactiveRenewableTypeAB, val) = value.Q_lim = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `T_p`."""
set_T_p!(value::ReactiveRenewableTypeAB, val) = value.T_p = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `Q_lim_inner`."""
set_Q_lim_inner!(value::ReactiveRenewableTypeAB, val) = value.Q_lim_inner = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `V_lim`."""
set_V_lim!(value::ReactiveRenewableTypeAB, val) = value.V_lim = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `K_qp`."""
set_K_qp!(value::ReactiveRenewableTypeAB, val) = value.K_qp = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `K_qi`."""
set_K_qi!(value::ReactiveRenewableTypeAB, val) = value.K_qi = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `Q_ref`."""
set_Q_ref!(value::ReactiveRenewableTypeAB, val) = value.Q_ref = val
"""Set [`ReactiveRenewableTypeAB`](@ref) `ext`."""
set_ext!(value::ReactiveRenewableTypeAB, val) = value.ext = val

