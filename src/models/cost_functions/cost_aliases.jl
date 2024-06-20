# Cost aliases: a simplified interface to the portion of the parametric
# `ValueCurve{FunctionData}` design that the user is likely to interact with. Each alias
# consists of a simple name for a particular `ValueCurve{FunctionData}` type, a constructor
# and methods to interact with it without having to think about `FunctionData`, and
# overridden printing behavior to complete the illusion. Everything here (aside from the
# overridden printing) is properly speaking mere syntactic sugar for the underlying
# `ValueCurve{FunctionData}` design. One could imagine similar convenience constructors and
# methods being defined for all the `ValueCurve{FunctionData}` types, not just the ones we
# have here nicely packaged and presented to the user.

"Whether there is a cost alias for the instance or type under consideration"
is_cost_alias(::Union{ValueCurve, Type{<:ValueCurve}}) = false

"""
    LinearCurve(proportional_term::Float64, constant_term::Float64)

A linear input-output curve, representing a constant marginal rate. May have zero no-load
cost (i.e., constant average rate) or not.

# Arguments
- `proportional_term::Float64`: marginal rate
- `constant_term::Float64`: optional, cost at zero production, defaults to `0.0`
"""
const LinearCurve = InputOutputCurve{LinearFunctionData}

is_cost_alias(::Union{LinearCurve, Type{LinearCurve}}) = true

InputOutputCurve{LinearFunctionData}(proportional_term::Real) =
    InputOutputCurve(LinearFunctionData(proportional_term))

InputOutputCurve{LinearFunctionData}(proportional_term::Real, constant_term::Real) =
    InputOutputCurve(LinearFunctionData(proportional_term, constant_term))

function Base.show(io::IO, data::LinearCurve)
    fd = get_function_data(data)
    p, c = get_proportional_term(fd), get_constant_term(fd)
    print(io, "$(typeof(data))($p, $c)")
end

"""
    QuadraticCurve(quadratic_term::Float64, proportional_term::Float64, constant_term::Float64)

A quadratic input-output curve, may have nonzero no-load cost.

# Arguments
- `quadratic_term::Float64`: quadratic term of the curve
- `proportional_term::Float64`: proportional term of the curve
- `constant_term::Float64`: constant term of the curve
"""
const QuadraticCurve = InputOutputCurve{QuadraticFunctionData}

is_cost_alias(::Union{QuadraticCurve, Type{QuadraticCurve}}) = true

InputOutputCurve{QuadraticFunctionData}(quadratic_term, proportional_term, constant_term) =
    InputOutputCurve(
        QuadraticFunctionData(quadratic_term, proportional_term, constant_term),
    )

function Base.show(io::IO, data::QuadraticCurve)
    fd = get_function_data(data)
    q, p, c = get_quadratic_term(fd), get_proportional_term(fd), get_constant_term(fd)
    print(io, "$(typeof(data))($q, $p, $c)")
end

"""
    PiecewisePointCurve(points::Vector{Tuple{Float64, Float64}})

A piecewise linear curve specified by cost values at production points.

# Arguments
- `points::Vector{Tuple{Float64, Float64}}` or similar: vector of `(production, cost)` pairs
"""
const PiecewisePointCurve = InputOutputCurve{PiecewiseLinearData}

is_cost_alias(::Union{PiecewisePointCurve, Type{PiecewisePointCurve}}) = true

InputOutputCurve{PiecewiseLinearData}(points::Vector) =
    InputOutputCurve(PiecewiseLinearData(points))

get_points(curve::PiecewisePointCurve) = get_points(get_function_data(curve))

# Here we manually circumvent the @NamedTuple{x::Float64, y::Float64} annotation, but we keep things looking like named tuples
Base.show(io::IO, data::PiecewisePointCurve) =
    print(io, "$(typeof(data))([$(join(get_points(data), ", "))])")

"""
    PiecewiseIncrementalCurve(initial_input::Float64, x_coords::Vector{Float64}, slopes::Vector{Float64})

A piecewise linear curve specified by marginal rates (slopes) between production points. May
have nonzero initial value.

# Arguments
- `initial_input::Float64`: cost at minimum production point
- `x_coords::Vector{Float64}`: vector of `n` production points
- `slopes::Vector{Float64}`: vector of `n-1` marginal rates/slopes of the curve segments between
  the points
"""
const PiecewiseIncrementalCurve = IncrementalCurve{PiecewiseStepData}

is_cost_alias(::Union{PiecewiseIncrementalCurve, Type{PiecewiseIncrementalCurve}}) = true

IncrementalCurve{PiecewiseStepData}(initial_input, x_coords::Vector, slopes::Vector) =
    IncrementalCurve(PiecewiseStepData(x_coords, slopes), initial_input)

get_slopes(curve::PiecewiseIncrementalCurve) = get_y_coords(get_function_data(curve))

function Base.show(io::IO, data::PiecewiseIncrementalCurve)
    initial_input = get_initial_input(data)
    fd = get_function_data(data)
    x_coords = get_x_coords(fd)
    slopes = get_slopes(data)
    print(io, "$(typeof(data))($initial_input, $x_coords, $slopes)")
end

"""
    PiecewiseAverageCurve(initial_input::Float64, x_coords::Vector{Float64}, slopes::Vector{Float64})

A piecewise linear curve specified by average rates between production points. May have
nonzero initial value.

# Arguments
- `initial_input::Float64`: cost at minimum production point
- `x_coords::Vector{Float64}`: vector of `n` production points
- `slopes::Vector{Float64}`: vector of `n-1` average rates/slopes of the curve segments between
  the points
"""
const PiecewiseAverageCurve = AverageRateCurve{PiecewiseStepData}

is_cost_alias(::Union{PiecewiseAverageCurve, Type{PiecewiseAverageCurve}}) = true

AverageRateCurve{PiecewiseStepData}(initial_input, x_coords::Vector, y_coords::Vector) =
    AverageRateCurve(PiecewiseStepData(x_coords, y_coords), initial_input)

function Base.show(io::IO, data::PiecewiseAverageCurve)
    initial_input = get_initial_input(data)
    fd = get_function_data(data)
    x_coords = get_x_coords(fd)
    y_coords = get_y_coords(fd)
    print(io, "$(typeof(data))($initial_input, $x_coords, $y_coords)")
end

# TODO documentation, more getters
