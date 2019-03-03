# Abstract representation of demand.

#=
Demands are parameterized in terms of how they are registered in time and where
they are located.  Functions will be provided to convert `Demand` into the
appropriate type `StaticLoad`, `InterruptibleLoad`, etc. that is properly
located at a `Bus`.
=#


# Import packages.

using Dates, TimeSeries


# Timeseries for allowable ranges of demand.


"""
An "envelope" of minimum and maximum allowable demands at each time point.

# Type parameters
- `T <: TimeType`: timestamp

# Example
```
example = TimeArray(
    [Time(0) , Time(8)   , Time(9) , Time(17)  , Time(18)],
    [(5., 8.), (10., 12.), (8., 8.), (11., 13.), (3., 4.)]
) :: Envelope{Time}
```
"""
const Envelope{T <: TimeType} = TimeArray{Tuple{Float64,Float64},1,T,Array{Tuple{Float64,Float64},1}}


"""
An "envelope" of minimum and maximum allowable demands at each time point, with a location for the demand.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location

# Example
```
example = TimeArray(
    [Time(0)             , Time(8)             , Time(9)                 , Time(17)           , Time(18)            ],
    [("Home #23", 5., 8.), ("Road #14", 0., 0.), ("Workplace #3", 8., 8.), ("Road #9", 0., 0.), ("Home #23", 3., 4.)]
) :: LocatedEnvelope{Time}
```
"""
const LocatedEnvelope{T <: TimeType, L} = TimeArray{Tuple{L,Float64,Float64},1,T,Array{Tuple{L,Float64,Float64},1}}


# Abstract interface for demand.

"""
The most abstract type of demand.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location
"""
abstract type Demand{T <: TimeType, L} end


"""
The "envelope" of minimum and maximum allowable demands at each time pont, with a location for the demand.

This must be implemented by subtypes of `Demand`.

# Arguments
- `demand :: Demand{T,L}`: the demand
"""
function envelope(demand :: Demand{T,L}) :: LocatedEnvelope{T, L} where L where T <: TimeType
end


"""
Represent demand constraints as a JuMP model.

This must be implemented by subtypes of `Demand`.

# Arguments
- `demand :: Demand{T,L}`: the demand

# Returns
- `locations :: TimeArray{T,L}`   : location of the demand during each time interval
- `model :: JuMP.Model`           : a JuMP model containing the constraints`
- `result() :: LocatedDemand{T,}` : a function that results the located demand,
                                    but which can only be called after the model
                                    has been solved
"""
function demandconstraints(demand :: Demand{T,L}) where L where T <: TimeType
end
