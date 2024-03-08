"""
    mutable struct RenewablePowerCost <: OperationalCost
        variable::ProductionVariableCost
    end

Data Structure for the Operational Cost of Renewable Power Plants which variable cost of curtailing power.
Variable Costs can be used to represent the cost of curtailment if negative values are used for instance the loss of tax incentives.

# Arguments
- `variable::InputOutputCostCurve`: Production Variable Cost represented as input/output.
"""
mutable struct RenewablePowerCost <: OperationalCost
    "variable cost"
    curtailment_cost::InputOutputCostCurve
end

function RenewablePowerCost(; variable)
    RenewablePowerCost(variable)
end

# Constructor for demo purposes; non-functional.
function RenewablePowerCost(::Nothing)
    RenewablePowerCost(;
        variable = InputOutputCostCurve(LinearProductionVariableCost(0.0)),
    )
end

"""Get [`RenewablePowerCost`](@ref) `variable`."""
get_variable(value::RenewablePowerCost) = value.variable

"""Set [`RenewablePowerCost`](@ref) `variable`."""
set_variable!(value::RenewablePowerCost, val) = value.variable = val
