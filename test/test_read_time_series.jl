import DataFrames
import Dates
import TimeSeries

function verify_time_series(sys::System, num_initial_times, num_time_series, horizon)
    initial_times = get_time_series_initial_times(sys)
    if length(initial_times) != num_initial_times
        @error "count of initial_times doesn't match" num_initial_times initial_times
        return false
    end

    total_time_series = 0
    all_time_series = get_time_series_multiple(sys)
    for time_series in all_time_series
        if IS.get_horizon(time_series) != horizon
            @error "horizon doesn't match" IS.get_horizon(time_series) horizon
            return false
        end
        total_time_series += 1
    end

    if num_time_series != total_time_series
        @error "num_time_series doesn't match" num_time_series total_time_series
        return false
    end

    return true
end

@testset "Test read_time_series_file_metadata" begin
    for file in ["timeseries_pointers.json", "timeseries_pointers.csv"]
        filename = joinpath(RTS_GMLC_DIR, file)
        all_time_series = IS.read_time_series_file_metadata(filename)
        @test length(all_time_series) == 260

        for time_series in all_time_series
            @test isfile(time_series.data_file)
        end
    end
end

@testset "Test time_series normalization" begin
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

    file_metadata = IS.TimeSeriesFileMetadata(
        simulation = "DAY_AHEAD",
        category = "Generator",
        component_name = "122_HYDRO_1",
        label = "active_power",
        normalization_factor = 1.0,
        data_file = timeseries_file,
        percentiles = [],
        time_series_type_module = "InfrastructureSystems",
        time_series_type = "Deterministic",
    )

    # Test code path where no normalization occurs.
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    add_time_series!(sys, [file_metadata])
    verify_time_series(sys, 1, 1, 24)
    time_series = collect(get_time_series_multiple(sys))[1]
    @test TimeSeries.values(time_series.data) == TimeSeries.values(timeseries)

    # Test code path where timeseries is normalized by dividing by the max value.
    file_metadata.normalization_factor = "Max"
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    add_time_series!(sys, [file_metadata])
    verify_time_series(sys, 1, 1, 24)
    time_series = collect(get_time_series_multiple(sys))[1]
    @test TimeSeries.values(time_series.data) == TimeSeries.values(timeseries ./ max_value)

    # Test code path where timeseries is normalized by dividing by a custom value.
    nf = 95.0
    file_metadata.normalization_factor = nf
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    add_time_series!(sys, [file_metadata])
    verify_time_series(sys, 1, 1, 24)
    time_series = collect(get_time_series_multiple(sys))[1]
    @test TimeSeries.values(time_series.data) == TimeSeries.values(timeseries ./ nf)
end

@testset "Test single time_series addition" begin
    component_name = "122_HYDRO_1"
    label = "active_power"
    timeseries_file = joinpath(
        DATA_DIR,
        "forecasts",
        "RTS_GMLC_forecasts",
        "gen",
        "Hydro",
        "DAY_AHEAD_hydro.csv",
    )
    ta = IS.read_time_series(timeseries_file)[Symbol(component_name)]

    # Test with a filename.
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    component = get_component(HydroEnergyReservoir, sys, component_name)
    ts = Deterministic(label, timeseries_file, component; normalization_factor = 1.0)
    add_time_series!(sys, component, ts)
    verify_time_series(sys, 1, 1, 24)
    time_series = collect(get_time_series_multiple(sys))[1]
    @test TimeSeries.timestamp(get_data(time_series)) == TimeSeries.timestamp(ta)
    @test TimeSeries.values(get_data(time_series)) == TimeSeries.values(ta)

    # Test with TimeSeries.TimeArray.
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    component = get_component(HydroEnergyReservoir, sys, component_name)
    ts = Deterministic(label, ta; normalization_factor = 1.0)
    add_time_series!(sys, component, ts)
    verify_time_series(sys, 1, 1, 24)
    time_series = collect(get_time_series_multiple(sys))[1]
    @test TimeSeries.values(get_data(time_series)) == TimeSeries.values(ta)

    # Test with DataFrames.DataFrame.
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "RTS_GMLC.m")))
    component = get_component(HydroEnergyReservoir, sys, component_name)
    df = DataFrames.DataFrame(ta)
    ts = Deterministic(label, df; normalization_factor = 1.0)
    add_time_series!(sys, component, ts)
    verify_time_series(sys, 1, 1, 24)
    time_series = collect(get_time_series_multiple(sys))[1]
end

@testset "TimeSeriesData data matpower" begin
    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5_re.m")))
    file_metadata = joinpath(TIME_SERIES_DIR, "5bus_ts", "timeseries_pointers_da.json")
    add_time_series!(sys, file_metadata)
    @test verify_time_series(sys, 1, 5, 24)

    # Add the same files.
    # This will fail because the component-label pairs will be duplicated.
    @test_throws ArgumentError add_time_series!(sys, file_metadata)

    file_metadata = joinpath(TIME_SERIES_DIR, "5bus_ts", "timeseries_pointers_rt.json")

    ## This will fail because the resolutions are different.
    @test_throws PowerSystems.DataFormatError add_time_series!(sys, file_metadata)

    ## TODO: need a dataset with same resolution but different horizon.

    sys = System(PowerSystems.PowerModelsData(joinpath(MATPOWER_DIR, "case5_re.m")))
    add_time_series!(sys, file_metadata)
    @test verify_time_series(sys, 1, 5, 288)
end
