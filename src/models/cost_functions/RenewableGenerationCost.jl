"""
$(TYPEDEF)
$(TYPEDFIELDS)

    RenewableGenerationCost(variable, curtailment_cost, fixed)
    RenewableGenerationCost(; variable, curtailment_cost, fixed)

An operational cost of renewable generators which includes the variable cost of energy
(like a [PPA](@ref P)), the cost of curtailing power, and a fixed cost of keeping the unit online.
For example, curtailment costs can be used to represent the loss of tax incentives.

The `variable` cost is a required parameter, but `zero(CostCurve)` can be used to set it to 0.
"""
@kwdef mutable struct RenewableGenerationCost <: OperationalCost
    "Variable cost represented as a [`CostCurve`](@ref)"
    variable::CostCurve
    "(default of 0) Cost of curtailing power represented as a [`CostCurve`](@ref)"
    curtailment_cost::CostCurve = zero(CostCurve)
    "Fixed cost of keeping the unit online. For some cost representations this field can be duplicative with respect to the data in the VOM field."
    fixed::Float64 = 0.0
end

RenewableGenerationCost(variable) = RenewableGenerationCost(; variable)

# Constructor for demo purposes; non-functional.
RenewableGenerationCost(::Nothing) = RenewableGenerationCost(zero(CostCurve))

"""Get [`RenewableGenerationCost`](@ref) `variable`."""
get_variable(value::RenewableGenerationCost) = value.variable
"""Get [`RenewableGenerationCost`](@ref) `curtailment_cost`."""
get_curtailment_cost(value::RenewableGenerationCost) = value.curtailment_cost
"""Get [`RenewableGenerationCost`](@ref) `fixed`."""
get_fixed(value::RenewableGenerationCost) = value.fixed

"""Set [`RenewableGenerationCost`](@ref) `variable`."""
set_variable!(value::RenewableGenerationCost, val) = value.variable = val
"""Set [`RenewableGenerationCost`](@ref) `curtailment_cost`."""
set_curtailment_cost!(value::RenewableGenerationCost, val) = value.curtailment_cost = val
"""Set [`RenewableGenerationCost`](@ref) `fixed`."""
set_fixed!(value::RenewableGenerationCost, val) = value.fixed = val
