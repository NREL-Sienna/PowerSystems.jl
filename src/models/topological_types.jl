export system_param

"""
This file contains the types used in the componentes for power systems analysis 
toolbox developed in Julia.
"""

include("bus.jl")
include("network.jl")

struct system_param
    #BusQuantity::Int
    #GeneratorQuantity::Int
    #LoadQuantity::Int
    BaseVoltage::Float64 # [kV]
    BasePower::Float64 # [MVA]
    GlobalReserves::Float64 # [pu]
    TimeSteps::Int
end


