# An inflexible stationary demand.


# Import packages.
using Dates


"""
A stationary demand that has no flexibility.

# Type parameters
`T <: TimeType`: timestamp
`L`            : network location

# Example
```
simple = StationaryInflexibleDemand(
    "a fixed location",
    TimeArray(
        [Time(0), Time(8), Time(9), Time(17), Time(18)],
        [     0.,     10.,      0.,      11.,       0.]
    )
) :: StationaryInflexibleDemand{Time,String}
```
"""
struct StationaryInflexibleDemand{T <: TimeType, L} <: Demand
    location :: L
    demands  :: TemporalDemand{T}
end


"""
Time-varying demands and their locations.
"""
function temporaldemands(demand :: StationaryInflexibleDemand{T,L}) :: LocatedDemand{T,L} where L where T <: TimeType
    TimeArray(
        timestamp(demand.demands),
        map(x -> (demand.location, x), values(demand.demands))
    )
end
