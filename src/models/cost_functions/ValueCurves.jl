"""
Supertype that represents a unitless cost curve

Concrete options are [listed here.](@ref value_curve_library)
"""
abstract type ValueCurve{T <: FunctionData} end

# JSON SERIALIZATION
IS.serialize(val::ValueCurve) = IS.serialize_struct(val)
IS.deserialize(T::Type{<:ValueCurve}, val::Dict) = IS.deserialize_struct(T, val)

"Get the underlying `FunctionData` representation of this `ValueCurve`"
get_function_data(curve::ValueCurve) = curve.function_data

"""
An input-output curve, directly relating the production quantity to the cost: `y = f(x)`.
Can be used, for instance, in the representation of a [`CostCurve`](@ref) where `x` is MW
and `y` is currency/hr, or in the representation of a [`FuelCurve`](@ref) where `x` is MW
and `y` is fuel/hr.
"""
@kwdef struct InputOutputCurve{
    T <: Union{QuadraticFunctionData, LinearFunctionData, PiecewiseLinearData},
} <: ValueCurve{T}
    "The underlying `FunctionData` representation of this `ValueCurve`"
    function_data::T
    "Optional, an explicit representation of the input value at zero output."
    input_at_zero::Union{Nothing, Float64} = nothing
end

InputOutputCurve(function_data) = InputOutputCurve(function_data, nothing)
InputOutputCurve{T}(function_data) where (T <: Union{QuadraticFunctionData, LinearFunctionData, PiecewiseLinearData}) = InputOutputCurve{T}(function_data, nothing)

"""
An incremental (or 'marginal') curve, relating the production quantity to the derivative of
cost: `y = f'(x)`. Can be used, for instance, in the representation of a [`CostCurve`](@ref)
where `x` is MW and `y` is currency/MWh, or in the representation of a [`FuelCurve`](@ref)
where `x` is MW and `y` is fuel/MWh.
"""
@kwdef struct IncrementalCurve{T <: Union{LinearFunctionData, PiecewiseStepData}} <:
              ValueCurve{T}
    "The underlying `FunctionData` representation of this `ValueCurve`"
    function_data::T
    "The value of f(x) at the least x for which the function is defined, or the origin for functions with no left endpoint, used for conversion to `InputOutputCurve`"
    initial_input::Float64
    "Optional, an explicit representation of the input value at zero output."
    input_at_zero::Union{Nothing, Float64} = nothing
end

IncrementalCurve(function_data, initial_input) = IncrementalCurve(function_data, initial_input, nothing)
IncrementalCurve{T}(function_data, initial_input) where (T <: Union{QuadraticFunctionData, LinearFunctionData, PiecewiseLinearData}) = IncrementalCurve{T}(function_data, initial_input, nothing)

"""
An average rate curve, relating the production quantity to the average cost rate from the
origin: `y = f(x)/x`. Can be used, for instance, in the representation of a
[`CostCurve`](@ref) where `x` is MW and `y` is currency/MWh, or in the representation of a
[`FuelCurve`](@ref) where `x` is MW and `y` is fuel/MWh. Typically calculated by dividing
absolute values of cost rate or fuel input rate by absolute values of electric power.
"""
@kwdef struct AverageRateCurve{T <: Union{LinearFunctionData, PiecewiseStepData}} <:
              ValueCurve{T}
    "The underlying `FunctionData` representation of this `ValueCurve`, in the case of `AverageRateCurve{LinearFunctionData}` representing only the oblique asymptote"
    function_data::T
    "The value of f(x) at the least x for which the function is defined, or the origin for functions with no left endpoint, used for conversion to `InputOutputCurve`"
    initial_input::Float64
    "Optional, an explicit representation of the input value at zero output."
    input_at_zero::Union{Nothing, Float64} = nothing
end

AverageRateCurve(function_data, initial_input) = AverageRateCurve(function_data, initial_input, nothing)
AverageRateCurve{T}(function_data, initial_input) where (T <: Union{QuadraticFunctionData, LinearFunctionData, PiecewiseLinearData}) = AverageRateCurve{T}(function_data, initial_input, nothing)

"Get the `initial_input` field of this `ValueCurve` (not defined for `InputOutputCurve`)"
get_initial_input(curve::Union{IncrementalCurve, AverageRateCurve}) = curve.initial_input

# BASE METHODS
Base.:(==)(a::T, b::T) where {T <: ValueCurve} = IS.double_equals_from_fields(a, b)

Base.isequal(a::T, b::T) where {T <: ValueCurve} = IS.isequal_from_fields(a, b)

Base.hash(a::ValueCurve) = IS.hash_from_fields(a)

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

# PRINTING
# For cost aliases, return the alias name; otherwise, return the type name without the parameter
simple_type_name(curve::ValueCurve) =
    string(is_cost_alias(curve) ? typeof(curve) : nameof(typeof(curve)))

function Base.show(io::IO, ::MIME"text/plain", curve::InputOutputCurve)
    print(io, simple_type_name(curve))
    is_cost_alias(curve) && print(io, " (a type of $InputOutputCurve)")
    print(io, " with function: ")
    show(IOContext(io, :compact => true), "text/plain", get_function_data(curve))
end

function Base.show(io::IO, ::MIME"text/plain", curve::IncrementalCurve)
    print(io, simple_type_name(curve))
    print(io, " where initial value is $(get_initial_input(curve))")
    print(io, " and derivative function f is: ")
    show(IOContext(io, :compact => true), "text/plain", get_function_data(curve))
end

function Base.show(io::IO, ::MIME"text/plain", curve::AverageRateCurve)
    print(io, simple_type_name(curve))
    print(io, " where initial value is $(get_initial_input(curve))")
    print(io, " and average rate function f is: ")
    show(IOContext(io, :compact => true), "text/plain", get_function_data(curve))
end
