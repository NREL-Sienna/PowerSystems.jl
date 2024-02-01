#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct MultiStartCost <: OperationalCost
        variable::FunctionData
        no_load::Float64
        fixed::Float64
        start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}
        shut_down::Float64
    end

Data Structure Operational Cost Data which includes fixed, variable cost, multiple start up cost and stop costs.

# Arguments
- `variable::FunctionData`: variable cost
- `no_load::Float64`: no load cost
- `fixed::Float64`: fixed cost
- `start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}`: start-up cost
- `shut_down::Float64`: shut-down cost, validation range: `(0, nothing)`, action if invalid: `warn`
"""
mutable struct MultiStartCost <: OperationalCost
    "variable cost"
    variable::FunctionData
    "no load cost"
    no_load::Float64
    "fixed cost"
    fixed::Float64
    "start-up cost"
    start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}
    "shut-down cost"
    shut_down::Float64
end


function MultiStartCost(; variable, no_load, fixed, start_up, shut_down, )
    MultiStartCost(variable, no_load, fixed, start_up, shut_down, )
end

# Constructor for demo purposes; non-functional.
function MultiStartCost(::Nothing)
    MultiStartCost(;
        variable=LinearFunctionData(0.0),
        no_load=0.0,
        fixed=0.0,
        start_up=(hot = START_COST, warm = START_COST, cold = START_COST),
        shut_down=0.0,
    )
end

"""Get [`MultiStartCost`](@ref) `variable`."""
get_variable(value::MultiStartCost) = value.variable
"""Get [`MultiStartCost`](@ref) `no_load`."""
get_no_load(value::MultiStartCost) = value.no_load
"""Get [`MultiStartCost`](@ref) `fixed`."""
get_fixed(value::MultiStartCost) = value.fixed
"""Get [`MultiStartCost`](@ref) `start_up`."""
get_start_up(value::MultiStartCost) = value.start_up
"""Get [`MultiStartCost`](@ref) `shut_down`."""
get_shut_down(value::MultiStartCost) = value.shut_down

"""Set [`MultiStartCost`](@ref) `variable`."""
set_variable!(value::MultiStartCost, val) = value.variable = val
"""Set [`MultiStartCost`](@ref) `no_load`."""
set_no_load!(value::MultiStartCost, val) = value.no_load = val
"""Set [`MultiStartCost`](@ref) `fixed`."""
set_fixed!(value::MultiStartCost, val) = value.fixed = val
"""Set [`MultiStartCost`](@ref) `start_up`."""
set_start_up!(value::MultiStartCost, val) = value.start_up = val
"""Set [`MultiStartCost`](@ref) `shut_down`."""
set_shut_down!(value::MultiStartCost, val) = value.shut_down = val
