"""
    mutable struct RenewablePowerCost <: OperationalCost
        curtailment_cost::InputOutputCostCurve
        variable::ProductionVariableCost
    end

Data Structure for the Operational Cost of Renewable Power Plants which includes the
variable cost of energy (like a PPA) and the cost of curtailing power. For example,
curtailment Costs can be used to represent the loss of tax incentives.

# Arguments
- `variable::InputOutputCostCurve`: Production Variable Cost represented as input/output.
- `curtailment_cost::InputOutputCostCurve`: Input/output cost of curtailing power.
"""
mutable struct RenewablePowerCost <: OperationalCost
    "variable cost"
    variable::InputOutputCostCurve
    "curtailment cost"
    curtailment_cost::InputOutputCostCurve
end

RenewablePowerCost(variable) =
    RenewablePowerCost(variable, InputOutputCostCurve(LinearFunctionData(0.0)))

function RenewablePowerCost(; variable, curtailment_cost)
    println(variable)
    println(curtailment_cost)
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
