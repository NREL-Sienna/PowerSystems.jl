#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ReactiveOuterBESSController <: ReactivePowerControl
        Power_Flag::Int
        T_p::Float64
        T_rv::Float64
        Kp_vr::Float64
        Ki_vr::Float64
        db_q::Float64
        Q_lim::MinMax
        Q_ref::Float64
        V_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of Reactive Power Controller from https://ieeexplore.ieee.org/document/9166575

# Arguments
- `Power_Flag::Int`: Power Flag for OuterControl: 0: constant Q, 1: constant power factor, 2: voltage regulation, validation range: `(0, 2)`
- `T_p::Float64`: Active Power measurement filter time constant (s), validation range: `(0, nothing)`
- `T_rv::Float64`: Voltage measurement filter time constant, validation range: `(0, nothing)`
- `Kp_vr::Float64`: Proportional Gain for voltage regulation, validation range: `(0, nothing)`
- `Ki_vr::Float64`: Integral Gain for voltage regulation, validation range: `(0, nothing)`
- `db_q::Float64`: dead-band for voltage controller, validation range: `(0, nothing)`
- `Q_lim::MinMax`: Upper/Lower limit on power reference `(Q_min, Q_max)`
- `Q_ref::Float64`: Reference Power Set-point, validation range: `(0, nothing)`
- `V_ref::Float64`: Reference Voltage Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the ReactiveOuterBESSController model depends on the Flag
- `n_states::Int`: The states of the ReactiveRenewableControllerAB model depends on the Flag
"""
mutable struct ReactiveOuterBESSController <: ReactivePowerControl
    "Power Flag for OuterControl: 0: constant Q, 1: constant power factor, 2: voltage regulation"
    Power_Flag::Int
    "Active Power measurement filter time constant (s)"
    T_p::Float64
    "Voltage measurement filter time constant"
    T_rv::Float64
    "Proportional Gain for voltage regulation"
    Kp_vr::Float64
    "Integral Gain for voltage regulation"
    Ki_vr::Float64
    "dead-band for voltage controller"
    db_q::Float64
    "Upper/Lower limit on power reference `(Q_min, Q_max)`"
    Q_lim::MinMax
    "Reference Power Set-point"
    Q_ref::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    ext::Dict{String, Any}
    "The states of the ReactiveOuterBESSController model depends on the Flag"
    states::Vector{Symbol}
    "The states of the ReactiveRenewableControllerAB model depends on the Flag"
    n_states::Int
end

function ReactiveOuterBESSController(Power_Flag, T_p, T_rv, Kp_vr, Ki_vr, db_q, Q_lim, Q_ref=1.0, V_ref=1.0, ext=Dict{String, Any}(), )
    ReactiveOuterBESSController(Power_Flag, T_p, T_rv, Kp_vr, Ki_vr, db_q, Q_lim, Q_ref, V_ref, ext, PowerSystems.get_ReactiveOuterBESSController_states(Power_Flag)[1], PowerSystems.get_ReactiveOuterBESSController_states(Power_Flag)[2], )
end

function ReactiveOuterBESSController(; Power_Flag, T_p, T_rv, Kp_vr, Ki_vr, db_q, Q_lim, Q_ref=1.0, V_ref=1.0, ext=Dict{String, Any}(), states=PowerSystems.get_ReactiveOuterBESSController_states(Power_Flag)[1], n_states=PowerSystems.get_ReactiveOuterBESSController_states(Power_Flag)[2], )
    ReactiveOuterBESSController(Power_Flag, T_p, T_rv, Kp_vr, Ki_vr, db_q, Q_lim, Q_ref, V_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ReactiveOuterBESSController(::Nothing)
    ReactiveOuterBESSController(;
        Power_Flag=0,
        T_p=0,
        T_rv=0,
        Kp_vr=0,
        Ki_vr=0,
        db_q=0,
        Q_lim=(min=0.0, max=0.0),
        Q_ref=0,
        V_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ReactiveOuterBESSController`](@ref) `Power_Flag`."""
get_Power_Flag(value::ReactiveOuterBESSController) = value.Power_Flag
"""Get [`ReactiveOuterBESSController`](@ref) `T_p`."""
get_T_p(value::ReactiveOuterBESSController) = value.T_p
"""Get [`ReactiveOuterBESSController`](@ref) `T_rv`."""
get_T_rv(value::ReactiveOuterBESSController) = value.T_rv
"""Get [`ReactiveOuterBESSController`](@ref) `Kp_vr`."""
get_Kp_vr(value::ReactiveOuterBESSController) = value.Kp_vr
"""Get [`ReactiveOuterBESSController`](@ref) `Ki_vr`."""
get_Ki_vr(value::ReactiveOuterBESSController) = value.Ki_vr
"""Get [`ReactiveOuterBESSController`](@ref) `db_q`."""
get_db_q(value::ReactiveOuterBESSController) = value.db_q
"""Get [`ReactiveOuterBESSController`](@ref) `Q_lim`."""
get_Q_lim(value::ReactiveOuterBESSController) = value.Q_lim
"""Get [`ReactiveOuterBESSController`](@ref) `Q_ref`."""
get_Q_ref(value::ReactiveOuterBESSController) = value.Q_ref
"""Get [`ReactiveOuterBESSController`](@ref) `V_ref`."""
get_V_ref(value::ReactiveOuterBESSController) = value.V_ref
"""Get [`ReactiveOuterBESSController`](@ref) `ext`."""
get_ext(value::ReactiveOuterBESSController) = value.ext
"""Get [`ReactiveOuterBESSController`](@ref) `states`."""
get_states(value::ReactiveOuterBESSController) = value.states
"""Get [`ReactiveOuterBESSController`](@ref) `n_states`."""
get_n_states(value::ReactiveOuterBESSController) = value.n_states

"""Set [`ReactiveOuterBESSController`](@ref) `Power_Flag`."""
set_Power_Flag!(value::ReactiveOuterBESSController, val) = value.Power_Flag = val
"""Set [`ReactiveOuterBESSController`](@ref) `T_p`."""
set_T_p!(value::ReactiveOuterBESSController, val) = value.T_p = val
"""Set [`ReactiveOuterBESSController`](@ref) `T_rv`."""
set_T_rv!(value::ReactiveOuterBESSController, val) = value.T_rv = val
"""Set [`ReactiveOuterBESSController`](@ref) `Kp_vr`."""
set_Kp_vr!(value::ReactiveOuterBESSController, val) = value.Kp_vr = val
"""Set [`ReactiveOuterBESSController`](@ref) `Ki_vr`."""
set_Ki_vr!(value::ReactiveOuterBESSController, val) = value.Ki_vr = val
"""Set [`ReactiveOuterBESSController`](@ref) `db_q`."""
set_db_q!(value::ReactiveOuterBESSController, val) = value.db_q = val
"""Set [`ReactiveOuterBESSController`](@ref) `Q_lim`."""
set_Q_lim!(value::ReactiveOuterBESSController, val) = value.Q_lim = val
"""Set [`ReactiveOuterBESSController`](@ref) `Q_ref`."""
set_Q_ref!(value::ReactiveOuterBESSController, val) = value.Q_ref = val
"""Set [`ReactiveOuterBESSController`](@ref) `V_ref`."""
set_V_ref!(value::ReactiveOuterBESSController, val) = value.V_ref = val
"""Set [`ReactiveOuterBESSController`](@ref) `ext`."""
set_ext!(value::ReactiveOuterBESSController, val) = value.ext = val
