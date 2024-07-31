"""
$(TYPEDEF)
$(TYPEDFIELDS)

    LoadCost(variable, fixed)
    LoadCost(; variable, fixed)

An operational cost for controllable loads (e.g., InterruptiblePowerLoad), including
fixed and variable cost components.

The `variable` cost is a required parameter, but `zero(CostCurve)` can be used to set it to 0.
"""
Base.@kwdef mutable struct LoadCost <: OperationalCost
    "Variable cost represented as a [`CostCurve`](@ref)"
    variable::CostCurve
    "(default: 0) Fixed cost. For some cost represenations this field can be
    duplicative"
    fixed::Float64
end

# Constructor for demo purposes; non-functional.
LoadCost(::Nothing) = LoadCost(zero(CostCurve), 0.0)

"""Get [`LoadCost`](@ref) `variable`."""
get_variable(value::LoadCost) = value.variable
"""Get [`LoadCost`](@ref) `fixed`."""
get_fixed(value::LoadCost) = value.fixed

"""Set [`LoadCost`](@ref) `variable`."""
set_variable!(value::LoadCost, val) = value.variable = val
"""Set [`LoadCost`](@ref) `fixed`."""
set_fixed!(value::LoadCost, val) = value.fixed = val
