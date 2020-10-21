# Managing Time Series Data
PowerSystems supports two categories of time series data depending on the process to obtain the data:

- Static data: a single column of time series values for a component field (such as active power). This data commonly is obtained from historical information or the realization of a time-varying quantity. 
- Forecasts: Predicted values of a time-varying quantity that commonly features a look-ahead. This data is used in simulation with receding horizons or data generated from forecasting algorithms. 

## Types

### Static Time Series Data
PowerSystems defines the Julia struct `SingleTimeSeries` to represent this data.

### Forecasts
PowerSystems defines the following Julia structs to represent forecasts:
- `Deterministic`: Point forecast without any uncertainty representation. 
- `Probabilistic`: Stores a discretized cumulative distribution functions (CDFs) or probability distribution functions (PDFs) at each time step in the look-ahead window. 
- `Scenarios`: Stores a set of probable trajectories for forecasted quantity with equal probability. 

## Storage
By default PowerSystems stores time-series data in an HDF5 file. This prevents
large datasets from overwhelming system memory. If you know that your dataset
will fit in your computer's memory then you can increase performance by storing
it in memory. Here is an example of how to do this:

```julia
sys = System(100.0; time_series_in_memory = true)
```

## Creating Forecasts
PowerSystems supports several methods to load time-series data into a System.
- Automated parsing during system construction.  Refer to the [parsing documentation](parsing.md).
- Create from TimeSeries.TimeArray or DataFrames.DataFrame
```julia
    resolution = Dates.Hour(1)
    dates = range(DateTime("2020-01-01T00:00:00"), step = resolution, length = 24)
    data = TimeArray(dates, ones(24))
    ts = SingleTimeSeries("max_active_power", data)
```
```julia
    resolution = Dates.Hour(1)
    data = Dict(
        DateTime("2020-01-01T00:00:00") => ones(24),
        DateTime("2020-01-01T01:00:00") => ones(24),
    )
    forecast = Deterministic("max_active_power", data, resolution)
```
- Load from CSV file. For Deterministic forecasts, each row represents one lookahead window. The first column must be the initial time and the rest must be the forecast values. The CSV file must have no header in the first row. 

```julia
    resolution = Dates.Hour(1)
    forecast = Deterministic("max_active_power", csv_filename, component, resolution)
```

## Scaling factors
Time series data can store actual component values (for instance MW) or scaling factors (0 - 1 values). By default PowerSystems treats the values in the forecasts as physical units. In order to specify them as scaling factors, you must pass the accessor function that provides the multiplier value. This value must be passed into the forecast when you create it.

Example:

```julia
    resolution = Dates.Hour(1)
    data = Dict(
        DateTime("2020-01-01T00:00:00") => ones(24),
        DateTime("2020-01-01T01:00:00") => ones(24),
    )
    forecast = Deterministic("max_active_power", data, resolution, scaling_factor_multiplier = get_max_active_power)
```

In this example, the forecasted component is a generator. Whenever the user retrieves the forecast data PowerSystems will call `get_max_active_power(component)` and multiply the result with the forecast values (scaling factors). For instance it the maximum active power returns the value 50.0 and the scaling factor at some time point is 0.65, the forecast value will correspond to 32.5. 

## Adding time series to the System
Adding time-series data to a system requires a component that is already attached to the system. Extending the example above:

```julia
    add_time_series!(sys, component, forecast)
```

In order to save space in memory for the storage of time series data, time series can be shared across devices to avoid repetition. If the same forecast applies to multiple components then can call `add_time_series!` passing the collection of components that share the time series data. 

```julia
    add_time_series!(sys, components, forecast)
```

This function stores a single copy of the data. Each component will store a reference to that data.

## Retrieving time-series data
PowerSystems provides several methods to retrieve time-series data. It is important that you choose the best one for your use case as there are performance implications.

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

**Note**: The default behavior is to read all data, so specify `start_time` and `len` if you only need a subset of data. 

### Get a TimeArray for a Deterministic forecast
For forecasts, the interfaces assume that modeling code will access one forecast window at a time. Here's how to get one window:

```julia
    ta = get_time_series_array(
        Deterministic,
        component,
        "max_active_power",
        start_time = DateTime("2020-01-01T00:00:00"),
    )
```

### Performance implications during simulations
It is important to understand the performance implications of accessing
forecast windows repeatedly during simulations. If each forecast window
contains an array of 24 floats and the windows cover an entire year then each
retrieval will involve a small disk read. This can slow down a simulation
significantly, especially if the underlying storage uses spinning disks.

PowerSystems provides an alternate interface that prefetches data into the system
memory with large reads in order to mitigate this problem.

It is highly recommended that you use this interface for simulations.

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

### Data exploration
If you want to explore the time series data stored in a system then you will
want to use the `get_time_series` function.

**Warning**: This will load all forecast windows into memory by default. Be
aware of how much data is stored.

**Note**: Unlike the functions above this will only return the exact stored
data. It will not apply a scaling factor multiplier.

```julia
    forecat = get_time_series(Deterministic, component, "max_active_power")
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

or iterate over the windows like this:

```julia
    for window in iterate_windows(forecast)
        @show window
    end
```

## Transform static time series into forecasts
PowerSystems provides a method to transform SingleTimeSeries data into
Deterministic forecasts without duplicating any data. The resulting object
behaves exactly like a Deterministic. Instead of storing windows at each
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
    transform_single_time_series!(sys)
```

This function transforms all SingleTimeSeries instances stored in the system.
You can also call it on a single component.

You can now access either a Deterministic or the original SingleTimeSeries.

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
`DeterministicSingleTimeSeries`. This type and `Determinsitic` are subtypes of
`AbstractDeterministic` and implement all of the same methods (i.e., they
behave identically).

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
