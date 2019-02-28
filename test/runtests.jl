using Test
using Logging
using Dates

using PowerSystems


BASE_DIR = abspath(joinpath(dirname(Base.find_package("PowerSystems")), ".."))
DATA_DIR = joinpath(BASE_DIR, "data")
FORECASTS_DIR = joinpath(DATA_DIR, "forecasts")
MATPOWER_DIR = joinpath(DATA_DIR, "matpower")
PSSE_RAW_DIR = joinpath(DATA_DIR, "psse_raw")
RTS_GMLC_DIR = joinpath(DATA_DIR, "RTS_GMLC")

download(PowerSystems.TestData)

LOG_LEVELS = Dict(
    "Debug" => Logging.Debug,
    "Info" => Logging.Info,
    "Warn" => Logging.Warn,
    "Error" => Logging.Error,
)


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
            tests = filter(f->endswith(f, ".jl") && f != basename(rootfile), tests)
        else
            tests = map(f->string(f, ".jl"), tests)
        end
        println()
        for test in tests
            print(splitext(test)[1], ": ")
            include(test)
            println()
        end
    end
end

gl = global_logger()
level = get(ENV, "PS_LOG_LEVEL", "Error")
log_level = get(LOG_LEVELS, level, nothing)
if log_level == nothing
    error("Invalid log level $level: Supported levels: $(values(LOG_LEVELS))")
end
global_logger(ConsoleLogger(gl.stream, log_level))

# Testing Topological components of the schema
@testset "Begin PowerSystems tests" begin
    @includetests ARGS
end
