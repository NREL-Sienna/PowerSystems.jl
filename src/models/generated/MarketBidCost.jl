#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct MarketBidCost <: OperationalCost
        variable::VariableCost
        no_load::Float64
        start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}
        shut_down::Float64
        ancillary_services::IdDict{Any,Float64}
    end

Data Structure Operational Cost to reflect market bids of energy and ancilliary services.
Compatible with most US Market bidding mechanisms

# Arguments
- `variable::VariableCost`: variable cost representing the energy bid
- `no_load::Float64`: no load cost
- `start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}`: start-up cost at different stages of the thermal cycle. Warm is also refered as intermediate in some markets
- `shut_down::Float64`: shut-down cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `ancillary_services::IdDict{Any,Float64}`: Bids for the ancillary services
"""
mutable struct MarketBidCost <: OperationalCost
    "variable cost representing the energy bid"
    variable::VariableCost
    "no load cost"
    no_load::Float64
    "start-up cost at different stages of the thermal cycle. Warm is also refered as intermediate in some markets"
    start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}
    "shut-down cost"
    shut_down::Float64
    "Bids for the ancillary services"
    ancillary_services::IdDict{Any,Float64}
end


function MarketBidCost(; variable, no_load, start_up, shut_down, ancillary_services=IdDict{Any,Float64}(), )
    MarketBidCost(variable, no_load, start_up, shut_down, ancillary_services, )
end

# Constructor for demo purposes; non-functional.
function MarketBidCost(::Nothing)
    MarketBidCost(;
        variable=VariableCost((0.0, 0.0)),
        no_load=0.0,
        start_up=(hot = START_COST, warm = START_COST, cold = START_COST),
        shut_down=0.0,
        ancillary_services=IdDict{Any,Float64}(),
    )
end

"""Get [`MarketBidCost`](@ref) `variable`."""
get_variable(value::MarketBidCost) = value.variable
"""Get [`MarketBidCost`](@ref) `no_load`."""
get_no_load(value::MarketBidCost) = value.no_load
"""Get [`MarketBidCost`](@ref) `start_up`."""
get_start_up(value::MarketBidCost) = value.start_up
"""Get [`MarketBidCost`](@ref) `shut_down`."""
get_shut_down(value::MarketBidCost) = value.shut_down
"""Get [`MarketBidCost`](@ref) `ancillary_services`."""
get_ancillary_services(value::MarketBidCost) = value.ancillary_services

"""Set [`MarketBidCost`](@ref) `variable`."""
set_variable!(value::MarketBidCost, val) = value.variable = val
"""Set [`MarketBidCost`](@ref) `no_load`."""
set_no_load!(value::MarketBidCost, val) = value.no_load = val
"""Set [`MarketBidCost`](@ref) `start_up`."""
set_start_up!(value::MarketBidCost, val) = value.start_up = val
"""Set [`MarketBidCost`](@ref) `shut_down`."""
set_shut_down!(value::MarketBidCost, val) = value.shut_down = val
"""Set [`MarketBidCost`](@ref) `ancillary_services`."""
set_ancillary_services!(value::MarketBidCost, val) = value.ancillary_services = val

