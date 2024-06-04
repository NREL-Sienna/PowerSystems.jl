#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct VariableReserve{T <: ReserveDirection} <: Reserve{T}
        name::String
        available::Bool
        time_frame::Float64
        requirement::Float64
        sustained_time::Float64
        max_output_fraction::Float64
        max_participation_factor::Float64
        deployed_fraction::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Data Structure for the procurement products for system simulations.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `time_frame::Float64`: the saturation time_frame in minutes to provide reserve contribution, validation range: `(0, nothing)`, action if invalid: `error`
- `requirement::Float64`: the required quantity of the product should be scaled by a TimeSeriesData
- `sustained_time::Float64`: (optional) the time in seconds reserve contribution must sustained at a specified level, validation range: `(0, nothing)`, action if invalid: `error`
- `max_output_fraction::Float64`: (optional) the maximum fraction of each device's output that can be assigned to the service, validation range: `(0, 1)`, action if invalid: `error`
- `max_participation_factor::Float64`: (optional) the maximum portion [0, 1.0] of the reserve that can be contributed per device, validation range: `(0, 1)`, action if invalid: `error`
- `deployed_fraction::Float64`: (optional) Fraction of ancillary services participation deployed from the assignment, validation range: `(0, 1)`, action if invalid: `error`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct VariableReserve{T <: ReserveDirection} <: Reserve{T}
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "the saturation time_frame in minutes to provide reserve contribution"
    time_frame::Float64
    "the required quantity of the product should be scaled by a TimeSeriesData"
    requirement::Float64
    "(optional) the time in seconds reserve contribution must sustained at a specified level"
    sustained_time::Float64
    "(optional) the maximum fraction of each device's output that can be assigned to the service"
    max_output_fraction::Float64
    "(optional) the maximum portion [0, 1.0] of the reserve that can be contributed per device"
    max_participation_factor::Float64
    "(optional) Fraction of ancillary services participation deployed from the assignment"
    deployed_fraction::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function VariableReserve{T}(name, available, time_frame, requirement, sustained_time=3600.0, max_output_fraction=1.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    VariableReserve{T}(name, available, time_frame, requirement, sustained_time, max_output_fraction, max_participation_factor, deployed_fraction, ext, InfrastructureSystemsInternal(), )
end

function VariableReserve{T}(; name, available, time_frame, requirement, sustained_time=3600.0, max_output_fraction=1.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), ) where T <: ReserveDirection
    VariableReserve{T}(name, available, time_frame, requirement, sustained_time, max_output_fraction, max_participation_factor, deployed_fraction, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function VariableReserve{T}(::Nothing) where T <: ReserveDirection
    VariableReserve{T}(;
        name="init",
        available=false,
        time_frame=0.0,
        requirement=0.0,
        sustained_time=0.0,
        max_output_fraction=1.0,
        max_participation_factor=1.0,
        deployed_fraction=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`VariableReserve`](@ref) `name`."""
get_name(value::VariableReserve) = value.name
"""Get [`VariableReserve`](@ref) `available`."""
get_available(value::VariableReserve) = value.available
"""Get [`VariableReserve`](@ref) `time_frame`."""
get_time_frame(value::VariableReserve) = value.time_frame
"""Get [`VariableReserve`](@ref) `requirement`."""
get_requirement(value::VariableReserve) = value.requirement
"""Get [`VariableReserve`](@ref) `sustained_time`."""
get_sustained_time(value::VariableReserve) = value.sustained_time
"""Get [`VariableReserve`](@ref) `max_output_fraction`."""
get_max_output_fraction(value::VariableReserve) = value.max_output_fraction
"""Get [`VariableReserve`](@ref) `max_participation_factor`."""
get_max_participation_factor(value::VariableReserve) = value.max_participation_factor
"""Get [`VariableReserve`](@ref) `deployed_fraction`."""
get_deployed_fraction(value::VariableReserve) = value.deployed_fraction
"""Get [`VariableReserve`](@ref) `ext`."""
get_ext(value::VariableReserve) = value.ext
"""Get [`VariableReserve`](@ref) `internal`."""
get_internal(value::VariableReserve) = value.internal

"""Set [`VariableReserve`](@ref) `available`."""
set_available!(value::VariableReserve, val) = value.available = val
"""Set [`VariableReserve`](@ref) `time_frame`."""
set_time_frame!(value::VariableReserve, val) = value.time_frame = val
"""Set [`VariableReserve`](@ref) `requirement`."""
set_requirement!(value::VariableReserve, val) = value.requirement = val
"""Set [`VariableReserve`](@ref) `sustained_time`."""
set_sustained_time!(value::VariableReserve, val) = value.sustained_time = val
"""Set [`VariableReserve`](@ref) `max_output_fraction`."""
set_max_output_fraction!(value::VariableReserve, val) = value.max_output_fraction = val
"""Set [`VariableReserve`](@ref) `max_participation_factor`."""
set_max_participation_factor!(value::VariableReserve, val) = value.max_participation_factor = val
"""Set [`VariableReserve`](@ref) `deployed_fraction`."""
set_deployed_fraction!(value::VariableReserve, val) = value.deployed_fraction = val
"""Set [`VariableReserve`](@ref) `ext`."""
set_ext!(value::VariableReserve, val) = value.ext = val
