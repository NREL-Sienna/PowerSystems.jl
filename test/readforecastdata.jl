@testset "Forecast data" begin
    ps_dict = PowerSystems.parsestandardfiles(joinpath(MATPOWER_DIR, "case5_re.m"))
    sys = PowerSystem(ps_dict)
    da_time_series = PowerSystems.read_data_files(joinpath(FORECASTS_DIR, "5bus_ts");
                                                  REGEX_FILE=r"da_(.*?)\.csv")
    rt_time_series = PowerSystems.read_data_files(joinpath(FORECASTS_DIR, "5bus_ts");
                                                  REGEX_FILE=r"rt_(.*?)\.csv")
    da_forecasts = PowerSystems.make_forecast_array(sys,da_time_series)
    rt_forecasts = PowerSystems.make_forecast_array(sys,rt_time_series)

    PowerSystems.pushforecast!(sys,:DA=>da_forecasts)
    PowerSystems.pushforecast!(sys,:RT=>rt_forecasts)


    #= default forecast creation disabled
    forecast_gen = PowerSystems.make_forecast_dict(da_time_series["gen"],
                                                   Dates.Day(1), 24, generators)
    forecast_load = PowerSystems.make_forecast_dict(da_time_series, Dates.Day(1), 24, loads)
    forecast_gen = PowerSystems.make_forecast_dict(da_time_series["gen"], Dates.Day(1), 24,
                                                   generators)
    forecast_load = PowerSystems.make_forecast_dict(da_time_series, Dates.Day(1), 24, loads)
    forecast_gen = PowerSystems.make_forecast_dict(da_time_series["gen"], Dates.Day(1), 24,
                                                   generators);
    forecast_load = PowerSystems.make_forecast_dict(da_time_series, Dates.Day(1), 24,
                                                    loads);=#

    #RTS
    ps_dict = PowerSystems.parsestandardfiles(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    da_time_series = PowerSystems.read_data_files(joinpath(FORECASTS_DIR,
                                                           "RTS_GMLC_forecasts");
                                                  REGEX_FILE=r"DAY_AHEAD(.*?)\.csv")
    rt_time_series = PowerSystems.read_data_files(joinpath(FORECASTS_DIR,
                                                           "RTS_GMLC_forecasts");
                                                  REGEX_FILE=r"REAL_TIME(.*?)\.csv")

    sys = PowerSystem(ps_dict)
    #make forecast arrays
    da_forecasts = PowerSystems.make_forecast_array(sys,da_time_series)
    rt_forecasts = PowerSystems.make_forecast_array(sys,rt_time_series)

    #push to sys
    PowerSystems.pushforecast!(sys,:DA=>da_forecasts)
    PowerSystems.pushforecast!(sys,:RT=>rt_forecasts)
end
