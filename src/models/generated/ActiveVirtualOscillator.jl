#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ActiveVirtualOscillator <: ActivePowerControl
        k1::Float64
        ψ::Float64
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of an Active Virtual Oscillator controller. Model is based from the paper Model Reduction for Inverters with Current Limiting and Dispatchable Virtual Oscillator Control by O. Ajala et al.

# Arguments
- `k1::Float64`: VOC Synchronization Gain, validation range: `(0, nothing)`
- `ψ::Float64`: Rotation angle of the controller, validation range: `(0, nothing)`
- `P_ref::Float64`: Reference Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the ActiveVirtualOscillator model are:
	θ_oc: Phase angle displacement of the inverter model
- `n_states::Int`: ActiveVirtualOscillator has one state
"""
mutable struct ActiveVirtualOscillator <: ActivePowerControl
    "VOC Synchronization Gain"
    k1::Float64
    "Rotation angle of the controller"
    ψ::Float64
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    "The states of the ActiveVirtualOscillator model are:
	θ_oc: Phase angle displacement of the inverter model"
    states::Vector{Symbol}
    "ActiveVirtualOscillator has one state"
    n_states::Int
end

function ActiveVirtualOscillator(k1, ψ, P_ref=1.0, ext=Dict{String, Any}(), )
    ActiveVirtualOscillator(k1, ψ, P_ref, ext, [:θ_oc], 1, )
end

function ActiveVirtualOscillator(; k1, ψ, P_ref=1.0, ext=Dict{String, Any}(), states=[:θ_oc], n_states=1, )
    ActiveVirtualOscillator(k1, ψ, P_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ActiveVirtualOscillator(::Nothing)
    ActiveVirtualOscillator(;
        k1=0,
        ψ=0,
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ActiveVirtualOscillator`](@ref) `k1`."""
get_k1(value::ActiveVirtualOscillator) = value.k1
"""Get [`ActiveVirtualOscillator`](@ref) `ψ`."""
get_ψ(value::ActiveVirtualOscillator) = value.ψ
"""Get [`ActiveVirtualOscillator`](@ref) `P_ref`."""
get_P_ref(value::ActiveVirtualOscillator) = value.P_ref
"""Get [`ActiveVirtualOscillator`](@ref) `ext`."""
get_ext(value::ActiveVirtualOscillator) = value.ext
"""Get [`ActiveVirtualOscillator`](@ref) `states`."""
get_states(value::ActiveVirtualOscillator) = value.states
"""Get [`ActiveVirtualOscillator`](@ref) `n_states`."""
get_n_states(value::ActiveVirtualOscillator) = value.n_states

"""Set [`ActiveVirtualOscillator`](@ref) `k1`."""
set_k1!(value::ActiveVirtualOscillator, val) = value.k1 = val
"""Set [`ActiveVirtualOscillator`](@ref) `ψ`."""
set_ψ!(value::ActiveVirtualOscillator, val) = value.ψ = val
"""Set [`ActiveVirtualOscillator`](@ref) `P_ref`."""
set_P_ref!(value::ActiveVirtualOscillator, val) = value.P_ref = val
"""Set [`ActiveVirtualOscillator`](@ref) `ext`."""
set_ext!(value::ActiveVirtualOscillator, val) = value.ext = val
