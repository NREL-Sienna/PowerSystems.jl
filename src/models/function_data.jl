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

"""
Structure to represent the underlying data of pointwise piecewise linear data. Principally
used for the representation of cost functions where the points store quantities (x, y), such
as (MW, \$).
"""
struct PiecewiseLinearPointData <: FunctionData
    segments::Vector{Tuple{Float64, Float64}}
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
    length(get_points(pwl))
Base.getindex(pwl::Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData}, ix::Int) =
    getindex(get_points(pwl), ix)

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

# TODO: Serialize methods need to be implemented
#=
function IS.serialize(val::FunctionData)
    return Dict{String, Any}("cost" => serialize(val.cost))
end

# The default implementation can't figure out the variable Union.

function IS.deserialize(::Type{FunctionData}, data::Dict)
    if data["cost"] isa Real
        return VariableCost(Float64(data["cost"]))
    elseif data["cost"][1] isa Array
        variable = Vector{Tuple{Float64, Float64}}()
        for array in data["cost"]
            push!(variable, Tuple{Float64, Float64}(array))
        end
    else
        @assert data["cost"] isa Tuple || data["cost"] isa Array
        variable = Tuple{Float64, Float64}(data["cost"])
    end

    return VariableCost(variable)
end
=#
