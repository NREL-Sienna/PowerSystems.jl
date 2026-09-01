"""
$(TYPEDEF)
$(TYPEDFIELDS)

    RenewableGenerationCost(variable_operation_cost, curtailment_cost, fixed)
    RenewableGenerationCost(; variable_operation_cost, curtailment_cost, fixed)

An operational cost of renewable generators which includes the variable cost of energy
(like a [PPA](@ref P)), the cost of curtailing power, and a fixed cost of keeping the unit online.
For example, curtailment costs can be used to represent the loss of tax incentives.

The `variable_operation_cost` cost is a required parameter, but `zero(CostCurve)` can be used
to set it to 0.
"""
@kwdef mutable struct RenewableGenerationCost <: OperationalCost
    "Variable cost represented as a [`CostCurve`](@ref)"
    variable_operation_cost::CostCurve
    "(default of 0) Cost of curtailing power represented as a [`CostCurve`](@ref)"
    curtailment_cost::CostCurve = zero(CostCurve)
    "Fixed cost of keeping the unit online. For some cost representations this field can be duplicative with respect to the data in the VOM field."
    fixed::Float64 = 0.0
end

RenewableGenerationCost(variable_operation_cost) =
    RenewableGenerationCost(; variable_operation_cost)

# Constructor for demo purposes; non-functional.
RenewableGenerationCost(::Nothing) = RenewableGenerationCost(zero(CostCurve))

"""Get [`RenewableGenerationCost`](@ref) `variable_operation_cost`."""
get_variable_operation_cost(value::RenewableGenerationCost) = value.variable_operation_cost
"""Get [`RenewableGenerationCost`](@ref) `curtailment_cost`."""
get_curtailment_cost(value::RenewableGenerationCost) = value.curtailment_cost
"""Get [`RenewableGenerationCost`](@ref) `fixed`."""
get_fixed(value::RenewableGenerationCost) = value.fixed

"""Set [`RenewableGenerationCost`](@ref) `variable_operation_cost`."""
set_variable_operation_cost!(value::RenewableGenerationCost, val) =
    value.variable_operation_cost = val
"""Set [`RenewableGenerationCost`](@ref) `curtailment_cost`."""
set_curtailment_cost!(value::RenewableGenerationCost, val) = value.curtailment_cost = val
"""Set [`RenewableGenerationCost`](@ref) `fixed`."""
set_fixed!(value::RenewableGenerationCost, val) = value.fixed = val
