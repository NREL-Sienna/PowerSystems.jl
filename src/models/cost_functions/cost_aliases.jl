# Cost aliases: a simplified interface to the portion of the parametric
# `ValueCurve{FunctionData}` design that the user is likely to interact with. Each alias
# consists of a simple name for a particular `ValueCurve{FunctionData}` type and a
# constructor and methods to interact with it without having to think about `FunctionData`.
# Everything here is properly speaking mere syntactic sugar for the underlying
# `ValueCurve{FunctionData}` design. One could imagine similar convenience constructors and
# methods being defined for all the `ValueCurve{FunctionData}` types, not just the ones we
# have here nicely packaged and presented to the user.

const LinearCurve = InputOutputCurve{LinearFunctionData}

InputOutputCurve{LinearFunctionData}(proportional_term::Real) =
    InputOutputCurve(LinearFunctionData(proportional_term))

InputOutputCurve{LinearFunctionData}(proportional_term::Real, constant_term::Real) =
    InputOutputCurve(LinearFunctionData(proportional_term, constant_term))

const QuadraticCurve = InputOutputCurve{QuadraticFunctionData}

InputOutputCurve{QuadraticFunctionData}(quadratic_term, proportional_term, constant_term) =
    InputOutputCurve(
        QuadraticFunctionData(quadratic_term, proportional_term, constant_term),
    )

const PiecewiseSlopeCurve = IncrementalCurve{PiecewiseStepData}

IncrementalCurve{PiecewiseStepData}(initial_input, x_coords, y_coords) =
    IncrementalCurve(PiecewiseStepData(x_coords, y_coords), initial_input)

get_slopes(curve::PiecewiseSlopeCurve) = get_y_coords(get_function_data(curve))

const PiecewisePointCurve = InputOutputCurve{PiecewiseLinearData}

InputOutputCurve{PiecewiseLinearData}(points) =
    InputOutputCurve(PiecewiseLinearData(points))

get_points(curve::PiecewisePointCurve) = get_points(get_function_data(curve))

const PiecewiseAverageCurve = AverageRateCurve{PiecewiseStepData}

AverageRateCurve{PiecewiseStepData}(initial_input, x_coords, y_coords) =
    AverageRateCurve(PiecewiseStepData(x_coords, y_coords), initial_input)

# TODO documentation, more getters, custom printing so it always shows the type alias (like Vector does)
