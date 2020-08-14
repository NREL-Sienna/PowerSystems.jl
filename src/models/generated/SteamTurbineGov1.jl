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
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Steam Turbine-Governor. 

# Arguments
- `R::Float64`: Droop parameter, validation range: `(0, nothing)`
- `T1::Float64`: Governor time constant, validation range: `("eps()", nothing)`, action if invalid: `error`
- `valve_position_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Valve position limits
- `T2::Float64`: Lead Lag Lead Time constant , validation range: `(0, nothing)`
- `T3::Float64`: Lead Lag Lag Time constant , validation range: `("eps()", nothing)`, action if invalid: `error`
- `D_T::Float64`: Turbine Damping, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the SteamTurbineGov1 model are:
	x_g1: Valve Opening,
	Pm: Turbine Power
- `n_states::Int64`: TGOV1 has 2 states
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
    ext::Dict{String, Any}
    "The states of the SteamTurbineGov1 model are:
	x_g1: Valve Opening,
	Pm: Turbine Power"
    states::Vector{Symbol}
    "TGOV1 has 2 states"
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function SteamTurbineGov1(R, T1, valve_position_limits, T2, T3, D_T=1.0, ext=Dict{String, Any}(), )
    SteamTurbineGov1(R, T1, valve_position_limits, T2, T3, D_T, ext, [:x_g1, :Pm], 2, InfrastructureSystemsInternal(), )
end

function SteamTurbineGov1(; R, T1, valve_position_limits, T2, T3, D_T=1.0, ext=Dict{String, Any}(), )
    SteamTurbineGov1(R, T1, valve_position_limits, T2, T3, D_T, ext, )
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
"""Get [`SteamTurbineGov1`](@ref) `ext`."""
get_ext(value::SteamTurbineGov1) = value.ext
"""Get [`SteamTurbineGov1`](@ref) `states`."""
get_states(value::SteamTurbineGov1) = value.states
"""Get [`SteamTurbineGov1`](@ref) `n_states`."""
get_n_states(value::SteamTurbineGov1) = value.n_states
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
"""Set [`SteamTurbineGov1`](@ref) `ext`."""
set_ext!(value::SteamTurbineGov1, val) = value.ext = val
"""Set [`SteamTurbineGov1`](@ref) `states`."""
set_states!(value::SteamTurbineGov1, val) = value.states = val
"""Set [`SteamTurbineGov1`](@ref) `n_states`."""
set_n_states!(value::SteamTurbineGov1, val) = value.n_states = val
"""Set [`SteamTurbineGov1`](@ref) `internal`."""
set_internal!(value::SteamTurbineGov1, val) = value.internal = val
