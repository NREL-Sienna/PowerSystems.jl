const STORAGE_OPERATION_MODES = NamedTuple{(:charge, :discharge), NTuple{2, Float64}}

"""
$(TYPEDEF)
$(TYPEDFIELDS)

    StorageCost(charge_variable_cost, discharge_variable_cost, fixed, start_up, shut_down, energy_shortage_cost, energy_surplus_cost)
    StorageCost(; charge_variable_cost, discharge_variable_cost, fixed, start_up, shut_down, energy_shortage_cost, energy_surplus_cost)

An operational cost for storage units including fixed costs and variable costs to charge
or discharge.

This data structure is not intended to represent market storage systems market operations
like the submission of buy/sell bids -- see [`MarketBidCost`](@ref) instead.
"""
@kwdef mutable struct StorageCost <: OperationalCost
    "(default of 0) Variable cost of charging represented as a [`CostCurve`](@ref)"
    charge_variable_cost::CostCurve = zero(CostCurve)
    "(default of 0) Variable cost of discharging represented as a [`CostCurve`](@ref)"
    discharge_variable_cost::CostCurve = zero(CostCurve)
    "(default: 0) Fixed cost of operating the storage system"
    fixed::Float64 = 0.0
    "(default: 0) Start-up cost"
    start_up::Union{STORAGE_OPERATION_MODES, Float64} = 0.0
    "(default: 0) Shut-down cost"
    shut_down::Float64 = 0.0
    "(default: 0) Cost incurred by the model for being short of the energy target"
    energy_shortage_cost::Float64 = 0.0
    "(default: 0) Cost incurred by the model for surplus energy stored"
    energy_surplus_cost::Float64 = 0.0
end

StorageCost(
    charge_variable_cost::CostCurve,
    discharge_variable_cost::CostCurve,
    fixed::Float64,
    start_up::Real,
    shut_down::Float64,
    energy_shortage_cost::Float64,
    energy_surplus_cost::Float64,
) =
    StorageCost(
        charge_variable_cost,
        discharge_variable_cost,
        fixed,
        Float64(start_up),
        shut_down,
        energy_shortage_cost,
        energy_surplus_cost,
    )

# Constructor for demo purposes; non-functional.
function StorageCost(::Nothing)
    StorageCost()
end

"""Get [`StorageCost`](@ref) `charge_variable_cost`."""
get_charge_variable_cost(value::StorageCost) = value.charge_variable_cost
"""Get [`StorageCost`](@ref) `discharge_variable_cost`."""
get_discharge_variable_cost(value::StorageCost) = value.discharge_variable_cost
"""Get [`StorageCost`](@ref) `fixed`."""
get_fixed(value::StorageCost) = value.fixed
"""Get [`StorageCost`](@ref) `start_up`."""
get_start_up(value::StorageCost) = value.start_up
"""Get [`StorageCost`](@ref) `shut_down`."""
get_shut_down(value::StorageCost) = value.shut_down
"""Get [`StorageCost`](@ref) `energy_shortage_cost`."""
get_energy_shortage_cost(value::StorageCost) = value.energy_shortage_cost
"""Get [`StorageCost`](@ref) `energy_surplus_cost`."""
get_energy_surplus_cost(value::StorageCost) = value.energy_surplus_cost

"""Set [`StorageCost`](@ref) `charge_variable_cost`."""
set_charge_variable_cost!(value::StorageCost, val) = value.charge_variable_cost = val
"""Set [`StorageCost`](@ref) `discharge_variable_cost`."""
set_discharge_variable_cost!(value::StorageCost, val) = value.discharge_variable_cost = val
"""Set [`StorageCost`](@ref) `fixed`."""
set_fixed!(value::StorageCost, val) = value.fixed = val
"""Set [`StorageCost`](@ref) `start_up`."""
set_start_up!(value::StorageCost, val) = value.start_up = val
"""Set [`StorageCost`](@ref) `shut_down`."""
set_shut_down!(value::StorageCost, val) = value.shut_down = val
"""Set [`StorageCost`](@ref) `energy_shortage_cost`."""
set_energy_shortage_cost!(value::StorageCost, val) =
    value.energy_shortage_cost = val
"""Set [`StorageCost`](@ref) `energy_surplus_cost`."""
set_energy_surplus_cost!(value::StorageCost, val) =
    value.energy_surplus_cost = val
