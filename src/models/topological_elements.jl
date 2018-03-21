export SystemParam
export Bus

struct SystemParam
    busquantity::Int
    basevoltage::Real # [kV]
    basepower::Real # [MVA]
    timesteps::Int
end

SystemParam(; busquantity = 0,
        basevoltage = 0.0,
        basepower = 1000,
        timesteps = 1
        ) = SystemParam(busquantity, basevoltage, basepower, timesteps)

# Update to named tuples when Julia 0.7 becomes available 

struct Bus
    number::Int
    name::String
    bustype::Union{String,Nothing} # [PV, PQ, SF]
    angle::Union{Real,Nothing} # [degrees]
    voltage::Union{Real,Nothing} # [pu]
    voltagelims::Union{NamedTuple,Nothing} # [pu]
    basevoltage::Union{Real,Nothing} # [kV]
end

Bus(;   number = 0, 
        name = "init", 
        bustype = nothing, 
        angle = nothing, 
        voltage = nothing, 
        voltagelims = nothing, 
        basevoltage = nothing
    ) = Bus(number, name, bustype, angle, voltage, orderedlimits(voltagelims), basevoltage)

include("network.jl")
