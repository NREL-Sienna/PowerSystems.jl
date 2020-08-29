#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct VariableReserveNonSpinning <: ReserveNonSpinning
        name::String
        available::Bool
        time_frame::Float64
        requirement::Float64
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        operation_cost::Union{Nothing, TwoPartCost}
        internal::InfrastructureSystemsInternal
    end

Data Structure for the procurement products for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `time_frame::Float64`: the relative saturation time_frame, validation range: `(0, nothing)`, action if invalid: `error`
- `requirement::Float64`: the required quantity of the product should be scaled by a Forecast
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `operation_cost::Union{Nothing, TwoPartCost}`: Cost for providing reserves  [`TwoPartCost`](@ref)
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct VariableReserveNonSpinning <: ReserveNonSpinning
    name::String
    available::Bool
    "the relative saturation time_frame"
    time_frame::Float64
    "the required quantity of the product should be scaled by a Forecast"
    requirement::Float64
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "Cost for providing reserves  [`TwoPartCost`](@ref)"
    operation_cost::Union{Nothing, TwoPartCost}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function VariableReserveNonSpinning(name, available, time_frame, requirement, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), operation_cost=nothing, )
    VariableReserveNonSpinning(name, available, time_frame, requirement, ext, forecasts, operation_cost, InfrastructureSystemsInternal(), )
end

function VariableReserveNonSpinning(; name, available, time_frame, requirement, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), operation_cost=nothing, )
    VariableReserveNonSpinning(name, available, time_frame, requirement, ext, forecasts, operation_cost, )
end

# Constructor for demo purposes; non-functional.
function VariableReserveNonSpinning(::Nothing)
    VariableReserveNonSpinning(;
        name="init",
        available=false,
        time_frame=0.0,
        requirement=0.0,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
        operation_cost=TwoPartCost(nothing),
    )
end


InfrastructureSystems.get_name(value::VariableReserveNonSpinning) = value.name
"""Get [`VariableReserveNonSpinning`](@ref) `available`."""
get_available(value::VariableReserveNonSpinning) = value.available
"""Get [`VariableReserveNonSpinning`](@ref) `time_frame`."""
get_time_frame(value::VariableReserveNonSpinning) = value.time_frame
"""Get [`VariableReserveNonSpinning`](@ref) `requirement`."""
get_requirement(value::VariableReserveNonSpinning) = value.requirement
"""Get [`VariableReserveNonSpinning`](@ref) `ext`."""
get_ext(value::VariableReserveNonSpinning) = value.ext

InfrastructureSystems.get_forecasts(value::VariableReserveNonSpinning) = value.forecasts
"""Get [`VariableReserveNonSpinning`](@ref) `operation_cost`."""
get_operation_cost(value::VariableReserveNonSpinning) = value.operation_cost
"""Get [`VariableReserveNonSpinning`](@ref) `internal`."""
get_internal(value::VariableReserveNonSpinning) = value.internal


InfrastructureSystems.set_name!(value::VariableReserveNonSpinning, val) = value.name = val
"""Set [`VariableReserveNonSpinning`](@ref) `available`."""
set_available!(value::VariableReserveNonSpinning, val) = value.available = val
"""Set [`VariableReserveNonSpinning`](@ref) `time_frame`."""
set_time_frame!(value::VariableReserveNonSpinning, val) = value.time_frame = val
"""Set [`VariableReserveNonSpinning`](@ref) `requirement`."""
set_requirement!(value::VariableReserveNonSpinning, val) = value.requirement = val
"""Set [`VariableReserveNonSpinning`](@ref) `ext`."""
set_ext!(value::VariableReserveNonSpinning, val) = value.ext = val

InfrastructureSystems.set_forecasts!(value::VariableReserveNonSpinning, val) = value.forecasts = val
"""Set [`VariableReserveNonSpinning`](@ref) `operation_cost`."""
set_operation_cost!(value::VariableReserveNonSpinning, val) = value.operation_cost = val
"""Set [`VariableReserveNonSpinning`](@ref) `internal`."""
set_internal!(value::VariableReserveNonSpinning, val) = value.internal = val
