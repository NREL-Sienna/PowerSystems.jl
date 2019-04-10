abstract type
    Forecast
end

struct Deterministic <: Forecast
    device::Device
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end

struct Scenarios <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    scenarioquantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end

struct Probabilistic <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    percentilequantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end
