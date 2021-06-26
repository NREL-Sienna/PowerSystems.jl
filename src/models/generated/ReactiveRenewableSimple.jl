#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ReactiveRenewableSimple <: ReactivePowerControl
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
        T_p::Float64
        Q_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
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
- `T_p::Float64`: Active power lag time constant in REECB (s). Used only when PF_Flag = 1, validation range: `(0, nothing)`
- `Q_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Upper/Lower limit on reactive power input in REECB `(Q_min, Q_max)`. Only used when V_Flag = 1
- `V_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Upper/Lower limit on reactive power PI controller in REECB `(V_min, V_max)`. Only used when V_Flag = 1
- `K_qp::Float64`: Reactive power regulator proportional gain (used when V_Flag = 1), validation range: `(0, nothing)`
- `K_qi::Float64`: Reactive power regulator integral gain (used when V_Flag = 1), validation range: `(0, nothing)`
- `Q_ref::Float64`: Reference Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the ReactiveRenewableSimple model depends on the Flag
- `n_states::Int`: The states of the ReactiveRenewableSimple model depends on the Flag
"""
mutable struct ReactiveRenewableSimple <: ReactivePowerControl
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
    "Active power lag time constant in REECB (s). Used only when PF_Flag = 1"
    T_p::Float64
    "Upper/Lower limit on reactive power input in REECB `(Q_min, Q_max)`. Only used when V_Flag = 1"
    Q_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Upper/Lower limit on reactive power PI controller in REECB `(V_min, V_max)`. Only used when V_Flag = 1"
    V_lim::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Reactive power regulator proportional gain (used when V_Flag = 1)"
    K_qp::Float64
    "Reactive power regulator integral gain (used when V_Flag = 1)"
    K_qi::Float64
    "Reference Power Set-point"
    Q_ref::Float64
    ext::Dict{String, Any}
    "The states of the ReactiveRenewableSimple model depends on the Flag"
    states::Vector{Symbol}
    "The states of the ReactiveRenewableSimple model depends on the Flag"
    n_states::Int
end

function ReactiveRenewableSimple(bus_control, from_branch_control, to_branch_control, branch_id_control, VC_Flag, Ref_Flag, PF_Flag, V_Flag, T_fltr, K_p, K_i, T_ft, T_fv, V_frz, R_c, X_c, e_lim, dbd1, dbd2, T_p, Q_lim, V_lim, K_qp, K_qi, Q_ref=1.0, ext=Dict{String, Any}(), )
    ReactiveRenewableSimple(bus_control, from_branch_control, to_branch_control, branch_id_control, VC_Flag, Ref_Flag, PF_Flag, V_Flag, T_fltr, K_p, K_i, T_ft, T_fv, V_frz, R_c, X_c, e_lim, dbd1, dbd2, T_p, Q_lim, V_lim, K_qp, K_qi, Q_ref, ext, PowerSystems.get_reactiveRESimple_states(Ref_Flag, PF_Flag, V_Flag)[1], PowerSystems.get_reactiveRESimple_states(Ref_Flag, PF_Flag, V_Flag)[2], )
end

function ReactiveRenewableSimple(; bus_control, from_branch_control, to_branch_control, branch_id_control, VC_Flag, Ref_Flag, PF_Flag, V_Flag, T_fltr, K_p, K_i, T_ft, T_fv, V_frz, R_c, X_c, e_lim, dbd1, dbd2, T_p, Q_lim, V_lim, K_qp, K_qi, Q_ref=1.0, ext=Dict{String, Any}(), states=PowerSystems.get_reactiveRESimple_states(Ref_Flag, PF_Flag, V_Flag)[1], n_states=PowerSystems.get_reactiveRESimple_states(Ref_Flag, PF_Flag, V_Flag)[2], )
    ReactiveRenewableSimple(bus_control, from_branch_control, to_branch_control, branch_id_control, VC_Flag, Ref_Flag, PF_Flag, V_Flag, T_fltr, K_p, K_i, T_ft, T_fv, V_frz, R_c, X_c, e_lim, dbd1, dbd2, T_p, Q_lim, V_lim, K_qp, K_qi, Q_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ReactiveRenewableSimple(::Nothing)
    ReactiveRenewableSimple(;
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
        T_p=0,
        Q_lim=(min=0.0, max=0.0),
        V_lim=(min=0.0, max=0.0),
        K_qp=0,
        K_qi=0,
        Q_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ReactiveRenewableSimple`](@ref) `bus_control`."""
get_bus_control(value::ReactiveRenewableSimple) = value.bus_control
"""Get [`ReactiveRenewableSimple`](@ref) `from_branch_control`."""
get_from_branch_control(value::ReactiveRenewableSimple) = value.from_branch_control
"""Get [`ReactiveRenewableSimple`](@ref) `to_branch_control`."""
get_to_branch_control(value::ReactiveRenewableSimple) = value.to_branch_control
"""Get [`ReactiveRenewableSimple`](@ref) `branch_id_control`."""
get_branch_id_control(value::ReactiveRenewableSimple) = value.branch_id_control
"""Get [`ReactiveRenewableSimple`](@ref) `VC_Flag`."""
get_VC_Flag(value::ReactiveRenewableSimple) = value.VC_Flag
"""Get [`ReactiveRenewableSimple`](@ref) `Ref_Flag`."""
get_Ref_Flag(value::ReactiveRenewableSimple) = value.Ref_Flag
"""Get [`ReactiveRenewableSimple`](@ref) `PF_Flag`."""
get_PF_Flag(value::ReactiveRenewableSimple) = value.PF_Flag
"""Get [`ReactiveRenewableSimple`](@ref) `V_Flag`."""
get_V_Flag(value::ReactiveRenewableSimple) = value.V_Flag
"""Get [`ReactiveRenewableSimple`](@ref) `T_fltr`."""
get_T_fltr(value::ReactiveRenewableSimple) = value.T_fltr
"""Get [`ReactiveRenewableSimple`](@ref) `K_p`."""
get_K_p(value::ReactiveRenewableSimple) = value.K_p
"""Get [`ReactiveRenewableSimple`](@ref) `K_i`."""
get_K_i(value::ReactiveRenewableSimple) = value.K_i
"""Get [`ReactiveRenewableSimple`](@ref) `T_ft`."""
get_T_ft(value::ReactiveRenewableSimple) = value.T_ft
"""Get [`ReactiveRenewableSimple`](@ref) `T_fv`."""
get_T_fv(value::ReactiveRenewableSimple) = value.T_fv
"""Get [`ReactiveRenewableSimple`](@ref) `V_frz`."""
get_V_frz(value::ReactiveRenewableSimple) = value.V_frz
"""Get [`ReactiveRenewableSimple`](@ref) `R_c`."""
get_R_c(value::ReactiveRenewableSimple) = value.R_c
"""Get [`ReactiveRenewableSimple`](@ref) `X_c`."""
get_X_c(value::ReactiveRenewableSimple) = value.X_c
"""Get [`ReactiveRenewableSimple`](@ref) `e_lim`."""
get_e_lim(value::ReactiveRenewableSimple) = value.e_lim
"""Get [`ReactiveRenewableSimple`](@ref) `dbd1`."""
get_dbd1(value::ReactiveRenewableSimple) = value.dbd1
"""Get [`ReactiveRenewableSimple`](@ref) `dbd2`."""
get_dbd2(value::ReactiveRenewableSimple) = value.dbd2
"""Get [`ReactiveRenewableSimple`](@ref) `T_p`."""
get_T_p(value::ReactiveRenewableSimple) = value.T_p
"""Get [`ReactiveRenewableSimple`](@ref) `Q_lim`."""
get_Q_lim(value::ReactiveRenewableSimple) = value.Q_lim
"""Get [`ReactiveRenewableSimple`](@ref) `V_lim`."""
get_V_lim(value::ReactiveRenewableSimple) = value.V_lim
"""Get [`ReactiveRenewableSimple`](@ref) `K_qp`."""
get_K_qp(value::ReactiveRenewableSimple) = value.K_qp
"""Get [`ReactiveRenewableSimple`](@ref) `K_qi`."""
get_K_qi(value::ReactiveRenewableSimple) = value.K_qi
"""Get [`ReactiveRenewableSimple`](@ref) `Q_ref`."""
get_Q_ref(value::ReactiveRenewableSimple) = value.Q_ref
"""Get [`ReactiveRenewableSimple`](@ref) `ext`."""
get_ext(value::ReactiveRenewableSimple) = value.ext
"""Get [`ReactiveRenewableSimple`](@ref) `states`."""
get_states(value::ReactiveRenewableSimple) = value.states
"""Get [`ReactiveRenewableSimple`](@ref) `n_states`."""
get_n_states(value::ReactiveRenewableSimple) = value.n_states

"""Set [`ReactiveRenewableSimple`](@ref) `bus_control`."""
set_bus_control!(value::ReactiveRenewableSimple, val) = value.bus_control = val
"""Set [`ReactiveRenewableSimple`](@ref) `from_branch_control`."""
set_from_branch_control!(value::ReactiveRenewableSimple, val) = value.from_branch_control = val
"""Set [`ReactiveRenewableSimple`](@ref) `to_branch_control`."""
set_to_branch_control!(value::ReactiveRenewableSimple, val) = value.to_branch_control = val
"""Set [`ReactiveRenewableSimple`](@ref) `branch_id_control`."""
set_branch_id_control!(value::ReactiveRenewableSimple, val) = value.branch_id_control = val
"""Set [`ReactiveRenewableSimple`](@ref) `VC_Flag`."""
set_VC_Flag!(value::ReactiveRenewableSimple, val) = value.VC_Flag = val
"""Set [`ReactiveRenewableSimple`](@ref) `Ref_Flag`."""
set_Ref_Flag!(value::ReactiveRenewableSimple, val) = value.Ref_Flag = val
"""Set [`ReactiveRenewableSimple`](@ref) `PF_Flag`."""
set_PF_Flag!(value::ReactiveRenewableSimple, val) = value.PF_Flag = val
"""Set [`ReactiveRenewableSimple`](@ref) `V_Flag`."""
set_V_Flag!(value::ReactiveRenewableSimple, val) = value.V_Flag = val
"""Set [`ReactiveRenewableSimple`](@ref) `T_fltr`."""
set_T_fltr!(value::ReactiveRenewableSimple, val) = value.T_fltr = val
"""Set [`ReactiveRenewableSimple`](@ref) `K_p`."""
set_K_p!(value::ReactiveRenewableSimple, val) = value.K_p = val
"""Set [`ReactiveRenewableSimple`](@ref) `K_i`."""
set_K_i!(value::ReactiveRenewableSimple, val) = value.K_i = val
"""Set [`ReactiveRenewableSimple`](@ref) `T_ft`."""
set_T_ft!(value::ReactiveRenewableSimple, val) = value.T_ft = val
"""Set [`ReactiveRenewableSimple`](@ref) `T_fv`."""
set_T_fv!(value::ReactiveRenewableSimple, val) = value.T_fv = val
"""Set [`ReactiveRenewableSimple`](@ref) `V_frz`."""
set_V_frz!(value::ReactiveRenewableSimple, val) = value.V_frz = val
"""Set [`ReactiveRenewableSimple`](@ref) `R_c`."""
set_R_c!(value::ReactiveRenewableSimple, val) = value.R_c = val
"""Set [`ReactiveRenewableSimple`](@ref) `X_c`."""
set_X_c!(value::ReactiveRenewableSimple, val) = value.X_c = val
"""Set [`ReactiveRenewableSimple`](@ref) `e_lim`."""
set_e_lim!(value::ReactiveRenewableSimple, val) = value.e_lim = val
"""Set [`ReactiveRenewableSimple`](@ref) `dbd1`."""
set_dbd1!(value::ReactiveRenewableSimple, val) = value.dbd1 = val
"""Set [`ReactiveRenewableSimple`](@ref) `dbd2`."""
set_dbd2!(value::ReactiveRenewableSimple, val) = value.dbd2 = val
"""Set [`ReactiveRenewableSimple`](@ref) `T_p`."""
set_T_p!(value::ReactiveRenewableSimple, val) = value.T_p = val
"""Set [`ReactiveRenewableSimple`](@ref) `Q_lim`."""
set_Q_lim!(value::ReactiveRenewableSimple, val) = value.Q_lim = val
"""Set [`ReactiveRenewableSimple`](@ref) `V_lim`."""
set_V_lim!(value::ReactiveRenewableSimple, val) = value.V_lim = val
"""Set [`ReactiveRenewableSimple`](@ref) `K_qp`."""
set_K_qp!(value::ReactiveRenewableSimple, val) = value.K_qp = val
"""Set [`ReactiveRenewableSimple`](@ref) `K_qi`."""
set_K_qi!(value::ReactiveRenewableSimple, val) = value.K_qi = val
"""Set [`ReactiveRenewableSimple`](@ref) `Q_ref`."""
set_Q_ref!(value::ReactiveRenewableSimple, val) = value.Q_ref = val
"""Set [`ReactiveRenewableSimple`](@ref) `ext`."""
set_ext!(value::ReactiveRenewableSimple, val) = value.ext = val

