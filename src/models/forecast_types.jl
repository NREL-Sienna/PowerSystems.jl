export Deterministic
export Scenarios

struct Deterministic
    horizon::Int
    issuetimestep::Base.Dates.Period
    resolution::Base.Dates.Period
    initialtime::DateTime
    data::Dict{Any,TimeSeries.TimeArray}
end

struct Scenarios
    horizon::Int
    issuetimestep::Base.Dates.Period
    resolution::Base.Dates.Period
    initialtime::DateTime
    numberscenarios::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
end