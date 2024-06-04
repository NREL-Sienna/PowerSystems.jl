#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ActivePowerDroop <: ActivePowerControl
        Rp::Float64
        ωz::Float64
        P_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of an Active Power droop controller

# Arguments
- `Rp::Float64`: Droop Gain, validation range: `(0, nothing)`
- `ωz::Float64`: filter frequency cutoff, validation range: `(0, nothing)`
- `P_ref::Float64`: Reference Power Set-point (pu), validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)
- `states::Vector{Symbol}`: (**Do not modify.**) The [states](@ref S) of the ActivePowerDroop model are:
	θ_oc: Phase angle displacement of the inverter model,
	p_oc: Measured active power of the inverter model
- `n_states::Int`: (**Do not modify.**) ActivePowerDroop has two states
"""
mutable struct ActivePowerDroop <: ActivePowerControl
    "Droop Gain"
    Rp::Float64
    "filter frequency cutoff"
    ωz::Float64
    "Reference Power Set-point (pu)"
    P_ref::Float64
    "An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)"
    ext::Dict{String, Any}
    "(**Do not modify.**) The [states](@ref S) of the ActivePowerDroop model are:
	θ_oc: Phase angle displacement of the inverter model,
	p_oc: Measured active power of the inverter model"
    states::Vector{Symbol}
    "(**Do not modify.**) ActivePowerDroop has two states"
    n_states::Int
end

function ActivePowerDroop(Rp, ωz, P_ref=1.0, ext=Dict{String, Any}(), )
    ActivePowerDroop(Rp, ωz, P_ref, ext, [:θ_oc, :p_oc], 2, )
end

function ActivePowerDroop(; Rp, ωz, P_ref=1.0, ext=Dict{String, Any}(), states=[:θ_oc, :p_oc], n_states=2, )
    ActivePowerDroop(Rp, ωz, P_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ActivePowerDroop(::Nothing)
    ActivePowerDroop(;
        Rp=0,
        ωz=0,
        P_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ActivePowerDroop`](@ref) `Rp`."""
get_Rp(value::ActivePowerDroop) = value.Rp
"""Get [`ActivePowerDroop`](@ref) `ωz`."""
get_ωz(value::ActivePowerDroop) = value.ωz
"""Get [`ActivePowerDroop`](@ref) `P_ref`."""
get_P_ref(value::ActivePowerDroop) = value.P_ref
"""Get [`ActivePowerDroop`](@ref) `ext`."""
get_ext(value::ActivePowerDroop) = value.ext
"""Get [`ActivePowerDroop`](@ref) `states`."""
get_states(value::ActivePowerDroop) = value.states
"""Get [`ActivePowerDroop`](@ref) `n_states`."""
get_n_states(value::ActivePowerDroop) = value.n_states

"""Set [`ActivePowerDroop`](@ref) `Rp`."""
set_Rp!(value::ActivePowerDroop, val) = value.Rp = val
"""Set [`ActivePowerDroop`](@ref) `ωz`."""
set_ωz!(value::ActivePowerDroop, val) = value.ωz = val
"""Set [`ActivePowerDroop`](@ref) `P_ref`."""
set_P_ref!(value::ActivePowerDroop, val) = value.P_ref = val
"""Set [`ActivePowerDroop`](@ref) `ext`."""
set_ext!(value::ActivePowerDroop, val) = value.ext = val
