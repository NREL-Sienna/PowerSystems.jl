#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TGTypeII <: TurbineGov
        R::Float64
        T1::Float64
        T2::Float64
        τ_min::Float64
        τ_max::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a Turbine Governor Type II.

# Arguments
- `R::Float64`: Droop parameter
- `T1::Float64`: Transient gain time constant
- `T2::Float64`: Power fraction time constant
- `τ_min::Float64`: Min Power into the Governor
- `τ_max::Float64`: Max Power into the Governor
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TGTypeII <: TurbineGov
    "Droop parameter"
    R::Float64
    "Transient gain time constant"
    T1::Float64
    "Power fraction time constant"
    T2::Float64
    "Min Power into the Governor"
    τ_min::Float64
    "Max Power into the Governor"
    τ_max::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TGTypeII(R, T1, T2, τ_min, τ_max, ext=Dict{String, Any}(), )
    TGTypeII(R, T1, T2, τ_min, τ_max, ext, [:xg], 1, InfrastructureSystemsInternal(), )
end

function TGTypeII(; R, T1, T2, τ_min, τ_max, ext=Dict{String, Any}(), )
    TGTypeII(R, T1, T2, τ_min, τ_max, ext, )
end

# Constructor for demo purposes; non-functional.
function TGTypeII(::Nothing)
    TGTypeII(;
        R=0,
        T1=0,
        T2=0,
        τ_min=0,
        τ_max=0,
        ext=Dict{String, Any}(),
    )
end

"""Get TGTypeII R."""
get_R(value::TGTypeII) = value.R
"""Get TGTypeII T1."""
get_T1(value::TGTypeII) = value.T1
"""Get TGTypeII T2."""
get_T2(value::TGTypeII) = value.T2
"""Get TGTypeII τ_min."""
get_τ_min(value::TGTypeII) = value.τ_min
"""Get TGTypeII τ_max."""
get_τ_max(value::TGTypeII) = value.τ_max
"""Get TGTypeII ext."""
get_ext(value::TGTypeII) = value.ext
"""Get TGTypeII states."""
get_states(value::TGTypeII) = value.states
"""Get TGTypeII n_states."""
get_n_states(value::TGTypeII) = value.n_states
"""Get TGTypeII internal."""
get_internal(value::TGTypeII) = value.internal
