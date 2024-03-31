"""
    mutable struct RenewableGenerationCost <: OperationalCost
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
mutable struct RenewableGenerationCost <: OperationalCost
    "variable cost"
    variable::CostCurve
    "curtailment cost"
    curtailment_cost::CostCurve
end

function RenewableGenerationCost(
    variable;
    curtailment_cost = zero(CostCurve),
)
    RenewableGenerationCost(variable, curtailment_cost)
end

# Constructor for demo purposes; non-functional.
function RenewableGenerationCost(::Nothing)
    RenewableGenerationCost(;
        variable = zero(CostCurve),
    )
end

"""Get [`RenewableGenerationCost`](@ref) `variable`."""
get_variable(value::RenewableGenerationCost) = value.variable

"""Set [`RenewableGenerationCost`](@ref) `variable`."""
set_variable!(value::RenewableGenerationCost, val) = value.variable = val
