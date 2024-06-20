# [Time Series Data](@id ts_data)

## Categories of Time Series

The bulk of the data in many power system models is time series data. Given the potential
complexity, `PowerSystems.jl` has a set of definitions to organize this data and
enable consistent modeling.

`PowerSystems.jl` supports two categories of time series data depending on the
process to obtain the data and its interpretation:

- [Static Time Series Data](@ref)
- [Forecasts](@ref)

### Static Time Series Data

A static time series data is a single column of data where each time period has a single
value assigned to a component field, such as its maximum active power. This data commonly
is obtained from historical information or the realization of a time-varying quantity.

Static time series usually comes in the following format, with a set [resolution](@ref R)
between the time-stamps:

| DateTime            | Value |
|---------------------|:-----:|
| 2020-09-01T00:00:00 | 100.0 |
| 2020-09-01T01:00:00 | 101.0 |
| 2020-09-01T02:00:00 |  99.0 |

This example is a 1-hour resolution static time-series.

In PowerSystems, a static time series is represented using [`SingleTimeSeries`](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/InfrastructureSystems/#InfrastructureSystems.SingleTimeSeries).

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

| DateTime            |   0   | 1     | 2     | 3    | 4     | 5     | 6     | 7     |
|---------------------|:-----:|:-----:|:-----:|:----:|:-----:|:-----:|:-----:|:------|
| 2020-09-01T00:00:00 | 100.0 | 101.0 | 101.3 | 90.0 | 98.0  | 87.0  | 88.0  | 67.0  |
| 2020-09-01T01:00:00 | 101.0 | 101.3 | 99.0  | 98.0 | 88.9  | 88.3  | 67.1  | 89.4  |
| 2020-09-01T02:00:00 |  99.0 | 67.0  | 89.0  | 99.9 | 100.0 | 101.0 | 112.0 | 101.3 |

This example forecast has a [interval](@ref I) of 1 hour and a [horizon](@ref H) of 8.

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

Time series data can also be shared on a component level. Suppose a time series array applies to
both the `max_active_power` and `max_reactive_power` attributes of a generator. You can share the
data as shown in this example.

```julia
    resolution = Dates.Hour(1)
    data = Dict(
        DateTime("2020-01-01T00:00:00") => ones(24),
        DateTime("2020-01-01T01:00:00") => ones(24),
    )
    forecast_max_active_power = Deterministic(
        "max_active_power",
        data,
        resolution,
        scaling_factor_multiplier = get_max_active_power,
    )
    add_time_series!(sys, generator, forecast_max_active_power)
    forecast_max_reactive_power = Deterministic(
        forecast_max_active_power,
        "max_reactive_power",
        scaling_factor_multiplier = get_max_reactive_power,
    )
    add_time_series!(sys, generator, forecast_max_reactive_power)
```

### Adding time series in bulk

By default, the call to `add_time_series!` will open the HDF5 file, write the data to the file,
and close the file. Opening and closing the file has overhead. If you will add thousands of time
series arrays, consider using `open_time_series_store!`as shown in the example below. All arrays
will be written with one file handle.

This example assumes that there are arrays of components and time series stored in the variables
`components` and `single_time_series`, respectively.

```julia
    open_time_series_store!(sys, "r+") do
        for (component, ts) in zip(components, single_time_series)
            add_time_series!(sys, component, ts)
        end
    end
```

You can also use this function to make reads faster. Change the mode from `"r+"` to `"r"` to open
the file read-only.

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
    transform_single_time_series!(sys, Hour(24), Hour(24))
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
