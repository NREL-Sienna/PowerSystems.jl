# Add time series to `System`

**Originally Contributed by**: Clayton Barrows

## Introduction

An example of how to parse add time series data to a `System` using [PowerSystems.jl](https://github.com/NREL-Sienna/PowerSystems.jl)

For example, a `System` created by parsing a MATPOWER file doesn't contain any time series data. So a user may want to add time series to the `System`.

## Dependencies

Let's use the 5-bus dataset we parsed in the MATPOWER example

```@repl forecasts
using PowerSystems
using JSON3

file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "tutorials_data");
sys = System(joinpath(file_dir, "case5_re.m"))
```

## Define pointers to time series files

For example, if we want to add a bunch of time series files, say one for each load and one for each renewable generator, we need to define pointers to each .csv file containing the time series in the following format (PowerSystems.jl also supports a CSV format for this file). We will use Artifacts for the following [data](https://github.com/NREL-Sienna/PowerSystemsTestData/tree/master/5-Bus/5bus_ts)

```@repl forecasts
import LazyArtifacts
DATA_DIR = joinpath(LazyArtifacts.artifact"CaseData", "PowerSystemsTestData-1.0.1");
FORECASTS_DIR = joinpath(DATA_DIR, "5-Bus", "5bus_ts");
fname = joinpath(FORECASTS_DIR, "timeseries_pointers_da.json");
open(fname, "r") do f
    JSON3.@pretty JSON3.read(f)
end
```

## Read and assign time series to `System` using these parameters.

```@repl forecasts
add_time_series!(sys, fname)
sys
```
