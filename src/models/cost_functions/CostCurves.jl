abstract type CostCurve <: ProductionVariableCost end

get_function_data(curve::CostCurve) = curve.function_data

"""
Representation of the variable operation cost of a power plant in $/time at a particular power output level.

# Arguments
- `function_data::FunctionData`: Functional representation of the cost curve
"""
struct InputOutputCostCurve <: CostCurve
    function_data::FunctionData
end

"""
First derivative of the Input/Output cost curve.

# Arguments
- `function_data::FunctionData`: Functional representation of the incremental cost.
- `no_load_cost::Float64`: The estimated cost needed to theoretically operate a unit at zero power. This is not the cost of operating at mininum stable levels
"""
struct IncrementalCostCurve <: CostCurve
    function_data::FunctionData
    no_load_cost::Float64
end
