#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PI_ActivePowerReference <: ActivePowerControl
        Kp_p::Float64
        Ki_p::Float64
        ωz::Float64
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Proportional-Integral Active Power controller for a specified power reference

# Arguments
- `Kp_p::Float64`: Proportional Gain, validation range: `(0, nothing)`
- `Ki_p::Float64`: Integral Gain, validation range: `(0, nothing)`
- `ωz::Float64`: filter frequency cutoff, validation range: `(0, nothing)`
- `P_ref::Float64`: Reference Power Set-point, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the PI_ActivePowerReference model are:
	σp_oc: Integrator state of the PI Controller,
	p_oc: Measured active power of the inverter model
- `n_states::Int`: PI_ActivePowerReference has two states
"""
mutable struct PI_ActivePowerReference <: ActivePowerControl
    "Proportional Gain"
    Kp_p::Float64
    "Integral Gain"
    Ki_p::Float64
    "filter frequency cutoff"
    ωz::Float64
    "Reference Power Set-point"
    P_ref::Float64
    ext::Dict{String, Any}
    "The states of the PI_ActivePowerReference model are:
	σp_oc: Integrator state of the PI Controller,
	p_oc: Measured active power of the inverter model"
    states::Vector{Symbol}
    "PI_ActivePowerReference has two states"
    n_states::Int
end

function PI_ActivePowerReference(Kp_p, Ki_p, ωz, P_ref=1.0, ext=Dict{String, Any}(), )
    PI_ActivePowerReference(Kp_p, Ki_p, ωz, P_ref, ext, [:σp_oc, :p_oc], 2, )
end

function PI_ActivePowerReference(; Kp_p, Ki_p, ωz, P_ref=1.0, ext=Dict{String, Any}(), states=[:σp_oc, :p_oc], n_states=2, )
    PI_ActivePowerReference(Kp_p, Ki_p, ωz, P_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function PI_ActivePowerReference(::Nothing)
    PI_ActivePowerReference(;
        Kp_p=0,
        Ki_p=0,
        ωz=0,
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`PI_ActivePowerReference`](@ref) `Kp_p`."""
get_Kp_p(value::PI_ActivePowerReference) = value.Kp_p
"""Get [`PI_ActivePowerReference`](@ref) `Ki_p`."""
get_Ki_p(value::PI_ActivePowerReference) = value.Ki_p
"""Get [`PI_ActivePowerReference`](@ref) `ωz`."""
get_ωz(value::PI_ActivePowerReference) = value.ωz
"""Get [`PI_ActivePowerReference`](@ref) `P_ref`."""
get_P_ref(value::PI_ActivePowerReference) = value.P_ref
"""Get [`PI_ActivePowerReference`](@ref) `ext`."""
get_ext(value::PI_ActivePowerReference) = value.ext
"""Get [`PI_ActivePowerReference`](@ref) `states`."""
get_states(value::PI_ActivePowerReference) = value.states
"""Get [`PI_ActivePowerReference`](@ref) `n_states`."""
get_n_states(value::PI_ActivePowerReference) = value.n_states

"""Set [`PI_ActivePowerReference`](@ref) `Kp_p`."""
set_Kp_p!(value::PI_ActivePowerReference, val) = value.Kp_p = val
"""Set [`PI_ActivePowerReference`](@ref) `Ki_p`."""
set_Ki_p!(value::PI_ActivePowerReference, val) = value.Ki_p = val
"""Set [`PI_ActivePowerReference`](@ref) `ωz`."""
set_ωz!(value::PI_ActivePowerReference, val) = value.ωz = val
"""Set [`PI_ActivePowerReference`](@ref) `P_ref`."""
set_P_ref!(value::PI_ActivePowerReference, val) = value.P_ref = val
"""Set [`PI_ActivePowerReference`](@ref) `ext`."""
set_ext!(value::PI_ActivePowerReference, val) = value.ext = val

