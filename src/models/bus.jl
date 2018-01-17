export Bus

struct Bus
    number::Int
    name::String
    bustype::String # [PV, PQ, SF]
    angle::Float64 # [degrees]
    voltage::Float64 # [pu]
    maxvoltage::Float64 # [pu]
    minvoltage::Float64 # [pu]
    basevoltage::Float64 # [kV]
end

Bus(number::Int, name::String, bustype::String, angle::Float64) = Bus(number, name, bustype, angle, Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}())

Bus(number::Int, name::String) = Bus(number, name, Nullable{String}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}())


