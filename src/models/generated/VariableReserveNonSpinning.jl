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
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
        internal::InfrastructureSystemsInternal
    end

Data Structure for the procurement products for system simulations.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon.
- `time_frame::Float64`: the saturation time_frame in minutes to provide reserve contribution, validation range: `(0, nothing)`, action if invalid: `error`
- `requirement::Float64`: the required quantity of the product should be scaled by a TimeSeriesData
- `sustained_time::Float64`: the time in secounds reserve contribution must sustained at a specified level, validation range: `(0, nothing)`, action if invalid: `error`
- `max_output_fraction::Float64`: the maximum fraction of the device's output that can be assigned to the service, validation range: `(0, 1)`, action if invalid: `error`
- `max_participation_factor::Float64`: the maximum limit of reserve contribution per device, validation range: `(0, 1)`, action if invalid: `error`
- `deployed_fraction::Float64`: Fraction of ancillary services participation deployed from the assignment, validation range: `(0, 1)`, action if invalid: `error`
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data).
- `supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer`: container for supplemental attributes
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct VariableReserveNonSpinning <: ReserveNonSpinning
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon."
    available::Bool
    "the saturation time_frame in minutes to provide reserve contribution"
    time_frame::Float64
    "the required quantity of the product should be scaled by a TimeSeriesData"
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
    "Contains references to the time-series data linked to this component, such as forecast time-series of `active_power` for a renewable generator or a single time-series of component availability to model line outages. See [`Time Series Data`](@ref ts_data)."
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "container for supplemental attributes"
    supplemental_attributes_container::InfrastructureSystems.SupplementalAttributesContainer
    "PowerSystems.jl internal reference. **Do not modify.**"
    internal::InfrastructureSystemsInternal
end

function VariableReserveNonSpinning(name, available, time_frame, requirement, sustained_time=14400.0, max_output_fraction=1.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), )
    VariableReserveNonSpinning(name, available, time_frame, requirement, sustained_time, max_output_fraction, max_participation_factor, deployed_fraction, ext, time_series_container, supplemental_attributes_container, InfrastructureSystemsInternal(), )
end

function VariableReserveNonSpinning(; name, available, time_frame, requirement, sustained_time=14400.0, max_output_fraction=1.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(), internal=InfrastructureSystemsInternal(), )
    VariableReserveNonSpinning(name, available, time_frame, requirement, sustained_time, max_output_fraction, max_participation_factor, deployed_fraction, ext, time_series_container, supplemental_attributes_container, internal, )
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
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
        supplemental_attributes_container=InfrastructureSystems.SupplementalAttributesContainer(),
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
"""Get [`VariableReserveNonSpinning`](@ref) `time_series_container`."""
get_time_series_container(value::VariableReserveNonSpinning) = value.time_series_container
"""Get [`VariableReserveNonSpinning`](@ref) `supplemental_attributes_container`."""
get_supplemental_attributes_container(value::VariableReserveNonSpinning) = value.supplemental_attributes_container
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
"""Set [`VariableReserveNonSpinning`](@ref) `time_series_container`."""
set_time_series_container!(value::VariableReserveNonSpinning, val) = value.time_series_container = val
"""Set [`VariableReserveNonSpinning`](@ref) `supplemental_attributes_container`."""
set_supplemental_attributes_container!(value::VariableReserveNonSpinning, val) = value.supplemental_attributes_container = val
