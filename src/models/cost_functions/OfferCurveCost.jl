"""
    OfferCurveCost

Abstract type for representing cost curves used in market bidding and offer mechanisms.

This serves as the base type for various cost curve implementations including:
- [`MarketBidCost`](@ref)
- [`ImportExportCost`](@ref)

All concrete subtypes must implement the required interface methods for cost calculation
and curve evaluation in power system market operations.
"""
abstract type OfferCurveCost <: OperationalCost end

"""
Throws ArgumentError if a non-`CURVE` `curve_style` is combined with linear interpolation on
either offer curve. Shared by the [`MarketBidCost`](@ref) and
[`MarketBidTimeSeriesCost`](@ref) constructors.
"""
function check_curve_style_exclusivity(
    curve_style::CurveStyles,
    incremental_slope::Bool,
    decremental_slope::Bool,
)
    if curve_style != CurveStyles.CURVE && (incremental_slope || decremental_slope)
        throw(
            ArgumentError(
                "curve_style is mutually exclusive with incremental_slope/decremental_slope: an interpolated curve cannot clear as a block",
            ),
        )
    end
    return nothing
end
