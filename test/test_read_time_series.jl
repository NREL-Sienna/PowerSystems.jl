import CSV
import DataFrames
import Dates
import TimeSeries
import PowerTableDataParser

const HYDRO_CSV = joinpath(
    RTS_GMLC_DIR,
    "RTS_GMLC_forecasts",
    "gen",
    "Hydro",
    "DAY_AHEAD_hydro.csv",
)

function verify_time_series(sys::System, num_initial_times, num_time_series, len)
    total_time_series = 0
    all_time_series = get_time_series_multiple(sys)
    for time_series in all_time_series
        if length(time_series) != len
            @error "length doesn't match" length(time_series) len
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

"""
Read one component's column out of an RTS forecast CSV into a `TimeArray`, through the same
pointer-CSV reader the parser package uses on these files.
"""
function read_component_time_array(
    filename::AbstractString,
    component_name::AbstractString,
    resolution::Dates.Period,
)
    df = CSV.read(filename, DataFrames.DataFrame)
    values, initial_timestamp =
        PowerTableDataParser.read_pointer_csv_values(df, component_name, resolution)
    timestamps = range(initial_timestamp; step = resolution, length = length(values))
    return TimeSeries.TimeArray(collect(timestamps), values)
end

@testset "Test time_series normalization" begin
    component_name = "122_HYDRO_1"
    resolution = Dates.Hour(1)
    ta = read_component_time_array(HYDRO_CSV, component_name, resolution)
    raw = TimeSeries.values(ta)
    max_value = maximum(raw)

    # No normalization.
    ts = SingleTimeSeries("active_power", ta; normalization_factor = 1.0)
    @test TimeSeries.values(get_data(ts)) == raw

    # Normalize by the max value.
    ts = SingleTimeSeries(
        "active_power",
        ta;
        normalization_factor = IS.NormalizationTypes.MAX,
    )
    @test TimeSeries.values(get_data(ts)) == raw ./ max_value

    # Normalize by a custom value.
    nf = 95.0
    ts = SingleTimeSeries("active_power", ta; normalization_factor = nf)
    @test TimeSeries.values(get_data(ts)) == raw ./ nf
end

@testset "Test single time_series addition" begin
    component_name = "122_HYDRO_1"
    name = "active_power"
    resolution = Dates.Hour(1)
    ta = read_component_time_array(HYDRO_CSV, component_name, resolution)

    # From a TimeSeries.TimeArray.
    sys = PSB.build_system(PSB.MatpowerTestSystems, "matpower_RTS_GMLC_sys")
    component = get_component(HydroDispatch, sys, component_name)
    ts = SingleTimeSeries(name, ta; normalization_factor = 1.0)
    add_time_series!(sys, component, ts)
    @test verify_time_series(sys, 1, 1, 24)
    time_series = collect(get_time_series_multiple(sys))[1]
    @test TimeSeries.values(get_data(time_series)) == TimeSeries.values(ta)

    # From a DataFrames.DataFrame.
    sys = PSB.build_system(PSB.MatpowerTestSystems, "matpower_RTS_GMLC_sys")
    component = get_component(HydroDispatch, sys, component_name)
    df = DataFrames.DataFrame(ta)
    ts = SingleTimeSeries(name, df; normalization_factor = 1.0)
    add_time_series!(sys, component, ts)
    @test verify_time_series(sys, 1, 1, 24)
    time_series = collect(get_time_series_multiple(sys))[1]
    @test TimeSeries.values(get_data(time_series)) == TimeSeries.values(ta)
end
