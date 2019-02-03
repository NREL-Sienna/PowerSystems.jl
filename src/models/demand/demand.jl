# Abstract representation of demand.

#=
These demands are parameterized in terms of how they are registered in time and
where they are located.  Functions will be provided to convert `Demand` into
the appropriate type `StaticLoad`, `InterruptibleLoad`, etc. that is properly
located at a `Bus`.
=#


# Import packages.

using Dates, TimeSeries


# Types for time series of possible mobile demands.


"""
Demands that vary with time.

# Type parameters
`T <: TimeType`: timestamp

# Example
```
bevdemand = TimeArray(
    [Time(0), Time(8), Time(9), Time(17), Time(18)],
    [     0.,     10.,      0.,      11.,       0.]
) :: TemporalDemand{Time}
```
"""
const TemporalDemand{T <: TimeType} = TimeArray{Float64, 1, T, Array{Float64,1}}


"""
Where demand locations move.

# Type parameters
`T <: TimeType`: timestamp
`L`            : network location

# Example
```
bevlocation = TimeArray(
    [Time(0)   , Time(8)   , Time(9)       , Time(17) , Time(18)  ],
    ["Home #23", "Road #14", "Workplace #3", "Road #9", "Home #23"]
) :: MobileDemand{Time,String}
```
"""
const MobileDemand{T <: TimeType, L} = TimeArray{L,1,T,Array{L,1}}


"""
Demands that move.

# Type parameters
`T <: TimeType`: timestamp
`L`            : network location

# Example
```
bevdemands = TimeArray(
    [Time(0)         , Time(8)          , Time(9)             , Time(17)        , Time(18)        ],
    [("Home #23", 0.), ("Road #14", 10.), ("Workplace #3", 0.), ("Road #9", 11.), ("Home #23", 0.)]
) :: LocatedDemand{Time,String}
```
"""
const LocatedDemand{T <: TimeType, L} = TimeArray{Tuple{L,Float64},1,T,Array{Tuple{L,Float64},1}}


# Abstract interface for demand.

"""
The most abstract type of demand.
"""
abstract type Demand end


"""
Time-varying demands and their locations.

This must be implemented by subtypes of `Demand`.
"""
function temporaldemands(demand :: Demand) :: LocatedDemand{T <: TimeType, L}
end
