abstract type FuelCurve <: VariableProductionCost end

get_function_data(curve::FuelCurve) = curve.function_data
get_fixed_fuel_cost(curve::FuelCurve) = curve.fixed_fuel_cost
get_fuel_cost_time_series(curve::FuelCurve) = curve.fuel_cost_time_series

"""
Fuel consumption representation fuel input in Fuel/hr as a function of the power output.
This function indicates how much fuel rate is required to produce a power level. It can be used
for any generator like gas (MBTU/hr/MW), oil (Liters/hr/MW) or hydro (m^3/hr/MW).

# Arguments
- `function_data::FunctionData`: Functional representation of the input/output curve.
- `fixed_fuel_cost::Union{Nothing Float64}`: Fixed value for fuel cost for the total cost calculation.
- `fuel_cost_time_series::Union{Nothing, String}`: Fuel cost time series name for the total cost calculation.
"""
struct InputOutputFuelCurve <: FuelCurve
    function_data::FunctionData
    fixed_fuel_cost::Union{Nothing, Float64}
    fuel_cost_time_series::Union{Nothing, String}
end

"""
Fuel usage representation of the amount of input energy required to produce an electric energy amount (e.g., MWhr)
at a given generation level. Usually calculated by dividing absolute values of fuel input rate by absolute values of electric output power

# Arguments
- `function_data::FunctionData`: Functional representation of the average heat rate for the unit
- `fixed_fuel_cost::Union{Nothing Float64}`: Fixed value for fuel cost for the total cost calculation.
- `fuel_cost_time_series::Union{Nothing, String}`: Fuel cost time series name for the total cost calculation.
"""
struct AverageHeatRateCurve <: FuelCurve
    function_data::FunctionData
    fixed_fuel_cost::Union{Nothing, Float64}
    fuel_cost_time_series::Union{Nothing, String}
end

"""
First derivative of the Input/Output curve

# Arguments
- `function_data::FunctionData`: Functional representation of the heat rate.
- `no_load_heat::Float64`: The estimated amount of fuel needed to theoretically operate a unit at zero power. This is not the fuel required to operate at mininum stable levels.
- `fixed_fuel_cost::Union{Nothing Float64}`: Fixed value for fuel cost for the total cost calculation.
- `fuel_cost_time_series::Union{Nothing, String}`: Fuel cost time series name for the total cost calculation.
"""
struct IncrementalHeatRateCurve <: FuelCurve
    function_data::FunctionData
    no_load_heat::Float64
    fixed_fuel_cost::Union{Nothing, Float64}
    fuel_cost_time_series::Union{Nothing, String}
end

get_no_load_heat(curve::IncrementalHeatRateCurve) = curve.no_load_heat
