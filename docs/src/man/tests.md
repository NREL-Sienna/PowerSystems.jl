# Tests

Unit tests can be executed in the REPL by executing the following:

```julia
julia> include("test/runtests.jl")
```

The unit test module supports several customizations to aid development and
debug.

- Run a subset of tests in the REPL:

```julia
julia> push!(ARGS, "<test_filename_without_.jl>")
julia> include("test/runtests.jl")
```

- Change console logging level (defaults to Error):

```julia
julia> ENV["PS_CONSOLE_LOG_LEVEL"] = Info
julia> include("test/runtests.jl")
```

- Change log file (./power-systems.log) logging level (defaults to Info):

```julia
julia> ENV["PS_LOG_LEVEL"] = Debug
julia> include("test/runtests.jl")
```

The unit test module appends a summary of all log message counts to the log
file.  If a message is logged too frequently then consider tagging that message
with maxlog=X to suppress it.
