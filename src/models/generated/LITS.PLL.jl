#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct LITS.PLL <: FrequencyEstimator
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
- `ω_lp::Float64`: PLL low-pass filter frequency (rad/sec)
- `kp_pll::Float64`: PLL proportional gain
- `ki_pll::Float64`: PLL integral gain
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct LITS.PLL <: FrequencyEstimator
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

function LITS.PLL(ω_lp, kp_pll, ki_pll, ext=Dict{String, Any}(), )
    LITS.PLL(ω_lp, kp_pll, ki_pll, ext, [:vpll_d, :vpll_q, :ε_pll, :δθ_pll], 4, InfrastructureSystemsInternal(), )
end

function LITS.PLL(; ω_lp, kp_pll, ki_pll, ext=Dict{String, Any}(), )
    LITS.PLL(ω_lp, kp_pll, ki_pll, ext, )
end

# Constructor for demo purposes; non-functional.
function LITS.PLL(::Nothing)
    LITS.PLL(;
        ω_lp=0,
        kp_pll=0,
        ki_pll=0,
        ext=Dict{String, Any}(),
    )
end

"""Get LITS.PLL ω_lp."""
get_ω_lp(value::LITS.PLL) = value.ω_lp
"""Get LITS.PLL kp_pll."""
get_kp_pll(value::LITS.PLL) = value.kp_pll
"""Get LITS.PLL ki_pll."""
get_ki_pll(value::LITS.PLL) = value.ki_pll
"""Get LITS.PLL ext."""
get_ext(value::LITS.PLL) = value.ext
"""Get LITS.PLL states."""
get_states(value::LITS.PLL) = value.states
"""Get LITS.PLL n_states."""
get_n_states(value::LITS.PLL) = value.n_states
"""Get LITS.PLL internal."""
get_internal(value::LITS.PLL) = value.internal
