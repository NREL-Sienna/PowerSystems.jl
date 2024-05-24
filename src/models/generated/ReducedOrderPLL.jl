#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ReducedOrderPLL <: FrequencyEstimator
        ω_lp::Float64
        kp_pll::Float64
        ki_pll::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Phase-Locked Loop (PLL) based on ["Reduced-order Structure-preserving Model for Parallel-connected Three-phase Grid-tied Inverters."](https://doi.org/10.1109/COMPEL.2017.8013389)

# Arguments
- `ω_lp::Float64`: PLL low-pass filter frequency (rad/sec), validation range: `(0, nothing)`
- `kp_pll::Float64`: PLL proportional gain, validation range: `(0, nothing)`
- `ki_pll::Float64`: PLL integral gain, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `states::Vector{Symbol}`: (**Do not modify.**) The [states](@ref S) of the ReducedOrderPLL model are:
	vq_pll: q-axis of the measured voltage in the PLL synchronous reference frame (SRF),
	ε_pll: Integrator state of the PI controller,
	θ_pll: Phase angle displacement in the PLL SRF
- `n_states::Int`: (**Do not modify.**) ReducedOrderPLL has 3 states
"""
mutable struct ReducedOrderPLL <: FrequencyEstimator
    "PLL low-pass filter frequency (rad/sec)"
    ω_lp::Float64
    "PLL proportional gain"
    kp_pll::Float64
    "PLL integral gain"
    ki_pll::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) The [states](@ref S) of the ReducedOrderPLL model are:
	vq_pll: q-axis of the measured voltage in the PLL synchronous reference frame (SRF),
	ε_pll: Integrator state of the PI controller,
	θ_pll: Phase angle displacement in the PLL SRF"
    states::Vector{Symbol}
    "(**Do not modify.**) ReducedOrderPLL has 3 states"
    n_states::Int
end

function ReducedOrderPLL(ω_lp, kp_pll, ki_pll, ext=Dict{String, Any}(), )
    ReducedOrderPLL(ω_lp, kp_pll, ki_pll, ext, [:vq_pll, :ε_pll, :θ_pll], 3, )
end

function ReducedOrderPLL(; ω_lp, kp_pll, ki_pll, ext=Dict{String, Any}(), states=[:vq_pll, :ε_pll, :θ_pll], n_states=3, )
    ReducedOrderPLL(ω_lp, kp_pll, ki_pll, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function ReducedOrderPLL(::Nothing)
    ReducedOrderPLL(;
        ω_lp=0,
        kp_pll=0,
        ki_pll=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ReducedOrderPLL`](@ref) `ω_lp`."""
get_ω_lp(value::ReducedOrderPLL) = value.ω_lp
"""Get [`ReducedOrderPLL`](@ref) `kp_pll`."""
get_kp_pll(value::ReducedOrderPLL) = value.kp_pll
"""Get [`ReducedOrderPLL`](@ref) `ki_pll`."""
get_ki_pll(value::ReducedOrderPLL) = value.ki_pll
"""Get [`ReducedOrderPLL`](@ref) `ext`."""
get_ext(value::ReducedOrderPLL) = value.ext
"""Get [`ReducedOrderPLL`](@ref) `states`."""
get_states(value::ReducedOrderPLL) = value.states
"""Get [`ReducedOrderPLL`](@ref) `n_states`."""
get_n_states(value::ReducedOrderPLL) = value.n_states

"""Set [`ReducedOrderPLL`](@ref) `ω_lp`."""
set_ω_lp!(value::ReducedOrderPLL, val) = value.ω_lp = val
"""Set [`ReducedOrderPLL`](@ref) `kp_pll`."""
set_kp_pll!(value::ReducedOrderPLL, val) = value.kp_pll = val
"""Set [`ReducedOrderPLL`](@ref) `ki_pll`."""
set_ki_pll!(value::ReducedOrderPLL, val) = value.ki_pll = val
"""Set [`ReducedOrderPLL`](@ref) `ext`."""
set_ext!(value::ReducedOrderPLL, val) = value.ext = val
