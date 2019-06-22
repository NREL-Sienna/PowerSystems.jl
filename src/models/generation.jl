abstract type Generator <: Injection end
const Generators = Array{<: Generator, 1}

abstract type HydroGen <: Generator end
abstract type RenewableGen <: Generator end
abstract type ThermalGen <: Generator end
