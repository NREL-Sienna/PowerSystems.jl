using Dates
@test try
    @test ps_dict = PowerSystems.parsestandardfiles(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/matpower/case5_re.m")));
    @test da_time_series = PowerSystems.read_data_files(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/forecasts/5bus_ts")); REGEX_FILE = r"da_(.*?)\.csv");
    @test rt_time_series = PowerSystems.read_data_files(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/forecasts/5bus_ts")); REGEX_FILE = r"rt_(.*?)\.csv");
    @test ps_dict = PowerSystems.assign_ts_data(ps_dict,rt_time_series);

    @test Buses, Generators, Storage, Branches, Loads, LoadZones ,Shunts  = PowerSystems.ps_dict2ps_struct(ps_dict);
    @test sys_5 = PowerSystems.PowerSystem(Buses, Generators,Loads,Branches,Storage,ps_dict["baseMVA"]);

    @test forecast_gen = PowerSystems.make_forecast_dict("DA",da_time_series["gen"],Day(1),24,Generators);
    @test forecast_load = PowerSystems.make_forecast_dict("DA",da_time_series,Day(1),24,Loads);

    @test Forecast_Struct = PowerSystems.make_forecast_array(forecast_gen);
true finally end

@test try
    @test ps_dict = PowerSystems.parsestandardfiles(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/matpower/RTS_GMLC.m")));
    @test da_time_series = PowerSystems.read_data_files(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/forecasts/RTS_GMLC_forecasts")); REGEX_FILE = r"DAY_AHEAD(.*?)\.csv");
    @test rt_time_series = PowerSystems.read_data_files(abspath(joinpath(dirname(Base.find_package("PowerSystems")), "../data/forecasts/RTS_GMLC_forecasts")); REGEX_FILE = r"REAL_TIME(.*?)\.csv");
    @test ps_dict = PowerSystems.assign_ts_data(ps_dict,rt_time_series);

    @test Buses, Generators, Storage, Branches, Loads, LoadZones ,Shunts  = PowerSystems.ps_dict2ps_struct(ps_dict);
    @test sys_RTS = PowerSystems.PowerSystem(Buses, Generators,Loads,Branches,Storage,ps_dict["baseMVA"]);

    @test forecast_gen = PowerSystems.make_forecast_dict("DA",da_time_series["gen"],Day(1),24,Generators);
    @test forecast_load = PowerSystems.make_forecast_dict("RT",rt_time_series,Day(1),288,Loads,LoadZones);

    @test Forecast_Struct = PowerSystems.make_forecast_array(forecast_load);
true finally end
true
