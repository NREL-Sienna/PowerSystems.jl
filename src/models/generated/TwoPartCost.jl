#=
This file is auto-generated. Do not edit.
=#

"""Data Structure Operational Cost Data in two parts fixed and variable cost."""
mutable struct TwoPartCost <: OperationalCost
    variable::VariableCost
    fixed_cost::Float64
    internal::PowerSystems.PowerSystemInternal
end

function TwoPartCost(variable, fixed_cost, )
    TwoPartCost(variable, fixed_cost, PowerSystemInternal())
end

function TwoPartCost(; variable, fixed_cost, )
    TwoPartCost(variable, fixed_cost, )
end

# Constructor for demo purposes; non-functional.

function TwoPartCost(::Nothing)
    TwoPartCost(;
        variable=VariableCost((0.0, 0.0)),
        fixed_cost=0.0,
    )
end

"""Get TwoPartCost variable."""
get_variable(value::TwoPartCost) = value.variable
"""Get TwoPartCost fixed_cost."""
get_fixed_cost(value::TwoPartCost) = value.fixed_cost
"""Get TwoPartCost internal."""
get_internal(value::TwoPartCost) = value.internal
