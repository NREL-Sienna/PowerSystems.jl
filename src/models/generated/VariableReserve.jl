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

A reserve product with a time-varying procurement requirement, such as a higher requirement during hours with an expected high load or high ramp.

This reserve product includes online generators that can respond right away after an unexpected contingency, such as a transmission line or generator outage. When defining the reserve, the `ReserveDirection` must be specified to define this as a [`ReserveUp`](@ref), [`ReserveDown`](@ref), or [`ReserveSymmetric`](@ref). To model the time varying requirement, a ["`requirement`" time series should be added](@ref ts_data) to this reserve

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `time_frame::Float64`: the saturation time_frame in minutes to provide reserve contribution, validation range: `(0, nothing)`
- `requirement::Float64`: the required quantity of the product should be scaled by a TimeSeriesData
- `sustained_time::Float64`: (default: `3600.0`) the time in seconds reserve contribution must sustained at a specified level, validation range: `(0, nothing)`
- `max_output_fraction::Float64`: (default: `1.0`) the maximum fraction of each device's output that can be assigned to the service, validation range: `(0, 1)`
- `max_participation_factor::Float64`: (default: `1.0`) the maximum portion [0, 1.0] of the reserve that can be contributed per device, validation range: `(0, 1)`
- `deployed_fraction::Float64`: (default: `0.0`) Fraction of service procurement that is assumed to be actually deployed. Most commonly, this is assumed to be either 0.0 or 1.0, validation range: `(0, 1)`
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct VariableReserve{T <: ReserveDirection} <: Reserve{T}
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "the saturation time_frame in minutes to provide reserve contribution"
    time_frame::Float64
    "the required quantity of the product should be scaled by a TimeSeriesData"
    requirement::Float64
    "the time in seconds reserve contribution must sustained at a specified level"
    sustained_time::Float64
    "the maximum fraction of each device's output that can be assigned to the service"
    max_output_fraction::Float64
    "the maximum portion [0, 1.0] of the reserve that can be contributed per device"
    max_participation_factor::Float64
    "Fraction of service procurement that is assumed to be actually deployed. Most commonly, this is assumed to be either 0.0 or 1.0"
    deployed_fraction::Float64
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
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
