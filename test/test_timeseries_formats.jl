
import CSV
import TimeSeries

@testset "Test Timeseries formats" begin
    formats = [
        (PowerSystems.TimeseriesFormatYMDPeriodAsColumn,
         joinpath(FORECASTS_DIR, "RTS_GMLC_forecasts", "gen", "Renewable",
                  "PV", "REAL_TIME_pv.csv"),
         nothing,
        ),
        (PowerSystems.TimeseriesFormatYMDPeriodAsHeader,
         joinpath(DATA_DIR, "RTS_GMLC", "Reserves", "REAL_TIME_regional_Reg_Up.csv"),
         "fake",
        ),
        (PowerSystems.TimeseriesFormatComponentsAsColumnsNoTime,
         joinpath(FORECASTS_DIR, "5bus_ts", "gen", "Renewable", "PV", "da_solar5.csv"),
         nothing),
        (PowerSystems.TimeseriesFormatComponentsAsColumnsNoTime,
         joinpath(FORECASTS_DIR, "5bus_ts", "load", "da_load5.csv"),
         nothing),
        # TODO: add a file that has a column name with a DateTime.
        # TODO: add a file that more than one unique timestamp so that we can fully test
        # get_step_time().
    ]

    for (format, filename, component_name) in formats
        file = CSV.File(filename)
        @test format == PowerSystems.get_timeseries_format(file)

        data = PowerSystems.read_time_array(filename, component_name)
        @test data isa TimeSeries.TimeArray
    end
end
