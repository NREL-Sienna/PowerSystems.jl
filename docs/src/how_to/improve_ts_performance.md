# Improve Performance with Time Series Data

Use the steps here to improve performance with small or large data sets, but
particularly large data sets. These improvements can help handle adding
large numbers of data sets or reduce overhead when accessing time series data
multiple times.

## Choosing the Storage Location

By default, time series data is stored on disk (as an HDF5 file with a sidecar SQLite
catalog) in the tmp file system to prevent large datasets from overwhelming system memory.
However, you can change its location.

### Small data sets

If your dataset will fit in your computer's memory, then you can increase
performance by storing it in memory:

```julia
sys = System(100.0; time_series_in_memory = true)
```

### Large data sets

If the system's time series data will be larger than the amount of tmp space available, use
the `time_series_directory` parameter to change its location.

```julia
sys = System(100.0; time_series_directory = "bigger_directory")
```

You can also override the location by setting the environment
variable `SIENNA_TIME_SERIES_DIRECTORY` to another directory.

Compression is not enabled by default, but you can enable
it with `enable_compression` to get significant storage savings at the cost of CPU time.
[`CompressionSettings`](@ref) can be used to customize the compression. The storage
backend supports `DEFLATE` compression (`BLOSC` is not available).

```julia
sys = System(100.0; enable_compression = true)
sys = System(
    100.0;
    compression = CompressionSettings(;
        enabled = true,
        type = CompressionTypes.DEFLATE,
        level = 3,
        shuffle = true,
    ),
)
```

## Adding Time Series To The System

In order to optimize the storage of time series data, time series can be shared
across devices to avoid duplication. If the same forecast applies to multiple
components then can call `add_time_series!`, passing the collection of
components that share the time series data.
Time series data can also be shared on a component level. Suppose a time series array applies to
both the `max_active_power` and `max_reactive_power` attributes of a generator. You can share the
data.

```julia
resolution = Dates.Hour(1)
data = Dict(
    DateTime("2020-01-01T00:00:00") => ones(24),
    DateTime("2020-01-01T01:00:00") => ones(24),
)
# Define a Deterministic for the first attribute
forecast_max_active_power = Deterministic(
    "max_active_power",
    data,
    resolution,
)
add_time_series!(sys, generator, forecast_max_active_power)
# Reuse time series for second attribute
forecast_max_reactive_power = Deterministic(
    forecast_max_active_power,
    "max_reactive_power",
)
add_time_series!(sys, generator, forecast_max_reactive_power)
```

By default, each call to [`add_time_series!`](@ref) will open the storage file, write the
data to it, and record the series in the store's catalog. These operations have overhead.
If you will add thousands of time series arrays, consider using [`time_series_transaction`](@ref).
Additions are buffered and written in one bulk operation, so the store pays one catalog
transaction for the whole block instead of one per series.

```julia
time_series_transaction(sys) do txn
    add_time_series!(txn, component1, time_series1)
    add_time_series!(txn, component2, time_series2)
    add_time_series!(txn, component3, time_series3)
end
```

## Reading Time Series Data in Simulations

Production cost modeling and similar analyses follow the same access pattern at every
step: at each timestamp, read the value or forecast window of every component. Retrieving
each component's time series individually repeats metadata resolution and storage reads
millions of times over a simulation. PowerSystems provides timestamp-oriented readers
built for exactly this pattern; it is highly recommended that you use them for modeling
implementations.

The readers resolve all metadata once, when the reader is built, off the read path.
Components that share a time series array are read from storage once per timestamp
regardless of how many components reference the data, and sweeping through timestamps in
order reads each storage chunk once.

### Forecasts

Build a [`ForecastReader`](@ref) over every forecast of one type at one resolution with
[`build_forecast_reader`](@ref), then drive it timestamp by timestamp:

```julia
reader = build_forecast_reader(sys, Deterministic; resolution = Dates.Hour(1))
timeline = get_forecast_reader_timeline(reader)
entries = get_forecast_reader_entries(reader)  # one per forecast, bound to its component
for k in 0:(timeline.count - 1)
    timestamp = timeline.initial_timestamp + k * timeline.interval
    read_forecast_window!(reader, timestamp)
    for (i, entry) in enumerate(entries)
        window = get_forecast_window(reader, i)
        # entry.owner is the component; `window` is its forecast window at `timestamp`.
    end
end
```

Forecasts that share an underlying array — for example, one forecast added to a collection
of components — collapse to a single physical read per timestamp; see
[`get_num_forecast_slots`](@ref).

### Static time series

The same pattern is available for `SingleTimeSeries` data with a
[`StaticTimeSeriesReader`](@ref), which returns each component's value at one timestamp:

```julia
reader = build_static_time_series_reader(sys; resolution = Dates.Hour(1))
grid = get_static_time_series_reader_grid(reader)
entries = get_static_time_series_reader_entries(reader)
for k in 0:(grid.length - 1)
    timestamp = grid.initial_timestamp + k * grid.resolution
    read_static_time_series_values!(reader, timestamp)
    for (i, entry) in enumerate(entries)
        value = get_static_time_series_value(reader, i)
    end
end
```

Series with the same element type are packed into one columnar group and served by a
single storage read per timestamp, no matter how many components match the filter.

## Iterating One Component's Forecast Windows

To iterate the forecast windows of a single component sequentially — rather than reading
every component per timestamp — use a `ForecastCache` (or a `StaticTimeSeriesCache` for
`SingleTimeSeries` data). It pre-fetches data into system memory with large reads:

```julia
cache = ForecastCache(Deterministic, component, "max_active_power")
window1 = get_next_time_series_array!(cache)
window2 = get_next_time_series_array!(cache)
# or
for window in cache
    @show window
end
```

Each iteration on the cache object will deliver the next forecast window (see
[`get_next_time_series_array!`](@ref)). For simulations that read many components, prefer
the timestamp-oriented readers above.
