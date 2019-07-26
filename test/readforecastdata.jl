import DataFrames
import TimeSeries

const PS = PowerSystems

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

@testset "Test read_timeseries_metadata" begin
    forecasts = PS.read_timeseries_metadata(joinpath(RTS_GMLC_DIR,
                                                     "timeseries_pointers.json"))
    @test length(forecasts) == 282

    for forecast in forecasts
        @test isfile(forecast.data_file)
    end
end

@testset "Test forecast normalization" begin
    component_name = "122_HYDRO_1"
    timeseries_file = joinpath(DATA_DIR, "forecasts", "RTS_GMLC_forecasts", "gen", "Hydro",
                               "DAY_AHEAD_hydro.csv")
    timeseries = PS.read_timeseries(timeseries_file)[Symbol(component_name)]
    max_value = maximum(TimeSeries.values(timeseries))

    metadata = PS.TimeseriesMetadata(
        "DAY_AHEAD",
        "Generator",
        "122_HYDRO_1",
        "PMax MW",
        1.0,
        timeseries_file,
    )

    # Test code path where no normalization occurs.
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    add_forecasts!(sys, [metadata])
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PS.iterate_forecasts(sys))[1]
    @test TimeSeries.values(forecast.data) == TimeSeries.values(timeseries)

    # Test code path where timeseries is normalized by dividing by the max value.
    metadata.scaling_factor = "Max"
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    add_forecasts!(sys, [metadata])
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PS.iterate_forecasts(sys))[1]
    @test TimeSeries.values(forecast.data) == TimeSeries.values(timeseries ./ max_value)

    # Test code path where timeseries is normalized by dividing by a custom value.
    sf = 95.0
    metadata.scaling_factor = sf
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    add_forecasts!(sys, [metadata])
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PS.iterate_forecasts(sys))[1]
    @test TimeSeries.values(forecast.data) == TimeSeries.values(timeseries ./ sf)
end

@testset "Test single forecast addition" begin
    component_name = "122_HYDRO_1"
    timeseries_file = joinpath(DATA_DIR, "forecasts", "RTS_GMLC_forecasts", "gen", "Hydro",
                               "DAY_AHEAD_hydro.csv")
    timeseries = PS.read_timeseries(timeseries_file)[Symbol(component_name)]

    # Test with a filename.
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    component = get_component(HydroDispatch, sys, component_name)
    add_forecast!(sys, timeseries_file, component, "PMax MW", 1.0)
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PS.iterate_forecasts(sys))[1]
    @test TimeSeries.values(forecast.data) == TimeSeries.values(timeseries)
    @test PS.get_timeseries(forecast) == timeseries

    # Test with TimeSeries.TimeArray.
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    component = get_component(HydroDispatch, sys, component_name)
    add_forecast!(sys, timeseries, component, "PMax MW", 1.0)
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PS.iterate_forecasts(sys))[1]
    @test TimeSeries.values(forecast.data) == TimeSeries.values(timeseries)
    @test PS.get_timeseries(forecast) == timeseries

    # Test with DataFrames.DataFrame.
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "RTS_GMLC.m"))
    component = get_component(HydroDispatch, sys, component_name)
    df = DataFrames.DataFrame(timeseries)
    add_forecast!(sys, df, component, "PMax MW", 1.0)
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PS.iterate_forecasts(sys))[1]
end

@testset "Forecast data matpower" begin
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "case5_re.m"))
    forecasts_metadata = joinpath(FORECASTS_DIR, "5bus_ts", "timeseries_pointers_da.json")
    add_forecasts!(sys, forecasts_metadata)
    @test verify_forecasts(sys, 1, 5, 24)


    # Add the same files.
    # This will fail because the component-label pairs will be duplicated.
    @test_throws PowerSystems.DataFormatError add_forecasts!(sys, forecasts_metadata)

    forecasts_metadata = joinpath(FORECASTS_DIR, "5bus_ts", "timeseries_pointers_rt.json")

    ## This will fail because the resolutions are different.
    @test_throws PowerSystems.DataFormatError add_forecasts!(sys, forecasts_metadata)

    ## TODO: need a dataset with same resolution but different horizon.

    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "case5_re.m"))
    add_forecasts!(sys, forecasts_metadata)
    @test verify_forecasts(sys, 1, 5, 288)
end
