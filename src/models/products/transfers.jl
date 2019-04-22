
struct Transfer <: Service
    name::String
    contributingdevices::Vector{Device}
    timeframe::Float64
    requirement::TimeSeries.TimeArray
    internal::PowerSystemInternal
end

function Transfer(name, contributingdevices, timeframe, requirement)
    return Transfer(name, contributingdevices, timeframe, requirement,
                    PowerSystemInternal())
end
