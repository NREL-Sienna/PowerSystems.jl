""" Supertype for all electric loads"""
abstract type ElectricLoad <: StaticInjection end

""" Supertype for all [static](@ref S) electric loads"""
abstract type StaticLoad <: ElectricLoad end

""" Supertype for all controllable loads"""
abstract type ControllableLoad <: StaticLoad end
