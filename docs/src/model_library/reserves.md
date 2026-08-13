# Reserves

Reserve products are modeled by [`OnlineReserve`](@ref), [`OfflineReserve`](@ref), and
[`GroupReserve`](@ref), documented with the reserve abstractions in the
[Public API Reference](@ref). A reserve prices its requirement instead of enforcing it when
an Operating Reserve Demand Curve is attached through `variable`; see
[`has_demand_curve`](@ref).

## Reserve Demand Curve

```@autodocs
Modules = [PowerSystems]
Pages   = ["cost_functions/ReserveDemandCurve.jl", "cost_functions/ReserveDemandTimeSeriesCurve.jl"]
Public = true
Private = false
```
