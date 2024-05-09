"""
    mutable struct MarketBidCost <: OperationalCost
        no_load_cost::Float64
        start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}
        shut_down::Float64
        incremental_offer_curves::Union{Nothing, TimeSeriesKey, PiecewiseLinearData}  # TODO update docs given struct
        decremental_offer_curves::Union{Nothing, TimeSeriesKey, PiecewiseLinearData}
        ancillary_service_offers::Vector{Service}
    end

Data Structure Operational Cost to reflect market bids of energy and ancilliary services for any asset.
Compatible with most US Market bidding mechanisms that support demand and generation side.

# Arguments
- `no_load_cost::Float64`: no load cost
- `start_up::NamedTuple{(:hot, :warm, :cold), NTuple{3, Float64}}`: start-up cost at different stages of the thermal cycle. Warm is also refered as intermediate in some markets
- `shut_down::Float64`: shut-down cost, validation range: `(0, nothing)`, action if invalid: `warn`
- `incremental_offer_curves::Union{Nothing, TimeSeriesKey, PiecewiseLinearData}`: Sell Offer Curves data, can be a time series or a fixed PiecewiseLinearData
- `decremental_offer_curves::Union{Nothing, TimeSeriesKey, PiecewiseLinearData}`: Buy Offer Curves data, can be a time series or a fixed PiecewiseLinearData
- `ancillary_service_offers::Vector{Service}`: Bids for the ancillary services
"""
@kwdef mutable struct MarketBidCost <: OperationalCost
    no_load_cost::Float64
    """start-up cost at different stages of the thermal cycle.
    Warm is also referred to as intermediate in some markets"""
    start_up::StartUpStages
    "shut-down cost"
    shut_down::Float64
    "Variable Cost TimeSeriesKey"
    incremental_offer_curves::Union{
        Nothing,
        TimeSeriesKey,
        CostCurve{PiecewiseIncrementalCurve},
    } = nothing
    "Variable Cost TimeSeriesKey"
    decremental_offer_curves::Union{
        Nothing,
        TimeSeriesKey,
        CostCurve{PiecewiseIncrementalCurve},
    } = nothing
    "Bids for the ancillary services"
    ancillary_service_offers::Vector{Service} = Vector{Service}()
end

# Constructor for demo purposes; non-functional.
function MarketBidCost(::Nothing)
    MarketBidCost(;
        no_load_cost = 0.0,
        start_up = (hot = START_COST, warm = START_COST, cold = START_COST),
        shut_down = 0.0,
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
    ancillary_service_offers = Vector{Service}(),
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
        ancillary_service_offers,
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
"""Get [`MarketBidCost`](@ref) `ancillary_service_offers`."""
get_ancillary_service_offers(value::MarketBidCost) = value.ancillary_service_offers

"""Set [`MarketBidCost`](@ref) `no_load_cost`."""
set_no_load_cost!(value::MarketBidCost, val) = value.no_load_cost = val
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
"""Set [`MarketBidCost`](@ref) `ancillary_service_offers`."""
set_ancillary_service_offers!(value::MarketBidCost, val) =
    value.ancillary_service_offers = val

# Each market bid curve (the elements that make up the incremental and decremental offer
# curves in MarketBidCost) is a CostCurve{PiecewiseIncrementalCurve} with NaN initial input
# and first x-coordinate
function is_market_bid_curve(curve::ProductionVariableCost)
    (curve isa CostCurve{PiecewiseIncrementalCurve}) || return false
    value_curve = get_value_curve(curve)
    return isnan(get_initial_input(value_curve)) &&
           isnan(first(get_x_coords(get_function_data(value_curve))))
end

"""
Make a CostCurve{PiecewiseIncrementalCurve} suitable for inclusion in a MarketBidCost from a
vector of power values, a vector of marginal costs, and an optional units system. The
minimum power, and cost at minimum power, are not represented.
"""
function make_market_bid_curve(powers::Vector{Float64},
    marginal_costs::Vector{Float64};
    power_units::UnitSystem = UnitSystem.NATURAL_UNITS)
    (length(powers) != length(marginal_costs)) &&
        throw(ArgumentError("Must specify an equal number of powers and marginal_costs"))
    fd = PiecewiseStepData(vcat(NaN, powers), marginal_costs)
    return make_market_bid_curve(fd; power_units = power_units)
end

"""
Make a CostCurve{PiecewiseIncrementalCurve} suitable for inclusion in a MarketBidCost from
the FunctionData that might be used to store such a cost curve in a time series.
"""
function make_market_bid_curve(data::PiecewiseStepData;
    power_units::UnitSystem = UnitSystem.NATURAL_UNITS)
    !isnan(first(get_x_coords(data))) && throw(
        ArgumentError(
            "The first x-coordinate in the PiecewiseStepData representation must be NaN",
        ),
    )
    cc = CostCurve(IncrementalCurve(data, NaN), power_units)
    @assert is_market_bid_curve(cc)
    return cc
end
