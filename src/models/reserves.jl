"""
Used to specify if a [`Reserve`](@ref) is upwards, downwards, or symmetric
"""
abstract type ReserveDirection end

"""
An upwards reserve to increase generation or reduce load

Upwards reserves are used when total load exceeds its expected level,
typically due to forecast errors or contingencies.

A [`Reserve`](@ref) can be specified as a `ReserveUp` when it is defined.
"""
abstract type ReserveUp <: ReserveDirection end

"""
A downwards reserve to decrease generation or increase load

Downwards reserves are used when total load falls below its expected level,
typically due to forecast errors or contingencies. Not work

A [`Reserve`](@ref) can be specified as a `ReserveDown` when it is defined.
"""
abstract type ReserveDown <: ReserveDirection end

"""
A symmetric reserve, procuring the same quantity (MW) of both upwards and downwards
reserves

A symmetric reserve is a special case. [`ReserveUp`](@ref) and [`ReserveDown`](@ref)
can be used individually to specify different quantities of upwards and downwards
reserves, respectively.

A [`Reserve`](@ref) can be specified as a `ReserveSymmetric` when it is defined.
"""
abstract type ReserveSymmetric <: ReserveDirection end
abstract type AbstractReserve <: Service end
abstract type Reserve{T <: ReserveDirection} <: AbstractReserve end
abstract type ReserveNonSpinning <: AbstractReserve end
