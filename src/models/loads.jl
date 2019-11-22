abstract type ElectricLoad <: StaticInjection end
abstract type StaticLoad <: ElectricLoad end
abstract type ControllableLoad <: ElectricLoad end
