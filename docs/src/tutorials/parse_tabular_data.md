# Parsing Tabular Data

**Originally Contributed by**: Clayton Barrows

## Introduction

An example of how to parse tabular files (CSV) files similar to the format established in the [RTS-GMLC](https://github.com/gridmod/rts-gmlc/RTS_Data/SourceData) and create a `System` using
[PowerSystems.jl](https://github.com/NREL-Sienna/PowerSystems.jl)

## Dependencies

```@repl parse_tabulardata
using PowerSystems
using TimeSeries
using Dates
```

## Fetch Data
PowerSystems.jl links to some test data that is suitable for this example.
Let's get the test data using Artifacts. You can find the repository of the data of the GMLC system [here](https://github.com/NREL-Sienna/PowerSystemsTestData/tree/master/RTS_GMLC):

```@repl parse_tabulardata
import LazyArtifacts
docs_dir = joinpath(pkgdir(PowerSystems), "docs")
DATA_DIR = joinpath(docs_dir, LazyArtifacts.artifact"CaseData", "PowerSystemsTestData-1.0.1");
# include download methods
RTS_GMLC_DIR = joinpath(DATA_DIR, "RTS_GMLC")
```

## The tabular data format relies on a folder containing `*.csv` files and a `user_descriptors.yaml` file
First, we'll read the tabular data

```@repl parse_tabulardata
rawsys = PowerSystems.PowerSystemTableData(
    RTS_GMLC_DIR,
    100.0,
    joinpath(RTS_GMLC_DIR, "user_descriptors.yaml"),
    timeseries_metadata_file = joinpath(RTS_GMLC_DIR, "timeseries_pointers.json"),
    generator_mapping_file = joinpath(RTS_GMLC_DIR, "generator_mapping_multi_start.yaml"),
)
```

## Create a `System`
Next, we'll create a `System` from the `rawsys` data. Since a `System` is predicated on a
time series resolution and the `rawsys` data includes both 5-minute and 1-hour resolution
time series, we also need to specify which time series we want to include in the `System`.
The `time_series_resolution` kwarg filters to only include time series with a matching resolution.

```@repl parse_tabulardata
sys = System(rawsys; time_series_resolution = Dates.Hour(1));
horizon = 24;
interval = Dates.Hour(24);
transform_single_time_series!(sys, horizon, interval);
sys
```

