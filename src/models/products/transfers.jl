
struct Transfer <: Service
    name::String
    contributingdevices::Array{Device}
    timeframe::Float64
    requirement::TimeSeries.TimeArray
end
