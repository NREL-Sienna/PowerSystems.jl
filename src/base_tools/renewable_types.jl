export renewable_power
export re_tech
export re_econ
export solar_power
export wind_power

abstract type 
    renewable_power 
end

struct re_tech
    MaxPower::Float64 # [MW]
end

struct re_econ
    CurtailCost::Float64 # [$/MWh]
end

struct wind_power <: renewable_power
    Name::String
    bus::bus
    TechnicalParameters::Union{re_tech,Tuple}
    EconomicParameters::Union{re_econ,Tuple}
    time_series::TimeSeries.TimeArray
end

struct solar_power <: renewable_power
    Name::String
    bus::bus
    TechnicalParameters::Union{re_tech,Tuple}
    EconomicParameters::Union{re_econ,Tuple}
    time_series::TimeSeries.TimeArray
end