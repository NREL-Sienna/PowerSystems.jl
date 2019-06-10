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

@testset "Forecast data matpower" begin
    ps_dict = PowerSystems.parsestandardfiles(joinpath(MATPOWER_DIR, "case5_re.m"))
    sys = System(ps_dict)
    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "5bus_ts", "gen"),
                                      "Simulation",
                                      Generator;
                                      REGEX_FILE=r"da_(.*?)\.csv")
    @test verify_forecasts(sys, 1, 2, 24)

    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "5bus_ts", "load"),
                                      "Simulation",
                                      Component;
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
                    Component;
                    REGEX_FILE=r"rt_(.*?)\.csv")
                )

    # TODO: need a dataset with same resolution but different horizon.

    sys = System(ps_dict)
    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "5bus_ts", "gen"),
                                      "Simulation",
                                      Generator;
                                      REGEX_FILE=r"rt_(.*?)\.csv")
    @test verify_forecasts(sys, 1, 2, 288)

    PowerSystems.forecast_csv_parser!(sys, joinpath(FORECASTS_DIR, "5bus_ts", "load"),
                                      "Simulation",
                                      Component;
                                      REGEX_FILE=r"rt_(.*?)\.csv")
    @test verify_forecasts(sys, 1, 5, 288)
end

@testset "Forecast data RTS" begin
    ps_dict = PowerSystems.parsestandardfiles(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    sys = System(ps_dict)
    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "RTS_GMLC_forecasts", "gen"),
                                      "Simulation",
                                      Generator;
                                      REGEX_FILE=r"DAY_AHEAD(.*?)\.csv")
    @test verify_forecasts(sys, 1, 81, 24)

    sys = System(ps_dict)
    PowerSystems.forecast_csv_parser!(sys,
                                      joinpath(FORECASTS_DIR, "RTS_GMLC_forecasts", "load"),
                                      "Simulation",
                                      LoadZones;
                                      REGEX_FILE=r"REAL_TIME(.*?)\.csv")
    @test verify_forecasts(sys, 1, 73, 288)
end
