# Reserves

Reserve products are modeled by [`OnlineReserve`](@ref), [`OfflineReserve`](@ref), and
[`GroupReserve`](@ref), documented with the reserve abstractions in the
[Public API Reference](@ref). A reserve prices its requirement instead of enforcing it when
an Operating Reserve Demand Curve is attached through `variable` (a static or
time-series-backed `CostCurve`); see [`has_demand_curve`](@ref) and the ORDC accessors
[`get_variable_cost`](@ref) / [`set_variable_cost!`](@ref).
