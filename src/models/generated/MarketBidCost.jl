#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct MarketBidCost <: OperationalCost
        energy_bid::VariableCost
        no_load_cost::Float64
        start_up::NamedTuple{(:hot, :int, :cold), NTuple{3, Float64}}
        shut_down::Float64
        ancillary_services::Dict{String, Float64}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data Structure Operational Cost to reflect market bids of energy and ancilliary services.
Compatible with most US Market bidding mechanisms

# Arguments
- `energy_bid::VariableCost`: variable cost
- `no_load_cost::Float64`: no load cost
- `start_up::NamedTuple{(:hot, :int, :cold), NTuple{3, Float64}}`: start-up cost
- `shut_down::Float64`: shut-down cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `ancillary_services::Dict{String, Float64}`: Bids for the ancillary services
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct MarketBidCost <: OperationalCost
    "variable cost"
    energy_bid::VariableCost
    "no load cost"
    no_load_cost::Float64
    "start-up cost"
    start_up::NamedTuple{(:hot, :int, :cold), NTuple{3, Float64}}
    "shut-down cost"
    shut_down::Float64
    "Bids for the ancillary services"
    ancillary_services::Dict{String, Float64}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function MarketBidCost(energy_bid, no_load_cost, start_up, shut_down, ancillary_services=Dict{String, Float}(), forecasts=InfrastructureSystems.Forecasts(), )
    MarketBidCost(energy_bid, no_load_cost, start_up, shut_down, ancillary_services, forecasts, InfrastructureSystemsInternal(), )
end

function MarketBidCost(; energy_bid, no_load_cost, start_up, shut_down, ancillary_services=Dict{String, Float}(), forecasts=InfrastructureSystems.Forecasts(), )
    MarketBidCost(energy_bid, no_load_cost, start_up, shut_down, ancillary_services, forecasts, )
end

# Constructor for demo purposes; non-functional.
function MarketBidCost(::Nothing)
    MarketBidCost(;
        energy_bid=VariableCost((0.0, 0.0)),
        no_load_cost=0.0,
        start_up=(hot = START_COST, int = START_COST, cold = START_COST),
        shut_down=0.0,
        ancillary_services=Dict{String, Float}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get [`MarketBidCost`](@ref) `energy_bid`."""
get_energy_bid(value::MarketBidCost) = value.energy_bid
"""Get [`MarketBidCost`](@ref) `no_load_cost`."""
get_no_load_cost(value::MarketBidCost) = value.no_load_cost
"""Get [`MarketBidCost`](@ref) `start_up`."""
get_start_up(value::MarketBidCost) = value.start_up
"""Get [`MarketBidCost`](@ref) `shut_down`."""
get_shut_down(value::MarketBidCost) = value.shut_down
"""Get [`MarketBidCost`](@ref) `ancillary_services`."""
get_ancillary_services(value::MarketBidCost) = value.ancillary_services

InfrastructureSystems.get_forecasts(value::MarketBidCost) = value.forecasts
"""Get [`MarketBidCost`](@ref) `internal`."""
get_internal(value::MarketBidCost) = value.internal

"""Set [`MarketBidCost`](@ref) `energy_bid`."""
set_energy_bid!(value::MarketBidCost, val) = value.energy_bid = val
"""Set [`MarketBidCost`](@ref) `no_load_cost`."""
set_no_load_cost!(value::MarketBidCost, val) = value.no_load_cost = val
"""Set [`MarketBidCost`](@ref) `start_up`."""
set_start_up!(value::MarketBidCost, val) = value.start_up = val
"""Set [`MarketBidCost`](@ref) `shut_down`."""
set_shut_down!(value::MarketBidCost, val) = value.shut_down = val
"""Set [`MarketBidCost`](@ref) `ancillary_services`."""
set_ancillary_services!(value::MarketBidCost, val) = value.ancillary_services = val

InfrastructureSystems.set_forecasts!(value::MarketBidCost, val) = value.forecasts = val
"""Set [`MarketBidCost`](@ref) `internal`."""
set_internal!(value::MarketBidCost, val) = value.internal = val
