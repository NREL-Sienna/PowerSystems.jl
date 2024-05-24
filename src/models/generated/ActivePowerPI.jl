#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ActivePowerPI <: ActivePowerControl
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
- `P_ref::Float64`: (optional) Reference Power Set-point (pu), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `states::Vector{Symbol}`: (**Do not modify.**) The [states](@ref S) of the ActivePowerPI model are:
	σp_oc: Integrator state of the PI Controller,
	p_oc: Measured active power of the inverter model
- `n_states::Int`: (**Do not modify.**) ActivePowerPI has two states
"""
mutable struct ActivePowerPI <: ActivePowerControl
    "Proportional Gain"
    Kp_p::Float64
    "Integral Gain"
    Ki_p::Float64
    "filter frequency cutoff"
    ωz::Float64
    "(optional) Reference Power Set-point (pu)"
    P_ref::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) The [states](@ref S) of the ActivePowerPI model are:
	σp_oc: Integrator state of the PI Controller,
	p_oc: Measured active power of the inverter model"
    states::Vector{Symbol}
    "(**Do not modify.**) ActivePowerPI has two states"
    n_states::Int
end

function ActivePowerPI(Kp_p, Ki_p, ωz, P_ref=1.0, ext=Dict{String, Any}(), )
    ActivePowerPI(Kp_p, Ki_p, ωz, P_ref, ext, [:σp_oc, :p_oc], 2, )
end

function ActivePowerPI(; Kp_p, Ki_p, ωz, P_ref=1.0, ext=Dict{String, Any}(), states=[:σp_oc, :p_oc], n_states=2, )
    ActivePowerPI(Kp_p, Ki_p, ωz, P_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ActivePowerPI(::Nothing)
    ActivePowerPI(;
        Kp_p=0,
        Ki_p=0,
        ωz=0,
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ActivePowerPI`](@ref) `Kp_p`."""
get_Kp_p(value::ActivePowerPI) = value.Kp_p
"""Get [`ActivePowerPI`](@ref) `Ki_p`."""
get_Ki_p(value::ActivePowerPI) = value.Ki_p
"""Get [`ActivePowerPI`](@ref) `ωz`."""
get_ωz(value::ActivePowerPI) = value.ωz
"""Get [`ActivePowerPI`](@ref) `P_ref`."""
get_P_ref(value::ActivePowerPI) = value.P_ref
"""Get [`ActivePowerPI`](@ref) `ext`."""
get_ext(value::ActivePowerPI) = value.ext
"""Get [`ActivePowerPI`](@ref) `states`."""
get_states(value::ActivePowerPI) = value.states
"""Get [`ActivePowerPI`](@ref) `n_states`."""
get_n_states(value::ActivePowerPI) = value.n_states

"""Set [`ActivePowerPI`](@ref) `Kp_p`."""
set_Kp_p!(value::ActivePowerPI, val) = value.Kp_p = val
"""Set [`ActivePowerPI`](@ref) `Ki_p`."""
set_Ki_p!(value::ActivePowerPI, val) = value.Ki_p = val
"""Set [`ActivePowerPI`](@ref) `ωz`."""
set_ωz!(value::ActivePowerPI, val) = value.ωz = val
"""Set [`ActivePowerPI`](@ref) `P_ref`."""
set_P_ref!(value::ActivePowerPI, val) = value.P_ref = val
"""Set [`ActivePowerPI`](@ref) `ext`."""
set_ext!(value::ActivePowerPI, val) = value.ext = val
