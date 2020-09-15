using Test
using Logging
using Dates
using LinearAlgebra
import TimeSeries
import InteractiveUtils
import JSON3

import InfrastructureSystems
import InfrastructureSystems: Deterministic, Probabilistic, Scenarios, TimeSeriesData
const IS = InfrastructureSystems
using PowerSystems
import PowerSystems: PowerSystemTableData
const PSY = PowerSystems

import Aqua
Aqua.test_unbound_args(PowerSystems)
Aqua.test_undefined_exports(PowerSystems)
Aqua.test_ambiguities(PowerSystems)

include(joinpath(@__DIR__, "../src/utils/data.jl"))
import .UtilsData: TestData
download(TestData; branch = "master")

BASE_DIR = abspath(joinpath(dirname(Base.find_package("PowerSystems")), ".."))
DATA_DIR = joinpath(BASE_DIR, "data")
TIME_SERIES_DIR = joinpath(DATA_DIR, "forecasts")
MATPOWER_DIR = joinpath(DATA_DIR, "matpower")
PSSE_RAW_DIR = joinpath(DATA_DIR, "psse_raw")
PSSE_DYR_DIR = joinpath(DATA_DIR, "psse_dyr")
PSSE_TEST_DIR = joinpath(DATA_DIR, "PSSE_test")
RTS_GMLC_DIR = joinpath(DATA_DIR, "RTS_GMLC")
TAMU_DIR = joinpath(DATA_DIR, "ACTIVSg2000")

LOG_FILE = "power-systems.log"
LOG_LEVELS = Dict(
    "Debug" => Logging.Debug,
    "Info" => Logging.Info,
    "Warn" => Logging.Warn,
    "Error" => Logging.Error,
)

include("common.jl")

"""
Copied @includetests from https://github.com/ssfrr/TestSetExtensions.jl.
Ideally, we could import and use TestSetExtensions.  Its functionality was broken by changes
in Julia v0.7.  Refer to https://github.com/ssfrr/TestSetExtensions.jl/pull/7.
"""

"""
Includes the given test files, given as a list without their ".jl" extensions.
If none are given it will scan the directory of the calling file and include all
the julia files.
"""
macro includetests(testarg...)
    if length(testarg) == 0
        tests = []
    elseif length(testarg) == 1
        tests = testarg[1]
    else
        error("@includetests takes zero or one argument")
    end

    quote
        tests = $tests
        rootfile = @__FILE__
        if length(tests) == 0
            tests = readdir(dirname(rootfile))
            tests = filter(
                f ->
                    startswith(f, "test_") && endswith(f, ".jl") && f != basename(rootfile),
                tests,
            )
        else
            tests = map(f -> string(f, ".jl"), tests)
        end
        println()
        for test in tests
            print(splitext(test)[1], ": ")
            include(test)
            println()
        end
    end
end

function get_logging_level(env_name::String, default)
    level = get(ENV, env_name, default)
    log_level = get(LOG_LEVELS, level, nothing)
    if log_level == nothing
        error("Invalid log level $level: Supported levels: $(values(LOG_LEVELS))")
    end

    return log_level
end

function run_tests()
    console_level = get_logging_level("PS_CONSOLE_LOG_LEVEL", "Error")
    console_logger = ConsoleLogger(stderr, console_level)
    file_level = get_logging_level("PS_LOG_LEVEL", "Info")

    IS.open_file_logger(LOG_FILE, file_level) do file_logger
        levels = (Logging.Info, Logging.Warn, Logging.Error)
        multi_logger =
            IS.MultiLogger([console_logger, file_logger], IS.LogEventTracker(levels))
        global_logger(multi_logger)

        # Testing Topological components of the schema
        @time @testset "Begin PowerSystems tests" begin
            @includetests ARGS
        end

        @test length(IS.get_log_events(multi_logger.tracker, Logging.Error)) == 0
        @info IS.report_log_summary(multi_logger)
    end
end

logger = global_logger()

try
    run_tests()
finally
    # Guarantee that the global logger is reset.
    global_logger(logger)
    nothing
end
