#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ReserveDemandCurve{T <: ReserveDirection} <: Reserve{T}
        variable::Union{Nothing, TimeSeriesKey}
        name::String
        available::Bool
        time_frame::Float64
        sustained_time::Float64
        max_participation_factor::Float64
        deployed_fraction::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A reserve product with an [Operating Reserve Demand Curve (ORDC)](https://hepg.hks.harvard.edu/files/hepg/files/ordcupdate-final.pdf) for operational simulations.

The ORDC is modeled as a discretized set of `(Reserve capacity (MW), Price (\$/MWh))` steps, which can vary with time. Use [`set_variable_cost!`](@ref) to define the ORDCs.

When defining the reserve, the `ReserveDirection` must be specified to define this as a [`ReserveUp`](@ref), [`ReserveDown`](@ref), or [`ReserveSymmetric`](@ref)

# Arguments
- `variable::Union{Nothing, TimeSeriesKey}`: Create this object with `variable` = `nothing`, then add assign a time-series of `variable_cost` using the [`set_variable_cost!`](@ref) function, which will automatically update this parameter
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `time_frame::Float64`: the saturation time_frame in minutes to provide reserve contribution, validation range: `(0, nothing)`
- `sustained_time::Float64`: (default: `3600.0`) the time in seconds that the reserve contribution must sustained at a specified level, validation range: `(0, nothing)`
- `max_participation_factor::Float64`: (default: `1.0`) the maximum portion [0, 1.0] of the reserve that can be contributed per device, validation range: `(0, 1)`
- `deployed_fraction::Float64`: (default: `0.0`) Fraction of service procurement that is assumed to be actually deployed. Most commonly, this is assumed to be either 0.0 or 1.0, validation range: `(0, 1)`
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct ReserveDemandCurve{T <: ReserveDirection} <: Reserve{T}
    "Create this object with `variable` = `nothing`, then add assign a time-series of `variable_cost` using the [`set_variable_cost!`](@ref) function, which will automatically update this parameter"
    variable::Union{Nothing, TimeSeriesKey}
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "the saturation time_frame in minutes to provide reserve contribution"
    time_frame::Float64
    "the time in seconds that the reserve contribution must sustained at a specified level"
    sustained_time::Float64
    "the maximum portion [0, 1.0] of the reserve that can be contributed per device"
    max_participation_factor::Float64
    "Fraction of service procurement that is assumed to be actually deployed. Most commonly, this is assumed to be either 0.0 or 1.0"
    deployed_fraction::Float64
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function ReserveDemandCurve{T}(variable, name, available, time_frame, sustained_time=3600.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), ) where T <: ReserveDirection
    ReserveDemandCurve{T}(variable, name, available, time_frame, sustained_time, max_participation_factor, deployed_fraction, ext, InfrastructureSystemsInternal(), )
end

function ReserveDemandCurve{T}(; variable, name, available, time_frame, sustained_time=3600.0, max_participation_factor=1.0, deployed_fraction=0.0, ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), ) where T <: ReserveDirection
    ReserveDemandCurve{T}(variable, name, available, time_frame, sustained_time, max_participation_factor, deployed_fraction, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function ReserveDemandCurve{T}(::Nothing) where T <: ReserveDirection
    ReserveDemandCurve{T}(;
        variable=nothing,
        name="init",
        available=false,
        time_frame=0.0,
        sustained_time=0.0,
        max_participation_factor=1.0,
        deployed_fraction=0.0,
        ext=Dict{String, Any}(),
    )
end

"""Get [`ReserveDemandCurve`](@ref) `variable`."""
get_variable(value::ReserveDemandCurve) = value.variable
"""Get [`ReserveDemandCurve`](@ref) `name`."""
get_name(value::ReserveDemandCurve) = value.name
"""Get [`ReserveDemandCurve`](@ref) `available`."""
get_available(value::ReserveDemandCurve) = value.available
"""Get [`ReserveDemandCurve`](@ref) `time_frame`."""
get_time_frame(value::ReserveDemandCurve) = value.time_frame
"""Get [`ReserveDemandCurve`](@ref) `sustained_time`."""
get_sustained_time(value::ReserveDemandCurve) = value.sustained_time
"""Get [`ReserveDemandCurve`](@ref) `max_participation_factor`."""
get_max_participation_factor(value::ReserveDemandCurve) = value.max_participation_factor
"""Get [`ReserveDemandCurve`](@ref) `deployed_fraction`."""
get_deployed_fraction(value::ReserveDemandCurve) = value.deployed_fraction
"""Get [`ReserveDemandCurve`](@ref) `ext`."""
get_ext(value::ReserveDemandCurve) = value.ext
"""Get [`ReserveDemandCurve`](@ref) `internal`."""
get_internal(value::ReserveDemandCurve) = value.internal

"""Set [`ReserveDemandCurve`](@ref) `variable`."""
set_variable!(value::ReserveDemandCurve, val) = value.variable = val
"""Set [`ReserveDemandCurve`](@ref) `available`."""
set_available!(value::ReserveDemandCurve, val) = value.available = val
"""Set [`ReserveDemandCurve`](@ref) `time_frame`."""
set_time_frame!(value::ReserveDemandCurve, val) = value.time_frame = val
"""Set [`ReserveDemandCurve`](@ref) `sustained_time`."""
set_sustained_time!(value::ReserveDemandCurve, val) = value.sustained_time = val
"""Set [`ReserveDemandCurve`](@ref) `max_participation_factor`."""
set_max_participation_factor!(value::ReserveDemandCurve, val) = value.max_participation_factor = val
"""Set [`ReserveDemandCurve`](@ref) `deployed_fraction`."""
set_deployed_fraction!(value::ReserveDemandCurve, val) = value.deployed_fraction = val
"""Set [`ReserveDemandCurve`](@ref) `ext`."""
set_ext!(value::ReserveDemandCurve, val) = value.ext = val
