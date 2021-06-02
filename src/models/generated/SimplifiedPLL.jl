#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct SimplifiedPLL <: FrequencyEstimator
        ω_lp::Float64
        kp_pll::Float64
        ki_pll::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Phase-Locked Loop (PLL) based on Purba, Dhople, Jafarpour, Bullo and Johnson.
"Reduced-order Structure-preserving Model for Parallel-connected Three-phase Grid-tied Inverters."
2017 IEEE 18th Workshop on Control and Modeling for Power Electronics (COMPEL): 1-7.

# Arguments
- `ω_lp::Float64`: PLL low-pass filter frequency (rad/sec), validation range: `(0, nothing)`
- `kp_pll::Float64`: PLL proportional gain, validation range: `(0, nothing)`
- `ki_pll::Float64`: PLL integral gain, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the SimplifiedPLL model are:
	vq_pll: q-axis of the measured voltage in the PLL synchronous reference frame (SRF),
	ε_pll: Integrator state of the PI controller,
	θ_pll: Phase angle displacement in the PLL SRF
- `n_states::Int`: SimplifiedPLL has 3 states
"""
mutable struct SimplifiedPLL <: FrequencyEstimator
    "PLL low-pass filter frequency (rad/sec)"
    ω_lp::Float64
    "PLL proportional gain"
    kp_pll::Float64
    "PLL integral gain"
    ki_pll::Float64
    ext::Dict{String, Any}
    "The states of the SimplifiedPLL model are:
	vq_pll: q-axis of the measured voltage in the PLL synchronous reference frame (SRF),
	ε_pll: Integrator state of the PI controller,
	θ_pll: Phase angle displacement in the PLL SRF"
    states::Vector{Symbol}
    "SimplifiedPLL has 3 states"
    n_states::Int
end

function SimplifiedPLL(ω_lp, kp_pll, ki_pll, ext=Dict{String, Any}(), )
    SimplifiedPLL(ω_lp, kp_pll, ki_pll, ext, [:vq_pll, :ε_pll, :θ_pll], 3, )
end

function SimplifiedPLL(; ω_lp, kp_pll, ki_pll, ext=Dict{String, Any}(), states=[:vq_pll, :ε_pll, :θ_pll], n_states=3, )
    SimplifiedPLL(ω_lp, kp_pll, ki_pll, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function SimplifiedPLL(::Nothing)
    SimplifiedPLL(;
        ω_lp=0,
        kp_pll=0,
        ki_pll=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`SimplifiedPLL`](@ref) `ω_lp`."""
get_ω_lp(value::SimplifiedPLL) = value.ω_lp
"""Get [`SimplifiedPLL`](@ref) `kp_pll`."""
get_kp_pll(value::SimplifiedPLL) = value.kp_pll
"""Get [`SimplifiedPLL`](@ref) `ki_pll`."""
get_ki_pll(value::SimplifiedPLL) = value.ki_pll
"""Get [`SimplifiedPLL`](@ref) `ext`."""
get_ext(value::SimplifiedPLL) = value.ext
"""Get [`SimplifiedPLL`](@ref) `states`."""
get_states(value::SimplifiedPLL) = value.states
"""Get [`SimplifiedPLL`](@ref) `n_states`."""
get_n_states(value::SimplifiedPLL) = value.n_states

"""Set [`SimplifiedPLL`](@ref) `ω_lp`."""
set_ω_lp!(value::SimplifiedPLL, val) = value.ω_lp = val
"""Set [`SimplifiedPLL`](@ref) `kp_pll`."""
set_kp_pll!(value::SimplifiedPLL, val) = value.kp_pll = val
"""Set [`SimplifiedPLL`](@ref) `ki_pll`."""
set_ki_pll!(value::SimplifiedPLL, val) = value.ki_pll = val
"""Set [`SimplifiedPLL`](@ref) `ext`."""
set_ext!(value::SimplifiedPLL, val) = value.ext = val

