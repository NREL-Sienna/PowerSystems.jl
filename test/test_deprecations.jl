@testset "Test deprecated convert_component!" begin
    # Test copied from test_powersystemconstructors.jl
    test_line_conversion =
        () -> begin
            sys = System(joinpath(BAD_DATA, "case5_re.m"))
            l = get_component(Line, sys, "bus2-bus3-i_4")
            initial_time = Dates.DateTime("2020-01-01T00:00:00")
            dates = collect(
                initial_time:Dates.Hour(1):Dates.DateTime("2020-01-01T23:00:00"),
            )
            data = collect(1:24)
            ta = TimeSeries.TimeArray(dates, data, [get_name(l)])
            name = "active_power_flow"
            time_series = SingleTimeSeries(; name = name, data = ta)
            add_time_series!(sys, l, time_series)
            @test get_time_series(SingleTimeSeries, l, name) isa SingleTimeSeries
            @test_deprecated PSY.convert_component!(MonitoredLine, l, sys)
            @test isnothing(get_component(Line, sys, "bus2-bus3-i_4"))
            mline = get_component(MonitoredLine, sys, "bus2-bus3-i_4")
            @test !isnothing(mline)
            @test get_name(mline) == "bus2-bus3-i_4"
            @test get_time_series(SingleTimeSeries, mline, name) isa SingleTimeSeries
            @test_deprecated @test_throws ErrorException convert_component!(
                Line,
                get_component(MonitoredLine, sys, "bus2-bus3-i_4"),
                sys,
            )
            @test_deprecated convert_component!(
                Line,
                get_component(MonitoredLine, sys, "bus2-bus3-i_4"),
                sys;
                force = true,
            )
            line = get_component(Line, sys, "bus2-bus3-i_4")
            @test !isnothing(mline)
            @test get_time_series(SingleTimeSeries, line, name) isa SingleTimeSeries
        end
    @test_logs (:error,) min_level = Logging.Error match_mode = :any test_line_conversion()
end
