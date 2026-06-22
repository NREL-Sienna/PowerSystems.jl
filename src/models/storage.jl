"""
Abstract supertype for energy storage technologies.

Storage devices can both inject and absorb power from the grid. The concrete subtype is
[`EnergyReservoirStorage`](@ref).

See also: [`StaticInjection`](@ref)
"""
abstract type Storage <: StaticInjection end
