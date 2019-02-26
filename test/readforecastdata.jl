@test try
        ps_dict = PowerSystems.parsestandardfiles(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/matpower/case5_re.m")));
        da_time_series = PowerSystems.read_data_files(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/forecasts/5bus_ts")); REGEX_FILE = r"da_(.*?)\.csv");
        rt_time_series = PowerSystems.read_data_files(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/forecasts/5bus_ts")); REGEX_FILE = r"rt_(.*?)\.csv");
        ps_dict = PowerSystems.assign_ts_data(ps_dict,rt_time_series);

        buses, generators, storage, branches, loads, loadZones, shunts, services  = PowerSystems.ps_dict2ps_struct(ps_dict);
        sys_5 = PowerSystems.PowerSystem(buses, generators, loads, branches, storage, ps_dict["baseMVA"]);

        forecast_gen = PowerSystems.make_forecast_dict(da_time_series["gen"], Dates.Day(1), 24, generators);
        forecast_load = PowerSystems.make_forecast_dict(da_time_series, Dates.Day(1), 24, loads);

        forecast_struct = PowerSystems.make_forecast_array(forecast_gen);
        true
    finally
        false
    end

@test try
        ps_dict = PowerSystems.parsestandardfiles(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/matpower/RTS_GMLC.m")));
        da_time_series = PowerSystems.read_data_files(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/forecasts/RTS_GMLC_forecasts")); REGEX_FILE = r"DAY_AHEAD(.*?)\.csv");
        rt_time_series = PowerSystems.read_data_files(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/forecasts/RTS_GMLC_forecasts")); REGEX_FILE = r"REAL_TIME(.*?)\.csv");
        ps_dict = PowerSystems.assign_ts_data(ps_dict,rt_time_series);

        buses, generators, storage, branches, loads, loadZones, shunts, services  = PowerSystems.ps_dict2ps_struct(ps_dict);
        sys_5 = PowerSystems.PowerSystem(buses, generators, loads, branches, storage, ps_dict["baseMVA"]);

        forecast_gen = PowerSystems.make_forecast_dict(da_time_series["gen"], Dates.Day(1), 24, generators);
        forecast_load = PowerSystems.make_forecast_dict(rt_time_series, Dates.Day(1), 288, loads, loadZones);

        forecast_struct = PowerSystems.make_forecast_array(forecast_load);
        true
    finally
        false
    end
true
