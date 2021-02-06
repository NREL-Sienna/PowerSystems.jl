#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct EnergyTargetCost <: OperationalCost
        variable::VariableCost
        fixed::Float64
        start_up::Float64
        shut_down::Float64
        energy_shortage_cost::Float64
        energy_surplus_cost::Float64
    end

Data Structure Operational Cost Data in Three parts fixed, variable cost and start - stop costs.

# Arguments
- `variable::VariableCost`: variable cost
- `fixed::Float64`: fixed cost
- `start_up::Float64`: start-up cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `shut_down::Float64`: shut-down cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `energy_shortage_cost::Float64`: Cost incurred by the model for being short of the energy target., validation range: `(0, nothing)`, action if invalid: `warn`
- `energy_surplus_cost::Float64`: Cost incurred by the model for surplus energy stored., validation range: `(0, nothing)`, action if invalid: `warn`
"""
mutable struct EnergyTargetCost <: OperationalCost
    "variable cost"
    variable::VariableCost
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


function EnergyTargetCost(; variable, fixed, start_up, shut_down, energy_shortage_cost, energy_surplus_cost, )
    EnergyTargetCost(variable, fixed, start_up, shut_down, energy_shortage_cost, energy_surplus_cost, )
end

# Constructor for demo purposes; non-functional.
function EnergyTargetCost(::Nothing)
    EnergyTargetCost(;
        variable=VariableCost((0.0, 0.0)),
        fixed=0.0,
        start_up=0.0,
        shut_down=0.0,
        energy_shortage_cost=0.0,
        energy_surplus_cost=0.0,
    )
end

"""Get [`EnergyTargetCost`](@ref) `variable`."""
get_variable(value::EnergyTargetCost) = value.variable
"""Get [`EnergyTargetCost`](@ref) `fixed`."""
get_fixed(value::EnergyTargetCost) = value.fixed
"""Get [`EnergyTargetCost`](@ref) `start_up`."""
get_start_up(value::EnergyTargetCost) = value.start_up
"""Get [`EnergyTargetCost`](@ref) `shut_down`."""
get_shut_down(value::EnergyTargetCost) = value.shut_down
"""Get [`EnergyTargetCost`](@ref) `energy_shortage_cost`."""
get_energy_shortage_cost(value::EnergyTargetCost) = value.energy_shortage_cost
"""Get [`EnergyTargetCost`](@ref) `energy_surplus_cost`."""
get_energy_surplus_cost(value::EnergyTargetCost) = value.energy_surplus_cost

"""Set [`EnergyTargetCost`](@ref) `variable`."""
set_variable!(value::EnergyTargetCost, val) = value.variable = val
"""Set [`EnergyTargetCost`](@ref) `fixed`."""
set_fixed!(value::EnergyTargetCost, val) = value.fixed = val
"""Set [`EnergyTargetCost`](@ref) `start_up`."""
set_start_up!(value::EnergyTargetCost, val) = value.start_up = val
"""Set [`EnergyTargetCost`](@ref) `shut_down`."""
set_shut_down!(value::EnergyTargetCost, val) = value.shut_down = val
"""Set [`EnergyTargetCost`](@ref) `energy_shortage_cost`."""
set_energy_shortage_cost!(value::EnergyTargetCost, val) = value.energy_shortage_cost = val
"""Set [`EnergyTargetCost`](@ref) `energy_surplus_cost`."""
set_energy_surplus_cost!(value::EnergyTargetCost, val) = value.energy_surplus_cost = val

