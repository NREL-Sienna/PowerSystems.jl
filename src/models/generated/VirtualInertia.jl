#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct VirtualInertia <: ActivePowerControl
        Ta::Float64
        kd::Float64
        kω::Float64
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Virtual Inertia with SRF using VSM for active power controller

# Arguments
- `Ta::Float64`: VSM inertia constant, validation range: `(0, nothing)`
- `kd::Float64`: VSM damping constant, validation range: `(0, nothing)`
- `kω::Float64`: frequency droop gain, validation range: `(0, nothing)`
- `P_ref::Float64`: (optional) Reference Power Set-point (pu), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `states::Vector{Symbol}`: (**Do not modify.**) The states of the VirtualInertia model are:
	θ_oc: Phase angle displacement of the virtual synchronous generator model
	ω_oc: Speed of the rotating reference frame of the virtual synchronous generator model
- `n_states::Int`: (**Do not modify.**) VirtualInertia has two states
"""
mutable struct VirtualInertia <: ActivePowerControl
    "VSM inertia constant"
    Ta::Float64
    "VSM damping constant"
    kd::Float64
    "frequency droop gain"
    kω::Float64
    "(optional) Reference Power Set-point (pu)"
    P_ref::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) The states of the VirtualInertia model are:
	θ_oc: Phase angle displacement of the virtual synchronous generator model
	ω_oc: Speed of the rotating reference frame of the virtual synchronous generator model"
    states::Vector{Symbol}
    "(**Do not modify.**) VirtualInertia has two states"
    n_states::Int
end

function VirtualInertia(Ta, kd, kω, P_ref=1.0, ext=Dict{String, Any}(), )
    VirtualInertia(Ta, kd, kω, P_ref, ext, [:θ_oc, :ω_oc], 2, )
end

function VirtualInertia(; Ta, kd, kω, P_ref=1.0, ext=Dict{String, Any}(), states=[:θ_oc, :ω_oc], n_states=2, )
    VirtualInertia(Ta, kd, kω, P_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function VirtualInertia(::Nothing)
    VirtualInertia(;
        Ta=0,
        kd=0,
        kω=0,
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`VirtualInertia`](@ref) `Ta`."""
get_Ta(value::VirtualInertia) = value.Ta
"""Get [`VirtualInertia`](@ref) `kd`."""
get_kd(value::VirtualInertia) = value.kd
"""Get [`VirtualInertia`](@ref) `kω`."""
get_kω(value::VirtualInertia) = value.kω
"""Get [`VirtualInertia`](@ref) `P_ref`."""
get_P_ref(value::VirtualInertia) = value.P_ref
"""Get [`VirtualInertia`](@ref) `ext`."""
get_ext(value::VirtualInertia) = value.ext
"""Get [`VirtualInertia`](@ref) `states`."""
get_states(value::VirtualInertia) = value.states
"""Get [`VirtualInertia`](@ref) `n_states`."""
get_n_states(value::VirtualInertia) = value.n_states

"""Set [`VirtualInertia`](@ref) `Ta`."""
set_Ta!(value::VirtualInertia, val) = value.Ta = val
"""Set [`VirtualInertia`](@ref) `kd`."""
set_kd!(value::VirtualInertia, val) = value.kd = val
"""Set [`VirtualInertia`](@ref) `kω`."""
set_kω!(value::VirtualInertia, val) = value.kω = val
"""Set [`VirtualInertia`](@ref) `P_ref`."""
set_P_ref!(value::VirtualInertia, val) = value.P_ref = val
"""Set [`VirtualInertia`](@ref) `ext`."""
set_ext!(value::VirtualInertia, val) = value.ext = val
