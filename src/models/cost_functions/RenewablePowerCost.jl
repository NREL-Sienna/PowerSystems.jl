"""
    mutable struct RenewablePowerCost <: OperationalCost
        variable::CostCurve
        curtailment_cost::CostCurve
    end

Data Structure for the Operational Cost of Renewable Power Plants which includes the
variable cost of energy (like a PPA) and the cost of curtailing power. For example,
curtailment Costs can be used to represent the loss of tax incentives.

# Arguments
- `variable::CostCurve`: Variable cost.
- `curtailment_cost::CostCurve`: Input/output cost of curtailing power.
"""
mutable struct RenewablePowerCost <: OperationalCost
    "variable cost"
    variable::CostCurve
    "curtailment cost"
    curtailment_cost::CostCurve
end

function RenewablePowerCost(;
    variable,
    curtailment_cost = InputOutputCostCurve(LinearFunctionData(0.0)),
)
    RenewablePowerCost(variable, curtailment_cost)
end

# Constructor for demo purposes; non-functional.
function RenewablePowerCost(::Nothing)
    RenewablePowerCost(;
        variable = InputOutputCostCurve(LinearFunctionData(0.0)),
    )
end

"""Get [`RenewablePowerCost`](@ref) `variable`."""
get_variable(value::RenewablePowerCost) = value.variable

"""Set [`RenewablePowerCost`](@ref) `variable`."""
set_variable!(value::RenewablePowerCost, val) = value.variable = val
