export Bus

struct Bus
    number::Int
    name::String
    bustype::Nullable{String} # [PV, PQ, SF]
    angle::Nullable{Float64} # [degrees]
    voltage::Nullable{Float64} # [pu]
    maxvoltage::Nullable{Float64} # [pu]
    minvoltage::Nullable{Float64} # [pu]
    basevoltage::Nullable{Float64} # [kV]
end

Bus(number::Int, name::String, bustype::String, angle::Float64) = Bus(number, name, bustype, angle, Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}())

Bus(number::Int, name::String) = Bus(number, name, Nullable{String}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}())


