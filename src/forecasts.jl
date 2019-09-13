function get_component(forecast::Forecast)
    return IS.get_component(forecast)
end

function get_forecast_component_name(forecast::Forecast)
    return IS.get_forecast_component_name(forecast)
end
function get_forecast_value(forecast::Forecast)
    return IS.get_forecast_value(forecast)
end
function get_horizon(forecast::Forecast)
    return IS.get_horizon(forecast)
end
function get_timeseries(forecast::Forecast)
    return IS.get_timeseries(forecast)
end

function get_data(forecast::Forecast)
    return IS.get_data(forecast)
end

function get_forecast_value(forecast::Forecast)
    return IS.get_forecast_value(forecast)
end
