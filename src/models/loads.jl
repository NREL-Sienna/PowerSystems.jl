abstract type ElectricLoad <: Injection end

include("loads/electric_loads.jl")
include("loads/controllable_loads.jl")
include("loads/shunt_elements.jl")
