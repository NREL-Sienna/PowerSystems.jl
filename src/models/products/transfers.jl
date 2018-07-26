
struct Transfer <: Service
    name::String
    contributingdevices::Array{PowerSystemDevice}
    timeframe::Float64
    requirement::TimeSeries.TimeArray
end