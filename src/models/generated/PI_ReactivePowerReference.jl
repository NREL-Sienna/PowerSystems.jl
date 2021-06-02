#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PI_ReactivePowerReference <: ReactivePowerControl
        Kp_q::Float64
        Ki_q::Float64
        ωf::Float64
        V_ref::Float64
        Q_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Proportional-Integral Reactive Power controller for a specified power reference

# Arguments
- `Kp_q::Float64`: Proportional Gain, validation range: `(0, nothing)`
- `Ki_q::Float64`: Integral Gain, validation range: `(0, nothing)`
- `ωf::Float64`: filter frequency cutoff, validation range: `(0, nothing)`
- `V_ref::Float64`: Voltage Set-point, validation range: `(0, nothing)`
- `Q_ref::Float64`: Reactive Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the PI_ReactivePowerReference model are:
	σq_oc: Integrator state of the PI Controller,
	q_oc: Measured reactive power of the inverter model
- `n_states::Int`: PI_ReactivePowerReference has two states
"""
mutable struct PI_ReactivePowerReference <: ReactivePowerControl
    "Proportional Gain"
    Kp_q::Float64
    "Integral Gain"
    Ki_q::Float64
    "filter frequency cutoff"
    ωf::Float64
    "Voltage Set-point"
    V_ref::Float64
    "Reactive Power Set-point"
    Q_ref::Float64
    ext::Dict{String, Any}
    "The states of the PI_ReactivePowerReference model are:
	σq_oc: Integrator state of the PI Controller,
	q_oc: Measured reactive power of the inverter model"
    states::Vector{Symbol}
    "PI_ReactivePowerReference has two states"
    n_states::Int
end

function PI_ReactivePowerReference(Kp_q, Ki_q, ωf, V_ref=1.0, Q_ref=1.0, ext=Dict{String, Any}(), )
    PI_ReactivePowerReference(Kp_q, Ki_q, ωf, V_ref, Q_ref, ext, [:σq_oc, :q_oc], 2, )
end

function PI_ReactivePowerReference(; Kp_q, Ki_q, ωf, V_ref=1.0, Q_ref=1.0, ext=Dict{String, Any}(), states=[:σq_oc, :q_oc], n_states=2, )
    PI_ReactivePowerReference(Kp_q, Ki_q, ωf, V_ref, Q_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function PI_ReactivePowerReference(::Nothing)
    PI_ReactivePowerReference(;
        Kp_q=0,
        Ki_q=0,
        ωf=0,
        V_ref=0,
        Q_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`PI_ReactivePowerReference`](@ref) `Kp_q`."""
get_Kp_q(value::PI_ReactivePowerReference) = value.Kp_q
"""Get [`PI_ReactivePowerReference`](@ref) `Ki_q`."""
get_Ki_q(value::PI_ReactivePowerReference) = value.Ki_q
"""Get [`PI_ReactivePowerReference`](@ref) `ωf`."""
get_ωf(value::PI_ReactivePowerReference) = value.ωf
"""Get [`PI_ReactivePowerReference`](@ref) `V_ref`."""
get_V_ref(value::PI_ReactivePowerReference) = value.V_ref
"""Get [`PI_ReactivePowerReference`](@ref) `Q_ref`."""
get_Q_ref(value::PI_ReactivePowerReference) = value.Q_ref
"""Get [`PI_ReactivePowerReference`](@ref) `ext`."""
get_ext(value::PI_ReactivePowerReference) = value.ext
"""Get [`PI_ReactivePowerReference`](@ref) `states`."""
get_states(value::PI_ReactivePowerReference) = value.states
"""Get [`PI_ReactivePowerReference`](@ref) `n_states`."""
get_n_states(value::PI_ReactivePowerReference) = value.n_states

"""Set [`PI_ReactivePowerReference`](@ref) `Kp_q`."""
set_Kp_q!(value::PI_ReactivePowerReference, val) = value.Kp_q = val
"""Set [`PI_ReactivePowerReference`](@ref) `Ki_q`."""
set_Ki_q!(value::PI_ReactivePowerReference, val) = value.Ki_q = val
"""Set [`PI_ReactivePowerReference`](@ref) `ωf`."""
set_ωf!(value::PI_ReactivePowerReference, val) = value.ωf = val
"""Set [`PI_ReactivePowerReference`](@ref) `V_ref`."""
set_V_ref!(value::PI_ReactivePowerReference, val) = value.V_ref = val
"""Set [`PI_ReactivePowerReference`](@ref) `Q_ref`."""
set_Q_ref!(value::PI_ReactivePowerReference, val) = value.Q_ref = val
"""Set [`PI_ReactivePowerReference`](@ref) `ext`."""
set_ext!(value::PI_ReactivePowerReference, val) = value.ext = val

