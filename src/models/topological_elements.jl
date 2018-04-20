export Bus

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
