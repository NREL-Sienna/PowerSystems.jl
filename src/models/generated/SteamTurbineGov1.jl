#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SteamTurbineGov1 <: TurbineGov
        R::Float64
        T1::Float64
        valve_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        T2::Float64
        T3::Float64
        D_T::Float64
        DB_h::Float64
        DB_l::Float64
        T_rate::Float64
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        states_types::Vector{StateTypes.StateType}
        internal::InfrastructureSystemsInternal
    end

Steam Turbine-Governor. This model considers both TGOV1 or TGOV1DU in PSS/E.

# Arguments
- `R::Float64`: Droop parameter, validation range: `(0, 0.1)`, action if invalid: `warn`
- `T1::Float64`: Governor time constant, validation range: `("eps()", 0.5)`, action if invalid: `error`
- `valve_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Valve position limits
- `T2::Float64`: Lead Lag Lead Time constant , validation range: `(0, nothing)`, action if invalid: `warn`
- `T3::Float64`: Lead Lag Lag Time constant , validation range: `("eps()", 10)`, action if invalid: `error`
- `D_T::Float64`: Turbine Damping, validation range: `(0, 0.5)`, action if invalid: `warn`
- `DB_h::Float64`: Deadband for overspeed, validation range: `(0, nothing)`, action if invalid: `warn`
- `DB_l::Float64`: Deadband for underspeed, validation range: `(nothing, 0)`, action if invalid: `warn`
- `T_rate::Float64`: Turbine Rate (MW). If zero, generator base is used., validation range: `(0, nothing)`, action if invalid: `warn`
- `P_ref::Float64`: Reference Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the SteamTurbineGov1 model are:
	x_g1: Valve Opening,
	x_g2: Lead-lag state
- `n_states::Int`: TGOV1 has 2 states
- `states_types::Vector{StateTypes.StateType}`: TGOV1 has 2 differential states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SteamTurbineGov1 <: TurbineGov
    "Droop parameter"
    R::Float64
    "Governor time constant"
    T1::Float64
    "Valve position limits"
    valve_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Lead Lag Lead Time constant "
    T2::Float64
    "Lead Lag Lag Time constant "
    T3::Float64
    "Turbine Damping"
    D_T::Float64
    "Deadband for overspeed"
    DB_h::Float64
    "Deadband for underspeed"
    DB_l::Float64
    "Turbine Rate (MW). If zero, generator base is used."
    T_rate::Float64
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    "The states of the SteamTurbineGov1 model are:
	x_g1: Valve Opening,
	x_g2: Lead-lag state"
    states::Vector{Symbol}
    "TGOV1 has 2 states"
    n_states::Int
    "TGOV1 has 2 differential states"
    states_types::Vector{StateTypes.StateType}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SteamTurbineGov1(R, T1, valve_position_limits, T2, T3, D_T, DB_h, DB_l, T_rate, P_ref=1.0, ext=Dict{String, Any}(), )
    SteamTurbineGov1(R, T1, valve_position_limits, T2, T3, D_T, DB_h, DB_l, T_rate, P_ref, ext, [:x_g1, :x_g2], 2, [StateTypes.Differential, StateTypes.Differential], InfrastructureSystemsInternal(), )
end

function SteamTurbineGov1(; R, T1, valve_position_limits, T2, T3, D_T, DB_h, DB_l, T_rate, P_ref=1.0, ext=Dict{String, Any}(), states=[:x_g1, :x_g2], n_states=2, states_types=[StateTypes.Differential, StateTypes.Differential], internal=InfrastructureSystemsInternal(), )
    SteamTurbineGov1(R, T1, valve_position_limits, T2, T3, D_T, DB_h, DB_l, T_rate, P_ref, ext, states, n_states, states_types, internal, )
end

# Constructor for demo purposes; non-functional.
function SteamTurbineGov1(::Nothing)
    SteamTurbineGov1(;
        R=0,
        T1=0,
        valve_position_limits=(min=0.0, max=0.0),
        T2=0,
        T3=0,
        D_T=0,
        DB_h=0,
        DB_l=0,
        T_rate=0,
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`SteamTurbineGov1`](@ref) `R`."""
get_R(value::SteamTurbineGov1) = value.R
"""Get [`SteamTurbineGov1`](@ref) `T1`."""
get_T1(value::SteamTurbineGov1) = value.T1
"""Get [`SteamTurbineGov1`](@ref) `valve_position_limits`."""
get_valve_position_limits(value::SteamTurbineGov1) = value.valve_position_limits
"""Get [`SteamTurbineGov1`](@ref) `T2`."""
get_T2(value::SteamTurbineGov1) = value.T2
"""Get [`SteamTurbineGov1`](@ref) `T3`."""
get_T3(value::SteamTurbineGov1) = value.T3
"""Get [`SteamTurbineGov1`](@ref) `D_T`."""
get_D_T(value::SteamTurbineGov1) = value.D_T
"""Get [`SteamTurbineGov1`](@ref) `DB_h`."""
get_DB_h(value::SteamTurbineGov1) = value.DB_h
"""Get [`SteamTurbineGov1`](@ref) `DB_l`."""
get_DB_l(value::SteamTurbineGov1) = value.DB_l
"""Get [`SteamTurbineGov1`](@ref) `T_rate`."""
get_T_rate(value::SteamTurbineGov1) = value.T_rate
"""Get [`SteamTurbineGov1`](@ref) `P_ref`."""
get_P_ref(value::SteamTurbineGov1) = value.P_ref
"""Get [`SteamTurbineGov1`](@ref) `ext`."""
get_ext(value::SteamTurbineGov1) = value.ext
"""Get [`SteamTurbineGov1`](@ref) `states`."""
get_states(value::SteamTurbineGov1) = value.states
"""Get [`SteamTurbineGov1`](@ref) `n_states`."""
get_n_states(value::SteamTurbineGov1) = value.n_states
"""Get [`SteamTurbineGov1`](@ref) `states_types`."""
get_states_types(value::SteamTurbineGov1) = value.states_types
"""Get [`SteamTurbineGov1`](@ref) `internal`."""
get_internal(value::SteamTurbineGov1) = value.internal

"""Set [`SteamTurbineGov1`](@ref) `R`."""
set_R!(value::SteamTurbineGov1, val) = value.R = val
"""Set [`SteamTurbineGov1`](@ref) `T1`."""
set_T1!(value::SteamTurbineGov1, val) = value.T1 = val
"""Set [`SteamTurbineGov1`](@ref) `valve_position_limits`."""
set_valve_position_limits!(value::SteamTurbineGov1, val) = value.valve_position_limits = val
"""Set [`SteamTurbineGov1`](@ref) `T2`."""
set_T2!(value::SteamTurbineGov1, val) = value.T2 = val
"""Set [`SteamTurbineGov1`](@ref) `T3`."""
set_T3!(value::SteamTurbineGov1, val) = value.T3 = val
"""Set [`SteamTurbineGov1`](@ref) `D_T`."""
set_D_T!(value::SteamTurbineGov1, val) = value.D_T = val
"""Set [`SteamTurbineGov1`](@ref) `DB_h`."""
set_DB_h!(value::SteamTurbineGov1, val) = value.DB_h = val
"""Set [`SteamTurbineGov1`](@ref) `DB_l`."""
set_DB_l!(value::SteamTurbineGov1, val) = value.DB_l = val
"""Set [`SteamTurbineGov1`](@ref) `T_rate`."""
set_T_rate!(value::SteamTurbineGov1, val) = value.T_rate = val
"""Set [`SteamTurbineGov1`](@ref) `P_ref`."""
set_P_ref!(value::SteamTurbineGov1, val) = value.P_ref = val
"""Set [`SteamTurbineGov1`](@ref) `ext`."""
set_ext!(value::SteamTurbineGov1, val) = value.ext = val
"""Set [`SteamTurbineGov1`](@ref) `states_types`."""
set_states_types!(value::SteamTurbineGov1, val) = value.states_types = val
"""Set [`SteamTurbineGov1`](@ref) `internal`."""
set_internal!(value::SteamTurbineGov1, val) = value.internal = val

