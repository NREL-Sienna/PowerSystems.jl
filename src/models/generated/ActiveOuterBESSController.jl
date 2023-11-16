#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ActiveOuterBESSController <: ActivePowerControl
        Power_Flag::Int
        T_rf::Float64
        K_osc::Float64
        K_w::Float64
        T_w::Float64
        T_l1::Float64
        T_l2::Float64
        T_lg1::Float64
        T_lg2::Float64
        K_d::Float64
        K_wd::Float64
        K_pf::Float64
        K_if::Float64
        db_p::Float64
        P_lim::MinMax
        dP_lim::MinMax
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of Active Power Controller from https://ieeexplore.ieee.org/document/9166575

# Arguments
- `Power_Flag::Int`: Power Flag for OuterControl: 0: constant P, 1: oscillation damping, 2: frequency reg., 3: oscillation damping + freq reg, validation range: `(0, 3)`
- `T_rf::Float64`: Frequency error filter time constant (s), validation range: `(0, nothing)`
- `K_osc::Float64`: Oscillation damping gain, validation range: `(0, nothing)`
- `K_w::Float64`: Washout filter damping gain, validation range: `(0, nothing)`
- `T_w::Float64`: Washout filter damping time constant (s), validation range: `(0, nothing)`
- `T_l1::Float64`: Numerator Time constant for Power Oscillation damping lead block (s), validation range: `(0, nothing)`
- `T_l2::Float64`: Denominator Time constant for Power Oscillation damping lead block (s), validation range: `(0, nothing)`
- `T_lg1::Float64`: Numerator Time constant for Power Oscillation damping lag block (s), validation range: `(0, nothing)`
- `T_lg2::Float64`: Denominator Time constant for Power Oscillation damping lag block (s), validation range: `(0, nothing)`
- `K_d::Float64`: Steady-state frequency droop constant, validation range: `(0, nothing)`
- `K_wd::Float64`: Integrator anti-windup gain, validation range: `(0, nothing)`
- `K_pf::Float64`: Proportional gain for frequency control, validation range: `(0, nothing)`
- `K_if::Float64`: Integral gain for frequency control, validation range: `(0, nothing)`
- `db_p::Float64`: dead-band for frequency controller, validation range: `(0, nothing)`
- `P_lim::MinMax`: Upper/Lower limit on power reference `(P_min, P_max)`
- `dP_lim::MinMax`: Upper/Lower limit on power reference ramp rates`(dP_min, dP_max)`
- `P_ref::Float64`: Reference Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the ActiveOuterBESSController model depends on the Flag
- `n_states::Int`: The states of the ActiveRenewableControllerAB model depends on the Flag
"""
mutable struct ActiveOuterBESSController <: ActivePowerControl
    "Power Flag for OuterControl: 0: constant P, 1: oscillation damping, 2: frequency reg., 3: oscillation damping + freq reg"
    Power_Flag::Int
    "Frequency error filter time constant (s)"
    T_rf::Float64
    "Oscillation damping gain"
    K_osc::Float64
    "Washout filter damping gain"
    K_w::Float64
    "Washout filter damping time constant (s)"
    T_w::Float64
    "Numerator Time constant for Power Oscillation damping lead block (s)"
    T_l1::Float64
    "Denominator Time constant for Power Oscillation damping lead block (s)"
    T_l2::Float64
    "Numerator Time constant for Power Oscillation damping lag block (s)"
    T_lg1::Float64
    "Denominator Time constant for Power Oscillation damping lag block (s)"
    T_lg2::Float64
    "Steady-state frequency droop constant"
    K_d::Float64
    "Integrator anti-windup gain"
    K_wd::Float64
    "Proportional gain for frequency control"
    K_pf::Float64
    "Integral gain for frequency control"
    K_if::Float64
    "dead-band for frequency controller"
    db_p::Float64
    "Upper/Lower limit on power reference `(P_min, P_max)`"
    P_lim::MinMax
    "Upper/Lower limit on power reference ramp rates`(dP_min, dP_max)`"
    dP_lim::MinMax
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    "The states of the ActiveOuterBESSController model depends on the Flag"
    states::Vector{Symbol}
    "The states of the ActiveRenewableControllerAB model depends on the Flag"
    n_states::Int
end

function ActiveOuterBESSController(Power_Flag, T_rf, K_osc, K_w, T_w, T_l1, T_l2, T_lg1, T_lg2, K_d, K_wd, K_pf, K_if, db_p, P_lim, dP_lim, P_ref=1.0, ext=Dict{String, Any}(), )
    ActiveOuterBESSController(Power_Flag, T_rf, K_osc, K_w, T_w, T_l1, T_l2, T_lg1, T_lg2, K_d, K_wd, K_pf, K_if, db_p, P_lim, dP_lim, P_ref, ext, PowerSystems.get_ActiveOuterBESSController_states(Power_Flag)[1], PowerSystems.get_ActiveOuterBESSController_states(Power_Flag)[2], )
end

function ActiveOuterBESSController(; Power_Flag, T_rf, K_osc, K_w, T_w, T_l1, T_l2, T_lg1, T_lg2, K_d, K_wd, K_pf, K_if, db_p, P_lim, dP_lim, P_ref=1.0, ext=Dict{String, Any}(), states=PowerSystems.get_ActiveOuterBESSController_states(Power_Flag)[1], n_states=PowerSystems.get_ActiveOuterBESSController_states(Power_Flag)[2], )
    ActiveOuterBESSController(Power_Flag, T_rf, K_osc, K_w, T_w, T_l1, T_l2, T_lg1, T_lg2, K_d, K_wd, K_pf, K_if, db_p, P_lim, dP_lim, P_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ActiveOuterBESSController(::Nothing)
    ActiveOuterBESSController(;
        Power_Flag=0,
        T_rf=0,
        K_osc=0,
        K_w=0,
        T_w=0,
        T_l1=0,
        T_l2=0,
        T_lg1=0,
        T_lg2=0,
        K_d=0,
        K_wd=0,
        K_pf=0,
        K_if=0,
        db_p=0,
        P_lim=(min=0.0, max=0.0),
        dP_lim=(min=0.0, max=0.0),
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ActiveOuterBESSController`](@ref) `Power_Flag`."""
get_Power_Flag(value::ActiveOuterBESSController) = value.Power_Flag
"""Get [`ActiveOuterBESSController`](@ref) `T_rf`."""
get_T_rf(value::ActiveOuterBESSController) = value.T_rf
"""Get [`ActiveOuterBESSController`](@ref) `K_osc`."""
get_K_osc(value::ActiveOuterBESSController) = value.K_osc
"""Get [`ActiveOuterBESSController`](@ref) `K_w`."""
get_K_w(value::ActiveOuterBESSController) = value.K_w
"""Get [`ActiveOuterBESSController`](@ref) `T_w`."""
get_T_w(value::ActiveOuterBESSController) = value.T_w
"""Get [`ActiveOuterBESSController`](@ref) `T_l1`."""
get_T_l1(value::ActiveOuterBESSController) = value.T_l1
"""Get [`ActiveOuterBESSController`](@ref) `T_l2`."""
get_T_l2(value::ActiveOuterBESSController) = value.T_l2
"""Get [`ActiveOuterBESSController`](@ref) `T_lg1`."""
get_T_lg1(value::ActiveOuterBESSController) = value.T_lg1
"""Get [`ActiveOuterBESSController`](@ref) `T_lg2`."""
get_T_lg2(value::ActiveOuterBESSController) = value.T_lg2
"""Get [`ActiveOuterBESSController`](@ref) `K_d`."""
get_K_d(value::ActiveOuterBESSController) = value.K_d
"""Get [`ActiveOuterBESSController`](@ref) `K_wd`."""
get_K_wd(value::ActiveOuterBESSController) = value.K_wd
"""Get [`ActiveOuterBESSController`](@ref) `K_pf`."""
get_K_pf(value::ActiveOuterBESSController) = value.K_pf
"""Get [`ActiveOuterBESSController`](@ref) `K_if`."""
get_K_if(value::ActiveOuterBESSController) = value.K_if
"""Get [`ActiveOuterBESSController`](@ref) `db_p`."""
get_db_p(value::ActiveOuterBESSController) = value.db_p
"""Get [`ActiveOuterBESSController`](@ref) `P_lim`."""
get_P_lim(value::ActiveOuterBESSController) = value.P_lim
"""Get [`ActiveOuterBESSController`](@ref) `dP_lim`."""
get_dP_lim(value::ActiveOuterBESSController) = value.dP_lim
"""Get [`ActiveOuterBESSController`](@ref) `P_ref`."""
get_P_ref(value::ActiveOuterBESSController) = value.P_ref
"""Get [`ActiveOuterBESSController`](@ref) `ext`."""
get_ext(value::ActiveOuterBESSController) = value.ext
"""Get [`ActiveOuterBESSController`](@ref) `states`."""
get_states(value::ActiveOuterBESSController) = value.states
"""Get [`ActiveOuterBESSController`](@ref) `n_states`."""
get_n_states(value::ActiveOuterBESSController) = value.n_states

"""Set [`ActiveOuterBESSController`](@ref) `Power_Flag`."""
set_Power_Flag!(value::ActiveOuterBESSController, val) = value.Power_Flag = val
"""Set [`ActiveOuterBESSController`](@ref) `T_rf`."""
set_T_rf!(value::ActiveOuterBESSController, val) = value.T_rf = val
"""Set [`ActiveOuterBESSController`](@ref) `K_osc`."""
set_K_osc!(value::ActiveOuterBESSController, val) = value.K_osc = val
"""Set [`ActiveOuterBESSController`](@ref) `K_w`."""
set_K_w!(value::ActiveOuterBESSController, val) = value.K_w = val
"""Set [`ActiveOuterBESSController`](@ref) `T_w`."""
set_T_w!(value::ActiveOuterBESSController, val) = value.T_w = val
"""Set [`ActiveOuterBESSController`](@ref) `T_l1`."""
set_T_l1!(value::ActiveOuterBESSController, val) = value.T_l1 = val
"""Set [`ActiveOuterBESSController`](@ref) `T_l2`."""
set_T_l2!(value::ActiveOuterBESSController, val) = value.T_l2 = val
"""Set [`ActiveOuterBESSController`](@ref) `T_lg1`."""
set_T_lg1!(value::ActiveOuterBESSController, val) = value.T_lg1 = val
"""Set [`ActiveOuterBESSController`](@ref) `T_lg2`."""
set_T_lg2!(value::ActiveOuterBESSController, val) = value.T_lg2 = val
"""Set [`ActiveOuterBESSController`](@ref) `K_d`."""
set_K_d!(value::ActiveOuterBESSController, val) = value.K_d = val
"""Set [`ActiveOuterBESSController`](@ref) `K_wd`."""
set_K_wd!(value::ActiveOuterBESSController, val) = value.K_wd = val
"""Set [`ActiveOuterBESSController`](@ref) `K_pf`."""
set_K_pf!(value::ActiveOuterBESSController, val) = value.K_pf = val
"""Set [`ActiveOuterBESSController`](@ref) `K_if`."""
set_K_if!(value::ActiveOuterBESSController, val) = value.K_if = val
"""Set [`ActiveOuterBESSController`](@ref) `db_p`."""
set_db_p!(value::ActiveOuterBESSController, val) = value.db_p = val
"""Set [`ActiveOuterBESSController`](@ref) `P_lim`."""
set_P_lim!(value::ActiveOuterBESSController, val) = value.P_lim = val
"""Set [`ActiveOuterBESSController`](@ref) `dP_lim`."""
set_dP_lim!(value::ActiveOuterBESSController, val) = value.dP_lim = val
"""Set [`ActiveOuterBESSController`](@ref) `P_ref`."""
set_P_ref!(value::ActiveOuterBESSController, val) = value.P_ref = val
"""Set [`ActiveOuterBESSController`](@ref) `ext`."""
set_ext!(value::ActiveOuterBESSController, val) = value.ext = val
