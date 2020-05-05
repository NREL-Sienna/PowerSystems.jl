const VarCostArgs = Union{Float64, NTuple{2, Float64}, Vector{NTuple{2, Float64}}}

abstract type OperationalCost <: DeviceParameter end

mutable struct VariableCost{T}
    cost::T
end

get_cost(vc::PowerSystems.VariableCost) = vc.cost
Base.length(vc::PowerSystems.VariableCost) = length(vc.cost)
Base.getindex(vc::PowerSystems.VariableCost, ix::Int64) = getindex(vc.cost, ix)

function break_point_upperbounds(vc::PowerSystems.VariableCost{Vector{NTuple{2, Float64}}})
    bp_ubs = Vector{Float64}(undef, length(vc))
    for (ix, component) in enumerate(PowerSystems.get_cost(vc))
        if ix == 1
            bp_ubs[ix] = component[2]
            continue
        end
        bp_ubs[ix] = component[2] - sum(bp_ubs)
    end
    return bp_ubs
end

function slopes(vc::PowerSystems.VariableCost{Vector{NTuple{2, Float64}}})
    slopes = Vector{Float64}(undef, length(vc))
    previous = (0.0, 0.0)
    for (ix, component) in enumerate(PowerSystems.get_cost(vc))
        if ix == 1
            slopes[ix] = component[1] / component[2]
            previous = component
            continue
        end
        slopes[ix] = (component[1] - previous[1]) / (component[2] - previous[2])
        previous = component
        slopes[ix] < slopes[ix - 1] && @debug("Non-convex cost function")
    end
    return slopes
end
