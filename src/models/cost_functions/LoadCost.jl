"""
$(TYPEDEF)
$(TYPEDFIELDS)

    LoadCost(variable_operation_cost, fixed)
    LoadCost(; variable_operation_cost, fixed)

An operational cost for controllable loads (e.g., InterruptiblePowerLoad), including
fixed and variable cost components.

The `variable_operation_cost` cost is a required parameter, but `zero(CostCurve)` can be used
to set it to 0.
"""
@kwdef mutable struct LoadCost <: OperationalCost
    "Variable cost represented as a [`CostCurve`](@ref)"
    variable_operation_cost::CostCurve
    "(default: 0) Fixed cost. For some cost represenations this field can be
    duplicative"
    fixed::Float64
end

# Constructor for demo purposes; non-functional.
LoadCost(::Nothing) = LoadCost(zero(CostCurve), 0.0)

"""Get [`LoadCost`](@ref) `variable_operation_cost`."""
get_variable_operation_cost(value::LoadCost) = value.variable_operation_cost
"""Get [`LoadCost`](@ref) `fixed`."""
get_fixed(value::LoadCost) = value.fixed

"""Set [`LoadCost`](@ref) `variable_operation_cost`."""
set_variable_operation_cost!(value::LoadCost, val) = value.variable_operation_cost = val
"""Set [`LoadCost`](@ref) `fixed`."""
set_fixed!(value::LoadCost, val) = value.fixed = val
