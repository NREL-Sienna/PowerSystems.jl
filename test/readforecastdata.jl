import TimeSeries

function verify_forecasts(sys::System, num_initial_times, num_forecasts, horizon)
    initial_times = get_forecast_initial_times(sys)
    if length(initial_times) != num_initial_times
        @error "count of initial_times doesn't match" num_initial_times initial_times
        return false
    end

    total_forecasts = 0
    for it in initial_times
        forecasts = get_forecasts(Forecast, sys, it)
        for forecast in forecasts
            if get_horizon(forecast) != horizon
                @error "horizon doesn't match" get_horizon(forecast) horizon
                return false
            end
        end
        total_forecasts += length(forecasts)
    end

    if num_forecasts != total_forecasts
        @error "num_forecasts doesn't match" num_forecasts total_forecasts
        return false
    end

    return true
end

@testset "Test get_forecast_files" begin
    path = joinpath(FORECASTS_DIR, "5bus_ts", "gen")
    files = PowerSystems.get_forecast_files(path)
    @test length(files) > 0

    files2 = PowerSystems.get_forecast_files(path, REGEX_FILE=r"da_(.*?)\.csv")
    @test length(files2) > 0
    @test length(files2) < length(files)

    hidden_path = joinpath(FORECASTS_DIR, "5bus_ts", "gen", ".hidden")
    mkdir(hidden_path)
    filename = joinpath(hidden_path, "data.csv")
    try
        open(filename, "w") do io
        end

        @test isfile(filename)
        files = PowerSystems.get_forecast_files(path)
        @test length([x for x in files if occursin(".hidden", x)]) == 0

        # This is allowed if we pass the path in.
        files = PowerSystems.get_forecast_files(hidden_path)
        @test length(files) == 1
    finally
        rm(hidden_path; recursive=true)
    end
end

@testset "Forecast data matpower" begin
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "case5_re.m"))
    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "5bus_ts", "gen"),
                                      "Simulation",
                                      Generator;
                                      REGEX_FILE=r"da_(.*?)\.csv")
    @test verify_forecasts(sys, 1, 2, 24)

    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "5bus_ts", "load"),
                                      "Simulation",
                                      Bus;
                                      REGEX_FILE=r"da_(.*?)\.csv")
    @test verify_forecasts(sys, 1, 5, 24)

    # Add the same files.
    # This will fail because the component-label pairs will be duplicated.
    @test_throws(PowerSystems.DataFormatError,
                 PowerSystems.forecast_csv_parser!(
                    sys,
                    joinpath(FORECASTS_DIR, "5bus_ts", "gen"),
                    "Simulation",
                    Generator;
                    REGEX_FILE=r"da_(.*?)\.csv")
                )

    # This will fail because the resolutions are different.
    @test_throws(PowerSystems.DataFormatError,
                 PowerSystems.forecast_csv_parser!(
                    sys,
                    joinpath(FORECASTS_DIR, "5bus_ts", "load"),
                    "Simulation",
                    Bus;
                    REGEX_FILE=r"rt_(.*?)\.csv")
                )

    # TODO: need a dataset with same resolution but different horizon.

    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "case5_re.m"))
    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "5bus_ts", "gen"),
                                      "Simulation",
                                      Generator;
                                      REGEX_FILE=r"rt_(.*?)\.csv")
    @test verify_forecasts(sys, 1, 2, 288)

    PowerSystems.forecast_csv_parser!(sys, joinpath(FORECASTS_DIR, "5bus_ts", "load"),
                                      "Simulation",
                                      Bus;
                                      REGEX_FILE=r"rt_(.*?)\.csv")
    @test verify_forecasts(sys, 1, 5, 288)

    # Test with single file.
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "case5_re.m"))
    filename = joinpath(FORECASTS_DIR, "5bus_ts", "gen", "Renewable", "PV", "da_solar5.csv")
    PowerSystems.forecast_csv_parser!(sys,
                                      filename,
                                      "Simulation",
                                      Generator)
    @test verify_forecasts(sys, 1, 1, 24)
end

@testset "Forecast data RTS" begin
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "RTS_GMLC_forecasts", "gen"),
                                      "Simulation",
                                      Generator;
                                      REGEX_FILE=r"DAY_AHEAD(.*?)\.csv")
    @test verify_forecasts(sys, 1, 81, 24)

    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "RTS_GMLC_forecasts", "load"),
                                      "Simulation",
                                      LoadZones;
                                      REGEX_FILE=r"REAL_TIME(.*?)\.csv")
    @test verify_forecasts(sys, 1, 54, 288)
end

@testset "Verify per-unit conversion of forecasts" begin
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "RTS_GMLC_forecasts", "gen"),
                                      "Simulation",
                                      Generator;
                                      REGEX_FILE=r"DAY_AHEAD(.*?)\.csv",
                                      per_unit=false)
    @test verify_forecasts(sys, 1, 81, 24)

    data_no_per_unit = vcat([x.data for x in iterate_forecasts(sys)])

    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "RTS_GMLC_forecasts", "gen"),
                                      "Simulation",
                                      Generator;
                                      REGEX_FILE=r"DAY_AHEAD(.*?)\.csv",
                                      per_unit=true)
    @test verify_forecasts(sys, 1, 81, 24)
    data_per_unit = vcat([x.data for x in iterate_forecasts(sys)])

    for i in range(1, length=length(data_no_per_unit))
        @test TimeSeries.values(data_per_unit[i]) == 
              TimeSeries.values(data_no_per_unit[i]) / sys.basepower
    end
end
