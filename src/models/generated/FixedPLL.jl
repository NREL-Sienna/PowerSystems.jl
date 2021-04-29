#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct FixedPLL <: FrequencyEstimator
        ω_pll_ref::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Fixed PLL (or no PLL).

# Arguments
- `ω_pll_ref::Float64`: Reference used
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`: FixedPLL has no states
- `n_states::Int`: FixedPLL has no states
"""
mutable struct FixedPLL <: FrequencyEstimator
    "Reference used"
    ω_pll_ref::Float64
    ext::Dict{String, Any}
    "FixedPLL has no states"
    states::Vector{Symbol}
    "FixedPLL has no states"
    n_states::Int
end

function FixedPLL(ω_pll_ref=1.0, ext=Dict{String, Any}(), )
    FixedPLL(ω_pll_ref, ext, Vector{Symbol}(), 0, )
end

function FixedPLL(; ω_pll_ref=1.0, ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, )
    FixedPLL(ω_pll_ref, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function FixedPLL(::Nothing)
    FixedPLL(;
        ω_pll_ref=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`FixedPLL`](@ref) `ω_pll_ref`."""
get_ω_pll_ref(value::FixedPLL) = value.ω_pll_ref
"""Get [`FixedPLL`](@ref) `ext`."""
get_ext(value::FixedPLL) = value.ext
"""Get [`FixedPLL`](@ref) `states`."""
get_states(value::FixedPLL) = value.states
"""Get [`FixedPLL`](@ref) `n_states`."""
get_n_states(value::FixedPLL) = value.n_states

"""Set [`FixedPLL`](@ref) `ω_pll_ref`."""
set_ω_pll_ref!(value::FixedPLL, val) = value.ω_pll_ref = val
"""Set [`FixedPLL`](@ref) `ext`."""
set_ext!(value::FixedPLL, val) = value.ext = val

