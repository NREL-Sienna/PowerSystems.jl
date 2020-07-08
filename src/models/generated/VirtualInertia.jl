#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct VirtualInertia <: ActivePowerControl
        Ta::Float64
        kd::Float64
        kω::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
    end

Parameters of a Virtual Inertia with SRF using VSM for active power controller

# Arguments
- `Ta::Float64`: VSM inertia constant, validation range: (0, nothing)
- `kd::Float64`: VSM damping constant, validation range: (0, nothing)
- `kω::Float64`: frequency droop gain, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the VirtualInertia model are:
	ω_oc: Speed of the rotating reference frame of the virtual synchronous generator model,
	θ_oc: Phase angle displacement of the virtual synchronous generator model
- `n_states::Int64`: VirtualInertia has two states
"""
mutable struct VirtualInertia <: ActivePowerControl
    "VSM inertia constant"
    Ta::Float64
    "VSM damping constant"
    kd::Float64
    "frequency droop gain"
    kω::Float64
    ext::Dict{String, Any}
    "The states of the VirtualInertia model are:
	ω_oc: Speed of the rotating reference frame of the virtual synchronous generator model,
	θ_oc: Phase angle displacement of the virtual synchronous generator model"
    states::Vector{Symbol}
    "VirtualInertia has two states"
    n_states::Int64
end

function VirtualInertia(Ta, kd, kω, ext=Dict{String, Any}(), )
    VirtualInertia(Ta, kd, kω, ext, [:θ_oc, :ω_oc], 2, )
end

function VirtualInertia(; Ta, kd, kω, ext=Dict{String, Any}(), )
    VirtualInertia(Ta, kd, kω, ext, )
end

# Constructor for demo purposes; non-functional.
function VirtualInertia(::Nothing)
    VirtualInertia(;
        Ta=0,
        kd=0,
        kω=0,
        ext=Dict{String, Any}(),
    )
end

"""Get VirtualInertia Ta."""
get_Ta(value::VirtualInertia) = value.Ta
"""Get VirtualInertia kd."""
get_kd(value::VirtualInertia) = value.kd
"""Get VirtualInertia kω."""
get_kω(value::VirtualInertia) = value.kω
"""Get VirtualInertia ext."""
get_ext(value::VirtualInertia) = value.ext
"""Get VirtualInertia states."""
get_states(value::VirtualInertia) = value.states
"""Get VirtualInertia n_states."""
get_n_states(value::VirtualInertia) = value.n_states

"""Set VirtualInertia Ta."""
set_Ta!(value::VirtualInertia, val::Float64) = value.Ta = val
"""Set VirtualInertia kd."""
set_kd!(value::VirtualInertia, val::Float64) = value.kd = val
"""Set VirtualInertia kω."""
set_kω!(value::VirtualInertia, val::Float64) = value.kω = val
"""Set VirtualInertia ext."""
set_ext!(value::VirtualInertia, val::Dict{String, Any}) = value.ext = val
"""Set VirtualInertia states."""
set_states!(value::VirtualInertia, val::Vector{Symbol}) = value.states = val
"""Set VirtualInertia n_states."""
set_n_states!(value::VirtualInertia, val::Int64) = value.n_states = val
