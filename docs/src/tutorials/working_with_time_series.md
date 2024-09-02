# [Working with Time Series Data](@id tutorial_time_series)

In this tutorial, we will manually add, retrieve, and inspect time-series data in
different formats, including identifying which components in a power `System` have time
series data. Along the way, we will also use workarounds for missing forecast data and
reuse identical time series profiles to avoid unnecessary memory usage.

## Example Data and Setup

We will make an example `System` with a wind generator and two loads, and
add the time series needed to model, for example, the impacts of wind forecast uncertainty.

Here is the available data:

```@raw html
<img src="../../assets/time_series_tutorial.png" width="100%"/>
```

For the wind generator, we have the historical point (deterministic) forecasts of power
output. The forecasts were generated every 30 minutes with a 5-minute [resolution](@ref R)
and 1-hour [horizon](@ref H). We also have
measurements what actually happened at 5-minute resolution over the 2 hours.

For the loads, note that the forecast data is missing. We only have the historical
measurements of total load for the system, which is normalized to the system's peak load.

Load the `PowerSystems`, `Dates`, and `TimeSeries` packages to get started:

```@repl timeseries
using PowerSystems
using Dates
using TimeSeries
```

As usual, we need to define a power [`System`](@ref) that holds all our data. Let's define
a simple system with a bus, a wind generator, and two loads:

```@repl timeseries
system = System(100.0); # 100 MVA base power

bus1 = ACBus(;
    number = 1,
    name = "bus1",
    bustype = ACBusTypes.REF,
    angle = 0.0,
    magnitude = 1.0,
    voltage_limits = (min = 0.9, max = 1.05),
    base_voltage = 230.0,
);

wind1 = RenewableDispatch(;
    name = "wind1",
    available = true,
    bus = bus1,
    active_power = 0.0, # Per-unitized by device base_power
    reactive_power = 0.0, # Per-unitized by device base_power
    rating = 1.0, # 10 MW per-unitized by device base_power
    prime_mover_type = PrimeMovers.WT,
    reactive_power_limits = (min = 0.0, max = 0.0), # per-unitized by device base_power
    power_factor = 1.0,
    operation_cost = RenewableGenerationCost(nothing),
    base_power = 10.0, # MVA
);

load1 = PowerLoad(;
    name = "load1",
    available = true,
    bus = bus1,
    active_power = 0.0, # Per-unitized by device base_power
    reactive_power = 0.0, # Per-unitized by device base_power
    base_power = 10.0, # MVA
    max_active_power = 1.0, # 10 MW per-unitized by device base_power
    max_reactive_power = 0.0,
);

load2 = PowerLoad(;
    name = "load2",
    available = true,
    bus = bus1,
    active_power = 0.0, # Per-unitized by device base_power
    reactive_power = 0.0, # Per-unitized by device base_power
    base_power = 30.0, # MVA
    max_active_power = 1.0, # 10 MW per-unitized by device base_power
    max_reactive_power = 0.0,
);

add_components!(system, [bus1, wind1, load1, load2])
```

Recall that we can also set the `System`'s unit base to natural units (MW)
to make it easier to inspect results:

```@repl timeseries
set_units_base_system!(system, "NATURAL_UNITS")
```

Before we get started, print `wind1` to see its data:

```@repl timeseries
wind1
```

See the `has_time_series` field at the bottom is `false`.

Recall that we also can see a summary of the system by printing it:

```@repl timeseries
system
```

Observe that there is no mention of time series data in the system yet.

# Add and Retrieve a Single Time Series

Let's start by defining and attaching the wind measurements shown in the data above.
This is a single time series profile, so we will use a [`SingleTimeSeries`](@ref).

First, define a `TimeSeries.TimeArray` of input data, using the 5-minute
[resolution](@ref R) to define the time-stamps in the example data:

```@repl timeseries
wind_values = [6.0, 7, 7, 6, 7, 9, 9, 9, 8, 8, 7, 6, 5, 5, 5, 5, 5, 6, 6, 6, 7, 6, 7, 7];
resolution = Dates.Minute(5);
timestamps = range(DateTime("2020-01-01T08:00:00"); step = resolution, length = 24);
wind_timearray = TimeArray(timestamps, wind_values);
```

Now, use the input data to define a Single Time Series in PowerSystems:

```@repl timeseries
wind_time_series = SingleTimeSeries(;
    name = "max_active_power",
    data = wind_timearray,
);
```

Note that we've chosen the name `max_active_power`, which is the default time series profile
name when using
[PowerSimulations.jl](https://nrel-sienna.github.io/PowerSimulations.jl/stable/formulation_library/RenewableGen/)
for simulations.

So far, this time series has been defined, but not attached to our `System` in any way. Now,
attach it to `wind1` using [`add_time_series!`](@ref add_time_series!(sys::System, component::Component, time_series::TimeSeriesData; features...)):

```@repl timeseries
add_time_series!(system, wind1, wind_time_series);
```

Let's double-check this worked by calling [`show_time_series`](@ref):

```@repl timeseries
show_time_series(wind1)
```

Now `wind1` has the first time-series data set. Recall that you can also print `wind1` and
check the `has_time_series` field like we did above.

Finally, let's retrieve and inspect the new timeseries, using `get_time_series_array`:

```@repl timeseries
get_time_series_array(SingleTimeSeries, wind1, "max_active_power")
```

Verify this matches your expectation based on the input data.

# Add and Retrieve a Forecast

Next, let's add the wind power forecasts. We will use a [`Deterministic`](@ref) format for
the point forecasts.

Because we have forecasts with at different [initial times](@ref I), the input data must be
a dictionary where the keys are the initial times and the values are vectors or
`TimeSeries.TimeArray`s of the forecast data.
Set up the example input data:

```@repl timeseries
wind_forecast_data = Dict(
    DateTime("2020-01-01T08:00:00") => [5.0, 6, 7, 7, 7, 8, 9, 10, 10, 9, 7, 5],
    DateTime("2020-01-01T08:30:00") => [9.0, 9, 9, 9, 8, 7, 6, 5, 4, 5, 4, 4],
    DateTime("2020-01-01T09:00:00") => [6.0, 6, 5, 5, 4, 5, 6, 7, 7, 7, 6, 6],
);
```

Define the `Deterministic` forecast and attach it to `wind1`:

```@repl timeseries
wind_forecast = Deterministic("max_active_power", wind_forecast_data, resolution);
add_time_series!(system, wind1, wind_forecast);
```

Let's call `show_time_series` once again:

```@repl timeseries
show_time_series(wind1)
```

Notice that we now have two types of time series listed -- the single time series and
the forecasts.

Finally, let's retrieve the forecast data to double check it was added properly, specifying
the initial time to get the 2nd forecast window starting at 8:30:

```@repl timeseries
get_time_series_array(
    Deterministic,
    wind1,
    "max_active_power";
    start_time = DateTime("2020-01-01T08:30:00"),
)
```

# Add A Time Series Using Scaling Factors

Let's add the load time series. Recall that this data is normalized to the peak system
power, so we'll use it to scale both of our loads. We call normalized time series data
*scaling factors*.

First, let's create our input data `TimeSeries.TimeArray` with the example data and the same
time stamps we used in the wind time series:

```@repl timeseries
load_values = [0.3, 0.3, 0.3, 0.3, 0.4, 0.4, 0.4, 0.4, 0.5, 0.5, 0.6, 0.6,
    0.7, 0.8, 0.8, 0.8, 0.8, 0.8, 0.9, 0.8, 0.8, 0.8, 0.8, 0.8];
load_timearray = TimeArray(timestamps, load_values);
```

Again, define a [`SingleTimeSeries`](@ref), but this time use the
`scaling_factor_multiplier`parameter to scale this time series from
normalized values to power values:

```@repl timeseries
load_time_series = SingleTimeSeries(;
    name = "max_active_power",
    data = load_timearray,
    scaling_factor_multiplier = get_max_active_power,
);
```

Notice that we assigned the
[`get_max_active_power`](@ref get_max_active_power(value::PowerLoad)) *function*
to scale the time series, rather than a value, making the time series reusable for multiple
components or multiple fields in a component.

Now, add the scaling factor time series to both loads to save memory and avoid data
duplication:

```@repl timeseries
add_time_series!(system, [load1, load2], load_time_series);
```

Let's take a look at `load1`, including printing its parameters...

```@repl timeseries
load1
```

...as well as its time series:

```@repl timeseries
show_time_series(load1)
```

!!! tip "Important"
    
    Notice that each load now has two references to `max_active_power`. This is intentional.
    There is the parameter, `max_active_power`, which is  the
    maximum demand of each load at any time (10 MW). There is also `max_active_power` the time
    series, which is the time varying demand over the 2-hour window, calculated using the
    scaling factors and the `max_active_power` parameter.
    
    This means that if we change the `max_active_power` parameter, the time series will
    also change when we retrieve it! This is also true when we apply the same scaling factors
    to multiple components or parameters.

Let's check the impact that these two `max_active_power` data sources have on the times
series data when we retrieve it. Get the `max_active_power` time series for `load1`:

```@repl timeseries
get_time_series_array(SingleTimeSeries, load1, "max_active_power") # in MW
```

See that the normalized values have been scaled up by 10 MW.

Now let's at `load2`. First check its `max_active_power` parameter:

```@repl timeseries
get_max_active_power(load2)
```

This has a higher peak maximum demand of 30 MW.

Next, retrieve it's `max_active_power` time series:

```@repl timeseries
get_time_series_array(SingleTimeSeries, load2, "max_active_power") # in MW
```

Observe the difference compared to `load1`'s time series.

Finally, retrieve the underlying time series data with no scaling factor multiplier
applied:

```@repl timeseries
get_time_series_array(SingleTimeSeries,
    load2,
    "max_active_power";
    ignore_scaling_factors = true,
)
```

Notice that this is the normalized input data, which is still being stored underneath. Each
load is using a reference to that data when we call `get_time_series_array` to avoid
unnecessary data duplication.

# Transform a `SingleTimeSeries` into a Forecast

Finally, let's use a workaround to handle the missing load forecast data. We will assume a
perfect forecast where the forecast is based on the `SingleTimeSeries` we just added.

Rather than unnecessarily duplicating and reformatting data, use PowerSystems.jl's dedicated
[`transform_single_time_series!`](@ref) function to generate a [`DeterministicSingleTimeSeries`](@ref),
which saves memory while behaving just like a `Deterministic` forecast:

```@repl timeseries
transform_single_time_series!(
    system,
    Dates.Hour(1), # horizon
    Dates.Minute(30), # interval
);
```

Let's see the results for `load1`'s time series summary:

```@repl timeseries
show_time_series(load1)
```

Notice we now have a load forecast data set with the resolution, horizon, and, interval
matching our wind forecasts.

Retrieve the first forecast window:

```@repl timeseries
get_time_series_array(
    DeterministicSingleTimeSeries,
    load1,
    "max_active_power";
    start_time = DateTime("2020-01-01T08:00:00"),
)
```

See that `load1`'s scaling factor multiplier is still being applied as expected.

Continue to the next section to address one more impact of calling
`transform_single_time_series!` on the entire `System`.

# Finding, Retrieving, and Inspecting Time Series

Now, let's complete this tutorial by doing a few sanity checks on the data that we've added,
where are we will also examine components with time series and retrieve
the time series data in a few more ways.

First, recall that we can print a component to check its `has_time_series` field:

```@repl timeseries
load1
```

Also, recall we can print the `System` to summarize the data in our system:

```@repl timeseries
system
```

Notice that a new table has been added -- the Time Series Summary, showing the count of
each Type of component that has a given time series type.

Additionally, see that there are both `Deterministic` and `DeterministicSingleTimeSeries`
forecasts for our `RenewableDispatch` generator (`wind1`). This was a side effect of
`transform_single_time_series!` which added `DeterministicSingleTimeSeries` for all
`StaticTimeSeries` in the system, even though we don't need one for wind.

Let's remove it with [`remove_time_series!`](@ref). Since we have one wind generator,
we could easily do it for that component, but let's do programmatically instead by
its Type:

```@repl timeseries
for g in get_components(x -> has_time_series(x), RenewableDispatch, system)
    remove_time_series!(system, DeterministicSingleTimeSeries, g, "max_active_power")
end
```

Notice that we also filtered for components where `has_time_series` is `true`,
which is a simple way to find and manipulate components with time series.

Let's double check `wind1` now:

```@repl timeseries
show_time_series(wind1)
```

See the unnecessary data is gone.

Finally, let's do a last data sanity check on the forecasts. Since we defined the wind
time series in MW instead of scaling factors, let's make sure none of our forecasts exceeds
the `max_active_power` parameter.

Instead of using `get_time_series_array` where we need to remember some details of
the time series we're looking up, let's use [`get_time_series_keys`](@ref) to refresh our
memories:

```@repl timeseries
keys = get_time_series_keys(wind1)
```

See the forecast key is first, so let's retrieve it using [`get_time_series`](@ref):

```@repl timeseries
forecast = get_time_series(wind1, keys[1])
```

See that unlike when we used `get_time_series_array`, this returns an object we can
manipulate.

Use [`iterate_windows`](@ref) to cycle through the 3 forecast windows and inspect the peak
value:

```@repl timeseries
for window in iterate_windows(forecast)
    @show values(maximum(window))
end
```

Finally, use [`get_max_active_power`](@ref get_max_active_power(d::RenewableGen)) to
check the expected maximum:

```@repl timeseries
get_max_active_power(wind1)
```

See that the forecasts are not exceeding this maximum -- sanity check complete.

!!! tip
    
    Unlike `PowerLoad` components, `RenewableDispatch` components do not have a
    `max_active_power` field, so check
    [`get_max_active_power`](@ref get_max_active_power(d::RenewableGen))
    to see how its calculated.

# Next Steps

In this tutorial, you defined, added, and retrieved four time series data
sets, including static time series and deterministic forecasts. Along the way, we
reduced data duplication using normalized scaling factors for reuse by multiple components
or component fields, as well as by referencing a `StaticTimeSeries` to address missing
forecast data.

Next you might like to:

  - [Parse many timeseries data sets from CSV's](@ref parsing_time_series)
  - [See how to improve performance efficiency with your own time series data](@ref "Improve Performance with Time Series Data")
  - [Review the available time series data formats](@ref ts_data)
  - [Learn more about how times series data is stored](@ref "Data Storage")
