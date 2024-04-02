abstract type ProductionVariableCost end

IS.serialize(val::ProductionVariableCost) = IS.serialize_struct(val)
IS.deserialize(T::Type{<:ProductionVariableCost}, val::Dict) = IS.deserialize_struct(T, val)

"Get the underlying `ValueCurve` representation of this `ProductionVariableCost`"
get_value_curve(cost::ProductionVariableCost) = cost.value_curve
"Get the `FunctionData` representation of this `ProductionVariableCost`'s `ValueCurve`"
get_function_data(cost::ProductionVariableCost) = get_function_data(get_value_curve(cost))
"Get the `initial_input` field of this `ProductionVariableCost`'s `ValueCurve` (not defined for input-output data)"
get_initial_input(cost::ProductionVariableCost) = get_initial_input(get_value_curve(cost))

"""
Direct representation of the variable operation cost of a power plant in currency. Composed
of a [`ValueCurve`][@ref] that may represent input-output, incremental, or average rate
data.
"""
@kwdef struct CostCurve{T <: ValueCurve} <: ProductionVariableCost
    "The underlying `ValueCurve` representation of this `ProductionVariableCost`"
    value_curve::T
end

Base.:(==)(a::CostCurve, b::CostCurve) =
    (get_value_curve(a) == get_value_curve(b))

"Get a `CostCurve` representing zero variable cost"
Base.zero(::Union{CostCurve, Type{CostCurve}}) = CostCurve(zero(ValueCurve))

"""
Representation of the variable operation cost of a power plant in terms of fuel (MBTU,
liters, m^3, etc.), coupled with a conversion factor between fuel and currency. Composed of
a [`ValueCurve`][@ref] that may represent input-output, incremental, or average rate data.
"""
@kwdef struct FuelCurve{T <: ValueCurve} <: ProductionVariableCost
    "The underlying `ValueCurve` representation of this `ProductionVariableCost`"
    value_curve::T
    "Either a fixed value for fuel cost or the name of a fuel cost time series name"
    fuel_cost::Union{Float64, String}
end

FuelCurve(value_curve::ValueCurve, fuel_cost::Int) =
    FuelCurve(value_curve, Float64(fuel_cost))

Base.:(==)(a::FuelCurve, b::FuelCurve) =
    (get_value_curve(a) == get_value_curve(b)) &&
    (get_fuel_cost(a) == get_fuel_cost(b))

"Get a `FuelCurve` representing zero fuel usage and zero fuel cost"
Base.zero(::Union{FuelCurve, Type{FuelCurve}}) = FuelCurve(zero(ValueCurve), 0.0)

"Get the fuel cost or the name of the fuel cost time series"
get_fuel_cost(cost::FuelCurve) = cost.fuel_cost
