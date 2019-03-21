
@testset "Test LogEventTracker" begin
    levels = (Logging.Info, Logging.Warn, Logging.Error)
    tracker = LogEventTracker(levels)

    events = (
        LogEvent("file", 14, :id, "test log message", Logging.Debug),
        LogEvent("file", 14, :id, "test log message", Logging.Info),
        LogEvent("file", 14, :id, "test log message", Logging.Warn),
        LogEvent("file", 14, :id, "test log message", Logging.Error),
    )

    for i in range(1, length=2)
        for event in events
            PowerSystems.increment_count(tracker, event, false)
        end
    end

    @test length(get_log_events(tracker, Logging.Debug)) == 0
    for level in levels
        test_events = collect(get_log_events(tracker, level))
        @test length(test_events) == 1
        @test test_events[1].count == 2
    end

    text = report_log_summary(tracker)
    @test !occursin("Debug", text)
    @test !occursin("suppressed", text)
    for level in ("Error", "Warn", "Info")
        @test occursin("1 $level event", text)
    end

    # Test again with suppression.
    PowerSystems.increment_count(tracker, events[2], true)
    text = report_log_summary(tracker)
    @test occursin("suppressed=1", text)
end

@testset "Test MultiLogger with no event tracking" begin
    orig_logger = global_logger()
    logger = PowerSystems.MultiLogger([ConsoleLogger(devnull, Logging.Info),
                                       SimpleLogger(devnull, Logging.Debug)])
    global_logger(logger)
    @info "test log message"

    @test_throws PowerSystems.InvalidParameter report_log_summary(logger)

    global_logger(orig_logger)
    
end

@testset "Test MultiLogger with event tracking" begin
    orig_logger = global_logger()
    levels = (Logging.Debug, Logging.Info, Logging.Warn, Logging.Error)
    logger = PowerSystems.MultiLogger([ConsoleLogger(devnull, Logging.Info),
                                       SimpleLogger(devnull, Logging.Debug)],
                                      LogEventTracker(levels))
    global_logger(logger)
    for i in range(1, length=2)
        @debug "test log message"
        @info "test log message"
        @warn "test log message"
        @error "test log message" maxlog=1
    end

    events = collect(get_log_events(logger.tracker, Logging.Error))
    @test length(events) == 1
    events[1].suppressed == 1

    text = report_log_summary(logger)
    for level in levels
        @test occursin("1 $level event", text)
    end

    global_logger(orig_logger)
end
