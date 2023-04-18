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
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

Data Structure for the procurement products for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the relative saturation time_frame, validation range: `(0, nothing)`, action if invalid: `error`
- `requirement::Float64`: the required quantity of the product should be scaled by a TimeSeriesData
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct VariableReserveNonSpinning <: ReserveNonSpinning
    name::String
    available::Bool
    "the relative saturation time_frame"
    time_frame::Float64
    "the required quantity of the product should be scaled by a TimeSeriesData"
    requirement::Float64
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function VariableReserveNonSpinning(name, available, time_frame, requirement, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    VariableReserveNonSpinning(name, available, time_frame, requirement, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function VariableReserveNonSpinning(; name, available, time_frame, requirement, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    VariableReserveNonSpinning(name, available, time_frame, requirement, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function VariableReserveNonSpinning(::Nothing)
    VariableReserveNonSpinning(;
        name="init",
        available=false,
        time_frame=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
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
"""Get [`VariableReserveNonSpinning`](@ref) `ext`."""
get_ext(value::VariableReserveNonSpinning) = value.ext
"""Get [`VariableReserveNonSpinning`](@ref) `time_series_container`."""
get_time_series_container(value::VariableReserveNonSpinning) = value.time_series_container
"""Get [`VariableReserveNonSpinning`](@ref) `internal`."""
get_internal(value::VariableReserveNonSpinning) = value.internal

"""Set [`VariableReserveNonSpinning`](@ref) `available`."""
set_available!(value::VariableReserveNonSpinning, val) = value.available = val
"""Set [`VariableReserveNonSpinning`](@ref) `time_frame`."""
set_time_frame!(value::VariableReserveNonSpinning, val) = value.time_frame = val
"""Set [`VariableReserveNonSpinning`](@ref) `requirement`."""
set_requirement!(value::VariableReserveNonSpinning, val) = value.requirement = set_value(value, val)
"""Set [`VariableReserveNonSpinning`](@ref) `ext`."""
set_ext!(value::VariableReserveNonSpinning, val) = value.ext = val
"""Set [`VariableReserveNonSpinning`](@ref) `time_series_container`."""
set_time_series_container!(value::VariableReserveNonSpinning, val) = value.time_series_container = val
