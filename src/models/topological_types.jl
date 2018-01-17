export system_param

struct system_param
    #BusQuantity::Int
    #GeneratorQuantity::Int
    #LoadQuantity::Int
    BaseVoltage::Float64 # [kV]
    BasePower::Float64 # [MVA]
    GlobalReserves::Float64 # [pu]
    TimeSteps::Int
end

include("bus.jl")
include("network.jl")
