# An inflexible stationary demand.


# Import packages.

using Dates


# Demand without flexibility.


"""
A stationary demand that has no flexibility.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location

# Fields
- `location`: network location of the demand
- `demands` : timeseries of the demands

# Example
```
example = StationaryInflexibleDemand(
    "a fixed location",
    TimeArray(
        [Time(0), Time(8), Time(9), Time(17), Time(18)],
        [     5.,     10.,      8.,      11.,       3.]
    )
) :: StationaryInflexibleDemand{Time,String}
```
"""
struct StationaryInflexibleDemand{T,L} <: InflexibleDemand{T,L}
    location :: L
    demands  :: TemporalDemand{T}
end


"""
Time-varying demands and their locations.

# Arguments
- `demand :: StationaryInflexibleDemand{T,L}`: the demand
"""
function demands(demand :: StationaryInflexibleDemand{T,L}) :: LocatedDemand{T,L} where L where T <: TimeType
    TimeArray(
        timestamp(demand.demands),
        map(x -> (demand.location, x), values(demand.demands))
    )
end
