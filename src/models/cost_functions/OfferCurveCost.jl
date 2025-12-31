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
