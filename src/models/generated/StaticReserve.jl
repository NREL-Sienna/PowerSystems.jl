#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct StaticReserve{T <: ReserveDirection} <: Reserve{T}
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

Data Structure for a proportional reserve product for system simulations.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon.
- `time_frame::Float64`: the saturation time_frame in minutes to provide reserve contribution, validation range: `(0, nothing)`, action if invalid: `error`
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: `(0, nothing)`, action if invalid: `error`
- `sustained_time::Float64`: the time in secounds reserve contribution must sustained at a specified level, validation range: `(0, nothing)`, action if invalid: `error`
- `max_output_fraction::Float64`: the maximum fraction of the device's output that can be assigned to the service, validation range: `(0, 1)`, action if invalid: `error`
- `max_participation_factor::Float64`: the maximum limit of reserve contribution per device, validation range: `(0, 1)`, action if invalid: `error`
- `deployed_fraction::Float64`: Fraction of ancillary services participation deployed from the assignment, validation range: `(0, 1)`, action if invalid: `error`
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct StaticReserve{T <: ReserveDirection} <: Reserve{T}
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon."
    available::Bool
    "the saturation time_frame in minutes to provide reserve contribution"
    time_frame::Float64
    "the static value of required reserves in system p.u."
    requirement::Float64
    "the time in secounds reserve contribution must sustained at a specified level"
    sustained_time::Float64
    "the maximum fraction of the device's output that can be assigned to the service"
    max_output_fraction::Float64
    "the maximum limit of reserve contribution per device"
    max_participation_factor::Float64
    "Fraction of ancillary services participation deployed from the assignment"
    deployed_fraction::Float64
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function StaticReserve{T}(name, available, time_frame, requirement, sustained_time=3600.0, max_output_fraction=1.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    StaticReserve{T}(name, available, time_frame, requirement, sustained_time, max_output_fraction, max_participation_factor, deployed_fraction, ext, InfrastructureSystemsInternal(), )
end

function StaticReserve{T}(; name, available, time_frame, requirement, sustained_time=3600.0, max_output_fraction=1.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), ) where T <: ReserveDirection
    StaticReserve{T}(name, available, time_frame, requirement, sustained_time, max_output_fraction, max_participation_factor, deployed_fraction, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function StaticReserve{T}(::Nothing) where T <: ReserveDirection
    StaticReserve{T}(;
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

"""Get [`StaticReserve`](@ref) `name`."""
get_name(value::StaticReserve) = value.name
"""Get [`StaticReserve`](@ref) `available`."""
get_available(value::StaticReserve) = value.available
"""Get [`StaticReserve`](@ref) `time_frame`."""
get_time_frame(value::StaticReserve) = value.time_frame
"""Get [`StaticReserve`](@ref) `requirement`."""
get_requirement(value::StaticReserve) = get_value(value, value.requirement)
"""Get [`StaticReserve`](@ref) `sustained_time`."""
get_sustained_time(value::StaticReserve) = value.sustained_time
"""Get [`StaticReserve`](@ref) `max_output_fraction`."""
get_max_output_fraction(value::StaticReserve) = value.max_output_fraction
"""Get [`StaticReserve`](@ref) `max_participation_factor`."""
get_max_participation_factor(value::StaticReserve) = value.max_participation_factor
"""Get [`StaticReserve`](@ref) `deployed_fraction`."""
get_deployed_fraction(value::StaticReserve) = value.deployed_fraction
"""Get [`StaticReserve`](@ref) `ext`."""
get_ext(value::StaticReserve) = value.ext
"""Get [`StaticReserve`](@ref) `internal`."""
get_internal(value::StaticReserve) = value.internal

"""Set [`StaticReserve`](@ref) `available`."""
set_available!(value::StaticReserve, val) = value.available = val
"""Set [`StaticReserve`](@ref) `time_frame`."""
set_time_frame!(value::StaticReserve, val) = value.time_frame = val
"""Set [`StaticReserve`](@ref) `requirement`."""
set_requirement!(value::StaticReserve, val) = value.requirement = set_value(value, val)
"""Set [`StaticReserve`](@ref) `sustained_time`."""
set_sustained_time!(value::StaticReserve, val) = value.sustained_time = val
"""Set [`StaticReserve`](@ref) `max_output_fraction`."""
set_max_output_fraction!(value::StaticReserve, val) = value.max_output_fraction = val
"""Set [`StaticReserve`](@ref) `max_participation_factor`."""
set_max_participation_factor!(value::StaticReserve, val) = value.max_participation_factor = val
"""Set [`StaticReserve`](@ref) `deployed_fraction`."""
set_deployed_fraction!(value::StaticReserve, val) = value.deployed_fraction = val
"""Set [`StaticReserve`](@ref) `ext`."""
set_ext!(value::StaticReserve, val) = value.ext = val
