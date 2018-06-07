abstract type ElectricLoad <: PowerSystemType end

abstract type
    ShuntElement
end

include("loads/electric_loads.jl")
include("loads/shunt_elements.jl")
