# Abstract representation of flexible demand.


"""
Demands that have flexibility.

# Type parameters
- `T <: TimeType`: timestamp
- `L`            : network location
"""
abstract type FlexibleDemand{T,L} <: Demand{T,L} end
