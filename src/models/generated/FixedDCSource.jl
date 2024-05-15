#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct FixedDCSource <: DCSource
        voltage::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int
        internal::InfrastructureSystemsInternal
    end

Parameters of a Fixed DC Source that returns a fixed DC voltage

# Arguments
- `voltage::Float64`: rated VA, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `states::Vector{Symbol}`
- `n_states::Int`: FixedDCSource has no states
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct FixedDCSource <: DCSource
    "rated VA"
    voltage::Float64
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    states::Vector{Symbol}
    "FixedDCSource has no states"
    n_states::Int
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function FixedDCSource(voltage, ext=Dict{String, Any}(), )
    FixedDCSource(voltage, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function FixedDCSource(; voltage, ext=Dict{String, Any}(), states=Vector{Symbol}(), n_states=0, internal=InfrastructureSystemsInternal(), )
    FixedDCSource(voltage, ext, states, n_states, internal, )
end

# Constructor for demo purposes; non-functional.
function FixedDCSource(::Nothing)
    FixedDCSource(;
        voltage=0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`FixedDCSource`](@ref) `voltage`."""
get_voltage(value::FixedDCSource) = value.voltage
"""Get [`FixedDCSource`](@ref) `ext`."""
get_ext(value::FixedDCSource) = value.ext
"""Get [`FixedDCSource`](@ref) `states`."""
get_states(value::FixedDCSource) = value.states
"""Get [`FixedDCSource`](@ref) `n_states`."""
get_n_states(value::FixedDCSource) = value.n_states
"""Get [`FixedDCSource`](@ref) `internal`."""
get_internal(value::FixedDCSource) = value.internal

"""Set [`FixedDCSource`](@ref) `voltage`."""
set_voltage!(value::FixedDCSource, val) = value.voltage = val
"""Set [`FixedDCSource`](@ref) `ext`."""
set_ext!(value::FixedDCSource, val) = value.ext = val
