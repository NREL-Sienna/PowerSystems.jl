#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct VirtualInertia <: ActivePowerControl
        Ta::Float64
        kd::Float64
        kω::Float64
        ωb::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
    end

Parameters of a Virtual Inertia with SRF using VSM for active power controller

# Arguments
- `Ta::Float64`: VSM inertia constant, validation range: (0, nothing)
- `kd::Float64`: VSM damping constant, validation range: (0, nothing)
- `kω::Float64`: frequency droop gain, validation range: (0, nothing)
- `ωb::Float64`: rated angular frequency, validation range: (0, nothing)
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
    "rated angular frequency"
    ωb::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
end

function VirtualInertia(Ta, kd, kω, ωb, ext=Dict{String, Any}(), )
    VirtualInertia(Ta, kd, kω, ωb, ext, [:ω_oc, :θ_oc], 2, )
end

function VirtualInertia(; Ta, kd, kω, ωb, ext=Dict{String, Any}(), )
    VirtualInertia(Ta, kd, kω, ωb, ext, )
end

# Constructor for demo purposes; non-functional.
function VirtualInertia(::Nothing)
    VirtualInertia(;
        Ta=0,
        kd=0,
        kω=0,
        ωb=0,
        ext=Dict{String, Any}(),
    )
end

"""Get VirtualInertia Ta."""
get_Ta(value::VirtualInertia) = value.Ta
"""Get VirtualInertia kd."""
get_kd(value::VirtualInertia) = value.kd
"""Get VirtualInertia kω."""
get_kω(value::VirtualInertia) = value.kω
"""Get VirtualInertia ωb."""
get_ωb(value::VirtualInertia) = value.ωb
"""Get VirtualInertia ext."""
get_ext(value::VirtualInertia) = value.ext
"""Get VirtualInertia states."""
get_states(value::VirtualInertia) = value.states
"""Get VirtualInertia n_states."""
get_n_states(value::VirtualInertia) = value.n_states
