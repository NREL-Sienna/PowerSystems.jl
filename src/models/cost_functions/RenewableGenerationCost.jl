"""
$(TYPEDEF)
$(TYPEDFIELDS)

    RenewableGenerationCost(variable, curtailment_cost)
    RenewableGenerationCost(variable; curtailment_cost)
    RenewableGenerationCost(; variable, curtailment_cost)

An operational cost of renewable generators which includes the variable cost of energy
(like a [PPA](@ref P)) and the cost of curtailing power. For example, curtailment costs
can be used to represent the loss of tax incentives.

The `variable` cost is a required parameter, but `zero(CostCurve)` can be used to set it to 0.
"""
Base.@kwdef mutable struct RenewableGenerationCost <: OperationalCost
    "Variable cost represented as a [`CostCurve`](@ref)"
    variable::CostCurve
    "(default of 0) Cost of curtailing power represented as a [`CostCurve`](@ref)"
    curtailment_cost::CostCurve = zero(CostCurve)
end

RenewableGenerationCost(variable) = RenewableGenerationCost(; variable)

# Constructor for demo purposes; non-functional.
RenewableGenerationCost(::Nothing) = RenewableGenerationCost(zero(CostCurve))

"""Get [`RenewableGenerationCost`](@ref) `variable`."""
get_variable(value::RenewableGenerationCost) = value.variable
"""Get [`RenewableGenerationCost`](@ref) `curtailment_cost`."""
get_curtailment_cost(value::RenewableGenerationCost) = value.curtailment_cost

"""Set [`RenewableGenerationCost`](@ref) `variable`."""
set_variable!(value::RenewableGenerationCost, val) = value.variable = val
"""Set [`RenewableGenerationCost`](@ref) `curtailment_cost`."""
set_curtailment_cost!(value::RenewableGenerationCost, val) = value.curtailment_cost = val
