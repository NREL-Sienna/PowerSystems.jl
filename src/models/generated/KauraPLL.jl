#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct KauraPLL <: FrequencyEstimator
        ω_lp::Float64
        kp_pll::Float64
        ki_pll::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Phase-Locked Loop (PLL) based on Kaura, Vikram, and Vladimir Blasko.
"Operation of a phase locked loop system under distorted utility conditions."
IEEE Transactions on Industry applications 33.1 (1997): 58-63.

# Arguments
- `ω_lp::Float64`: PLL low-pass filter frequency (rad/sec), validation range: `(0, nothing)`
- `kp_pll::Float64`: PLL proportional gain, validation range: `(0, nothing)`
- `ki_pll::Float64`: PLL integral gain, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: The states of the KauraPLL model are:
	vd_pll: d-axis of the measured voltage in the PLL synchronous reference frame (SRF),
	vq_pll: q-axis of the measured voltage in the PLL SRF,
	ε_pll: Integrator state of the PI controller,
	θ_pll: Phase angle displacement in the PLL SRF
- `n_states::Int`: KauraPLL has 4 states
"""
mutable struct KauraPLL <: FrequencyEstimator
    "PLL low-pass filter frequency (rad/sec)"
    ω_lp::Float64
    "PLL proportional gain"
    kp_pll::Float64
    "PLL integral gain"
    ki_pll::Float64
    ext::Dict{String, Any}
    "The states of the KauraPLL model are:
	vd_pll: d-axis of the measured voltage in the PLL synchronous reference frame (SRF),
	vq_pll: q-axis of the measured voltage in the PLL SRF,
	ε_pll: Integrator state of the PI controller,
	θ_pll: Phase angle displacement in the PLL SRF"
    states::Vector{Symbol}
    "KauraPLL has 4 states"
    n_states::Int
end

function KauraPLL(ω_lp, kp_pll, ki_pll, ext=Dict{String, Any}(), )
    KauraPLL(ω_lp, kp_pll, ki_pll, ext, [:vd_pll, :vq_pll, :ε_pll, :θ_pll], 4, )
end

function KauraPLL(; ω_lp, kp_pll, ki_pll, ext=Dict{String, Any}(), states=[:vd_pll, :vq_pll, :ε_pll, :θ_pll], n_states=4, )
    KauraPLL(ω_lp, kp_pll, ki_pll, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function KauraPLL(::Nothing)
    KauraPLL(;
        ω_lp=0,
        kp_pll=0,
        ki_pll=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`KauraPLL`](@ref) `ω_lp`."""
get_ω_lp(value::KauraPLL) = value.ω_lp
"""Get [`KauraPLL`](@ref) `kp_pll`."""
get_kp_pll(value::KauraPLL) = value.kp_pll
"""Get [`KauraPLL`](@ref) `ki_pll`."""
get_ki_pll(value::KauraPLL) = value.ki_pll
"""Get [`KauraPLL`](@ref) `ext`."""
get_ext(value::KauraPLL) = value.ext
"""Get [`KauraPLL`](@ref) `states`."""
get_states(value::KauraPLL) = value.states
"""Get [`KauraPLL`](@ref) `n_states`."""
get_n_states(value::KauraPLL) = value.n_states

"""Set [`KauraPLL`](@ref) `ω_lp`."""
set_ω_lp!(value::KauraPLL, val) = value.ω_lp = val
"""Set [`KauraPLL`](@ref) `kp_pll`."""
set_kp_pll!(value::KauraPLL, val) = value.kp_pll = val
"""Set [`KauraPLL`](@ref) `ki_pll`."""
set_ki_pll!(value::KauraPLL, val) = value.ki_pll = val
"""Set [`KauraPLL`](@ref) `ext`."""
set_ext!(value::KauraPLL, val) = value.ext = val

