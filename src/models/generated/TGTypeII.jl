#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TGTypeII <: TurbineGov
        R::Float64
        T1::Float64
        T2::Float64
        τ_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of a Turbine Governor Type II.

# Arguments
- `R::Float64`: Droop parameter, validation range: (0, nothing)
- `T1::Float64`: Transient gain time constant, validation range: (0, nothing)
- `T2::Float64`: Power fraction time constant, validation range: (0, nothing)
- `τ_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}`: Power into the governor limits
- `P_ref::Float64`: Reference Power Set-point, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the TGTypeI model are:
	x_g1: lead-lag state
- `n_states::Int`: TGTypeII has 1 state
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TGTypeII <: TurbineGov
    "Droop parameter"
    R::Float64
    "Transient gain time constant"
    T1::Float64
    "Power fraction time constant"
    T2::Float64
    "Power into the governor limits"
    τ_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    "The states of the TGTypeI model are:
	x_g1: lead-lag state"
    states::Vector{Symbol}
    "TGTypeII has 1 state"
    n_states::Int
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TGTypeII(R, T1, T2, τ_limits, P_ref=1.0, ext=Dict{String, Any}(), )
    TGTypeII(R, T1, T2, τ_limits, P_ref, ext, [:xg], 1, InfrastructureSystemsInternal(), )
end

function TGTypeII(; R, T1, T2, τ_limits, P_ref=1.0, ext=Dict{String, Any}(), )
    TGTypeII(R, T1, T2, τ_limits, P_ref, ext, )
end

# Constructor for demo purposes; non-functional.
function TGTypeII(::Nothing)
    TGTypeII(;
        R=0,
        T1=0,
        T2=0,
        τ_limits=(min=0.0, max=0.0),
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get TGTypeII R."""
get_R(value::TGTypeII) = value.R
"""Get TGTypeII T1."""
get_T1(value::TGTypeII) = value.T1
"""Get TGTypeII T2."""
get_T2(value::TGTypeII) = value.T2
"""Get TGTypeII τ_limits."""
get_τ_limits(value::TGTypeII) = value.τ_limits
"""Get TGTypeII P_ref."""
get_P_ref(value::TGTypeII) = value.P_ref
"""Get TGTypeII ext."""
get_ext(value::TGTypeII) = value.ext
"""Get TGTypeII states."""
get_states(value::TGTypeII) = value.states
"""Get TGTypeII n_states."""
get_n_states(value::TGTypeII) = value.n_states
"""Get TGTypeII internal."""
get_internal(value::TGTypeII) = value.internal

"""Set TGTypeII R."""
set_R!(value::TGTypeII, val::Float64) = value.R = val
"""Set TGTypeII T1."""
set_T1!(value::TGTypeII, val::Float64) = value.T1 = val
"""Set TGTypeII T2."""
set_T2!(value::TGTypeII, val::Float64) = value.T2 = val
"""Set TGTypeII τ_limits."""
set_τ_limits!(value::TGTypeII, val::NamedTuple{(:min, :max), Tuple{Float64, Float64}}) = value.τ_limits = val
"""Set TGTypeII P_ref."""
set_P_ref!(value::TGTypeII, val::Float64) = value.P_ref = val
"""Set TGTypeII ext."""
set_ext!(value::TGTypeII, val::Dict{String, Any}) = value.ext = val
"""Set TGTypeII states."""
set_states!(value::TGTypeII, val::Vector{Symbol}) = value.states = val
"""Set TGTypeII n_states."""
set_n_states!(value::TGTypeII, val::Int) = value.n_states = val
"""Set TGTypeII internal."""
set_internal!(value::TGTypeII, val::InfrastructureSystemsInternal) = value.internal = val
