# Basics

This tutorial shows some basic operations that you can do in PowerSystems.jl with your data.

## Types in PowerSystems

PowerSystems.jl provides a type hierarchy for specifying power system data. Data that
describes infrastructure components is held in `struct`s. For example, a `Bus` is defined
as follows with fields for the parameters required to describe a bus (along with an
`internal` field used by InfrastructureSystems to improve the efficiency of handling data).

````@example basics
print_struct(Bus)
````

### Type Hierarchy

PowerSystems is intended to organize data containers by the behavior of the devices that
the data represents. To that end, a type hierarchy has been defined with several levels of
abstract types starting with `InfrastructureSystemsType`. There are a bunch of subtypes of
`InfrastructureSystemsType`, but the important ones to know about are:
- `Component`: includes all elements of power system data
  - `Topology`: includes non physical elements describing network connectivity
  - `Service`: includes descriptions of system requirements (other than energy balance)
  - `Device`: includes descriptions of all the physical devices in a power system
- `InfrastructureSystems.DeviceParameter`: includes structs that hold data describing the
 dynamic, or economic capabilities of `Device`.
- `TimeSeriesData`: Includes all time series types
  - `Forecast`: includes structs to define time series of forecasted data where multiple
values can represent each time stamp
  - `StaticTimeSeries`: includes structs to define time series with a single value for each
time stamp
- `System`: collects all of the `Component`s

````@example basics
print_tree(PowerSystems.IS.InfrastructureSystemsType)
````

### `TimeSeriesData`

[_Read the Docs!_](https://nrel-siip.github.io/PowerSystems.jl/stable/modeler_guide/time_series/)
Every `Component` has a `time_series_container::InfrastructureSystems.TimeSeriesContainer`
field. `TimeSeriesData` are used to hold time series information that describes the
temporally dependent data of fields within the same struct. For example, the
`ThermalStandard.time_series_container` field can
describe other fields in the struct (`available`, `activepower`, `reactivepower`).

`TimeSeriesData`s themselves can take the form of the following:

````@example basics
print_tree(TimeSeriesData)
````

In each case, the time series contains fields for `scaling_factor_multiplier` and `data`
to identify the details of  th `Component` field that the time series describes, and the
time series `data`. For example: we commonly want to use a time series to
describe the maximum active power capability of a renewable generator. In this case, we
can create a `SingleTimeSeries` with a `TimeArray` and an accessor function to the
maximum active power field in the struct describing the generator. In this way, we can
store a scaling factor time series that will get multiplied by the maximum active power
rather than the magnitudes of the maximum active power time series.

````@example basics
print_struct(Deterministic)
````

Examples of how to create and add time series to system can be found in the
[Add Time Series Example](https://nbviewer.jupyter.org/github/NREL-SIIP/SIIPExamples.jl/blob/main/notebook/2_PowerSystems_examples/05_add_forecasts.ipynb)

### System

The `System` object collects all of the individual components into a single struct along
with some metadata about the system itself (e.g. `base_power`)

````@example basics
print_struct(System)
````

## Example Code

PowerSystems contains a few basic data files (mostly for testing and demonstration).

````@example basics
BASE_DIR = abspath(joinpath(dirname(Base.find_package("PowerSystems")), ".."))
include(joinpath(BASE_DIR, "test", "data_5bus_pu.jl")) #.jl file containing 5-Bus system data
nodes_5 = nodes5() # function to create 5-Bus buses
````

### Create a `System`

````@example basics
sys = System(
    100.0,
    nodes_5,
    vcat(thermal_generators5(nodes_5), renewable_generators5(nodes_5)),
    loads5(nodes_5),
    branches5(nodes_5),
)
````

### Accessing `System` Data

PowerSystems provides functional interfaces to all data. The following examples outline
the intended approach to accessing data expressed using PowerSystems.

PowerSystems enforces unique `name` fields between components of a particular concrete type.
So, in order to retrieve a specific component, the user must specify the type of the component
along with the name and system

#### Accessing components

````@example basics
@show get_component(Bus, sys, "nodeA")
@show get_component(Line, sys, "1")
````

Similarly, you can access all the components of a particular type: *note: the return type
of get_components is a `FlattenIteratorWrapper`, so call `collect` to get an `Array`

````@example basics
get_components(Bus, sys) |> collect
````

`get_components` also works on abstract types:

````@example basics
get_components(Branch, sys) |> collect
````

The fields within a component can be accessed using the `get_*` functions:
*It's highly recommended that users avoid using the `.` to access fields since we make no
guarantees on the stability field names and locations. We do however promise to keep the
accessor functions stable.*

````@example basics
bus1 = get_component(Bus, sys, "nodeA")
@show get_name(bus1);
@show get_magnitude(bus1);
nothing #hide
````

#### Accessing `TimeSeries`

First we need to add some time series to the `System`

````@example basics
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
````

If we want to access a specific time series for a specific component, we need to specify:
 - time series type
 - `component`
 - initial_time
 - label

We can find the initial time of all the time series in the system:

````@example basics
get_forecast_initial_times(sys)
````

We can find the names of all time series attached to a component:

````@example basics
ts_names = get_time_series_names(Deterministic, loads[1])
````

We can access a specific time series for a specific component:

````@example basics
ta = get_time_series_array(Deterministic, loads[1], ts_names[1])
````

Or, we can just get the values of the time series:

````@example basics
ts = get_time_series_values(Deterministic, loads[1], ts_names[1])
````
