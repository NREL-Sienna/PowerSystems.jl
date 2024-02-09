abstract type FunctionData end

"""
Structure to represent the underlying data of linear functions. Principally used for
the representation of cost functions `f(x) = proportional_term*x`.

# Arguments
 - `proportional_term::Float64`: the proportional term in the function
   `f(x) = proportional_term*x`
"""
struct LinearFunctionData <: FunctionData
    proportional_term::Float64
end

get_proportional_term(fd::LinearFunctionData) = fd.proportional_term

"""
Structure to represent the underlying data of quadratic polynomial functions. Principally
used for the representation of cost functions
`f(x) = quadratic_term*x^2 + proportional_term*x + constant_term`.

# Arguments
 - `quadratic_term::Float64`: the quadratic term in the represented function
 - `proportional_term::Float64`: the proportional term in the represented function
 - `constant_term::Float64`: the constant term in the represented function
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
`f(x) = sum_{i in keys(coefficients)} coefficients[i]*x^i`.

# Arguments
 - `coefficients::Dict{Int, Float64}`: values are coefficients, keys are degrees to which
   the coefficients apply (0 for the constant term, 2 for the squared term, etc.)
"""
struct PolynomialFunctionData <: FunctionData
    coefficients::Dict{Int, Float64}
end

get_coefficients(fd::PolynomialFunctionData) = fd.coefficients

function _validate_piecewise_x(x_coords)
    (length(x_coords) >= 2) ||
        throw(ArgumentError("Must specify at least two x-coordinates"))
    issorted(x_coords) || throw(ArgumentError("Piecewise x-coordinates must be ascending"))
    # TODO are there legitimate cases where we'd want negative x-coordinates?
    # (x_coords[1] >= 0) || throw(ArgumentError("Piecewise x-coordinates cannot be negative"))
end

"""
Structure to represent  pointwise piecewise linear data. Principally used for the
representation of cost functions where the points store quantities (x, y), such as (MW, \$).
The curve starts at the first point given, not the origin.

# Arguments
 - `points::Vector{Tuple{Float64, Float64}}`: the points (x, y) that define the function
"""
struct PiecewiseLinearPointData <: FunctionData
    points::Vector{Tuple{Float64, Float64}}

    function PiecewiseLinearPointData(points)
        _validate_piecewise_x(first.(points))
        return new(points)
    end
end

"Get the points that define the piecewise data"
get_points(data::PiecewiseLinearPointData) = data.points

"Get the x-coordinates of the points that define the piecewise data"
get_x_coords(data::PiecewiseLinearPointData) = first.(get_points(data))

function _get_slopes(vc::Vector{NTuple{2, Float64}})
    slopes = Vector{Float64}(undef, length(vc)-1)
    (prev_x, prev_y) = vc[1]
    for (i, (comp_x, comp_y)) in enumerate(vc[2:end])
        slopes[i] = (comp_y - prev_y) / (comp_x - prev_x)
        (prev_x, prev_y) = (comp_x, comp_y)
    end
    return slopes
end

_get_x_lengths(x_coords) = x_coords[2:end] .- x_coords[1:end-1]

"""
Calculates the slopes of the line segments defined by the PiecewiseLinearPointData,
returning one fewer slope than the number of underlying points.
"""
function get_slopes(pwl::PiecewiseLinearPointData)
    return _get_slopes(get_points(pwl))
end

"""
Structure to represent the underlying data of slope piecewise linear data. Principally used
for the representation of cost functions where the points store quantities (x, dy/dx), such
as (MW, \$/MW).

# Arguments
 - `x_coords::Vector{Float64}`: the x-coordinates of the endpoints of the segments
 - `y0::Float64`: the y-coordinate of the data at the first x-coordinate
 - `slopes::Vector{Float64}`: the slopes of the segments: `slopes[1]` is the slope between
   `x_coords[1]` and `x_coords[2]`, etc.
"""
struct PiecewiseLinearSlopeData <: FunctionData
    x_coords::Vector{Float64}
    y0::Float64
    slopes::Vector{Float64}

    function PiecewiseLinearSlopeData(x_coords, y0, slopes)
        _validate_piecewise_x(x_coords)
        (length(slopes) == length(x_coords) - 1) ||
            throw(ArgumentError("Must specify one fewer slope than x-coordinates"))
        return new(x_coords, y0, slopes)
    end
end

"Get the slopes that define the PiecewiseLinearSlopeData"
get_slopes(data::PiecewiseLinearSlopeData) = data.slopes

"Get the x-coordinates of the points that define the piecewise data"
get_x_coords(data::PiecewiseLinearSlopeData) = data.x_coords

"Get the y-coordinate of the data at the first x-coordinate"
get_y0(data::PiecewiseLinearSlopeData) = data.y0

"Calculate the endpoints of the segments in the PiecewiseLinearSlopeData"
function get_points(data::PiecewiseLinearSlopeData)
    slopes = get_slopes(data)
    x_coords = get_x_coords(data)
    points = Vector{Tuple{Float64, Float64}}(undef, length(x_coords))
    running_y = get_y0(data)
    points[1] = (x_coords[1], running_y)
    for (i, (prev_slope, this_x, dx)) in enumerate(zip(slopes, x_coords[2:end], get_x_lengths(data)))
        running_y += prev_slope * dx
        points[i+1] = (this_x, running_y)
    end
    return points
end

"""
Calculates the x-length of each segment of a piecewise curve.
"""
function get_x_lengths(
    pwl::Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData},
)
    return _get_x_lengths(get_x_coords(pwl))
end

Base.length(pwl::Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData}) =
    length(get_x_coords(pwl))-1

Base.getindex(pwl::PiecewiseLinearPointData, ix::Int) =
    getindex(get_points(pwl), ix)

Base.:(==)(a::PiecewiseLinearPointData, b::PiecewiseLinearPointData) =
    get_points(a) == get_points(b)

Base.:(==)(a::PiecewiseLinearSlopeData, b::PiecewiseLinearSlopeData) =
    (get_x_coords(a) == get_x_coords(b)) &&
    (get_y0(a) == get_y0(b)) &&
    (get_slopes(a) == get_slopes(b))

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

PiecewiseLinearPointData(; points) = PiecewiseLinearPointData(points)

PiecewiseLinearSlopeData(; x_coords, y0, slopes) =
    PiecewiseLinearSlopeData(x_coords, y0, slopes)

IS.serialize(val::FunctionData) = IS.serialize_struct(val)

IS.deserialize(x::Type{<:FunctionData}, val::Dict) =
    IS.deserialize_struct(x, val)
