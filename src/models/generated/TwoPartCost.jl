#=
This file is auto-generated. Do not edit.
=#

"""Data Structure Operational Cost Data in two parts fixed and variable cost."""
mutable struct TwoPartCost <: OperationalCost
    variable_cost::Union{Tuple{Float64, Float64}, Array{Tuple{Float64, Float64}, N} where N}
    fixed_cost::Float64
    internal::PowerSystems.PowerSystemInternal
end

function TwoPartCost(variable_cost, fixed_cost, )
    TwoPartCost(variable_cost, fixed_cost, PowerSystemInternal())
end

function TwoPartCost(; variable_cost, fixed_cost, )
    TwoPartCost(variable_cost, fixed_cost, )
end

# Constructor for demo purposes; non-functional.

function TwoPartCost(::Nothing)
    TwoPartCost(;
        variable_cost=[(0.0, 1.0)],
        fixed_cost=0.0,
    )
end

"""Get TwoPartCost variable_cost."""
get_variable_cost(value::TwoPartCost) = value.variable_cost
"""Get TwoPartCost fixed_cost."""
get_fixed_cost(value::TwoPartCost) = value.fixed_cost
"""Get TwoPartCost internal."""
get_internal(value::TwoPartCost) = value.internal
