#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct StorageManagementCost <: OperationalCost
        variable::FunctionData
        fixed::Float64
        start_up::Float64
        shut_down::Float64
        energy_shortage_cost::Float64
        energy_surplus_cost::Float64
    end

Data Structure for Operational Cost Data like variable cost and start - stop costs and energy storage cost.

# Arguments
- `variable::FunctionData`: variable cost
- `fixed::Float64`: fixed cost
- `start_up::Float64`: start-up cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `shut_down::Float64`: shut-down cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `energy_shortage_cost::Float64`: Cost incurred by the model for being short of the energy target., validation range: `(0, nothing)`, action if invalid: `warn`
- `energy_surplus_cost::Float64`: Cost incurred by the model for surplus energy stored., validation range: `(0, nothing)`, action if invalid: `warn`
"""
mutable struct StorageManagementCost <: OperationalCost
    "variable cost"
    variable::FunctionData
    "fixed cost"
    fixed::Float64
    "start-up cost"
    start_up::Float64
    "shut-down cost"
    shut_down::Float64
    "Cost incurred by the model for being short of the energy target."
    energy_shortage_cost::Float64
    "Cost incurred by the model for surplus energy stored."
    energy_surplus_cost::Float64
end


function StorageManagementCost(; variable=LinearFunctionData(0.0), fixed=0.0, start_up=0.0, shut_down=0.0, energy_shortage_cost=0.0, energy_surplus_cost=0.0, )
    StorageManagementCost(variable, fixed, start_up, shut_down, energy_shortage_cost, energy_surplus_cost, )
end

# Constructor for demo purposes; non-functional.
function StorageManagementCost(::Nothing)
    StorageManagementCost(;
        variable=LinearFunctionData(0.0),
        fixed=0.0,
        start_up=0.0,
        shut_down=0.0,
        energy_shortage_cost=0.0,
        energy_surplus_cost=0.0,
    )
end

"""Get [`StorageManagementCost`](@ref) `variable`."""
get_variable(value::StorageManagementCost) = value.variable
"""Get [`StorageManagementCost`](@ref) `fixed`."""
get_fixed(value::StorageManagementCost) = value.fixed
"""Get [`StorageManagementCost`](@ref) `start_up`."""
get_start_up(value::StorageManagementCost) = value.start_up
"""Get [`StorageManagementCost`](@ref) `shut_down`."""
get_shut_down(value::StorageManagementCost) = value.shut_down
"""Get [`StorageManagementCost`](@ref) `energy_shortage_cost`."""
get_energy_shortage_cost(value::StorageManagementCost) = value.energy_shortage_cost
"""Get [`StorageManagementCost`](@ref) `energy_surplus_cost`."""
get_energy_surplus_cost(value::StorageManagementCost) = value.energy_surplus_cost

"""Set [`StorageManagementCost`](@ref) `variable`."""
set_variable!(value::StorageManagementCost, val) = value.variable = val
"""Set [`StorageManagementCost`](@ref) `fixed`."""
set_fixed!(value::StorageManagementCost, val) = value.fixed = val
"""Set [`StorageManagementCost`](@ref) `start_up`."""
set_start_up!(value::StorageManagementCost, val) = value.start_up = val
"""Set [`StorageManagementCost`](@ref) `shut_down`."""
set_shut_down!(value::StorageManagementCost, val) = value.shut_down = val
"""Set [`StorageManagementCost`](@ref) `energy_shortage_cost`."""
set_energy_shortage_cost!(value::StorageManagementCost, val) = value.energy_shortage_cost = val
"""Set [`StorageManagementCost`](@ref) `energy_surplus_cost`."""
set_energy_surplus_cost!(value::StorageManagementCost, val) = value.energy_surplus_cost = val
