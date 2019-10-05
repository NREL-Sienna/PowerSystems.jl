function get_component(forecast::Forecast)
    return IS.get_component(forecast)
end

function get_forecast_value(forecast::Forecast, ix)
    return IS.get_forecast_value(forecast, ix)
end

function get_horizon(forecast::Forecast)
    return IS.get_horizon(forecast)
end

function get_data(forecast::Forecast)
    return IS.get_data(forecast)
end
