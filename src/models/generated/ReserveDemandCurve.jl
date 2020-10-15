#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ReserveDemandCurve{T <: ReserveDirection} <: Reserve{T}
        variable::Union{Nothing, IS.TimeSeriesKey}
        name::String
        available::Bool
        time_frame::Float64
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end

Data Structure for a operating reserve with demand curve product for system simulations.

# Arguments
- `variable::Union{Nothing, IS.TimeSeriesKey}`: no load cost
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the relative saturation time_frame, validation range: `(0, nothing)`, action if invalid: `error`
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ReserveDemandCurve{T <: ReserveDirection} <: Reserve{T}
    "no load cost"
    variable::Union{Nothing, IS.TimeSeriesKey}
    name::String
    available::Bool
    "the relative saturation time_frame"
    time_frame::Float64
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ReserveDemandCurve{T}(variable, name, available, time_frame, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), ) where T <: ReserveDirection
    ReserveDemandCurve{T}(variable, name, available, time_frame, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function ReserveDemandCurve{T}(; variable, name, available, time_frame, ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), ) where T <: ReserveDirection
    ReserveDemandCurve{T}(variable, name, available, time_frame, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function ReserveDemandCurve{T}(::Nothing) where T <: ReserveDirection
    ReserveDemandCurve{T}(;
        variable=0.0,
        name="init",
        available=false,
        time_frame=0.0,
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`ReserveDemandCurve`](@ref) `variable`."""
get_variable(value::ReserveDemandCurve) = value.variable

InfrastructureSystems.get_name(value::ReserveDemandCurve) = value.name
"""Get [`ReserveDemandCurve`](@ref) `available`."""
get_available(value::ReserveDemandCurve) = value.available
"""Get [`ReserveDemandCurve`](@ref) `time_frame`."""
get_time_frame(value::ReserveDemandCurve) = value.time_frame
"""Get [`ReserveDemandCurve`](@ref) `ext`."""
get_ext(value::ReserveDemandCurve) = value.ext

InfrastructureSystems.get_time_series_container(value::ReserveDemandCurve) = value.time_series_container
"""Get [`ReserveDemandCurve`](@ref) `internal`."""
get_internal(value::ReserveDemandCurve) = value.internal

"""Set [`ReserveDemandCurve`](@ref) `variable`."""
set_variable!(value::ReserveDemandCurve, val) = value.variable = val

InfrastructureSystems.set_name!(value::ReserveDemandCurve, val) = value.name = val
"""Set [`ReserveDemandCurve`](@ref) `available`."""
set_available!(value::ReserveDemandCurve, val) = value.available = val
"""Set [`ReserveDemandCurve`](@ref) `time_frame`."""
set_time_frame!(value::ReserveDemandCurve, val) = value.time_frame = val
"""Set [`ReserveDemandCurve`](@ref) `ext`."""
set_ext!(value::ReserveDemandCurve, val) = value.ext = val

InfrastructureSystems.set_time_series_container!(value::ReserveDemandCurve, val) = value.time_series_container = val

