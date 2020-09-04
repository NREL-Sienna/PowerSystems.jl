#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct TwoPartCost <: OperationalCost
        variable::VariableCost
        fixed::Float64
    end

Data Structure Operational Cost Data in two parts: fixed and variable cost.

# Arguments
- `variable::VariableCost`: variable cost
- `fixed::Float64`: fixed cost, validation range: `(0, nothing)`, action if invalid: `warn`
"""
mutable struct TwoPartCost <: OperationalCost
    "variable cost"
    variable::VariableCost
    "fixed cost"
    fixed::Float64
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

"""Get [`TwoPartCost`](@ref) `variable`."""
get_variable(value::TwoPartCost) = value.variable
"""Get [`TwoPartCost`](@ref) `fixed`."""
get_fixed(value::TwoPartCost) = value.fixed

"""Set [`TwoPartCost`](@ref) `variable`."""
set_variable!(value::TwoPartCost, val) = value.variable = val
"""Set [`TwoPartCost`](@ref) `fixed`."""
set_fixed!(value::TwoPartCost, val) = value.fixed = val
