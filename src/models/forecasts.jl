export Forecast
export Deterministic
export Scenarios
export Probabilistic

abstract type 
    Forecast
end

struct Deterministic <: Forecast
    horizon::Int
    issuetimestep::Base.Dates.Period
    resolution::Base.Dates.Period
    initialtime::DateTime
    data::Dict{Any,TimeSeries.TimeArray}
end

struct Scenarios <: Forecast
    horizon::Int
    issuetimestep::Base.Dates.Period
    resolution::Base.Dates.Period
    initialtime::DateTime
    numberscenarios::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end

struct Probabilistic <: Forecast
    horizon::Int
    issuetimestep::Base.Dates.Period
    resolution::Base.Dates.Period
    initialtime::DateTime
    numberscenarios::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end