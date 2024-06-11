#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct VariableReserveNonSpinning <: ReserveNonSpinning
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
- `time_frame::Float64`: the saturation time_frame in minutes to provide reserve contribution, validation range: `(0, nothing)`
- `requirement::Float64`: the required quantity of the product should be scaled by a TimeSeriesData
- `sustained_time::Float64`: (default: `14400.0`) (optional) the time in seconds reserve contribution must sustained at a specified level, validation range: `(0, nothing)`
- `max_output_fraction::Float64`: (default: `1.0`) (optional) the maximum fraction of each device's output that can be assigned to the service, validation range: `(0, 1)`
- `max_participation_factor::Float64`: (default: `1.0`) (optional) the maximum portion [0, 1.0] of the reserve that can be contributed per device, validation range: `(0, 1)`
- `deployed_fraction::Float64`: (default: `0.0`) (optional) Fraction of ancillary services participation deployed from the assignment, validation range: `(0, 1)`
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct VariableReserveNonSpinning <: ReserveNonSpinning
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

function VariableReserveNonSpinning(name, available, time_frame, requirement, sustained_time=14400.0, max_output_fraction=1.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), )
    VariableReserveNonSpinning(name, available, time_frame, requirement, sustained_time, max_output_fraction, max_participation_factor, deployed_fraction, ext, InfrastructureSystemsInternal(), )
end

function VariableReserveNonSpinning(; name, available, time_frame, requirement, sustained_time=14400.0, max_output_fraction=1.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    VariableReserveNonSpinning(name, available, time_frame, requirement, sustained_time, max_output_fraction, max_participation_factor, deployed_fraction, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function VariableReserveNonSpinning(::Nothing)
    VariableReserveNonSpinning(;
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

"""Get [`VariableReserveNonSpinning`](@ref) `name`."""
get_name(value::VariableReserveNonSpinning) = value.name
"""Get [`VariableReserveNonSpinning`](@ref) `available`."""
get_available(value::VariableReserveNonSpinning) = value.available
"""Get [`VariableReserveNonSpinning`](@ref) `time_frame`."""
get_time_frame(value::VariableReserveNonSpinning) = value.time_frame
"""Get [`VariableReserveNonSpinning`](@ref) `requirement`."""
get_requirement(value::VariableReserveNonSpinning) = get_value(value, value.requirement)
"""Get [`VariableReserveNonSpinning`](@ref) `sustained_time`."""
get_sustained_time(value::VariableReserveNonSpinning) = value.sustained_time
"""Get [`VariableReserveNonSpinning`](@ref) `max_output_fraction`."""
get_max_output_fraction(value::VariableReserveNonSpinning) = value.max_output_fraction
"""Get [`VariableReserveNonSpinning`](@ref) `max_participation_factor`."""
get_max_participation_factor(value::VariableReserveNonSpinning) = value.max_participation_factor
"""Get [`VariableReserveNonSpinning`](@ref) `deployed_fraction`."""
get_deployed_fraction(value::VariableReserveNonSpinning) = value.deployed_fraction
"""Get [`VariableReserveNonSpinning`](@ref) `ext`."""
get_ext(value::VariableReserveNonSpinning) = value.ext
"""Get [`VariableReserveNonSpinning`](@ref) `internal`."""
get_internal(value::VariableReserveNonSpinning) = value.internal

"""Set [`VariableReserveNonSpinning`](@ref) `available`."""
set_available!(value::VariableReserveNonSpinning, val) = value.available = val
"""Set [`VariableReserveNonSpinning`](@ref) `time_frame`."""
set_time_frame!(value::VariableReserveNonSpinning, val) = value.time_frame = val
"""Set [`VariableReserveNonSpinning`](@ref) `requirement`."""
set_requirement!(value::VariableReserveNonSpinning, val) = value.requirement = set_value(value, val)
"""Set [`VariableReserveNonSpinning`](@ref) `sustained_time`."""
set_sustained_time!(value::VariableReserveNonSpinning, val) = value.sustained_time = val
"""Set [`VariableReserveNonSpinning`](@ref) `max_output_fraction`."""
set_max_output_fraction!(value::VariableReserveNonSpinning, val) = value.max_output_fraction = val
"""Set [`VariableReserveNonSpinning`](@ref) `max_participation_factor`."""
set_max_participation_factor!(value::VariableReserveNonSpinning, val) = value.max_participation_factor = val
"""Set [`VariableReserveNonSpinning`](@ref) `deployed_fraction`."""
set_deployed_fraction!(value::VariableReserveNonSpinning, val) = value.deployed_fraction = val
"""Set [`VariableReserveNonSpinning`](@ref) `ext`."""
set_ext!(value::VariableReserveNonSpinning, val) = value.ext = val
