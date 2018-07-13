
data = PowerSystems.ParseStandardFiles(Pkg.dir("PowerSystems/data/matpower/RTS_GMLC.m"))

ps_dict = PowerSystems.pm2ps_dict(data)

time_series = PowerSystems.read_data_files(Pkg.dir("PowerSystems/data/forecasts/RTS_GMLC_forecasts"))

ps_dict = PowerSystems.add_realtime_ts(ps_dict,time_series)

Buses, Generators, Storage, Branches, Loads, LoadZones ,Shunts  = PowerSystems.ps_dict2ps_struct(ps_dict)
sys_RTS = PowerSystems.PowerSystem(Buses, Generators,Loads,Branches,Storage,230.0,1000.0)
forecast_gen = PowerSystems.make_forecast_dict(time_series,Day(1),24,Generators)
forecast_load = PowerSystems.make_forecast_dict(time_series,Day(1),24,Loads, LoadZones)

Forecast_Struct = PowerSystems.make_forecast_array(forecast_gen)



true
