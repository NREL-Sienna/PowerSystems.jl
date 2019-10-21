# Interruptible demands.


# Import packages.
using Dates, TimeSeries


# Demands that can be interrupted.


"""
A simple interruptible demand.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location

# Fields
- `location`: network location of the demand
- `envelope`: timeseries of minimum and maximum allowable demands

```
example = InterruptibleDemand(
    "a fixed location",
    TimeArray(
        [Time(0) , Time(8)   , Time(9) , Time(17)  , Time(18)],
        [(5., 8.), (10., 12.), (8., 8.), (11., 13.), (3., 4.)]
    )
) :: InterruptibleDemand{Time,String}
```
"""
struct InterruptibleDemand{T,L} <: FlexibleDemand{T,L}
    location :: L
    envelope :: Envelope{T}
end


"""
The "envelope" of minimum and maximum allowable demands at each time pont, with a location for the demand.

# Arguments
- `demand :: InteruptibleDemand{T,L}`: the demand
"""
function envelope(demand :: InterruptibleDemand{T,L}) :: LocatedEnvelope{T,L} where L where T <: TimeType
    TimeArray(
        timestamp(demand.envelope),
        map(x -> (demand.location, x[1], x[2]), values(demand.envelope))
    )
end
