#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct PLL <: FrequencyEstimator
        ω_lp::Float64
        kp_pll::Float64
        ki_pll::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a Phase-Locked Loop (PLL) for VSM

# Arguments
- `ω_lp::Float64`: PLL low-pass filter frequency (rad/sec), validation range: (0, nothing)
- `kp_pll::Float64`: PLL proportional gain, validation range: (0, nothing)
- `ki_pll::Float64`: PLL integral gain, validation range: (0, nothing)
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct PLL <: FrequencyEstimator
    "PLL low-pass filter frequency (rad/sec)"
    ω_lp::Float64
    "PLL proportional gain"
    kp_pll::Float64
    "PLL integral gain"
    ki_pll::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function PLL(ω_lp, kp_pll, ki_pll, ext=Dict{String, Any}(), )
    PLL(ω_lp, kp_pll, ki_pll, ext, [:vpll_d, :vpll_q, :ε_pll, :δθ_pll], 4, InfrastructureSystemsInternal(), )
end

function PLL(; ω_lp, kp_pll, ki_pll, ext=Dict{String, Any}(), )
    PLL(ω_lp, kp_pll, ki_pll, ext, )
end

# Constructor for demo purposes; non-functional.
function PLL(::Nothing)
    PLL(;
        ω_lp=0,
        kp_pll=0,
        ki_pll=0,
        ext=Dict{String, Any}(),
    )
end

"""Get PLL ω_lp."""
get_ω_lp(value::PLL) = value.ω_lp
"""Get PLL kp_pll."""
get_kp_pll(value::PLL) = value.kp_pll
"""Get PLL ki_pll."""
get_ki_pll(value::PLL) = value.ki_pll
"""Get PLL ext."""
get_ext(value::PLL) = value.ext
"""Get PLL states."""
get_states(value::PLL) = value.states
"""Get PLL n_states."""
get_n_states(value::PLL) = value.n_states
"""Get PLL internal."""
get_internal(value::PLL) = value.internal
