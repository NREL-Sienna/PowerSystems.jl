"""
$(TYPEDEF)
$(TYPEDFIELDS)

    ImportExportCost(import_offer_curves, export_offer_curves, ancillary_service_offers)
    ImportExportCost(; import_offer_curves, export_offer_curves, ancillary_service_offers)
    ImportExportCost(import_offer_curves, export_offer_curves, ancillary_service_offers)

An operating cost for imports/exports and ancilliary services from neighbooring areas. The data model
    employs a CostCurve{PiecewiseIncrementalCurve} with an implied zero cost at zero power.
"""
mutable struct ImportExportCost <: OperationalCost
    "Buy Price Curves data to import power, which can be a time series of `PiecewiseStepData` or a
    [`CostCurve`](@ref) of [`PiecewiseIncrementalCurve`](@ref)"
    import_offer_curves::Union{
        Nothing,
        TimeSeriesKey,  # piecewise step data
        CostCurve{PiecewiseIncrementalCurve},
    }
    "Sell Price Curves data to export power, which can be a time series of `PiecewiseStepData` or a
    [`CostCurve`](@ref) of [`PiecewiseIncrementalCurve`](@ref)"
    export_offer_curves::Union{
        Nothing,
        TimeSeriesKey,
        CostCurve{PiecewiseIncrementalCurve},
    }
    "Bids to buy or sell ancillary services in the interconnection"
    ancillary_service_offers::Vector{Service}
end

"Auxiliary constructor for shut_down::Integer"
ImportExportCost(
    import_offer_curves,
    export_offer_curves,
    ancillary_service_offers,
) = ImportExportCost(
    import_offer_curves,
    export_offer_curves,
    ancillary_service_offers,
)

"Auxiliary constructor for no_load_cost::Integer"
ImportExportCost(
    import_offer_curves,
    export_offer_curves,
    ancillary_service_offers,
) =
    ImportExportCost(
        import_offer_curves,
        export_offer_curves,
        ancillary_service_offers,
    )

"""Auxiliary Constructor for TestData"""
ImportExportCost(
    import_offer_curves,
    export_offer_curves,
    ancillary_service_offers,
) =
    ImportExportCost(
        import_offer_curves,
        export_offer_curves,
        ancillary_service_offers,
    )

# Constructor for demo purposes; non-functional.
function ImportExportCost(::Nothing)
    ImportExportCost()
end

ImportExportCost(;
    import_offer_curves = nothing,
    export_offer_curves = nothing,
    ancillary_service_offers = Vector{Service}(),
) = ImportExportCost(
    import_offer_curves,
    export_offer_curves,
    ancillary_service_offers,
)

"""
Accepts a single `start_up` value to use as the `hot` value, with `warm` and `cold` set to
`0.0`.
"""
function ImportExportCost(
    no_load_cost,
    start_up::Real,
    shut_down;
    incremental_offer_curves = nothing,
    decremental_offer_curves = nothing,
    incremental_initial_input = nothing,
    decremental_initial_input = nothing,
    ancillary_service_offers = Vector{Service}(),
)
    # Intended for use with generators that are not multi-start (e.g. ThermalStandard).
    # Operators use `hot` when they don’t have multiple stages.
    start_up_multi = single_start_up_to_stages(start_up)
    return ImportExportCost(;
        no_load_cost = no_load_cost,
        start_up = start_up_multi,
        shut_down = shut_down,
        incremental_offer_curves = incremental_offer_curves,
        decremental_offer_curves = decremental_offer_curves,
        incremental_initial_input = incremental_initial_input,
        decremental_initial_input = decremental_initial_input,
        ancillary_service_offers = ancillary_service_offers,
    )
end

"""Get [`ImportExportCost`](@ref) `incremental_offer_curves`."""
get_incremental_offer_curves(value::ImportExportCost) = value.incremental_offer_curves
"""Get [`ImportExportCost`](@ref) `decremental_offer_curves`."""
get_decremental_offer_curves(value::ImportExportCost) = value.decremental_offer_curves
"""Get [`ImportExportCost`](@ref) `ancillary_service_offers`."""
get_ancillary_service_offers(value::ImportExportCost) = value.ancillary_service_offers

"""Set [`ImportExportCost`](@ref) `incremental_offer_curves`."""
set_incremental_offer_curves!(value::ImportExportCost, val) =
    value.incremental_offer_curves = val
"""Set [`ImportExportCost`](@ref) `incremental_offer_curves`."""
set_decremental_offer_curves!(value::ImportExportCost, val) =
    value.decremental_offer_curves = val
"""Set [`ImportExportCost`](@ref) `ancillary_service_offers`."""
set_ancillary_service_offers!(value::ImportExportCost, val) =
    value.ancillary_service_offers = val

# Each market bid curve (the elements that make up the incremental and decremental offer
# curves in ImportExportCost) is a CostCurve{PiecewiseIncrementalCurve} with NaN initial input
# and first x-coordinate
function is_import_export_curve(curve::ProductionVariableCostCurve)
    return (curve isa CostCurve{PiecewiseIncrementalCurve})
end

"""
Make a CostCurve{PiecewiseIncrementalCurve} suitable for inclusion in a ImportExportCost from a
vector of power values, a vector of costs, and an optional units system.

# Examples
```julia
mbc = make_import_export_curve([0.0, 100.0, 105.0, 120.0, 130.0], [25.0, 26.0, 28.0, 30.0])
mbc1 = make_import_export_curve([0.0, 100.0, 105.0, 120.0, 130.0], [25.0, 26.0, 28.0, 30.0], 10.0; power_inputs = UnitSystem.NATURAL_UNITS)
```
"""
function make_import_export_curve(
    import_powers::Vector{Float64} = [0.0, 0.0],
    import_prices::Vector{Float64} = [0.0],
    export_powers::Vector{Float64} = [0.0, 0.0],
    export_prices::Vector{Float64} = [0.0],
    ;
    power_units::UnitSystem = UnitSystem.NATURAL_UNITS,
)
    valid_data = (length(import_powers) == length(import_prices) + 1)
    valid_data = (length(export_powers) == length(export_prices) + 1)
    if valid_data
        buy_curve = PiecewiseStepData(import_powers, import_prices)
        sell_curve = PiecewiseStepData(export_powers, export_prices)
        return make_market_bid_curve(
            buy_curve,
            sell_curve;
            power_units = power_units,
        )
    else
        throw(
            ArgumentError(
                "Must specify exactly one more number of powers points than prices",
            ),
        )
    end
end

"""
Make a CostCurve{PiecewiseIncrementalCurve} from suitable for inclusion in a ImportExportCost from a
a max import/export power, a price and an optional units system. Assume the minimum import/export is 0.0

# Examples
```julia
mbc = make_import_export_curve(import_max_power = 100.0, import_price = 25.0)
mbc1 = make_import_export_curve(import_max_power = 100.0, import_price = 25.0, power_inputs = UnitSystem.NATURAL_UNITS)
mbc2 = make_import_export_curve(export_max_power = 100.0, export_price = 25.0, power_inputs = UnitSystem.NATURAL_UNITS)
mbc2 = make_import_export_curve(import_max_power = 100.0, import_price = 25.0, power_inputs = UnitSystem.NATURAL_UNITS)
```
"""
function make_import_export_curve(;
    import_max_power::Vector{Float64} = 0.0,
    import_price::Vector{Float64} = 0.0,
    export_max_power::Vector{Float64} = 0.0,
    export_price::Vector{Float64} = 0.0,
    power_units::UnitSystem = UnitSystem.NATURAL_UNITS,
)
    return make_market_bid_curve(
        [0.0, import_max_power],
        import_price,
        [0.0, export_max_power],
        export_price, ;
        power_units = power_units,
    )
end

"""
Make a CostCurve{PiecewiseIncrementalCurve} suitable for inclusion in a ImportExportCost from
the FunctionData that might be used to store such a cost curve in a time series.
"""
function make_import_export_curve(
    curve::Union{PiecewiseStepData, Nothing} = nothing,
    power_units::UnitSystem = UnitSystem.NATURAL_UNITS,
)
    cc = CostCurve(IncrementalCurve(curve, 0.0, 0.0), power_units)
    @assert is_market_bid_curve(buy_cc)
    return cc
end

# Unclear if we need this method here
#=
"""
Auxiliary make market bid curve for timeseries with nothing inputs.
"""
function _make_market_bid_curve(data::PiecewiseStepData;
    initial_input::Union{Nothing, Float64} = nothing,
    power_units::UnitSystem = UnitSystem.NATURAL_UNITS,
    input_at_zero::Union{Nothing, Float64} = nothing)
    cc = CostCurve(IncrementalCurve(data, initial_input, input_at_zero), power_units)
    @assert is_market_bid_curve(cc)
    return cc
end
=#
