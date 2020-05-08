#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct VariableReserve{T <: ReserveDirection} <: Reserve{T}
        name::String
        available::Bool
        timeframe::Float64
        requirement::Float64
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure for the procurement products for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `timeframe::Float64`: the relative saturation timeframe, validation range: (0, nothing), action if invalid: error
- `requirement::Float64`: the required quantity of the product should be scaled by a Forecast
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct VariableReserve{T <: ReserveDirection} <: Reserve{T}
    name::String
    available::Bool
    "the relative saturation timeframe"
    timeframe::Float64
    "the required quantity of the product should be scaled by a Forecast"
    requirement::Float64
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function VariableReserve{T}(name, available, timeframe, requirement, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), ) where T <: ReserveDirection
    VariableReserve{T}(name, available, timeframe, requirement, ext, forecasts, InfrastructureSystemsInternal(), )
end

function VariableReserve{T}(; name, available, timeframe, requirement, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), ) where T <: ReserveDirection
    VariableReserve{T}(name, available, timeframe, requirement, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function VariableReserve{T}(::Nothing) where T <: ReserveDirection
    VariableReserve{T}(;
        name="init",
        available=false,
        timeframe=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::VariableReserve) = value.name
"""Get VariableReserve available."""
get_available(value::VariableReserve) = value.available
"""Get VariableReserve timeframe."""
get_timeframe(value::VariableReserve) = value.timeframe
"""Get VariableReserve requirement."""
get_requirement(value::VariableReserve) = value.requirement
"""Get VariableReserve ext."""
get_ext(value::VariableReserve) = value.ext

InfrastructureSystems.get_forecasts(value::VariableReserve) = value.forecasts
"""Get VariableReserve internal."""
get_internal(value::VariableReserve) = value.internal


InfrastructureSystems.set_name!(value::VariableReserve, val::String) = value.name = val
"""Set VariableReserve available."""
set_available!(value::VariableReserve, val::Bool) = value.available = val
"""Set VariableReserve timeframe."""
set_timeframe!(value::VariableReserve, val::Float64) = value.timeframe = val
"""Set VariableReserve requirement."""
set_requirement!(value::VariableReserve, val::Float64) = value.requirement = val
"""Set VariableReserve ext."""
set_ext!(value::VariableReserve, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::VariableReserve, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set VariableReserve internal."""
set_internal!(value::VariableReserve, val::InfrastructureSystemsInternal) = value.internal = val
