#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct ThreePartCost <: OperationalCost
        variable::FunctionData
        fixed::Float64
        start_up::Float64
        shut_down::Float64
    end

Data Structure Operational Cost Data in Three parts fixed, variable cost and start - stop costs.

# Arguments
- `variable::FunctionData`: variable cost
- `fixed::Float64`: fixed cost
- `start_up::Float64`: start-up cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `shut_down::Float64`: shut-down cost, validation range: `(0, nothing)`, action if invalid: `warn`
"""
mutable struct ThreePartCost <: OperationalCost
    "variable cost"
    variable::FunctionData
    "fixed cost"
    fixed::Float64
    "start-up cost"
    start_up::Float64
    "shut-down cost"
    shut_down::Float64
end


function ThreePartCost(; variable, fixed, start_up, shut_down, )
    ThreePartCost(variable, fixed, start_up, shut_down, )
end

# Constructor for demo purposes; non-functional.
function ThreePartCost(::Nothing)
    ThreePartCost(;
        variable=LinearFunctionData(0.0),
        fixed=0.0,
        start_up=0.0,
        shut_down=0.0,
    )
end

"""Get [`ThreePartCost`](@ref) `variable`."""
get_variable(value::ThreePartCost) = value.variable
"""Get [`ThreePartCost`](@ref) `fixed`."""
get_fixed(value::ThreePartCost) = value.fixed
"""Get [`ThreePartCost`](@ref) `start_up`."""
get_start_up(value::ThreePartCost) = value.start_up
"""Get [`ThreePartCost`](@ref) `shut_down`."""
get_shut_down(value::ThreePartCost) = value.shut_down

"""Set [`ThreePartCost`](@ref) `variable`."""
set_variable!(value::ThreePartCost, val) = value.variable = val
"""Set [`ThreePartCost`](@ref) `fixed`."""
set_fixed!(value::ThreePartCost, val) = value.fixed = val
"""Set [`ThreePartCost`](@ref) `start_up`."""
set_start_up!(value::ThreePartCost, val) = value.start_up = val
"""Set [`ThreePartCost`](@ref) `shut_down`."""
set_shut_down!(value::ThreePartCost, val) = value.shut_down = val
