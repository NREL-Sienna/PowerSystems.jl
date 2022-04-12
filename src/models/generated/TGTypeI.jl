#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TGTypeI <: TurbineGov
        R::Float64
        Ts::Float64
        Tc::Float64
        T3::Float64
        T4::Float64
        T5::Float64
        valve_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of a Turbine Governor Type I.

# Arguments
- `R::Float64`: Droop parameter, validation range: `(0, nothing)`
- `Ts::Float64`: Governor time constant, validation range: `(0, nothing)`
- `Tc::Float64`: Servo time constant, validation range: `(0, nothing)`
- `T3::Float64`: Transient gain time constant, validation range: `(0, nothing)`
- `T4::Float64`: Power fraction time constant, validation range: `(0, nothing)`
- `T5::Float64`: Reheat time constant, validation range: `(0, nothing)`
- `valve_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Valve position limits in MW
- `P_ref::Float64`: Reference Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the TGTypeI model are:
	x_g1: Governor state,
	x_g2: Servo state,
	x_g3: Reheat state
- `n_states::Int`: TGTypeI has 3 states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TGTypeI <: TurbineGov
    "Droop parameter"
    R::Float64
    "Governor time constant"
    Ts::Float64
    "Servo time constant"
    Tc::Float64
    "Transient gain time constant"
    T3::Float64
    "Power fraction time constant"
    T4::Float64
    "Reheat time constant"
    T5::Float64
    "Valve position limits in MW"
    valve_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    "The states of the TGTypeI model are:
	x_g1: Governor state,
	x_g2: Servo state,
	x_g3: Reheat state"
    states::Vector{Symbol}
    "TGTypeI has 3 states"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TGTypeI(R, Ts, Tc, T3, T4, T5, valve_position_limits, P_ref=1.0, ext=Dict{String, Any}(), )
    TGTypeI(R, Ts, Tc, T3, T4, T5, valve_position_limits, P_ref, ext, [:x_g1, :x_g2, :x_g3], 3, InfrastructureSystemsInternal(), )
end

function TGTypeI(; R, Ts, Tc, T3, T4, T5, valve_position_limits, P_ref=1.0, ext=Dict{String, Any}(), states=[:x_g1, :x_g2, :x_g3], n_states=3, internal=InfrastructureSystemsInternal(), )
    TGTypeI(R, Ts, Tc, T3, T4, T5, valve_position_limits, P_ref, ext, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function TGTypeI(::Nothing)
    TGTypeI(;
        R=0,
        Ts=0,
        Tc=0,
        T3=0,
        T4=0,
        T5=0,
        valve_position_limits=(min=0.0, max=0.0),
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`TGTypeI`](@ref) `R`."""
get_R(value::TGTypeI) = value.R
"""Get [`TGTypeI`](@ref) `Ts`."""
get_Ts(value::TGTypeI) = value.Ts
"""Get [`TGTypeI`](@ref) `Tc`."""
get_Tc(value::TGTypeI) = value.Tc
"""Get [`TGTypeI`](@ref) `T3`."""
get_T3(value::TGTypeI) = value.T3
"""Get [`TGTypeI`](@ref) `T4`."""
get_T4(value::TGTypeI) = value.T4
"""Get [`TGTypeI`](@ref) `T5`."""
get_T5(value::TGTypeI) = value.T5
"""Get [`TGTypeI`](@ref) `valve_position_limits`."""
get_valve_position_limits(value::TGTypeI) = value.valve_position_limits
"""Get [`TGTypeI`](@ref) `P_ref`."""
get_P_ref(value::TGTypeI) = value.P_ref
"""Get [`TGTypeI`](@ref) `ext`."""
get_ext(value::TGTypeI) = value.ext
"""Get [`TGTypeI`](@ref) `states`."""
get_states(value::TGTypeI) = value.states
"""Get [`TGTypeI`](@ref) `n_states`."""
get_n_states(value::TGTypeI) = value.n_states
"""Get [`TGTypeI`](@ref) `internal`."""
get_internal(value::TGTypeI) = value.internal

"""Set [`TGTypeI`](@ref) `R`."""
set_R!(value::TGTypeI, val) = value.R = val
"""Set [`TGTypeI`](@ref) `Ts`."""
set_Ts!(value::TGTypeI, val) = value.Ts = val
"""Set [`TGTypeI`](@ref) `Tc`."""
set_Tc!(value::TGTypeI, val) = value.Tc = val
"""Set [`TGTypeI`](@ref) `T3`."""
set_T3!(value::TGTypeI, val) = value.T3 = val
"""Set [`TGTypeI`](@ref) `T4`."""
set_T4!(value::TGTypeI, val) = value.T4 = val
"""Set [`TGTypeI`](@ref) `T5`."""
set_T5!(value::TGTypeI, val) = value.T5 = val
"""Set [`TGTypeI`](@ref) `valve_position_limits`."""
set_valve_position_limits!(value::TGTypeI, val) = value.valve_position_limits = val
"""Set [`TGTypeI`](@ref) `P_ref`."""
set_P_ref!(value::TGTypeI, val) = value.P_ref = val
"""Set [`TGTypeI`](@ref) `ext`."""
set_ext!(value::TGTypeI, val) = value.ext = val

