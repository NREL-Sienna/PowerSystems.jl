# Demand response.

#=
WORK IN PROGRESS

In order to handle PHEVs, buildings, home appliances, industrial facilities,
etc., in addition to BEVs, serveral new types and subtypes will be introduced.
The organization of `FlexibleDemand` will change, but its numerical content will
remain the same.

There are really four types of demands:
1.  Inflexible, just a fixed timeseries.
2.  Flexible, without storage, like an industrial facility, that can reduce its
    production in response to price signals or contractual conditions.
3.  Flexible, with storage and its own generation, like a PHEV or a building
    with CHP, that can adjust its demand and shift to other energy sources.
4.  Constrained, dependent on storage, like a BEV, that can adjust its demand but
    has no other source of energy.

We'll probably end up with types along the following lines:
*   InflexibleDemand, FlexibleDemand, ConstrainedDemand
*   BEV, PHEV, CHP, . . .
Type-specific methods will specialize the behavior of the types of demands.

Locations will be mappable to Bus and demands will be mappable to
PowerSystems.StaticLoad and PowerSystems.InterruptibleLoad.
=#


include("demand/demand.jl")
include("demand/stationary_inflexible.jl")
include("demand/bev_demand.jl")
