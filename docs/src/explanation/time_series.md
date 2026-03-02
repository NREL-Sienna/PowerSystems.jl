# [Time Series Data](@id ts_data)

## Categories of Time Series

The bulk of the data in many power system models is time series data. Given the potential
complexity, `PowerSystems.jl` has a set of definitions to organize this data and
enable consistent modeling.

`PowerSystems.jl` supports two categories of time series data depending on the
process to obtain the data and its interpretation:

  - [Static Time Series Data](@ref)
  - [Forecasts](@ref)

These categories are are all subtypes of `TimeSeriesData` and fall within this time series
type hierarchy:

```@repl
using PowerSystems #hide
import TypeTree: tt #hide
docs_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "utils"); #hide
include(joinpath(docs_dir, "docs_utils.jl")); #hide
print(join(tt(TimeSeriesData), "")) #hide
```

### Static Time Series Data

A static time series data is a single column of data where each time period has a single
value assigned to a component field, such as its maximum active power. This data commonly
is obtained from historical information or the realization of a time-varying quantity.

Static time series usually comes in the following format, with a set [resolution](@ref R)
between the time-stamps:

| DateTime            | Value |
|:------------------- |:-----:|
| 2020-09-01T00:00:00 | 100.0 |
| 2020-09-01T01:00:00 | 101.0 |
| 2020-09-01T02:00:00 | 99.0  |

This example is a 1-hour resolution static time-series.

In PowerSystems, a static time series is represented using [`SingleTimeSeries`](@ref).

### Forecasts

A forecast time series includes predicted values of a time-varying quantity that commonly
includes a look-ahead window and can have multiple data values representing each time
period. This data is used in simulation with receding horizons or data generated from
forecasting algorithms.

Key forecast format parameters are the forecast [resolution](@ref R), the
[interval](@ref I) of time between forecast [initial times](@ref I), and the number of
[forecast windows](@ref F) (or forecasted values) in the forecast [horizon](@ref H).

Forecast data usually comes in the following format, where a column represents the time
stamp associated with the [initial time](@ref I) of the forecast, and the remaining columns
represent the forecasted values at each step in the forecast [horizon](@ref H).

| DateTime            | 0     | 1     | 2     | 3    | 4     | 5     | 6     | 7     |
|:------------------- |:-----:|:-----:|:-----:|:----:|:-----:|:-----:|:-----:|:----- |
| 2020-09-01T00:00:00 | 100.0 | 101.0 | 101.3 | 90.0 | 98.0  | 87.0  | 88.0  | 67.0  |
| 2020-09-01T01:00:00 | 101.0 | 101.3 | 99.0  | 98.0 | 88.9  | 88.3  | 67.1  | 89.4  |
| 2020-09-01T02:00:00 | 99.0  | 67.0  | 89.0  | 99.9 | 100.0 | 101.0 | 112.0 | 101.3 |

This example forecast has a [interval](@ref I) of 1 hour and a [horizon](@ref H) of 8.

PowerSystems defines the following Julia structs to represent forecasts:

  - [`Deterministic`](@ref): Point forecast without any uncertainty representation.
  - [`Probabilistic`](@ref): Stores a discretized cumulative distribution functions
    (CDFs) or probability distribution functions (PDFs) at each time step in the
    look-ahead window.
  - [`Scenarios`](@ref): Stores a set of probable trajectories for forecasted quantity
    with equal probability.

## Data Storage

By default PowerSystems stores time series data in an HDF5 file.
This prevents
large datasets from overwhelming system memory. Refer to this
[page](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/dev_guide/time_series/#Data-Format)
for details on how the time series data is stored in HDF5 files.

Time series data can be stored actual component values (for instance MW) or scaling
factors intended to be multiplied by a scalar to generate the component values.
By default PowerSystems treats the values in the time
series data as physical units. In order to specify them as scaling factors, you
must pass the getter function that provides the multiplier value (e.g.,
`get_time_series_array`). The scaling factor multiplier
must be passed into the forecast when you create it to use this option.

The time series contains fields for `scaling_factor_multiplier` and `data`
to identify the details of  th `Component` field that the time series describes, and the
time series `data`. For example: we commonly want to use a time series to
describe the maximum active power capability of a renewable generator. In this case, we
can create a `SingleTimeSeries` with a `TimeArray` and a getter function to the
maximum active power field in the struct describing the generator. In this way, we can
store a scaling factor time series that will get multiplied by the maximum active power
rather than the magnitudes of the maximum active power time series.

Examples of how to create and add time series to system can be found in the
[Add Time Series Example](https://nrel-sienna.github.io/PowerSystems.jl/stable/tutorials/add_forecasts/)
