"""
    mutable struct MarketBidCost <: OperationalCost
        no_load::Float64
        start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}
        shut_down::Float64
        incremental_offer_curves::Union{Nothing, IS.TimeSeriesKey, PiecewiseLinearData}
        decremental_offer_curves::Union{Nothing, IS.TimeSeriesKey, PiecewiseLinearData}
        ancillary_services::Vector{Service}
    end

Data Structure Operational Cost to reflect market bids of energy and ancilliary services for any asset.
Compatible with most US Market bidding mechanisms that support demand and generation side.

# Arguments
- `no_load::Float64`: no load cost
- `start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}`: start-up cost at different stages of the thermal cycle. Warm is also refered as intermediate in some markets
- `shut_down::Float64`: shut-down cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `incremental_offer_curves::Union{Nothing, IS.TimeSeriesKey, PiecewiseLinearData}`: Sell Offer Curves data, can be a time series or a fixed PiecewiseLinearData
- `decremental_offer_curves::Union{Nothing, IS.TimeSeriesKey, PiecewiseLinearData}`: Buy Offer Curves data, can be a time series or a fixed PiecewiseLinearData
- `ancillary_services::Vector{Service}`: Bids for the ancillary services
"""
mutable struct MarketBidCost <: OperationalCost
    no_load_cost::Float64
    "start-up cost at different stages of the thermal cycle. Warm is also refered as intermediate in some markets"
    start_up::StartUpStages
    "shut-down cost"
    shut_down::Float64
    "Variable Cost TimeSeriesKey"
    incremental_offer_curves::Union{
        Nothing,
        IS.TimeSeriesKey,
        CostCurve{InputOutputCurve{PiecewiseLinearData}},
    }
    "Variable Cost TimeSeriesKey"
    decremental_offer_curves::Union{
        Nothing,
        IS.TimeSeriesKey,
        CostCurve{InputOutputCurve{PiecewiseLinearData}},
    }
    "Bids for the ancillary services"
    ancillary_services::Vector{Service}
end

function MarketBidCost(;
    no_load_cost,
    start_up,
    shut_down,
    incremental_offer_curves = nothing,
    decremental_offer_curves = nothing,
    ancillary_services = Vector{Service}(),
)
    MarketBidCost(
        no_load_cost,
        start_up,
        shut_down,
        incremental_offer_curves,
        decremental_offer_curves,
        ancillary_services,
    )
end

# Constructor for demo purposes; non-functional.
function MarketBidCost(::Nothing)
    MarketBidCost(;
        no_load_cost = 0.0,
        start_up = (hot = START_COST, warm = START_COST, cold = START_COST),
        shut_down = 0.0,
        incremental_offer_curves = nothing,
        decremental_offer_curves = nothing,
        ancillary_services = Vector{Service}(),
    )
end

"""
Accepts a single `start_up` value to use as the `hot` value, with `warm` and `cold` set to
`0.0`.
"""
function MarketBidCost(
    no_load_cost,
    start_up::Real,
    shut_down,
    incremental_offer_curves = nothing,
    decremental_offer_curves = nothing,
    ancillary_services = Vector{Service}(),
)
    # Intended for use with generators that are not multi-start (e.g. ThermalStandard).
    # Operators use `hot` when they don’t have multiple stages.
    start_up_multi = (hot = Float64(start_up), warm = 0.0, cold = 0.0)
    return MarketBidCost(
        no_load_cost,
        start_up_multi,
        shut_down,
        incremental_offer_curves,
        decremental_offer_curves,
        ancillary_services,
    )
end

"""Get [`MarketBidCost`](@ref) `no_load_cost`."""
get_no_load_cost(value::MarketBidCost) = value.no_load_cost
"""Get [`MarketBidCost`](@ref) `start_up`."""
get_start_up(value::MarketBidCost) = value.start_up
"""Get [`MarketBidCost`](@ref) `shut_down`."""
get_shut_down(value::MarketBidCost) = value.shut_down
"""Get [`MarketBidCost`](@ref) `incremental_offer_curves`."""
get_incremental_offer_curves(value::MarketBidCost) = value.incremental_offer_curves
"""Get [`MarketBidCost`](@ref) `incremental_offer_curves`."""
get_decremental_offer_curves(value::MarketBidCost) = value.incremental_offer_curves
"""Get [`MarketBidCost`](@ref) `ancillary_services`."""
get_ancillary_services(value::MarketBidCost) = value.ancillary_services

"""Set [`MarketBidCost`](@ref) `no_load_cost`."""
set_no_load_cost!(value::MarketBidCost, val) = value.no_load = val
"""Set [`MarketBidCost`](@ref) `start_up`."""
set_start_up!(value::MarketBidCost, val) = value.start_up = val
"""Set [`MarketBidCost`](@ref) `shut_down`."""
set_shut_down!(value::MarketBidCost, val) = value.shut_down = val
"""Set [`MarketBidCost`](@ref) `incremental_offer_curves`."""
set_incremental_offer_curves!(value::MarketBidCost, val) =
    value.incremental_offer_curves = val
"""Set [`MarketBidCost`](@ref) `incremental_offer_curves`."""
set_decremental_offer_curves!(value::MarketBidCost, val) =
    value.decremental_offer_curves = val
"""Set [`MarketBidCost`](@ref) `ancillary_services`."""
set_ancillary_services!(value::MarketBidCost, val) = value.ancillary_services = val
