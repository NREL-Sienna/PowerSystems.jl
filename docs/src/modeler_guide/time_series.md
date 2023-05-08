# [Time Series Data](@id ts_data)

## Introduction

The bulk of the data in many power system models is time series data, in order to
organize the data the potential inherent complexity, `PowerSystems.jl` has a set of definitions
to enable consistent modeling.

- **Resolution**: The period of time between each discrete value in the data, all resolutions
  are represented using `Dates.Period` types. For instance, a Day-ahead market data set usually
  has a resolution of `Hour(1)`, a Real-Time market data set usually has a resolution of `Minute(5)`.

- **Static data**: a single column of time series values for a component field
  (such as active power) where each time period is represented by a single value.
  This data commonly is obtained from historical information or the realization of
  a time-varying quantity.

This category of Time Series data usually comes in the following format:

| DateTime            | Value |
|---------------------|:-----:|
| 2020-09-01T00:00:00 | 100.0 |
| 2020-09-01T01:00:00 | 101.0 |
| 2020-09-01T02:00:00 |  99.0 |

Where a column (or several columns) represent the timestamp associated with the value and
a column stores the values of interest.

- **Forecasts**: Predicted values of a time-varying quantity that commonly features
  a look-ahead and can have multiple data values representing each time period.
  This data is used in simulation with receding horizons or data generated from
  forecasting algorithms.

Forecast data usually comes in the following format:

| DateTime            |   0   | 1     | 2     | 3    | 4     | 5     | 6     | 7     |
|---------------------|:-----:|:-----:|:-----:|:----:|:-----:|:-----:|:-----:|:------|
| 2020-09-01T00:00:00 | 100.0 | 101.0 | 101.3 | 90.0 | 98.0  | 87.0  | 88.0  | 67.0  |
| 2020-09-01T01:00:00 | 101.0 | 101.3 | 99.0  | 98.0 | 88.9  | 88.3  | 67.1  | 89.4  |
| 2020-09-01T02:00:00 |  99.0 | 67.0  | 89.0  | 99.9 | 100.0 | 101.0 | 112.0 | 101.3 |

Where a column (or several columns) represent the time stamp associated with the initial
time of the forecast, and the columns represent the forecasted values.

- **Interval**: The period of time between forecasts initial times. In `PowerSystems.jl` all
  intervals are represented using `Dates.Period` types. For instance, in a Day-Ahead market
  simulation, the interval of the time series is usually `Hour(24)`, in the example above, the
  interval is `Hour(1)`.

- **Horizon**: Is the count of discrete forecasted values, all horizons in `PowerSystems.jl`
  are represented with `Int`. For instance, many Day-ahead markets will have a forecast with a
  horizon 24.

- **Forecast window**: Represents the forecasted value starting at a particular initial time.

**Currently `PowerSystems.jl` does not support Forecasts or SingleTimeSeries with dissimilar
intervals or resolution.**

## Types

`PowerSystems.jl` supports two categories of time series data depending on the
process to obtain the data:

- Static data: a single column of time series values for a component field
  (such as active power) where each time period is represented by a single value.
  This data commonly is obtained from historical information or the realization of
  a time-varying quantity.
- Forecasts: Predicted values of a time-varying quantity that commonly features
  a look-ahead and can have multiple data values representing each time period.
  This data is used in simulation with receding horizons or data generated from
  forecasting algorithms.

### Static Time Series Data

PowerSystems defines the Julia struct [`SingleTimeSeries`](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/InfrastructureSystems/#InfrastructureSystems.SingleTimeSeries) to represent this data.

### Forecasts

PowerSystems defines the following Julia structs to represent forecasts:

- [`Deterministic`](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/InfrastructureSystems/#InfrastructureSystems.Deterministic): Point forecast without any uncertainty representation.
- [`Probabilistic`](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/InfrastructureSystems/#InfrastructureSystems.Probabilistic): Stores a discretized cumulative distribution functions
  (CDFs) or probability distribution functions (PDFs) at each time step in the
  look-ahead window.
- [`Scenarios`](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/InfrastructureSystems/#InfrastructureSystems.Scenarios): Stores a set of probable trajectories for forecasted quantity
  with equal probability.

## Storage

By default PowerSystems stores time series data in an HDF5 file. This prevents
large datasets from overwhelming system memory. If you know that your dataset
will fit in your computer's memory then you can increase performance by storing
it in memory. Here is an example of how to do this:

```julia
sys = System(100.0; time_series_in_memory = true)
```

PowerSystems stores the HDF5 file in the tmp filesystem by default. You can
change this by passing `time_series_directory = X` when you create the System.
This is required if the time series data is larger than the amount of tmp space
available. You can also override the location by setting the environment
variable SIIP_TIME_SERIES_DIRECTORY to another directory.

### Compression

PowerSystems does not enable HDF5 compression by default. You can enable it to
get significant storage savings at the cost of CPU time.

```julia
# Take defaults.
sys = System(100.0; enable_compression = true)
```

```julia
# Customize.
settings = CompressionSettings(
    enabled = true,
    type = CompressionTypes.DEFLATE,  # BLOSC is also supported
    level = 3,
    shuffle = true,
)
sys = System(100.0; compression = settings)
```

Refer to the [HDF5.jl](https://github.com/JuliaIO/HDF5.jl) and
[HDF5](https://support.hdfgroup.org/HDF5/) documentation for more details on the
options.

## Creating Time Series Data

PowerSystems supports several methods to load time series data (Forecasts or
StaticTimeSeries) into a System.

- Automated parsing during system construction, this method loads the data from CSV files.
  Refer to the parsing [documentation](@ref parsing_time_series).

- Create directly from data in `TimeSeries.TimeArray` or `DataFrames.DataFrame`.

Examples:

When creating data for `SingleTimeSeries` the user can directly pass a
`TimeSeries.TimeArray` to the constructor.

```julia
    resolution = Dates.Hour(1)
    dates = range(DateTime("2020-01-01T00:00:00"), step = resolution, length = 24)
    data = TimeArray(dates, ones(24))
    time_series = SingleTimeSeries("max_active_power", data)
```

When creating time series data that represents forecasts, the data can be stored in
any `AbstractDict` where the key is the initial time of the forecast and the value
field is the forecast value. The value fields in the dictionary can be regular
vectors or `TimeSeries.TimeArray`.

```julia
    resolution = Dates.Hour(1)
    data = Dict(
        DateTime("2020-01-01T00:00:00") => 10.0*ones(24),
        DateTime("2020-01-01T01:00:00") => 5.0*ones(24),
    )
    forecast = Deterministic("max_active_power", data, resolution)
```

- Load from CSV file. For Deterministic forecasts, each row represents one
  look-ahead window. The first column must be the initial time and the rest must
  be the forecast values. The CSV file must have no header in the first row.

```julia
    resolution = Dates.Hour(1)
    forecast = Deterministic("max_active_power", csv_filename, component, resolution)
```

## Scaling factors

Time series data can store actual component values (for instance MW) or scaling
factors intended to be multiplied by a scalar to generate the component values.
By default PowerSystems treats the values in the time
series data as physical units. In order to specify them as scaling factors, you
must pass the accessor function that provides the multiplier value. This value
must be passed into the forecast when you create it.

Example:

```julia
    resolution = Dates.Hour(1)
    data = Dict(
        DateTime("2020-01-01T00:00:00") => ones(24),
        DateTime("2020-01-01T01:00:00") => ones(24),
    )
    forecast = Deterministic(
	"max_active_power",
	data,
	resolution,
	scaling_factor_multiplier = get_max_active_power,
    )
```

In this example, the forecasted component is a generator. Whenever the user
retrieves the forecast data PowerSystems will call
`get_max_active_power(component)` and multiply the result with the forecast
values (scaling factors). For instance it the maximum active power returns the
value 50.0 and the scaling factor at some time point is 0.65, the forecast
value will correspond to 32.5.

## Adding time series to the System

Adding time series data to a system requires a component that is already
attached to the system. Extending the example above:

```julia
    add_time_series!(sys, component, forecast)
```

In order to optimize the storage of time series data, time series can be shared
across devices to avoid duplication. If the same forecast applies to multiple
components then can call `add_time_series!`, passing the collection of
components that share the time series data.

```julia
    add_time_series!(sys, components, forecast)
```

This function stores a single copy of the data. Each component will store a
reference to that data.

## Removing time series data

Time series instances can be removed from a system like this:

```julia
    remove_time_series!(Deterministic, sys, "max_active_power")
```

**Note**: If you are storing time series data in an HDF5 file, this does
not actually free up file space (HDF5 behavior). If you want to remove all or
most time series instances then consider using `clear_time_series!`. It
will delete the HDF5 file and create a new one. PowerSystems has plans to
automate this type of workflow.

```julia
    clear_time_series!(sys)
```

## Retrieving time series data

PowerSystems provides several methods to retrieve time series data. It is
important that you choose the best one for your use case as there are
performance implications. When an accessor function is used to create the forecast,
the `get_time_series_array` methods will apply the associated multiplier and return a
different value than is stored. If you want to explore the data as it's stored rather than
as it's intended for modeling use, refer to the next section.

### Get a TimeArray for a SingleTimeSeries

```julia
    ta = get_time_series_array(
        SingleTimeSeries,
        component,
        "max_active_power",
        start_time = DateTime("2020-01-01T00:00:00"),
        len = 24,
    )
```

**Note**: The default behavior is to read all data, so specify `start_time` and
`len` if you only need a subset of data.

### Get a TimeArray for a Deterministic forecast

For forecasts, the interfaces assume that modeling code will access one
forecast window at a time. Here's how to get one window:

```julia
    ta = get_time_series_array(
        Deterministic,
        component,
        "max_active_power",
        start_time = DateTime("2020-01-01T00:00:00"),
    )
```

## Data exploration

If you want to explore the time series data as it is stored in a system then you will
want to use the `get_time_series` function.

**Warning**: This will load all forecast windows into memory by default. Be
aware of how much data is stored.

**Note**: Unlike the functions above this will only return the exact stored
data. It will not apply a scaling factor multiplier.

```julia
    forecast = get_time_series(Deterministic, component, "max_active_power")
```

You can limit the data returned by specifying `start_time` and `count`.

```julia
    forecast = get_time_series(
        Deterministic,
        component,
        "max_active_power",
        start_time = DateTime("2020-01-09T00:00:00"),
        count = 10,
    )
```

Once you have a forecast instance you can access a specific window like this:

```julia
    window = get_window(forecast, DateTime("2020-01-09T00:00:00"))
```

or iterate over the look-ahead windows like this:

```julia
    for window in iterate_windows(forecast)
        @show window
    end
```

## Using forecast data in simulations

The interfaces documented up to this point are useful for the development of
scripts and models that use a small amount of forecasting data or do not
require accessing time series data multiple times. It is important to
understand the performance implications of accessing
forecast windows repeatedly like in the case of production cost modeling
simulations.

If each forecast window contains an array of 24 floats and the windows cover an
entire year then each retrieval will involve a small disk read. This can slow
down a simulation significantly, especially if the underlying storage uses
spinning disks.

PowerSystems provides an alternate interface that pre-fetches data into the
system memory with large reads in order to mitigate this potential problem. The
mechanism creates a cache of data and makes it available to the user.

It is highly recommended that you use this interface for modeling implementations. This is
particularly relevant for models using large datasets.

```julia
    cache = ForecastCache(Deterministic, component, "max_active_power")
    window1 = get_next_time_series_array(cache)
    window2 = get_next_time_series_array(cache)

    # or

    for window in cache
        @show window
    end
```

Each iteration on the cache object will deliver the next forecast window.
`get_next_time_series_array` will return `nothing` when all windows have been
delivered.

## Transform static time series into forecasts

A common workflow in developing models is transforming data generated from a
realization and stored in a single column into deterministic forecasts to
account for the effects of the look-ahead. Usually, this workflow leads to
large data duplications in the overlapping windows between forecasts.

PowerSystems provides a method to transform `SingleTimeSeries` data into
`Deterministic` forecasts without duplicating any data. The resulting object
behaves exactly like a `Deterministic`. Instead of storing windows at each
initial time it provides a view into the existing data at incrementing offsets.

Here's an example:

```julia
    # Create static time series data.
    resolution = Dates.Hour(1)
    dates = range(DateTime("2020-01-01T00:00:00"), step = resolution, length = 8760)
    data = TimeArray(dates, ones(8760))
    ts = SingleTimeSeries("max_active_power", data)
    add_time_series!(sys, component, ts)

    # Transform it to Deterministic
    transform_single_time_series!(sys, 24, Hour(24))
```

This function transforms all `SingleTimeSeries` instances stored in the system.
You can also call it on a single component.

You can now access either a `Deterministic` or the original `SingleTimeSeries`.

```julia
    ta_forecast = get_time_series_array(
        Deterministic,
        component,
        "max_active_power",
        start_time = DateTime("2020-01-01T00:00:00"),
    )
    ta_static = get_time_series_array(SingleTimeSeries, component, "max_active_power")
```

**Note**: The actual type of the returned forecast will be
`DeterministicSingleTimeSeries`. This type and `Deterministic` are subtypes of
`AbstractDeterministic` and implement all of the same methods (i.e., they
behave identically).

## Time Series Validation

PowerSystems applies validation rules whenever users add time series to a
`System`. It will throw an exception if any rule is violated.

1. All time series data, static or forecasts, must have the same resolution.
2. All forecasts must have identical parameters:  initial timestamp, horizon,
   interval, look-ahead window count.

Static time series instances may have different start times and lengths.

## Data Format

Refer to this
[page](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/dev_guide/time_series/#Data-Format)
for details on how the time series data is stored in HDF5 files.
