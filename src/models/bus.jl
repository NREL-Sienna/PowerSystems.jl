export bus

struct bus
    Number::Int
    Name::String
    BusType::Nullable{String} # [PV, PQ, SF]
    Angle::Nullable{Float64} # [degrees]
    Voltage::Nullable{Float64} # [pu]
    MaxVoltage::Nullable{Float64} # [pu]
    MinVoltage::Nullable{Float64} # [pu]
    BaseVoltage::Nullable{Float64} # [kV]
end

bus(Number::Int, Name::String) = bus(Number, Name, Nullable{String}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(), Nullable{Float64}(),Nullable{Float64})