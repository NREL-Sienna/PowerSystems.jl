module PowerSystemsTests

import TerminalLoggers: TerminalLogger
using ReTest
using Logging
using DataStructures
using Dates
using LinearAlgebra
using PowerSystemCaseBuilder
import TimeSeries
import InteractiveUtils
import JSON3
import PowerSystemCaseBuilder: PSYTestSystems
import InfrastructureSystems
const IS = InfrastructureSystems
using PowerSystems
import PowerSystems: PowerSystemTableData
const PSY = PowerSystems
const PSB = PowerSystemCaseBuilder

import Aqua
Aqua.test_unbound_args(PowerSystems)
Aqua.test_undefined_exports(PowerSystems)
Aqua.test_ambiguities(PowerSystems)
Aqua.test_stale_deps(PowerSystems)
Aqua.test_deps_compat(PowerSystems)

const BASE_DIR = dirname(dirname(Base.find_package("PowerSystems")))
const DATA_DIR = PSB.DATA_DIR
const TIME_SERIES_DIR = joinpath(DATA_DIR, "forecasts")
const MATPOWER_DIR = joinpath(DATA_DIR, "matpower")
const PSSE_RAW_DIR = joinpath(DATA_DIR, "psse_raw")
const PSSE_DYR_DIR = joinpath(DATA_DIR, "psse_dyr")
const PSSE_TEST_DIR = joinpath(DATA_DIR, "PSSE_test")
const RTS_GMLC_DIR = joinpath(DATA_DIR, "RTS_GMLC")
const TAMU_DIR = joinpath(DATA_DIR, "ACTIVSg2000")
const DESCRIPTORS = joinpath(RTS_GMLC_DIR, "user_descriptors.yaml")
const BAD_DATA = joinpath(DATA_DIR, "bad_data_for_tests")

LOG_FILE = "power-systems.log"
LOG_LEVELS = Dict(
    "Debug" => Logging.Debug,
    "Info" => Logging.Info,
    "Warn" => Logging.Warn,
    "Error" => Logging.Error,
)

include("common.jl")

for filename in readdir(joinpath(BASE_DIR, "test"))
    if startswith(filename, "test_") && endswith(filename, ".jl")
        include(filename)
    end
end

function get_logging_level_from_env(env_name::String, default)
    level = get(ENV, env_name, default)
    return IS.get_logging_level(level)
end

logger = global_logger()

function run_tests(args...; kwargs...)
    logger = global_logger()
    try
        logging_config_filename = get(ENV, "SIENNA_LOGGING_CONFIG", nothing)
        if logging_config_filename !== nothing
            config = IS.LoggingConfiguration(logging_config_filename)
        else
            config = IS.LoggingConfiguration(;
                filename = LOG_FILE,
                file_level = get_logging_level_from_env("SIENNA_FILE_LOG_LEVEL", "Info"),
                console_level = get_logging_level_from_env(
                    "SIENNA_CONSOLE_LOG_LEVEL",
                    "Error",
                ),
            )
        end
        console_logger = TerminalLogger(config.console_stream, config.console_level)

        IS.open_file_logger(config.filename, config.file_level) do file_logger
            levels = (Logging.Info, Logging.Warn, Logging.Error)
            multi_logger =
                IS.MultiLogger([console_logger, file_logger], IS.LogEventTracker(levels))
            global_logger(multi_logger)

            if !isempty(config.group_levels)
                IS.set_group_levels!(multi_logger, config.group_levels)
            end

            @time retest(args...; kwargs...)
            @test length(IS.get_log_events(multi_logger.tracker, Logging.Error)) == 0
            @info IS.report_log_summary(multi_logger)
        end
    finally
        # Guarantee that the global logger is reset.
        global_logger(logger)
        nothing
    end
end


export run_tests

end

using .PowerSystemsTests