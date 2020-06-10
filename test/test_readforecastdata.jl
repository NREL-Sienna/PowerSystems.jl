import DataFrames
import Dates
import TimeSeries

function verify_forecasts(sys::System, num_initial_times, num_forecasts, horizon)
    initial_times = get_forecast_initial_times(sys)
    if length(initial_times) != num_initial_times
        @error "count of initial_times doesn't match" num_initial_times initial_times
        return false
    end

    total_forecasts = 0
    forecasts = iterate_forecasts(sys)
    for forecast in forecasts
        if IS.get_horizon(forecast) != horizon
            @error "horizon doesn't match" IS.get_horizon(forecast) horizon
            return false
        end
        total_forecasts += 1
    end

    if num_forecasts != total_forecasts
        @error "num_forecasts doesn't match" num_forecasts total_forecasts
        return false
    end

    return true
end

@testset "Test read_time_series_metadata" begin
    for file in ("timeseries_pointers.json", "timeseries_pointers.csv")
        filename = joinpath(RTS_GMLC_DIR, file)
        forecasts = IS.read_time_series_metadata(filename)
        @test length(forecasts) == 180

        for forecast in forecasts
            @test isfile(forecast.data_file)
        end
    end
end

@testset "Test forecast normalization" begin
    component_name = "122_HYDRO_1"
    timeseries_file = joinpath(
        DATA_DIR,
        "forecasts",
        "RTS_GMLC_forecasts",
        "gen",
        "Hydro",
        "DAY_AHEAD_hydro.csv",
    )
    timeseries = IS.read_time_series(timeseries_file)[Symbol(component_name)]
    max_value = maximum(TimeSeries.values(timeseries))

    metadata = IS.TimeseriesFileMetadata(
        "DAY_AHEAD",
        "Generator",
        "122_HYDRO_1",
        "activepower",
        1.0,
        timeseries_file,
        [],
        "DeterministicInternal",
    )

    # Test code path where no normalization occurs.
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    add_forecasts!(sys, [metadata])
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PSY.iterate_forecasts(sys))[1]
    @test TimeSeries.values(forecast.data) == TimeSeries.values(timeseries)

    # Test code path where timeseries is normalized by dividing by the max value.
    metadata.scaling_factor = "Max"
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    add_forecasts!(sys, [metadata])
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PSY.iterate_forecasts(sys))[1]
    @test TimeSeries.values(forecast.data) == TimeSeries.values(timeseries ./ max_value)

    # Test code path where timeseries is normalized by dividing by a custom value.
    sf = 95.0
    metadata.scaling_factor = sf
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    add_forecasts!(sys, [metadata])
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PSY.iterate_forecasts(sys))[1]
    @test TimeSeries.values(forecast.data) == TimeSeries.values(timeseries ./ sf)
end

@testset "Test single forecast addition" begin
    component_name = "122_HYDRO_1"
    label = "activepower"
    timeseries_file = joinpath(
        DATA_DIR,
        "forecasts",
        "RTS_GMLC_forecasts",
        "gen",
        "Hydro",
        "DAY_AHEAD_hydro.csv",
    )
    timeseries = IS.read_time_series(timeseries_file)[Symbol(component_name)]

    # Test with a filename.
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    component = get_component(HydroEnergyReservoir, sys, component_name)
    add_forecast!(sys, timeseries_file, component, label, 1.0)
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PSY.iterate_forecasts(sys))[1]
    @test TimeSeries.timestamp(get_data(forecast)) == TimeSeries.timestamp(timeseries)
    @test TimeSeries.values(get_data(forecast)) == TimeSeries.values(timeseries)

    # Test with TimeSeries.TimeArray.
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    component = get_component(HydroEnergyReservoir, sys, component_name)
    add_forecast!(sys, timeseries, component, label, 1.0)
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PSY.iterate_forecasts(sys))[1]
    @test TimeSeries.values(get_data(forecast)) == TimeSeries.values(timeseries)

    # Test with DataFrames.DataFrame.
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    component = get_component(HydroEnergyReservoir, sys, component_name)
    df = DataFrames.DataFrame(timeseries)
    add_forecast!(sys, df, component, label, 1.0)
    verify_forecasts(sys, 1, 1, 24)
    forecast = collect(PSY.iterate_forecasts(sys))[1]
end

@testset "Forecast data matpower" begin
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5_re.m")))
    forecasts_metadata = joinpath(FORECASTS_DIR, "5bus_ts", "timeseries_pointers_da.json")
    add_forecasts!(sys, forecasts_metadata)
    @test verify_forecasts(sys, 1, 5, 24)

    # Add the same files.
    # This will fail because the component-label pairs will be duplicated.
    @test_throws ArgumentError add_forecasts!(sys, forecasts_metadata)

    forecasts_metadata = joinpath(FORECASTS_DIR, "5bus_ts", "timeseries_pointers_rt.json")

    ## This will fail because the resolutions are different.
    @test_throws PowerSystems.DataFormatError add_forecasts!(sys, forecasts_metadata)

    ## TODO: need a dataset with same resolution but different horizon.

    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5_re.m")))
    add_forecasts!(sys, forecasts_metadata)
    @test verify_forecasts(sys, 1, 5, 288)
end
