export SystemParam

struct SystemParam
    busquantity::Int
    generatorquantity::Int
    loadquantity::Int
    basevoltage::Float64 # [kV]
    basepower::Float64 # [MVA]
    timesteps::Int
end

include("bus.jl")
include("network.jl")
