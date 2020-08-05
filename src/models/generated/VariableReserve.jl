#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct VariableReserve{T <: ReserveDirection} <: Reserve{T}
        name::String
        available::Bool
        time_frame::Float64
        requirement::Float64
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for the procurement products for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the relative saturation time_frame, validation range: (0, nothing), action if invalid: error
- `requirement::Float64`: the required quantity of the product should be scaled by a Forecast
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct VariableReserve{T <: ReserveDirection} <: Reserve{T}
    name::String
    available::Bool
    "the relative saturation time_frame"
    time_frame::Float64
    "the required quantity of the product should be scaled by a Forecast"
    requirement::Float64
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function VariableReserve{T}(name, available, time_frame, requirement, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), ) where T <: ReserveDirection
    VariableReserve{T}(name, available, time_frame, requirement, ext, forecasts, InfrastructureSystemsInternal(), )
end

function VariableReserve{T}(; name, available, time_frame, requirement, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), ) where T <: ReserveDirection
    VariableReserve{T}(name, available, time_frame, requirement, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function VariableReserve{T}(::Nothing) where T <: ReserveDirection
    VariableReserve{T}(;
        name="init",
        available=false,
        time_frame=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::VariableReserve) = value.name
"""Get VariableReserve available."""
get_available(value::VariableReserve) = value.available
"""Get VariableReserve time_frame."""
get_time_frame(value::VariableReserve) = value.time_frame
"""Get VariableReserve requirement."""
get_requirement(value::VariableReserve) = value.requirement
"""Get VariableReserve ext."""
get_ext(value::VariableReserve) = value.ext

InfrastructureSystems.get_forecasts(value::VariableReserve) = value.forecasts
"""Get VariableReserve internal."""
get_internal(value::VariableReserve) = value.internal


InfrastructureSystems.set_name!(value::VariableReserve, val) = value.name = val
"""Set VariableReserve available."""
set_available!(value::VariableReserve, val) = value.available = val
"""Set VariableReserve time_frame."""
set_time_frame!(value::VariableReserve, val) = value.time_frame = val
"""Set VariableReserve requirement."""
set_requirement!(value::VariableReserve, val) = value.requirement = val
"""Set VariableReserve ext."""
set_ext!(value::VariableReserve, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::VariableReserve, val) = value.forecasts = val
"""Set VariableReserve internal."""
set_internal!(value::VariableReserve, val) = value.internal = val
