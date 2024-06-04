#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct FixedFrequency <: FrequencyEstimator
        frequency::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
    end

Parameters of a Fixed Frequency Estimator (i.e. no PLL)

# Arguments
- `frequency::Float64`: Reference Frequency (pu)
- `ext::Dict{String, Any}`: An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)
- `states::Vector{Symbol}`: (**Do not modify.**) FixedFrequency has no [states](@ref S)
- `n_states::Int`: (**Do not modify.**) FixedFrequency has no states
"""
mutable struct FixedFrequency <: FrequencyEstimator
    "Reference Frequency (pu)"
    frequency::Float64
    "An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)"
    ext::Dict{String, Any}
    "(**Do not modify.**) FixedFrequency has no [states](@ref S)"
    states::Vector{Symbol}
    "(**Do not modify.**) FixedFrequency has no states"
    n_states::Int
end


function FixedFrequency(; frequency=1.0, ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, )
    FixedFrequency(frequency, ext, states, n_states, )
end

# Constructor for demo purposes; non-functional.
function FixedFrequency(::Nothing)
    FixedFrequency(;
        frequency=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`FixedFrequency`](@ref) `frequency`."""
get_frequency(value::FixedFrequency) = value.frequency
"""Get [`FixedFrequency`](@ref) `ext`."""
get_ext(value::FixedFrequency) = value.ext
"""Get [`FixedFrequency`](@ref) `states`."""
get_states(value::FixedFrequency) = value.states
"""Get [`FixedFrequency`](@ref) `n_states`."""
get_n_states(value::FixedFrequency) = value.n_states

"""Set [`FixedFrequency`](@ref) `frequency`."""
set_frequency!(value::FixedFrequency, val) = value.frequency = val
"""Set [`FixedFrequency`](@ref) `ext`."""
set_ext!(value::FixedFrequency, val) = value.ext = val
