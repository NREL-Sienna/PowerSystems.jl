const STORAGE_OPERATION_MODES = NamedTuple{(:charge, :discharge), NTuple{2, Float64}}

"""
    mutable struct StorageCost <: OperationalCost
        charge_variable_cost::CostCurve
        discharge_variable_cost::CostCurve
        fixed::Float64
        start_up::Union{STORAGE_OPERATION_MODES, Float64}
        shut_down::Float64
        energy_shortage_cost::Float64
        energy_surplus_cost::Float64
    end

Data Structure for Operational Cost Data like variable cost and start - stop costs and energy storage cost.
This data structure is not intended to represent market storage systems market operations like the submission of
buy/sell bids.

# Arguments
- `charge_variable_cost::CostCurve`: variable cost represented as a CostCurve
- `discharge_variable_cost::CostCurve`: variable cost represented as a CostCurve
- `fixed::Float64`: fixed cost of operating the storage system
- `start_up::Union{STORAGE_OPERATION_MODES, Float64}`: start-up cost, validation range:, action if invalid
- `shut_down::Float64`: shut-down cost, validation range: action if invalid
- `energy_shortage_cost::Float64`: Cost incurred by the model for being short of the energy target.
- `energy_surplus_cost::Float64`: Cost incurred by the model for surplus energy stored.
"""
mutable struct StorageCost <: OperationalCost
    "charge variable cost"
    charge_variable_cost::CostCurve
    "discharge variable cost"
    discharge_variable_cost::CostCurve
    "fixed cost"
    fixed::Float64
    "start-up cost"
    start_up::Union{STORAGE_OPERATION_MODES, Float64}
    "shut-down cost"
    shut_down::Float64
    "Cost incurred by the model for being short of the energy target."
    energy_shortage_cost::Float64
    "Cost incurred by the model for surplus energy stored."
    energy_surplus_cost::Float64
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

function StorageCost(;
    charge_variable_cost = zero(CostCurve),
    discharge_variable_cost = zero(CostCurve),
    fixed = 0.0,
    start_up = 0.0,
    shut_down = 0.0,
    energy_shortage_cost = 0.0,
    energy_surplus_cost = 0.0,
)
    StorageCost(
        charge_variable_cost,
        discharge_variable_cost,
        fixed,
        start_up,
        shut_down,
        energy_shortage_cost,
        energy_surplus_cost,
    )
end

# Constructor for demo purposes; non-functional.
function StorageCost(::Nothing)
    StorageCost()
end

"""Get [`StorageCost`](@ref) `variable`."""
get_variable(value::StorageCost) = value.variable
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

"""Set [`StorageCost`](@ref) `variable`."""
set_variable!(value::StorageCost, val) = value.variable = val
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
