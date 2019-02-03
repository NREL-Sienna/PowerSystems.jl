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

# Import modules.
using Dates
using TimeSeries


"""
Detailed representation of a flexible, mobile demand.  For example, this may represent single or multiple vehicles or building loads.

This records the location of an entity and its consumption of its stored energy as a function of time, along with physical parameters and constraints: storage capacity, charge/discharge effiency, maximum charge/discharge rate, and temporal boundary conditions.  Charging represents grid-to-vehicle transfer of energy and discharging represents vehicle-to-grid transfer.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location

# Fields
- `locations`          : time/event series of locations of the demand.
- `consumptions`       : time/event series of consumption rate [energy/time].
- `storagemin`         : constraint on minimum storage level [energy].
- `storagemax`         : constraint on maximum storage level [energy].
- `boundarystorage`    : `nothing` for cyclic boundary conditions or a tuple of minimum and maximum storage allowed at the time boundaries [energy].
- `chargeratemax`      : constraint on maximum charging rate [energy/time].
- `dischargeratemax`   : constraint on maximum discharge rate, for V2G [energy/time].
- `chargeefficiency`   : efficiency of charging [energy/energy].
- `dischargeefficiency`: efficiency of discharging, for V2G [energy/energy].

# Example
```
vehicledemand = FlexibleDemand(
    TimeArray(
        [Time(0)   , Time(8)   , Time(9)       , Time(17) , Time(18)  ],
        ["Home #23", "Road #14", "Workplace #3", "Road #9", "Home #23"]
    ),
    TimeArray(
        [Time(0), Time(8), Time(9), Time(17), Time(18)],
        [     0.,     10.,      0.,      11.,       0.]
    ),
    0., 100.,
    nothing,
    50., 0.,
    0.99, 0.99
)
```
"""
struct FlexibleDemand{T <: TimeType, L, A <: AbstractArray{L,1}, B <: AbstractArray{Float64,1}}
    locations           :: TimeArray{L, 1, T, A}
    demands             :: TimeArray{Float64, 1, T, B}
    storagemin          :: Float64
    storagemax          :: Float64
    boundarystorage     :: Union{Tuple{Float64, Float64}, Nothing}
    chargeratemax       :: Float64
    dischargeratemax    :: Float64
    chargeefficiency    :: Float64
    dischargeefficiency :: Float64
end
