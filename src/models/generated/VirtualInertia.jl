#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct VirtualInertia <: ActivePowerControl
        Ta::Float64
        kd::Float64
        kω::Float64
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
    end

Parameters of a Virtual Inertia with SRF using VSM for active power controller

# Arguments
- `Ta::Float64`: VSM inertia constant, validation range: (0, nothing)
- `kd::Float64`: VSM damping constant, validation range: (0, nothing)
- `kω::Float64`: frequency droop gain, validation range: (0, nothing)
- `P_ref::Float64`: Reference Power Set-point, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
"""
mutable struct VirtualInertia <: ActivePowerControl
    "VSM inertia constant"
    Ta::Float64
    "VSM damping constant"
    kd::Float64
    "frequency droop gain"
    kω::Float64
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
end

function VirtualInertia(Ta, kd, kω, P_ref=1.0, ext=Dict{String, Any}(), )
    VirtualInertia(Ta, kd, kω, P_ref, ext, [:ω_oc, :θ_oc], 2, )
end

function VirtualInertia(; Ta, kd, kω, P_ref=1.0, ext=Dict{String, Any}(), )
    VirtualInertia(Ta, kd, kω, P_ref, ext, )
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

"""Get VirtualInertia Ta."""
get_Ta(value::VirtualInertia) = value.Ta
"""Get VirtualInertia kd."""
get_kd(value::VirtualInertia) = value.kd
"""Get VirtualInertia kω."""
get_kω(value::VirtualInertia) = value.kω
"""Get VirtualInertia P_ref."""
get_P_ref(value::VirtualInertia) = value.P_ref
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
"""Set VirtualInertia P_ref."""
set_P_ref!(value::VirtualInertia, val::Float64) = value.P_ref = val
"""Set VirtualInertia ext."""
set_ext!(value::VirtualInertia, val::Dict{String, Any}) = value.ext = val
"""Set VirtualInertia states."""
set_states!(value::VirtualInertia, val::Vector{Symbol}) = value.states = val
"""Set VirtualInertia n_states."""
set_n_states!(value::VirtualInertia, val::Int64) = value.n_states = val
