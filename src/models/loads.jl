abstract type ElectricLoad <: PowerSystemDevice end

abstract type
    ShuntElement <: PowerSystemDevice
end

include("loads/electric_loads.jl")
include("loads/shunt_elements.jl")
