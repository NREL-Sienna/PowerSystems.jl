export LoadEcon
export LoadTech
export ElectricLoad
export StaticLoad

abstract type 
    ElectricLoad  
end

struct LoadTech
    model::String # [Z, I, P]
    realpower::Real # [MW]
    reactivepower::Real # [MVAr]
    basevoltage::Real # [kV]
end 

struct LoadEcon
    SheddingCost::Real
    MaxEnergyLoss::Real
end 

struct StaticLoad <: ElectricLoad
    Name::String 
    bus::Bus
    TechnicalParameters::Nullable{LoadTech} 
    time_series::TimeSeries.TimeArray
end

struct ControllableLoad 