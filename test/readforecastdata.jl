using Dates

ps_dict = PowerSystems.parsestandardfiles(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/matpower/RTS_GMLC.m")))

time_series = PowerSystems.read_data_files(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/forecasts/RTS_GMLC_forecasts")); REGEX_FILE = r"DAY_AHEAD(.*?)\.csv")

ps_dict = PowerSystems.assign_ts_data(ps_dict,time_series)

Buses, Generators, Storage, Branches, Loads, LoadZones ,Shunts  = PowerSystems.ps_dict2ps_struct(ps_dict)

sys_RTS = PowerSystems.PowerSystem(Buses, Generators,Loads,Branches,Storage,ps_dict["baseMVA"])

#forecast_gen = PowerSystems.make_forecast_dict(time_series,Dates.Day(1),24,Generators);
#forecast_load = PowerSystems.make_forecast_dict(time_series,Dates.Day(1),24,Loads, LoadZones);

#Forecast_Struct = PowerSystems.make_forecast_array(forecast_gen);



true
