#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct FixedDCSource <: DCSource
        voltage::Float64
        ext::Dict{String, Any}
        states::Vector{Symbol}
        n_states::Int64
        internal::InfrastructureSystemsInternal
    end

Parameters of a Fixed DC Source that returns a fixed DC voltage

# Arguments
- `voltage::Float64`: rated VA, validation range: `(0, nothing)`
- `ext::Dict{String, Any}`
- `states::Vector{Symbol}`
- `n_states::Int64`: FixedDCSource has no states
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct FixedDCSource <: DCSource
    "rated VA"
    voltage::Float64
    ext::Dict{String, Any}
    states::Vector{Symbol}
    "FixedDCSource has no states"
    n_states::Int64
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function FixedDCSource(voltage, ext=Dict{String, Any}(), )
    FixedDCSource(voltage, ext, Vector{Symbol}(), 0, InfrastructureSystemsInternal(), )
end

function FixedDCSource(; voltage, ext=Dict{String, Any}(), )
    FixedDCSource(voltage, ext, )
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
"""Set [`FixedDCSource`](@ref) `states`."""
set_states!(value::FixedDCSource, val) = value.states = val
"""Set [`FixedDCSource`](@ref) `n_states`."""
set_n_states!(value::FixedDCSource, val) = value.n_states = val
"""Set [`FixedDCSource`](@ref) `internal`."""
set_internal!(value::FixedDCSource, val) = value.internal = val
