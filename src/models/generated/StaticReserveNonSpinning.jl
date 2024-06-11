#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct StaticReserveNonSpinning <: ReserveNonSpinning
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

Data Structure for a non-spinning reserve product for system simulations.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `time_frame::Float64`: the saturation time_frame in minutes to provide reserve contribution, validation range: `(0, nothing)`
- `requirement::Float64`: the static value of required reserves in p.u. ([`System Base`](@ref per_unit)), validation range: `(0, nothing)`
- `sustained_time::Float64`: (default: `3600.0`) (optional) the time in seconds reserve contribution must sustained at a specified level, validation range: `(0, nothing)`
- `max_output_fraction::Float64`: (default: `1.0`) (optional) the maximum fraction of each device's output that can be assigned to the service, validation range: `(0, 1)`
- `max_participation_factor::Float64`: (default: `1.0`) (optional) the maximum portion [0, 1.0] of the reserve that can be contributed per device, validation range: `(0, 1)`
- `deployed_fraction::Float64`: (default: `0.0`) (optional) Fraction of ancillary services participation deployed from the assignment, validation range: `(0, 1)`
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct StaticReserveNonSpinning <: ReserveNonSpinning
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "the saturation time_frame in minutes to provide reserve contribution"
    time_frame::Float64
    "the static value of required reserves in p.u. ([`System Base`](@ref per_unit))"
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

function StaticReserveNonSpinning(name, available, time_frame, requirement, sustained_time=3600.0, max_output_fraction=1.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), )
    StaticReserveNonSpinning(name, available, time_frame, requirement, sustained_time, max_output_fraction, max_participation_factor, deployed_fraction, ext, InfrastructureSystemsInternal(), )
end

function StaticReserveNonSpinning(; name, available, time_frame, requirement, sustained_time=3600.0, max_output_fraction=1.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    StaticReserveNonSpinning(name, available, time_frame, requirement, sustained_time, max_output_fraction, max_participation_factor, deployed_fraction, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function StaticReserveNonSpinning(::Nothing)
    StaticReserveNonSpinning(;
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

"""Get [`StaticReserveNonSpinning`](@ref) `name`."""
get_name(value::StaticReserveNonSpinning) = value.name
"""Get [`StaticReserveNonSpinning`](@ref) `available`."""
get_available(value::StaticReserveNonSpinning) = value.available
"""Get [`StaticReserveNonSpinning`](@ref) `time_frame`."""
get_time_frame(value::StaticReserveNonSpinning) = value.time_frame
"""Get [`StaticReserveNonSpinning`](@ref) `requirement`."""
get_requirement(value::StaticReserveNonSpinning) = get_value(value, value.requirement)
"""Get [`StaticReserveNonSpinning`](@ref) `sustained_time`."""
get_sustained_time(value::StaticReserveNonSpinning) = value.sustained_time
"""Get [`StaticReserveNonSpinning`](@ref) `max_output_fraction`."""
get_max_output_fraction(value::StaticReserveNonSpinning) = value.max_output_fraction
"""Get [`StaticReserveNonSpinning`](@ref) `max_participation_factor`."""
get_max_participation_factor(value::StaticReserveNonSpinning) = value.max_participation_factor
"""Get [`StaticReserveNonSpinning`](@ref) `deployed_fraction`."""
get_deployed_fraction(value::StaticReserveNonSpinning) = value.deployed_fraction
"""Get [`StaticReserveNonSpinning`](@ref) `ext`."""
get_ext(value::StaticReserveNonSpinning) = value.ext
"""Get [`StaticReserveNonSpinning`](@ref) `internal`."""
get_internal(value::StaticReserveNonSpinning) = value.internal

"""Set [`StaticReserveNonSpinning`](@ref) `available`."""
set_available!(value::StaticReserveNonSpinning, val) = value.available = val
"""Set [`StaticReserveNonSpinning`](@ref) `time_frame`."""
set_time_frame!(value::StaticReserveNonSpinning, val) = value.time_frame = val
"""Set [`StaticReserveNonSpinning`](@ref) `requirement`."""
set_requirement!(value::StaticReserveNonSpinning, val) = value.requirement = set_value(value, val)
"""Set [`StaticReserveNonSpinning`](@ref) `sustained_time`."""
set_sustained_time!(value::StaticReserveNonSpinning, val) = value.sustained_time = val
"""Set [`StaticReserveNonSpinning`](@ref) `max_output_fraction`."""
set_max_output_fraction!(value::StaticReserveNonSpinning, val) = value.max_output_fraction = val
"""Set [`StaticReserveNonSpinning`](@ref) `max_participation_factor`."""
set_max_participation_factor!(value::StaticReserveNonSpinning, val) = value.max_participation_factor = val
"""Set [`StaticReserveNonSpinning`](@ref) `deployed_fraction`."""
set_deployed_fraction!(value::StaticReserveNonSpinning, val) = value.deployed_fraction = val
"""Set [`StaticReserveNonSpinning`](@ref) `ext`."""
set_ext!(value::StaticReserveNonSpinning, val) = value.ext = val
