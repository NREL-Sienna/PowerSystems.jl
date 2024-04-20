"Type that represents an abstract cost curve without units on the cost"
abstract type ValueCurve{T <: FunctionData} end

# JSON SERIALIZATION
IS.serialize(val::ValueCurve) = IS.serialize_struct(val)
IS.deserialize(T::Type{<:ValueCurve}, val::Dict) = IS.deserialize_struct(T, val)

"Get the underlying `FunctionData` representation of this `ValueCurve`"
get_function_data(curve::ValueCurve) = curve.function_data

"""
An input-output curve, directly relating the production quantity to the cost: `y = f(x)`.
Can be used, for instance, in the representation of a [`CostCurve`][@ref] where `x` is MW
and `y` is \$/hr, or in the representation of a [`FuelCurve`][@ref] where `x` is MW and `y`
is fuel/hr.
"""
@kwdef struct InputOutputCurve{
    T <: Union{QuadraticFunctionData, LinearFunctionData, PiecewiseLinearData},
} <: ValueCurve{T}
    "The underlying `FunctionData` representation of this `ValueCurve`"
    function_data::T
end

"""
An incremental (or 'marginal') curve, relating the production quantity to the derivative of
cost: `y = f'(x)`. Can be used, for instance, in the representation of a [`CostCurve`][@ref]
where `x` is MW and `y` is \$/MWh, or in the representation of a [`FuelCurve`][@ref] where
`x` is MW and `y` is fuel/MWh.
"""
@kwdef struct IncrementalCurve{T <: Union{LinearFunctionData, PiecewiseStepData}} <:
              ValueCurve{T}
    "The underlying `FunctionData` representation of this `ValueCurve`"
    function_data::T
    "The value of f(x) at the least x for which the function is defined, or the origin for functions with no left endpoint, used for conversion to `InputOutputCurve`"
    initial_input::Float64
end

"""
An average rate curve, relating the production quantity to the average cost rate from the
origin: `y = f(x)/x`. Can be used, for instance, in the representation of a
[`CostCurve`][@ref] where `x` is MW and `y` is \$/MWh, or in the representation of a
[`FuelCurve`][@ref] where `x` is MW and `y` is fuel/MWh. Typically calculated by dividing
absolute values of cost rate or fuel input rate by absolute values of electric power.
"""
@kwdef struct AverageRateCurve{T <: Union{LinearFunctionData, PiecewiseStepData}} <:
              ValueCurve{T}
    "The underlying `FunctionData` representation of this `ValueCurve`, in the case of `AverageRateCurve{LinearFunctionData}` representing only the oblique asymptote"
    function_data::T
    "The value of f(x) at the least x for which the function is defined, or the origin for functions with no left endpoint, used for conversion to `InputOutputCurve`"
    initial_input::Float64
end

"Get the `initial_input` field of this `ValueCurve` (not defined for `InputOutputCurve`)"
get_initial_input(curve::Union{IncrementalCurve, AverageRateCurve}) = curve.initial_input

# BASE METHODS
Base.:(==)(a::InputOutputCurve, b::InputOutputCurve) =
    (get_function_data(a) == get_function_data(b))

Base.:(==)(a::T, b::T) where {T <: Union{IncrementalCurve, AverageRateCurve}} =
    (get_function_data(a) == get_function_data(b)) &&
    (get_initial_input(a) == get_initial_input(b))

"Get an `InputOutputCurve` representing `f(x) = 0`"
Base.zero(::Union{InputOutputCurve, Type{InputOutputCurve}}) =
    InputOutputCurve(zero(FunctionData))

"Get an `IncrementalCurve` representing `f'(x) = 0` with zero `initial_input`"
Base.zero(::Union{IncrementalCurve, Type{IncrementalCurve}}) =
    IncrementalCurve(zero(FunctionData), 0.0)

"Get an `AverageRateCurve` representing `f(x)/x = 0` with zero `initial_input`"
Base.zero(::Union{AverageRateCurve, Type{AverageRateCurve}}) =
    AverageRateCurve(zero(FunctionData), 0.0)

"Get a `ValueCurve` representing zero variable cost"
Base.zero(::Union{ValueCurve, Type{ValueCurve}}) =
    Base.zero(InputOutputCurve)

# CONVERSIONS: InputOutputCurve{LinearFunctionData} to InputOutputCurve{QuadraticFunctionData}
InputOutputCurve{QuadraticFunctionData}(data::InputOutputCurve{LinearFunctionData}) =
    InputOutputCurve{QuadraticFunctionData}(get_function_data(data))

Base.convert(
    ::Type{InputOutputCurve{QuadraticFunctionData}},
    data::InputOutputCurve{LinearFunctionData},
) = InputOutputCurve{QuadraticFunctionData}(data)

# CONVERSIONS: InputOutputCurve to X
function IncrementalCurve(data::InputOutputCurve{QuadraticFunctionData})
    fd = get_function_data(data)
    q, p, c = get_quadratic_term(fd), get_proportional_term(fd), get_constant_term(fd)
    return IncrementalCurve(LinearFunctionData(2q, p), c)
end

function AverageRateCurve(data::InputOutputCurve{QuadraticFunctionData})
    fd = get_function_data(data)
    q, p, c = get_quadratic_term(fd), get_proportional_term(fd), get_constant_term(fd)
    return AverageRateCurve(LinearFunctionData(q, p), c)
end

IncrementalCurve(data::InputOutputCurve{LinearFunctionData}) =
    IncrementalCurve(InputOutputCurve{QuadraticFunctionData}(data))

AverageRateCurve(data::InputOutputCurve{LinearFunctionData}) =
    AverageRateCurve(InputOutputCurve{QuadraticFunctionData}(data))

function IncrementalCurve(data::InputOutputCurve{PiecewiseLinearData})
    fd = get_function_data(data)
    return IncrementalCurve(
        PiecewiseStepData(get_x_coords(fd), get_slopes(fd)),
        first(get_points(fd)).y,
    )
end

function AverageRateCurve(data::InputOutputCurve{PiecewiseLinearData})
    fd = get_function_data(data)
    points = get_points(fd)
    slopes_from_origin = [p.y / p.x for p in points[2:end]]
    return AverageRateCurve(
        PiecewiseStepData(get_x_coords(fd), slopes_from_origin),
        first(points).y,
    )
end

# CONVERSIONS: IncrementalCurve to X
function InputOutputCurve(data::IncrementalCurve{LinearFunctionData})
    fd = get_function_data(data)
    p = get_proportional_term(fd)
    (p == 0) && return InputOutputCurve(
        LinearFunctionData(get_constant_term(fd), get_initial_input(data)),
    )
    return InputOutputCurve(
        QuadraticFunctionData(p / 2, get_constant_term(fd), get_initial_input(data)),
    )
end

function InputOutputCurve(data::IncrementalCurve{PiecewiseStepData})
    fd = get_function_data(data)
    c = get_initial_input(data)
    points = running_sum(fd)
    return InputOutputCurve(PiecewiseLinearData([(p.x, p.y + c) for p in points]))
end

AverageRateCurve(data::IncrementalCurve) = AverageRateCurve(InputOutputCurve(data))

# CONVERSIONS: AverageRateCurve to X
function InputOutputCurve(data::AverageRateCurve{LinearFunctionData})
    fd = get_function_data(data)
    p = get_proportional_term(fd)
    (p == 0) && return InputOutputCurve(
        LinearFunctionData(get_constant_term(fd), get_initial_input(data)),
    )
    return InputOutputCurve(
        QuadraticFunctionData(p, get_constant_term(fd), get_initial_input(data)),
    )
end

function InputOutputCurve(data::AverageRateCurve{PiecewiseStepData})
    fd = get_function_data(data)
    c = get_initial_input(data)
    xs = get_x_coords(fd)
    ys = xs[2:end] .* get_y_coords(fd)
    return InputOutputCurve(PiecewiseLinearData(collect(zip(xs, vcat(c, ys)))))
end

IncrementalCurve(data::AverageRateCurve) = IncrementalCurve(InputOutputCurve(data))

# CALCULATIONS
is_convex(curve::InputOutputCurve) = is_convex(get_function_data(curve))
"Calculate the convexity of the underlying data"
is_convex(curve::ValueCurve) = is_convex(InputOutputCurve(curve))

# HDF5 SERIALIZATION
IS.transform_array_for_hdf(data::Vector{<:InputOutputCurve}) =
    IS.transform_array_for_hdf(IS.get_raw_data.(get_function_data.(data)))

IS.transform_array_for_hdf(
    data::SortedDict{Dates.DateTime, Vector{InputOutputCurve{T}}},
) where {T <: Union{LinearFunctionData, QuadraticFunctionData}} =
    transform_array_for_hdf(
        SortedDict{Dates.DateTime, Vector{get_raw_data_type(T)}}(
            k => IS.get_raw_data.(get_function_data.(v)) for (k, v) in data
        ),
    )

IS.retransform_hdf_array(data::Array, T::Type{InputOutputCurve{U}}) where {U} =
    T.(IS.retransform_hdf_array(data, U))

_derived_piecewise_step_data =
    Union{IncrementalCurve{PiecewiseStepData}, AverageRateCurve{PiecewiseStepData}}

_initial_step_to_pairs(data::_derived_piecewise_step_data) =
    collect(
        zip(IS.get_x_coords(get_function_data(data)),
            vcat(get_initial_input(data), IS.get_y_coords(get_function_data(data)))),
    )

function _pairs_to_initial_step(pairs, T::Type{<:_derived_piecewise_step_data})
    x_coords, y_coords = collect.(zip(pairs...))
    return T(PiecewiseStepData(x_coords, y_coords[2:end]), first(y_coords))
end

IS.transform_array_for_hdf(data::Vector{T}) where {T <: _derived_piecewise_step_data} =
    IS.transform_array_for_hdf(_initial_step_to_pairs.(data))

IS.transform_array_for_hdf(
    data::SortedDict{Dates.DateTime, Vector{T}},
) where {T <: _derived_piecewise_step_data} =
    IS.transform_array_for_hdf(
        SortedDict{Dates.DateTime, Vector{Tuple}}(
            k => _initial_step_to_pairs(v) for (k, v) in data
        ),
    )

IS.retransform_hdf_array(data::Array, T::Type{<:_derived_piecewise_step_data}) =
    _pairs_to_initial_step.(IS.retransform_hdf_array(data, Vector{Tuple}), T)

# These could easily be implemented if need be
_derived_linear_function_data =
    Union{IncrementalCurve{LinearFunctionData}, AverageRateCurve{LinearFunctionData}}

IS.transform_array_for_hdf(::Vector{T}) where {T <: _derived_linear_function_data} =
    throw(IS.NotImplementedError(:(IS.transform_array_for_hdf), T))

IS.transform_array_for_hdf(
    ::SortedDict{Dates.DateTime, Vector{T}},
) where {T <: _derived_linear_function_data} =
    throw(IS.NotImplementedError(:(IS.transform_array_for_hdf), T))

IS.retransform_hdf_array(::Array, ::_derived_linear_function_data) =
    throw(IS.NotImplementedError(:(IS.retransform_hdf_array), T))
