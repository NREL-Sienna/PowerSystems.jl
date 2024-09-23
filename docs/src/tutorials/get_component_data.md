# [Getting, Setting, and Viewing Data](@id get_components_tutorial )

In this tutorial, we will explore the data in a `System`, including looking at a summary of
the system and getting both its components and their data. We will also start checking for
time-series data, which we will explore more in the tutorial on
[Working with Time Series Data](@ref tutorial_time_series).

In [Create and Explore a Power `System`](@ref), we created a basic `System` with nodes, a transmission
line, and a few generators. Let's recreate that system if you don't have it already: 


```@setup get_component_data
using PowerSystems;
sys = System(100.0);
bus1 = ACBus(1, "bus1", ACBusTypes.REF, 0.0, 1.0, (min = 0.9, max = 1.05), 230.0);
bus2 = ACBus(2, "bus2", ACBusTypes.PV, 0.0, 1.0, (min = 0.9, max = 1.05), 230.0);

```

PowerSystems provides functional interfaces to all data. The following examples outline
the intended approach to accessing data expressed using PowerSystems.

PowerSystems enforces unique `name` fields between components of a particular concrete type.
So, in order to retrieve a specific component, the user must specify the type of the component
along with the name and system

#### Accessing components and their data

```@repl get_components
get_component(ACBus, sys, "nodeA")
get_component(Line, sys, "1")
```

Similarly, you can access all the components of a particular type: *note: the return type
of get_components is a `FlattenIteratorWrapper`, so call `collect` to get an `Array`

```@repl get_components
get_components(ACBus, sys) |> collect
```

`get_components` also works on abstract types:

```@repl get_components
get_components(Branch, sys) |> collect
```

The fields within a component can be accessed using the `get_*` functions:
*It's highly recommended that users avoid using the `.` to access fields since we make no
guarantees on the stability field names and locations. We do however promise to keep the
accessor functions stable.*

```@repl get_components
bus1 = get_component(ACBus, sys, "nodeA")
@show get_name(bus1);
@show get_magnitude(bus1);
nothing #hide
```
