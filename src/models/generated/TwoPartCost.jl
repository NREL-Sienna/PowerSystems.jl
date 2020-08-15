#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TwoPartCost <: OperationalCost
        variable::VariableCost
        fixed::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure Operational Cost Data in two parts: fixed and variable cost.

# Arguments
- `variable::VariableCost`: variable cost
- `fixed::Float64`: fixed cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct TwoPartCost <: OperationalCost
    "variable cost"
    variable::VariableCost
    "fixed cost"
    fixed::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function TwoPartCost(variable, fixed, forecasts=InfrastructureSystems.Forecasts(), )
    TwoPartCost(variable, fixed, forecasts, InfrastructureSystemsInternal(), )
end

function TwoPartCost(; variable, fixed, forecasts=InfrastructureSystems.Forecasts(), )
    TwoPartCost(variable, fixed, forecasts, )
end

# Constructor for demo purposes; non-functional.
function TwoPartCost(::Nothing)
    TwoPartCost(;
        variable=VariableCost((0.0, 0.0)),
        fixed=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get [`TwoPartCost`](@ref) `variable`."""
get_variable(value::TwoPartCost) = value.variable
"""Get [`TwoPartCost`](@ref) `fixed`."""
get_fixed(value::TwoPartCost) = value.fixed

InfrastructureSystems.get_forecasts(value::TwoPartCost) = value.forecasts
"""Get [`TwoPartCost`](@ref) `internal`."""
get_internal(value::TwoPartCost) = value.internal

"""Set [`TwoPartCost`](@ref) `variable`."""
set_variable!(value::TwoPartCost, val) = value.variable = val
"""Set [`TwoPartCost`](@ref) `fixed`."""
set_fixed!(value::TwoPartCost, val) = value.fixed = val

InfrastructureSystems.set_forecasts!(value::TwoPartCost, val) = value.forecasts = val
"""Set [`TwoPartCost`](@ref) `internal`."""
set_internal!(value::TwoPartCost, val) = value.internal = val
