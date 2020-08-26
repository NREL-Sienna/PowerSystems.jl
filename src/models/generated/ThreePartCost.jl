#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct ThreePartCost <: OperationalCost
        variable::VariableCost
        fixed::Float64
        start_up::Float64
        shut_down::Float64
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure Operational Cost Data in Three parts fixed, variable cost and start - stop costs.

# Arguments
- `variable::VariableCost`: variable cost
- `fixed::Float64`: fixed cost
- `start_up::Float64`: startup cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `shut_down::Float64`: shutdown cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct ThreePartCost <: OperationalCost
    "variable cost"
    variable::VariableCost
    "fixed cost"
    fixed::Float64
    "startup cost"
    start_up::Float64
    "shutdown cost"
    shut_down::Float64
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function ThreePartCost(variable, fixed, start_up, shut_down, forecasts=InfrastructureSystems.Forecasts(), )
    ThreePartCost(variable, fixed, start_up, shut_down, forecasts, InfrastructureSystemsInternal(), )
end

function ThreePartCost(; variable, fixed, start_up, shut_down, forecasts=InfrastructureSystems.Forecasts(), )
    ThreePartCost(variable, fixed, start_up, shut_down, forecasts, )
end

# Constructor for demo purposes; non-functional.
function ThreePartCost(::Nothing)
    ThreePartCost(;
        variable=VariableCost((0.0, 0.0)),
        fixed=0.0,
        start_up=0.0,
        shut_down=0.0,
        forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get [`ThreePartCost`](@ref) `variable`."""
get_variable(value::ThreePartCost) = value.variable
"""Get [`ThreePartCost`](@ref) `fixed`."""
get_fixed(value::ThreePartCost) = value.fixed
"""Get [`ThreePartCost`](@ref) `start_up`."""
get_start_up(value::ThreePartCost) = value.start_up
"""Get [`ThreePartCost`](@ref) `shut_down`."""
get_shut_down(value::ThreePartCost) = value.shut_down

InfrastructureSystems.get_forecasts(value::ThreePartCost) = value.forecasts
"""Get [`ThreePartCost`](@ref) `internal`."""
get_internal(value::ThreePartCost) = value.internal

"""Set [`ThreePartCost`](@ref) `variable`."""
set_variable!(value::ThreePartCost, val) = value.variable = val
"""Set [`ThreePartCost`](@ref) `fixed`."""
set_fixed!(value::ThreePartCost, val) = value.fixed = val
"""Set [`ThreePartCost`](@ref) `start_up`."""
set_start_up!(value::ThreePartCost, val) = value.start_up = val
"""Set [`ThreePartCost`](@ref) `shut_down`."""
set_shut_down!(value::ThreePartCost, val) = value.shut_down = val

InfrastructureSystems.set_forecasts!(value::ThreePartCost, val) = value.forecasts = val
"""Set [`ThreePartCost`](@ref) `internal`."""
set_internal!(value::ThreePartCost, val) = value.internal = val
