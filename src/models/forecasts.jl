abstract type
    Forecast
end

struct Deterministic <: Forecast
    device::PowerSystemDevice
    horizon::Int
    resolution::Base.Dates.Period
    interval::Base.Dates.Period
    initialtime::DateTime
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end

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
