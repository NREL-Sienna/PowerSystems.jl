"""
Supertype of market constructs: instruments whose cleared award enters the network balance of at
least one clearing stage, and the hubs they settle at. Peers of `Device`, `Service`, `Topology`.
"""
abstract type MarketComponent <: Component end

"""
Supertype of market instruments (virtual bids, point-to-point spread bids). Bilateral trades are
settlement-ledger records in the schemas layer, not components.
"""
abstract type MarketTransaction <: MarketComponent end

supports_time_series(::MarketComponent) = true
