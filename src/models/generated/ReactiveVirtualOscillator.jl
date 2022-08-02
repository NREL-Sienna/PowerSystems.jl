#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ReactiveVirtualOscillator <: ReactivePowerControl
        k2::Float64
        V_ref::Float64
        Q_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Reactive Virtual Oscillator controller. Model is based from the paper Model Reduction for Inverters with Current Limiting and Dispatchable Virtual Oscillator Control by O. Ajala et al.

# Arguments
- `k2::Float64`: VOC voltage-amplitude control gain, validation range: `(0, nothing)`
- `V_ref::Float64`: Reference Voltage Set-point, validation range: `(0, nothing)`
- `Q_ref::Float64`: Reference Reactive Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the ReactiveVirtualOscilator model are:
	E_oc: voltage reference state for inner control in the d-axis
- `n_states::Int`: ReactiveVirtualOscillator has 1 state
"""
mutable struct ReactiveVirtualOscillator <: ReactivePowerControl
    "VOC voltage-amplitude control gain"
    k2::Float64
    "Reference Voltage Set-point"
    V_ref::Float64
    "Reference Reactive Power Set-point"
    Q_ref::Float64
    ext::Dict{String, Any}
    "The states of the ReactiveVirtualOscilator model are:
	E_oc: voltage reference state for inner control in the d-axis"
    states::Vector{Symbol}
    "ReactiveVirtualOscillator has 1 state"
    n_states::Int
end

function ReactiveVirtualOscillator(k2, V_ref=1.0, Q_ref=1.0, ext=Dict{String, Any}(), )
    ReactiveVirtualOscillator(k2, V_ref, Q_ref, ext, [:E_oc], 1, )
end

function ReactiveVirtualOscillator(; k2, V_ref=1.0, Q_ref=1.0, ext=Dict{String, Any}(), states=[:E_oc], n_states=1, )
    ReactiveVirtualOscillator(k2, V_ref, Q_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ReactiveVirtualOscillator(::Nothing)
    ReactiveVirtualOscillator(;
        k2=0,
        V_ref=0,
        Q_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ReactiveVirtualOscillator`](@ref) `k2`."""
get_k2(value::ReactiveVirtualOscillator) = value.k2
"""Get [`ReactiveVirtualOscillator`](@ref) `V_ref`."""
get_V_ref(value::ReactiveVirtualOscillator) = value.V_ref
"""Get [`ReactiveVirtualOscillator`](@ref) `Q_ref`."""
get_Q_ref(value::ReactiveVirtualOscillator) = value.Q_ref
"""Get [`ReactiveVirtualOscillator`](@ref) `ext`."""
get_ext(value::ReactiveVirtualOscillator) = value.ext
"""Get [`ReactiveVirtualOscillator`](@ref) `states`."""
get_states(value::ReactiveVirtualOscillator) = value.states
"""Get [`ReactiveVirtualOscillator`](@ref) `n_states`."""
get_n_states(value::ReactiveVirtualOscillator) = value.n_states

"""Set [`ReactiveVirtualOscillator`](@ref) `k2`."""
set_k2!(value::ReactiveVirtualOscillator, val) = value.k2 = val
"""Set [`ReactiveVirtualOscillator`](@ref) `V_ref`."""
set_V_ref!(value::ReactiveVirtualOscillator, val) = value.V_ref = val
"""Set [`ReactiveVirtualOscillator`](@ref) `Q_ref`."""
set_Q_ref!(value::ReactiveVirtualOscillator, val) = value.Q_ref = val
"""Set [`ReactiveVirtualOscillator`](@ref) `ext`."""
set_ext!(value::ReactiveVirtualOscillator, val) = value.ext = val
