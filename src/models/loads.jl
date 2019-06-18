abstract type ElectricLoad <: Injection end
abstract type StaticLoad <: ElectricLoad end 
abstract type ControllableLoad <: ElectricLoad end
