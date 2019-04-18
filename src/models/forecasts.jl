abstract type Forecast <: PowerSystemType end

const Forecasts = Vector{ <: Forecast}
const SystemForecasts = Dict{Symbol, Forecasts}

"""
    Deterministic
        A deterministic forecast for a particular data field in a PowerSystemDevice.

"""
struct Deterministic{T <: Component} <: Forecast
    component::T                        # component
    label::String                       # label of component parameter forecasted
    resolution::Dates.Period            # resolution
    initialtime::Dates.DateTime         # forecast availability time
    data::TimeSeries.TimeArray          # TimeStamp - scalingfactor
    internal::PowerSystemInternal
end

function Deterministic(component, label, resolution, initialtime, data,)
    return Deterministic(component, label, resolution, initialtime, data,
                         PowerSystemInternal())
end

function Deterministic(component::Component,
                       label::String,
                       resolution::Dates.Period,
                       initialtime::Dates.DateTime,
                       time_steps::Int)
    data = TimeSeries.TimeArray(initialtime:Dates.Hour(1):initialtime+resolution*(time_steps-1),
                                ones(time_steps))
    return Deterministic(component, label, resolution, initialtime, data)
end

function Deterministic(component::Component, label::String, data::TimeSeries.TimeArray)
    resolution = getresolution(data)
    initialtime = TimeSeries.timestamp(data)[1]
    Deterministic(component, label, resolution, initialtime, data)
end

struct Scenarios <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    scenarioquantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
    internal::PowerSystemInternal
end

function Scenarios(horizon, resolution, interval, initialtime, scenarioquantity, data)
    return Scenarios(horizon, resolution, interval, initialtime, scenarioquantity, data,
                     PowerSystemInternal())
end

struct Probabilistic <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    percentilequantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
    internal::PowerSystemInternal
end

function Probabilistic(horizon, resolution, interval, initialtime, percentilequantity, data)
    return Probabilistic(horizon, resolution, interval, initialtime, percentilequantity,
                         data, PowerSystemInternal())
end
