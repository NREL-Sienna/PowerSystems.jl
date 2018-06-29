
data = PowerSystems.ParseStandardFiles(Pkg.dir("PowerSystems/data/matpower/RTS_GMLC.m"))

ps_dict = PowerSystems.pm2ps_dict(data)

time_series = PowerSystems.read_data_files(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts"))

ps_dict = PowerSystems.add_realtime_ts(ps_dict,time_series)

Buses, Generators, Branches, Loads  = PowerSystems.ps_dict2ps_struct(ps_dict)

forecast = PowerSystems.make_forecast_dict(time_series,Day(1),24,Array{PowerSystems.PowerSystemDevice,1}(Generators))

Forecast_Struct = PowerSystems.make_forecast_array(forecast)

true
