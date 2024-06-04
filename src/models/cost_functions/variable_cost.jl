abstract type ProductionVariableCostCurve{T <: ValueCurve} end

IS.serialize(val::ProductionVariableCostCurve) = IS.serialize_struct(val)
IS.deserialize(T::Type{<:ProductionVariableCostCurve}, val::Dict) = IS.deserialize_struct(T, val)

"Get the underlying `ValueCurve` representation of this `ProductionVariableCostCurve`"
get_value_curve(cost::ProductionVariableCostCurve) = cost.value_curve
"Get the variable operation and maintenance cost in \$/(power_units h)"
get_vom_cost(cost::ProductionVariableCostCurve) = cost.vom_cost
"Get the units for the x-axis of the curve"
get_power_units(cost::ProductionVariableCostCurve) = cost.power_units
"Get the `FunctionData` representation of this `ProductionVariableCostCurve`'s `ValueCurve`"
get_function_data(cost::ProductionVariableCostCurve) = get_function_data(get_value_curve(cost))
"Get the `initial_input` field of this `ProductionVariableCostCurve`'s `ValueCurve` (not defined for input-output data)"
get_initial_input(cost::ProductionVariableCostCurve) = get_initial_input(get_value_curve(cost))
"Calculate the convexity of the underlying data"
is_convex(cost::ProductionVariableCostCurve) = is_convex(get_value_curve(cost))

Base.:(==)(a::T, b::T) where {T <: ProductionVariableCostCurve} =
    IS.double_equals_from_fields(a, b)

Base.isequal(a::T, b::T) where {T <: ProductionVariableCostCurve} = IS.isequal_from_fields(a, b)

Base.hash(a::ProductionVariableCostCurve) = IS.hash_from_fields(a)

"""
Direct representation of the variable operation cost of a power plant in currency. Composed
of a [`ValueCurve`][@ref] that may represent input-output, incremental, or average rate
data. The default units for the x-axis are megawatts and can be specified with
`power_units`.
"""
@kwdef struct CostCurve{T <: ValueCurve} <: ProductionVariableCostCurve{T}
    "The underlying `ValueCurve` representation of this `ProductionVariableCostCurve`"
    value_curve::T
    "The units for the x-axis of the curve; defaults to natural units (megawatts)"
    power_units::UnitSystem = UnitSystem.NATURAL_UNITS
    "Additional proportional Variable Operation and Maintenance Cost in \$/(power_unit h)"
    vom_cost::Float64 = 0.0
end

CostCurve(value_curve) = CostCurve(; value_curve)
CostCurve(value_curve, vom_cost::Float64) =
    CostCurve(; value_curve, vom_cost = vom_cost)
CostCurve(value_curve, power_units::UnitSystem) =
    CostCurve(; value_curve, power_units = power_units)

Base.:(==)(a::CostCurve, b::CostCurve) =
    (get_value_curve(a) == get_value_curve(b)) &&
    (get_power_units(a) == get_power_units(b)) &&
    (get_vom_cost(a) == get_vom_cost(b))

"Get a `CostCurve` representing zero variable cost"
Base.zero(::Union{CostCurve, Type{CostCurve}}) = CostCurve(zero(ValueCurve))

"""
Representation of the variable operation cost of a power plant in terms of fuel (MBTU,
liters, m^3, etc.), coupled with a conversion factor between fuel and currency. Composed of
a [`ValueCurve`][@ref] that may represent input-output, incremental, or average rate data.
The default units for the x-axis are megawatts and can be specified with `power_units`.
"""
@kwdef struct FuelCurve{T <: ValueCurve} <: ProductionVariableCostCurve{T}
    "The underlying `ValueCurve` representation of this `ProductionVariableCostCurve`"
    value_curve::T
    "The units for the x-axis of the curve; defaults to natural units (megawatts)"
    power_units::UnitSystem = UnitSystem.NATURAL_UNITS
    "Either a fixed value for fuel cost or the key to a fuel cost time series"
    fuel_cost::Union{Float64, TimeSeriesKey}
    "Additional proportional Variable Operation and Maintenance Cost in \$/(power_unit h)"
    vom_cost::Float64 = 0.0
end

FuelCurve(
    value_curve::ValueCurve,
    power_units::UnitSystem,
    fuel_cost::Real,
    vom_cost::Float64,
) =
    FuelCurve(value_curve, power_units, Float64(fuel_cost), vom_cost)

FuelCurve(value_curve, fuel_cost) = FuelCurve(; value_curve, fuel_cost)
FuelCurve(value_curve, fuel_cost::Union{Float64, TimeSeriesKey}, vom_cost::Float64) =
    FuelCurve(; value_curve, fuel_cost, vom_cost = vom_cost)
FuelCurve(value_curve, power_units::UnitSystem, fuel_cost::Union{Float64, TimeSeriesKey}) =
    FuelCurve(; value_curve, power_units = power_units, fuel_cost = fuel_cost)

Base.:(==)(a::FuelCurve, b::FuelCurve) =
    (get_value_curve(a) == get_value_curve(b)) &&
    (get_power_units(a) == get_power_units(b)) &&
    (get_fuel_cost(a) == get_fuel_cost(b)) &&
    (get_vom_cost(a) == get_vom_cost(b))

"Get a `FuelCurve` representing zero fuel usage and zero fuel cost"
Base.zero(::Union{FuelCurve, Type{FuelCurve}}) = FuelCurve(zero(ValueCurve), 0.0)

"Get the fuel cost or the name of the fuel cost time series"
get_fuel_cost(cost::FuelCurve) = cost.fuel_cost
