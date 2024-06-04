#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ReactivePowerPI <: ReactivePowerControl
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
- `V_ref::Float64`: (optional) Voltage Set-point (pu), validation range: `(0, nothing)`
- `Q_ref::Float64`: (optional) Reactive Power Set-point (pu), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `states::Vector{Symbol}`: (**Do not modify.**) The states of the ReactivePowerPI model are:
	σq_oc: Integrator state of the PI Controller,
	q_oc: Measured reactive power of the inverter model
- `n_states::Int`: (**Do not modify.**) ReactivePowerPI has two states
"""
mutable struct ReactivePowerPI <: ReactivePowerControl
    "Proportional Gain"
    Kp_q::Float64
    "Integral Gain"
    Ki_q::Float64
    "filter frequency cutoff"
    ωf::Float64
    "(optional) Voltage Set-point (pu)"
    V_ref::Float64
    "(optional) Reactive Power Set-point (pu)"
    Q_ref::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) The states of the ReactivePowerPI model are:
	σq_oc: Integrator state of the PI Controller,
	q_oc: Measured reactive power of the inverter model"
    states::Vector{Symbol}
    "(**Do not modify.**) ReactivePowerPI has two states"
    n_states::Int
end

function ReactivePowerPI(Kp_q, Ki_q, ωf, V_ref=1.0, Q_ref=1.0, ext=Dict{String, Any}(), )
    ReactivePowerPI(Kp_q, Ki_q, ωf, V_ref, Q_ref, ext, [:σq_oc, :q_oc], 2, )
end

function ReactivePowerPI(; Kp_q, Ki_q, ωf, V_ref=1.0, Q_ref=1.0, ext=Dict{String, Any}(), states=[:σq_oc, :q_oc], n_states=2, )
    ReactivePowerPI(Kp_q, Ki_q, ωf, V_ref, Q_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ReactivePowerPI(::Nothing)
    ReactivePowerPI(;
        Kp_q=0,
        Ki_q=0,
        ωf=0,
        V_ref=0,
        Q_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ReactivePowerPI`](@ref) `Kp_q`."""
get_Kp_q(value::ReactivePowerPI) = value.Kp_q
"""Get [`ReactivePowerPI`](@ref) `Ki_q`."""
get_Ki_q(value::ReactivePowerPI) = value.Ki_q
"""Get [`ReactivePowerPI`](@ref) `ωf`."""
get_ωf(value::ReactivePowerPI) = value.ωf
"""Get [`ReactivePowerPI`](@ref) `V_ref`."""
get_V_ref(value::ReactivePowerPI) = value.V_ref
"""Get [`ReactivePowerPI`](@ref) `Q_ref`."""
get_Q_ref(value::ReactivePowerPI) = value.Q_ref
"""Get [`ReactivePowerPI`](@ref) `ext`."""
get_ext(value::ReactivePowerPI) = value.ext
"""Get [`ReactivePowerPI`](@ref) `states`."""
get_states(value::ReactivePowerPI) = value.states
"""Get [`ReactivePowerPI`](@ref) `n_states`."""
get_n_states(value::ReactivePowerPI) = value.n_states

"""Set [`ReactivePowerPI`](@ref) `Kp_q`."""
set_Kp_q!(value::ReactivePowerPI, val) = value.Kp_q = val
"""Set [`ReactivePowerPI`](@ref) `Ki_q`."""
set_Ki_q!(value::ReactivePowerPI, val) = value.Ki_q = val
"""Set [`ReactivePowerPI`](@ref) `ωf`."""
set_ωf!(value::ReactivePowerPI, val) = value.ωf = val
"""Set [`ReactivePowerPI`](@ref) `V_ref`."""
set_V_ref!(value::ReactivePowerPI, val) = value.V_ref = val
"""Set [`ReactivePowerPI`](@ref) `Q_ref`."""
set_Q_ref!(value::ReactivePowerPI, val) = value.Q_ref = val
"""Set [`ReactivePowerPI`](@ref) `ext`."""
set_ext!(value::ReactivePowerPI, val) = value.ext = val
