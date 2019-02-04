# Demands that have no flexibility.


# Import packages.
using Dates, TimeSeries


# Timeseries of possibly mobile demands.


"""
Demands that vary with time.

# Type parameters
- `T <: TimeType`: timestamp

# Example
```
example = TimeArray(
    [Time(0), Time(8), Time(9), Time(17), Time(18)],
    [     0.,     10.,      0.,      11.,       0.]
) :: TemporalDemand{Time}
```
"""
const TemporalDemand{T <: TimeType} = TimeArray{Float64,1,T,Array{Float64,1}}


"""
Locations where demand moves.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location

# Example
```
example = TimeArray(
    [Time(0)   , Time(8)   , Time(9)       , Time(17) , Time(18)  ],
    ["Home #23", "Road #14", "Workplace #3", "Road #9", "Home #23"]
) :: MobileDemand{Time,String}
```
"""
const MobileDemand{T <: TimeType, L} = TimeArray{L,1,T,Array{L,1}}


"""
Demands that move.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location

# Example
```
example = TimeArray(
    [Time(0)         , Time(8)          , Time(9)             , Time(17)        , Time(18)        ],
    [("Home #23", 0.), ("Road #14", 10.), ("Workplace #3", 0.), ("Road #9", 11.), ("Home #23", 0.)]
) :: LocatedDemand{Time,String}
```
"""
const LocatedDemand{T <: TimeType, L} = TimeArray{Tuple{L,Float64},1,T,Array{Tuple{L,Float64},1}}


# Abstract inflexbile demands.


abstract type InflexibleDemand{T,L} <: Demand{T,L} end


"""
Time-varying demands and their locations.

This must be implemented by subtypes of `InflexibleDemand`.

# Arguments
- `demand :: InflexibleDemand{T,L}`: the demand
"""
function demands(demand :: InflexibleDemand{T,L}) :: LocatedDemand{T,L} where L where T <: TimeType
end


"""
The "envelope" of minimum and maximum allowable demands at each time pont, with a location for the demand.

# Arguments
- `demand :: InflexibleDemand{T,L}`: the demand
"""
function envelope(demand :: InflexibleDemand{T,L}) :: LocatedEnvelope{T,L} where L where T <: TimeType
    simple = demands(demand)
    TimeArray(
        timestamp(simple),
        map(x -> (x[1], x[2], x[2]), values(simple))
    )
end
