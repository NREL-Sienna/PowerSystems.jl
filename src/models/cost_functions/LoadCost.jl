"""
    @kwdef mutable struct LoadCost <: OperationalCost
        "variable cost"
        variable::CostCurve
        "fixed cost"
        fixed::Float64
    end


Data structure for the operational cost of loads (e.g., InterruptiblePowerLoad), including
fixed and variable cost components.

# Arguments
- `variable::CostCurve`: Variable cost.
- `fixed::Union{Nothing, Float64}`: Fixed cost of keeping the unit online. For some cost
  represenations this field can be duplicative.
"""
@kwdef mutable struct LoadCost <: OperationalCost
    "variable cost"
    variable::CostCurve
    "fixed cost"
    fixed::Float64
end

# Constructor for demo purposes; non-functional.
LoadCost(::Nothing) = LoadCost(zero(CostCurve), 0.0)

"""Get [`ThermalGenerationCost`](@ref) `variable`."""
get_variable(value::LoadCost) = value.variable
"""Get [`ThermalGenerationCost`](@ref) `fixed`."""
get_fixed(value::LoadCost) = value.fixed
"""Get [`ThermalGenerationCost`](@ref) `start_up`."""

"""Set [`ThermalGenerationCost`](@ref) `variable`."""
set_variable!(value::LoadCost, val) = value.variable = val
"""Set [`ThermalGenerationCost`](@ref) `fixed`."""
set_fixed!(value::LoadCost, val) = value.fixed = val
"""Set [`ThermalGenerationCost`](@ref) `start_up`."""
