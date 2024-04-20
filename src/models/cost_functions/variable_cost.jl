abstract type ProductionVariableCost{T <: ValueCurve} end

IS.serialize(val::ProductionVariableCost) = IS.serialize_struct(val)
IS.deserialize(T::Type{<:ProductionVariableCost}, val::Dict) = IS.deserialize_struct(T, val)

"Get the underlying `ValueCurve` representation of this `ProductionVariableCost`"
get_value_curve(cost::ProductionVariableCost) = cost.value_curve
"Get the units for the x-axis of the curve"
get_power_units(cost::ProductionVariableCost) = cost.power_units
"Get the `FunctionData` representation of this `ProductionVariableCost`'s `ValueCurve`"
get_function_data(cost::ProductionVariableCost) = get_function_data(get_value_curve(cost))
"Get the `initial_input` field of this `ProductionVariableCost`'s `ValueCurve` (not defined for input-output data)"
get_initial_input(cost::ProductionVariableCost) = get_initial_input(get_value_curve(cost))
"Calculate the convexity of the underlying data"
is_convex(cost::ProductionVariableCost) = is_convex(get_value_curve(cost))

"""
Direct representation of the variable operation cost of a power plant in currency. Composed
of a [`ValueCurve`][@ref] that may represent input-output, incremental, or average rate
data. The default units for the x-axis are megawatts and can be specified with
`power_units`.
"""
@kwdef struct CostCurve{T <: ValueCurve} <: ProductionVariableCost{T}
    "The underlying `ValueCurve` representation of this `ProductionVariableCost`"
    value_curve::T
    "The units for the x-axis of the curve; defaults to natural units (megawatts)"
    power_units::UnitSystem = UnitSystem.NATURAL_UNITS
end

CostCurve(value_curve) = CostCurve(; value_curve)

Base.:(==)(a::CostCurve, b::CostCurve) =
    (get_value_curve(a) == get_value_curve(b)) &&
    (get_power_units(a) == get_power_units(b))

"Get a `CostCurve` representing zero variable cost"
Base.zero(::Union{CostCurve, Type{CostCurve}}) = CostCurve(zero(ValueCurve))

"""
Representation of the variable operation cost of a power plant in terms of fuel (MBTU,
liters, m^3, etc.), coupled with a conversion factor between fuel and currency. Composed of
a [`ValueCurve`][@ref] that may represent input-output, incremental, or average rate data.
The default units for the x-axis are megawatts and can be specified with `power_units`.
"""
@kwdef struct FuelCurve{T <: ValueCurve} <: ProductionVariableCost{T}
    "The underlying `ValueCurve` representation of this `ProductionVariableCost`"
    value_curve::T
    "The units for the x-axis of the curve; defaults to natural units (megawatts)"
    power_units::UnitSystem = UnitSystem.NATURAL_UNITS
    "Either a fixed value for fuel cost or the name of a fuel cost time series name"
    fuel_cost::Union{Float64, String}
end

FuelCurve(value_curve::ValueCurve, power_units::UnitSystem, fuel_cost::Int) =
    FuelCurve(value_curve, power_units, Float64(fuel_cost))

FuelCurve(value_curve, fuel_cost) = FuelCurve(; value_curve, fuel_cost)

Base.:(==)(a::FuelCurve, b::FuelCurve) =
    (get_value_curve(a) == get_value_curve(b)) &&
    (get_power_units(a) == get_power_units(b)) &&
    (get_fuel_cost(a) == get_fuel_cost(b))

"Get a `FuelCurve` representing zero fuel usage and zero fuel cost"
Base.zero(::Union{FuelCurve, Type{FuelCurve}}) = FuelCurve(zero(ValueCurve), 0.0)

"Get the fuel cost or the name of the fuel cost time series"
get_fuel_cost(cost::FuelCurve) = cost.fuel_cost

# HDF5 SERIALIZATION
IS.transform_array_for_hdf(data::Vector{<:CostCurve}) =
    IS.transform_array_for_hdf(get_value_curve.(data))

IS.transform_array_for_hdf(data::SortedDict{Dates.DateTime, <:Vector{<:CostCurve{T}}}) where {T} =
    IS.transform_array_for_hdf(
        SortedDict{Dates.DateTime, Vector{T}}(
            k => get_value_curve.(v) for (k, v) in data
        )
    )

IS.retransform_hdf_array(data::Array, T::Type{CostCurve{U}}) where {U} =
    CostCurve.(IS.retransform_hdf_array(data, U))
