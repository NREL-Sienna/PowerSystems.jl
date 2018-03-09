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
    bustype::Union{String,Missing} # [PV, PQ, SF]
    angle::Union{Real,Missing} # [degrees]
    voltage::Union{Real,Missing} # [pu]
    voltagelims::Union{Tuple{Real,Real},Missing} # [pu]
    basevoltage::Union{Real,Missing} # [kV]
end

Bus(;   number = 0, 
        name = "init", 
        bustype = missing, 
        angle = missing, 
        voltage = missing, 
        voltagelims = missing, 
        basevoltage = missing
    ) = Bus(number, name, bustype, angle, voltage, voltagelims, basevoltage)


include("network.jl")
