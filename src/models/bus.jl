export Bus

# Update to named tuples when Julia 0.7 becomes available 

struct Bus
    number::Int
    name::String
    bustype::Nullable{String} # [PV, PQ, SF]
    angle::Nullable{Real} # [degrees]
    voltage::Nullable{Real} # [pu]
    voltagelims::Nullable{Tuple{Real,Real}} # [pu]
    basevoltage::Nullable{Real} # [kV]
end

Bus(;   number = 0, 
        name = "init", 
        bustype = Nullable{String}(), 
        angle = Nullable{Real}(), 
        voltage = Nullable{Real}(), 
        voltagelims=Nullable{Tuple{Real,Real}}(), 
        basevoltage=Nullable{Real}()
    ) = Bus(Real, name, bustype, angle, voltage, voltagelims, basevoltage)
