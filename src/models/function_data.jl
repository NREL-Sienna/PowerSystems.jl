abstract type FunctionData end

"""
Structure to represent the underlying data of linear functions. Principally used for
the representation of cost functions f(x) = proportional_term*x
"""
struct LinearFunctionData <: FunctionData
    proportional_term::Float64
end

get_proportional_term(fd::LinearFunctionData) = fd.proportional_term

"""
Structure to represent the underlying data of quadratic polynomial functions. Principally used for
the representation of cost functions f(x) = quadratic_term*x^2 + proportional_term*x + constant_term
"""
struct QuadraticFunctionData <: FunctionData
    quadratic_term::Float64
    proportional_term::Float64
    constant_term::Float64
end

get_quadratic_term(fd::QuadraticFunctionData) = fd.quadratic_term
get_proportional_term(fd::QuadraticFunctionData) = fd.proportional_term
get_constant_term(fd::QuadraticFunctionData) = fd.constant_term

"""
Structure to represent the underlying data of higher order polynomials. Principally used for
the representation of cost functions where
f(x) = sum_{i in keys(coefficients)} coefficients[i]*x^i.
"""
struct PolynomialFunctionData <: FunctionData
    coefficients::Dict{Int, Float64}
end

get_coefficients(fd::PolynomialFunctionData) = fd.coefficients

function _validate_piecewise_x(x_coords)
    issorted(x_coords) || throw(ArgumentError("Piecewise x-coordinates must be ascending"))
    (x_coords[1] >= 0) || throw(ArgumentError("Piecewise x-coordinates cannot be negative"))
end

"""
Structure to represent the underlying data of pointwise piecewise linear data. Principally
used for the representation of cost functions where the points store quantities (x, y), such
as (MW, \$).
"""
struct PiecewiseLinearPointData <: FunctionData
    segments::Vector{Tuple{Float64, Float64}}

    function PiecewiseLinearPointData(segments)
        _validate_piecewise_x(first.(segments))
        return new(segments)
    end
end

get_segments(data::PiecewiseLinearPointData) = data.segments

get_points(data::PiecewiseLinearPointData) = get_segments(data)

function _get_slopes(vc::Vector{NTuple{2, Float64}})
    slopes = Vector{Float64}(undef, length(vc))
    (prev_x, prev_y) = (0.0, 0.0)
    for (i, (comp_x, comp_y)) in enumerate(vc)
        # Special case: if first point is on the y-axis, define the degenerate first segment to have slope 0
        if i == 1 && comp_x == 0
            slopes[i] = 0
        else
            slopes[i] = (comp_y - prev_y) / (comp_x - prev_x)
        end
        (prev_x, prev_y) = (comp_x, comp_y)
    end
    return slopes
end

function _get_breakpoint_upperbounds(vc::Vector{NTuple{2, Float64}})
    x_coords = first.(vc)
    return x_coords .- vcat(0, x_coords[1:(end - 1)])
end

"""
Calculates the slopes of the line segments defined by the PiecewiseLinearPointData, assuming
the first segment starts at the origin. If the first point in the data has an x-coordinate
of 0, reports 0 for the slope of the degenerate first segment. Returns as many slopes as
there are points in the data. If your formulation uses n-1 slopes, discard the first slope.
"""
function get_slopes(pwl::PiecewiseLinearPointData)
    return _get_slopes(get_points(pwl))
end

"""
Structure to represent the underlying data of slope piecewise linear data. Principally used
for the representation of cost functions where the points store quantities (x, dy/dx), such
as (MW, \$/MW).
"""
struct PiecewiseLinearSlopeData <: FunctionData
    segments::Vector{Tuple{Float64, Float64}}

    function PiecewiseLinearSlopeData(segments)
        _validate_piecewise_x(first.(segments))
        return new(segments)
    end
end

get_segments(data::PiecewiseLinearSlopeData) = data.segments

get_slopes(data::PiecewiseLinearSlopeData) = last.(get_segments(data))

"""
Calculates the x-length of each segment of a piecewise curve.
"""
function get_breakpoint_upperbounds(
    pwl::Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData},
)
    return _get_breakpoint_upperbounds(get_segments(pwl))
end

Base.length(pwl::Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData}) =
    length(get_segments(pwl))

Base.getindex(pwl::Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData}, ix::Int) =
    getindex(get_segments(pwl), ix)

Base.:(==)(a::T, b::T) where T<:Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData} =
    get_segments(a) == get_segments(b)

Base.:(==)(a::PolynomialFunctionData, b::PolynomialFunctionData) =
    get_coefficients(a) == get_coefficients(b)

function _slope_convexity_check(slopes::Vector{Float64})
    for ix in 1:(length(slopes) - 1)
        if slopes[ix] > slopes[ix + 1]
            @debug slopes
            return false
        end
    end
    return true
end

"""
Returns True/False depending on the convexity of the underlying data
"""
is_convex(pwl::Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData}) =
    _slope_convexity_check(get_slopes(pwl))

# kwargs-only constructors for deserialization
LinearFunctionData(; proportional_term) = LinearFunctionData(proportional_term)

QuadraticFunctionData(; quadratic_term, proportional_term, constant_term) =
    QuadraticFunctionData(quadratic_term, proportional_term, constant_term)

PolynomialFunctionData(; coefficients) = PolynomialFunctionData(coefficients)

PiecewiseLinearPointData(; segments) = PiecewiseLinearPointData(segments)

PiecewiseLinearSlopeData(; segments) = PiecewiseLinearSlopeData(segments)

IS.serialize(val::FunctionData) = IS.serialize_struct(val)

IS.deserialize(x::Type{<:FunctionData}, val::Dict) =
    IS.deserialize_struct(x, val)
