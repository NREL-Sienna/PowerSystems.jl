using ExcelReaders
using TimeSeries
using JSON

data = readxl("data_files/point_forecast_data.xlsx", "Sheet1!A1:AS287")

forecast_det = Dict(
                :Horizon => 44,
                :Resolution => Dates.Minute(5),
                :IssueTimeStep => Dates.Minute(5),
                :InitialTime => Dates.Time(),
                :data => Dict{DateTime,TimeSeries.TimeArray}()
            )

temp = Dict{Any,TimeSeries.TimeArray}()
for i in 2:length(data[:,1])
    ini_temp = forecast_det[:InitialTime]+(i - 1)*forecast_det[:Resolution]
    temp[(forecast_det[:InitialTime]+(i - 2)*forecast_det[:IssueTimeStep])]=
    TimeArray(collect(ini_temp:forecast_det[:Resolution]:ini_temp+(forecast_det[:Resolution]*(forecast_det[:Horizon]-1))),data[i,2:end])
end

forecast_det[:data] = temp

open("data_files/forecast_det.json","w") do f
    JSON.print(f, forecast_det)
    close(f)
end

