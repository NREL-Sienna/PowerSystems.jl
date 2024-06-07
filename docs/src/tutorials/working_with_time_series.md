### `TimeSeriesData`

```@setup timeseries
using PowerSystems #hide
import TypeTree: tt #hide
docs_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "utils"); #hide
include(joinpath(docs_dir, "docs_utils.jl")); #hide

BASE_DIR = abspath(joinpath(dirname(Base.find_package("PowerSystems")), "..")); #hide
include(joinpath(BASE_DIR, "test", "data_5bus_pu.jl")); #.jl file containing 5-bus system data
nodes_5 = nodes5(); # function to create 5-bus buses 
thermal_generators5(nodes_5); # function to create thermal generators in 5-bus buses 
renewable_generators5(nodes_5); # function to create renewable generators in 5-bus buses
loads5(nodes_5); # function to create the loads
branches5(nodes_5); # function to create the branches
sys = System(
           100.0,
           nodes_5,
           vcat(
             thermal_generators5(nodes_5),
             renewable_generators5(nodes_5)),
             loads5(nodes_5),
             branches5(nodes_5),
       ); #hide
```

[_Read the Docs!_](https://nrel-sienna.github.io/PowerSystems.jl/stable/modeler_guide/time_series/)
Some `Component` types support time series data (refer to `supports_time_series(component)`.
`TimeSeriesData` are used to hold time series information that describes the
temporally dependent data of fields within the same struct. For example, the
`ThermalStandard.time_series_container` field can
describe other fields in the struct (`available`, `activepower`, `reactivepower`).

`TimeSeriesData`s themselves can take the form of the following:

```@repl timeseries
print(join(tt(TimeSeriesData), "")) #hide
```

In each case, the time series contains fields for `scaling_factor_multiplier` and `data`
to identify the details of  th `Component` field that the time series describes, and the
time series `data`. For example: we commonly want to use a time series to
describe the maximum active power capability of a renewable generator. In this case, we
can create a `SingleTimeSeries` with a `TimeArray` and an accessor function to the
maximum active power field in the struct describing the generator. In this way, we can
store a scaling factor time series that will get multiplied by the maximum active power
rather than the magnitudes of the maximum active power time series.

```@repl timeseries
print_struct(Deterministic) #hide
```

Examples of how to create and add time series to system can be found in the
[Add Time Series Example](https://nrel-sienna.github.io/PowerSystems.jl/stable/tutorials/add_forecasts/)


#### Accessing `TimeSeries`

First we need to add some time series to the `System`:

```@repl timeseries
loads = collect(get_components(PowerLoad, sys))
for (l, ts) in zip(loads, load_timeseries_DA[2])
    add_time_series!(
        sys,
        l,
        Deterministic(
            "activepower",
            Dict(TimeSeries.timestamp(load_timeseries_DA[2][1])[1] => ts),
        ),
    )
end
```

If we want to access a specific time series for a specific component, we need to specify:

- time series type
- `component`
- initial_time
- label

We can find the initial time of all the time series in the system:

```@repl timeseries
get_forecast_initial_times(sys)
```

We can find the names of all time series attached to a component:

```@repl timeseries
show_time_series(loads[1])
```

We can access a specific time series for a specific component:

```@repl timeseries
ta = get_time_series_array(Deterministic, loads[1], ts_names[1])
```

Or, we can just get the values of the time series:

```@repl timeseries
ts = get_time_series_values(Deterministic, loads[1], ts_names[1])
```
