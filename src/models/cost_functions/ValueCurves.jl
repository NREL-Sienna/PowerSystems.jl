"Type that represents an abstract cost curve without units on the cost"
abstract type ValueCurve end

"Get the underlying `FunctionData` representation of this `ValueCurve`"
get_function_data(curve::ValueCurve) = curve.function_data

"An input-output curve, directly relating the production quantity to the cost: `y = f(x)`"
struct InputOutputCurve{T} <: ValueCurve where {
    T <: Union{QuadraticFunctionData, LinearFunctionData, PiecewiseLinearData}}
    "The underlying `FunctionData` representation of this `ValueCurve`"
    function_data::T
end

"An incremental (or 'marginal') curve, relating the production quantity to the derivative of cost: `y = f'(x)`"
struct IncrementalCurve{T} <: ValueCurve where {
    T <: Union{LinearFunctionData, PiecewiseStepData}}
    "The underlying `FunctionData` representation of this `ValueCurve`"
    function_data::T
    "The value of f(x) at the least x for which the function is defined, or the origin for functions with no left endpoint, used for conversion to `InputOutputCurve`"
    initial_input::Float64
end

"An average rate curve, relating the production quantity to the average cost rate from the origin: `y = f(x)/x`"
struct AverageRateCurve{T} <: ValueCurve where {
    T <: Union{LinearFunctionData, PiecewiseStepData}}
    "The underlying `FunctionData` representation of this `ValueCurve`, in the case of `AverageRateCurve{LinearFunctionData}` representing only the oblique asymptote"
    function_data::T
    "The value of f(x) at the least x for which the function is defined, or the origin for functions with no left endpoint, used for conversion to `InputOutputCurve`"
    initial_input::Float64
end

"Get the `initial_input` field of this `ValueCurve`"
get_initial_input(curve::Union{IncrementalCurve, AverageRateCurve}) = curve.initial_input

# EQUALITY
Base.:(==)(a::InputOutputCurve, b::InputOutputCurve) =
    (get_function_data(a) == get_function_data(b))

Base.:(==)(a::T, b::T) where {T <: Union{IncrementalCurve, AverageRateCurve}} =
    (get_function_data(a) == get_function_data(b)) &&
    (get_initial_input(a) == get_initial_input(b))

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
