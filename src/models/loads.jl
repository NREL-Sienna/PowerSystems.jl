abstract type ElectricLoad <: PowerSystemDevice end
const ElectricLoads = Array{<: ElectricLoad, 1}
const OptionalBranches = Union{Nothing, Branches}

include("loads/electric_loads.jl")
include("loads/controllable_loads.jl")
include("loads/shunt_elements.jl")
