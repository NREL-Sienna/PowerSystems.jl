abstract type
    Forecast
end

struct Deterministic <: Forecast
    device::PowerSystems.PowerSystemDevice
    horizon::Int
    resolution::Base.Dates.Period
    interval::Base.Dates.Period
    initialtime::DateTime
    data::Dict{Any,Dict{Int64,TimeSeries.TimeArray}}
end


Deterministic(; horizon=24,
                resolution=Day(1),
                interval =Hour(1), 
                initialtime = Dates.today(),
                device= PowerSystemDevice(),
                data =  Dict("1"=> TimeSeries.TimeArray(Dates.today(), [1.0])))  = Deterministic(horizon,resolution,interval, initialtime,device_name, data) 

struct Scenarios <: Forecast
    horizon::Int
    resolution::Base.Dates.Period
    interval::Base.Dates.Period
    initialtime::DateTime
    scenarioquantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end

struct Probabilistic <: Forecast
    horizon::Int
    resolution::Base.Dates.Period
    interval::Base.Dates.Period
    initialtime::DateTime
    percentilequantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end
