export load_econ
export load_tech
export load

struct load_tech
    LoadType::String # [Z, I, P]
    RealPower::Float64 # [MW]
    ReactivePower::Float64 # [MVAr]
    BaseVoltage::Float64 # [kV]
end 

struct load_econ
    LoadType::String
    SheddingCost::Float64
    MaxEnergyLoss::Float64
end 

struct load
    Name::String 
    bus::bus
    TechnicalParameters::Union{load_tech,Tuple}
    EconomicParameters::Union{load_econ,Tuple}
    time_series::TimeSeries.TimeArray
end