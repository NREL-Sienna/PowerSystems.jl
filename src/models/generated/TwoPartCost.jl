#=
This file is auto-generated. Do not edit.
=#

"""Data Structure Operational Cost Data in two parts fixed and variable cost."""
mutable struct TwoPartCost <: OperationalCost
    variable::VariableCost
    fixed::Float64
    internal::PowerSystems.PowerSystemInternal
end

function TwoPartCost(variable, fixed, )
    TwoPartCost(variable, fixed, PowerSystemInternal())
end

function TwoPartCost(; variable, fixed, )
    TwoPartCost(variable, fixed, )
end

# Constructor for demo purposes; non-functional.

function TwoPartCost(::Nothing)
    TwoPartCost(;
        variable=VariableCost((0.0, 0.0)),
        fixed=0.0,
    )
end

"""Get TwoPartCost variable."""
get_variable(value::TwoPartCost) = value.variable
"""Get TwoPartCost fixed."""
get_fixed(value::TwoPartCost) = value.fixed
"""Get TwoPartCost internal."""
get_internal(value::TwoPartCost) = value.internal
