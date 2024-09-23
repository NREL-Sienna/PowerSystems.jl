"""
$(TYPEDEF)
$(TYPEDFIELDS)

    ThermalGenerationCost(variable, fixed, start_up, shut_down)
    ThermalGenerationCost(; variable, fixed, start_up, shut_down)

An operational cost for thermal generators which includes fixed cost, variable cost, shut-down
cost, and  multiple options for start up costs.
"""
@kwdef mutable struct ThermalGenerationCost <: OperationalCost
    "Variable production cost. Can take a [`CostCurve`](@ref) or [`FuelCurve`](@ref)"
    variable::ProductionVariableCostCurve
    "Fixed cost of keeping the unit online. For some cost represenations this field can be
    duplicative"
    fixed::Float64
    "Start-up cost can take linear or multi-stage cost"
    start_up::Union{StartUpStages, Float64}
    "Cost to turn the unit off"
    shut_down::Float64
end

ThermalGenerationCost(variable, fixed, start_up::Integer, shut_down) =
    ThermalGenerationCost(variable, fixed, convert(Float64, start_up), shut_down)

# Constructor for demo purposes; non-functional.
function ThermalGenerationCost(::Nothing)
    ThermalGenerationCost(;
        variable = zero(CostCurve),
        fixed = 0.0,
        start_up = 0.0,
        shut_down = 0.0,
    )
end

"""Get [`ThermalGenerationCost`](@ref) `variable`."""
get_variable(value::ThermalGenerationCost) = value.variable
"""Get [`ThermalGenerationCost`](@ref) `fixed`."""
get_fixed(value::ThermalGenerationCost) = value.fixed
"""Get [`ThermalGenerationCost`](@ref) `start_up`."""
get_start_up(value::ThermalGenerationCost) = value.start_up
"""Get [`ThermalGenerationCost`](@ref) `shut_down`."""
get_shut_down(value::ThermalGenerationCost) = value.shut_down

"""Set [`ThermalGenerationCost`](@ref) `variable`."""
set_variable!(value::ThermalGenerationCost, val) = value.variable = val
"""Set [`ThermalGenerationCost`](@ref) `fixed`."""
set_fixed!(value::ThermalGenerationCost, val) = value.fixed = val
"""Set [`ThermalGenerationCost`](@ref) `start_up`."""
set_start_up!(value::ThermalGenerationCost, val) = value.start_up = val
"""Set [`ThermalGenerationCost`](@ref) `shut_down`."""
set_shut_down!(value::ThermalGenerationCost, val) = value.shut_down = val
