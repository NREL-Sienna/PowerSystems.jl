export ReadPointForecast

function ReadPointForecast(file::String; Interval = 60, Resolution = 60, InitialTime = Dates.Time())

    warn("This function assumes Forecasts are provided row-wise from the CSV file")

    data = CSV.read(file)


    #Analysis of the forecast DataFrame 
    numberofperiods = length(data[1,:]) - 1

    forecast_det = Dict( 
                    :ForecastHorizon => numberofperiods, 
                    :ForecastInterval => Dates.Minute(Interval),
                    :ForecastResolution => Dates.Minute(Resolution), 
                    :InitialTime => InitialTime,
                    :data => Dict{DateTime,TimeSeries.TimeArray}()  
                )

    warn("If Initial time is not provided, 00:00 will be assumed")            

    temp = Dict{Any,TimeSeries.TimeArray}()  
    for i in 1:length(data[:,1])
        ini_temp = forecast_det[:InitialTime]+forecast_det[:ForecastInterval]
        temp[(forecast_det[:InitialTime]+(i - 1)*forecast_det[:ForecastResolution])]=
        TimeArray(collect(ini_temp:forecast_det[:ForecastInterval]:ini_temp+(forecast_det[:ForecastInterval]*(forecast_det[:ForecastHorizon]-1))),Array(data[i,2:end])[1,:])
    end

    forecast_det[:data] = temp

    open(string(file,".json"),"w") do f
        JSON.print(f, forecast_det)
        close(f)
    end

    return forecast_det 

end
