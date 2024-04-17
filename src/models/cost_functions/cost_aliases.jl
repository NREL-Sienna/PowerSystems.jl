# Cost aliases: a simplified interface to the portion of the parametric
# `ValueCurve{FunctionData}` design that the user is likely to interact with. Each alias
# consists of a simple name for a particular `ValueCurve{FunctionData}` type and a
# constructor and methods to interact with it without having to think about `FunctionData`.
# Everything here is properly speaking mere syntactic sugar for the underlying
# `ValueCurve{FunctionData}` design. One could imagine similar convenience constructors and
# methods being defined for all the `ValueCurve{FunctionData}` types, not just the ones we
# have here nicely packaged and presented to the user.

"""
A linear input-output curve, representing a constant marginal rate. May have zero no-load
cost (i.e., constant average rate) or not.

# Arguments
- `proportional_term::Float64`: marginal rate
- `constant_term::Float64`: optional, cost at zero production, defaults to `0.0`
"""
const LinearCurve = InputOutputCurve{LinearFunctionData}

InputOutputCurve{LinearFunctionData}(proportional_term::Real) =
    InputOutputCurve(LinearFunctionData(proportional_term))

InputOutputCurve{LinearFunctionData}(proportional_term::Real, constant_term::Real) =
    InputOutputCurve(LinearFunctionData(proportional_term, constant_term))

"""
A quadratic input-output curve, may have nonzero no-load cost.

# Arguments
- `quadratic_term::Float64`: quadratic term of the curve
- `proportional_term::Float64`: proportional term of the curve
- `constant_term::Float64`: constant term of the curve
"""
const QuadraticCurve = InputOutputCurve{QuadraticFunctionData}

InputOutputCurve{QuadraticFunctionData}(quadratic_term, proportional_term, constant_term) =
    InputOutputCurve(
        QuadraticFunctionData(quadratic_term, proportional_term, constant_term),
    )

"""
A piecewise linear curve specified by cost values at production points.

# Arguments
- `points::Vector{Tuple{Float64, Float64}}` or similar: vector of `(production, cost)` pairs
"""
const PiecewisePointCurve = InputOutputCurve{PiecewiseLinearData}

InputOutputCurve{PiecewiseLinearData}(points) =
    InputOutputCurve(PiecewiseLinearData(points))

get_points(curve::PiecewisePointCurve) = get_points(get_function_data(curve))

"""
A piecewise linear curve specified by marginal rates (slopes) between production points. May
have nonzero initial value.

# Arguments
- `initial_input::Float64`: cost at minimum production point
- `x_coords::Float64`: vector of `n` production points
- `slopes::Float64`: vector of `n-1` marginal rates/slopes of the curve segments between
  the points
"""
const PiecewiseIncrementalCurve = IncrementalCurve{PiecewiseStepData}

IncrementalCurve{PiecewiseStepData}(initial_input, x_coords, slopes) =
    IncrementalCurve(PiecewiseStepData(x_coords, slopes), initial_input)

get_slopes(curve::PiecewiseIncrementalCurve) = get_y_coords(get_function_data(curve))

"""
A piecewise linear curve specified by average rates between production points. May have
nonzero initial value.

# Arguments
- `pairs::Vector{Tuple{Float64, Float64}}` or similar: vector of `(production, average
  rate)` pairs
"""
const PiecewiseAverageCurve = AverageRateCurve{PiecewiseStepData}

AverageRateCurve{PiecewiseStepData}(initial_input, x_coords, y_coords) =
    AverageRateCurve(PiecewiseStepData(x_coords, y_coords), initial_input)

# TODO documentation, more getters, custom printing so it always shows the type alias (like Vector does)
