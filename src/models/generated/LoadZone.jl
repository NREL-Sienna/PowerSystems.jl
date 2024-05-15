#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct LoadZone <: AggregationTopology
        name::String
        peak_active_power::Float64
        peak_reactive_power::Float64
        internal::InfrastructureSystemsInternal
    end

A load zone for electricity price analysis.

The load zone can be specified when defining each [`ACBus`](@ref) or [`DCBus`](@ref) in the zone.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `peak_active_power::Float64`: (optional) Peak active power in the zone (MW)
- `peak_reactive_power::Float64`: (optional) Peak reactive power in the zone (MVAR)
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct LoadZone <: AggregationTopology
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "(optional) Peak active power in the zone (MW)"
    peak_active_power::Float64
    "(optional) Peak reactive power in the zone (MVAR)"
    peak_reactive_power::Float64
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function LoadZone(name, peak_active_power, peak_reactive_power, )
    LoadZone(name, peak_active_power, peak_reactive_power, InfrastructureSystemsInternal(), )
end

function LoadZone(; name, peak_active_power, peak_reactive_power, internal=InfrastructureSystemsInternal(), )
    LoadZone(name, peak_active_power, peak_reactive_power, internal, )
end

# Constructor for demo purposes; non-functional.
function LoadZone(::Nothing)
    LoadZone(;
        name="init",
        peak_active_power=0.0,
        peak_reactive_power=0.0,
    )
end

"""Get [`LoadZone`](@ref) `name`."""
get_name(value::LoadZone) = value.name
"""Get [`LoadZone`](@ref) `peak_active_power`."""
get_peak_active_power(value::LoadZone) = get_value(value, value.peak_active_power)
"""Get [`LoadZone`](@ref) `peak_reactive_power`."""
get_peak_reactive_power(value::LoadZone) = get_value(value, value.peak_reactive_power)
"""Get [`LoadZone`](@ref) `internal`."""
get_internal(value::LoadZone) = value.internal

"""Set [`LoadZone`](@ref) `peak_active_power`."""
set_peak_active_power!(value::LoadZone, val) = value.peak_active_power = set_value(value, val)
"""Set [`LoadZone`](@ref) `peak_reactive_power`."""
set_peak_reactive_power!(value::LoadZone, val) = value.peak_reactive_power = set_value(value, val)
