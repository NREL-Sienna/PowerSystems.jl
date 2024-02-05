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
Structure to represent the underlying data of point wise piecewise linear data. Principally used for
the representation of cost functions where the points store quantities (x, y).
"""
struct PiecewiseLinearPointData <: FunctionData
    points::Vector{Tuple{Float64, Float64}}
end

get_points(data::PiecewiseLinearPointData) = data.points

function _get_slopes(vc::Vector{NTuple{2, Float64}})
    slopes = Vector{Float64}(undef, length(vc))
    previous = (0.0, 0.0)
    for (ix, component) in enumerate(vc)
        if ix == 1
            slopes[ix] = component[2] == 0.0 ? 0.0 : component[1] / component[2] # if the cost component starts at the y-origin make the first slope 0.0
            previous = component
            continue
        end
        slopes[ix] = (component[1] - previous[1]) / (component[2] - previous[2])
        previous = component
    end
    return slopes
end

function _get_breakpoint_upperbounds(vc::Vector{NTuple{2, Float64}})
    bp_ubs = Vector{Float64}(undef, length(vc))
    for (ix, component) in enumerate(vc)
        if ix == 1
            bp_ubs[ix] = component[2]
            continue
        end
        bp_ubs[ix] = component[2] - sum(bp_ubs[1:(ix - 1)])
    end
    return bp_ubs
end

"""
Calculates the slopes for the variable cost represented as a piecewise linear cost function.
This function returns n - slopes for n - piecewise linear elements in the function.
The first element of the return array corresponds to the average cost at the minimum operating point.
If your formulation uses n - 1 slopes, you can disregard the first component of the array.
If the first point in the variable cost has a quantity of 0.0, the first slope returned will be 0.0.
Otherwise, the first slope represents the trajectory to get from the origin to the first point in the variable cost.
"""
function get_slopes(pwl::PiecewiseLinearPointData)
    return _get_slopes(get_points(pwl))
end

"""
Structure to represent the underlying data of slope piecewise linear data. Principally used for
the representation of cost functions where the points store quantities (dx/dy, y).
"""
struct PiecewiseLinearSlopeData <: FunctionData
    points::Vector{Tuple{Float64, Float64}}
end

get_points(data::PiecewiseLinearSlopeData) = data.points

"""
Calculates the upper bounds of a variable cost function represented as a collection of piece-wise linear segments.
"""
function get_breakpoint_upperbounds(
    pwl::Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData},
)
    return _get_breakpoint_upperbounds(get_points(pwl))
end

Base.length(pwl::Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData}) =
    length(get_points(pwl))
Base.getindex(pwl::Union{PiecewiseLinearPointData, PiecewiseLinearSlopeData}, ix::Int) =
    getindex(get_points(pwl), ix)

function _slope_convexity_check(slopes::Vector{Float64})
    flag = true
    for ix in 1:(length(slopes) - 1)
        if slopes[ix] > slopes[ix + 1]
            @debug slopes
            return flag = false
        end
    end
    return flag
end

"""
Returns True/False depending on the convexity of the underlying data
"""
function is_convex(pwl::PiecewiseLinearSlopeData)
    return _convexity_check([p[2] for p in pwl])
end

function is_convex(pwl::PiecewiseLinearPointData)
    return _convexity_check(get_slopes(pwl))
end

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
