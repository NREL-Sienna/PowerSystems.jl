const VarCostArgs = Union{Float64, NTuple{2, Float64}, Vector{NTuple{2, Float64}}}

abstract type OperationalCost <: DeviceParameter end

mutable struct VariableCost{T}
    cost::T
end

get_cost(vc::VariableCost) = vc.cost
Base.length(vc::VariableCost) = length(vc.cost)
Base.getindex(vc::VariableCost, ix::Int64) = getindex(vc.cost, ix)

function get_breakpoint_upperbounds(vc::VariableCost{T}) where {T}
    throw(ArgumentError("Method not supported for VariableCost using $(T)"))
end

function get_slopes(vc::VariableCost{T}) where {T}
    throw(ArgumentError("Method not supported for VariableCost using $(T)"))
end

"""
Calculates the upper bounds of a variable cost function represented as a collection of piece-wise linear segments.

"""
function get_breakpoint_upperbounds(vc::VariableCost{Vector{NTuple{2, Float64}}})
    return get_breakpoint_upperbounds(get_cost(vc))
end

function get_breakpoint_upperbounds(vc::Vector{NTuple{2, Float64}})
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
Calculates the slopes for the variable cost represented as a piece wise linear cost function. This function returns n - slopes for n - piecewise linear elements in the function. The first element of the return array corresponds to the average cost at the minimum operating point. If your formulation uses n -1 slopes, you can disregard the first component of the array. If the first point in the variable cost has a quantity of 0.0, the first slope returned will be 0.0, otherwise, the first slope represents the trajectory to get from the origin to the first point in the variable cost.

"""
function get_slopes(vc::VariableCost{Vector{NTuple{2, Float64}}})
    return get_slopes(get_cost(vc))
end

function get_slopes(vc::Vector{NTuple{2, Float64}})
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
