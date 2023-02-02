```@meta
EditURL = "<unknown>/script/2_PowerSystems_examples/04_parse_tabulardata.jl"
```

# Parsing Tabular Data

**Originally Contributed by**: Clayton Barrows

## Introduction

An example of how to parse tabular files (CSV) files similar to the format established in
the [RTS-GMLC](github.com/gridmod/rts-gmlc/RTS_Data/SourceData) and create a `System` using
[PowerSystems.jl](github.com/NREL-SIIP/PowerSystems.jl)

### Dependencies

````@example 04_parse_tabulardata
using PowerSystems
using TimeSeries
using Dates
````

### Fetch Data
PowerSystems.jl links to some test data that is suitable for this example.
Let's download the test data

````@example 04_parse_tabulardata
PowerSystems.download(PowerSystems.TestData; branch = "master") # *note* add `force=true` to get a fresh copy
base_dir = pkgdir(PowerSystems);
nothing #hide
````

### The tabular data format relies on a folder containing `*.csv` files and a `user_descriptors.yaml` file
First, we'll read the tabular data

````@example 04_parse_tabulardata
RTS_GMLC_DIR = joinpath(base_dir, "data", "RTS_GMLC");
rawsys = PowerSystems.PowerSystemTableData(
    RTS_GMLC_DIR,
    100.0,
    joinpath(RTS_GMLC_DIR, "user_descriptors.yaml"),
    timeseries_metadata_file = joinpath(RTS_GMLC_DIR, "timeseries_pointers.json"),
    generator_mapping_file = joinpath(RTS_GMLC_DIR, "generator_mapping_multi_start.yaml"),
)
````

### Create a `System`
Next, we'll create a `System` from the `rawsys` data. Since a `System` is predicated on a
time series resolution and the `rawsys` data includes both 5-minute and 1-hour resolution
time series, we also need to specify which time series we want to include in the `System`.
The `time_series_resolution` kwarg filters to only include time series with a matching resolution.

````@example 04_parse_tabulardata
sys = System(rawsys; time_series_resolution = Dates.Hour(1));
horizon = 24;
interval = Dates.Hour(24);
transform_single_time_series!(sys, horizon, interval);
sys
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

