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

# copied over from the System

## Accessing components stored in the system

<!-- 
`PowerSystems.jl` implements a wide variety of methods to search for components to
aid in the development of models. The code block shows an example of
retrieving components through the type hierarchy with the [`get_components`](@ref)
function and exploiting the type hierarchy for modeling purposes.

The default implementation of the function [`get_components`](@ref) takes the desired device
type (concrete or abstract) and the system and it also accepts filter functions for a more
refined search. The container is optimized for iteration over abstract or concrete component
types as described by the [Type Structure](@ref type_structure). Given the potential size of the return,
`PowerSystems.jl` returns Julia iterators in order to avoid unnecessary memory allocations. -->
```@repl system
using PowerSystems
file_dir = joinpath(pkgdir(PowerSystems), "docs", "src", "tutorials", "tutorials_data")
system = System(joinpath(file_dir, "RTS_GMLC.m"));
thermal_gens = get_components(ThermalStandard, system)
```

It is also possible to execute [`get_components`](@ref) with abstract types from the
[abstract tree](@ref type_structure). For instance, it is possible to retrieve all renewable
generators

```@repl system
thermal_gens = get_components(RenewableGen, system)
```

The most common filtering requirement is by component name and for this case the method
[`get_component`](@ref) returns a single component taking the device type, system and name as arguments.

```@repl system
my_thermal_gen = get_component(ThermalStandard, system, "323_CC_1")
```

## Accessing data stored in a component

__Using the "dot" access to get a parameter value from a component is actively discouraged, use "getter" functions instead__

<!-- Using code autogeneration, `PowerSystems.jl` implements accessor (or "getter") functions to
enable the retrieval of parameters defined in the component struct fields. Julia syntax enables
access to this data using the "dot" access (e.g. `component.field`), however
_this is actively discouraged_ for two reasons:

 1. We make no guarantees on the stability of component structure definitions. We will maintain version stability on the accessor methods.
 2. Per-unit conversions are made in the return of data from the accessor functions. (see the [per-unit section](@ref per_unit) for more details) -->
For example, the `my_thermal_gen.active_power_limits` parameter of a thermal generator should be accessed as follows:

```@repl system
get_active_power_limits(my_thermal_gen)
```

You can also view data from all instances of a concrete type in one table with the function `show_components`. It provides a few options:

 1. View the standard fields by accepting the defaults.
 2. Pass a dictionary where the keys are column names and the values are functions that accept a component as a single argument.
 3. Pass a vector of symbols that are field names of the type.

```@repl system
show_components(system, ThermalStandard)
show_components(system, ThermalStandard, Dict("has_time_series" => x -> has_time_series(x)))
show_components(system, ThermalStandard, [:active_power, :reactive_power])
```

# to do: add a link in the system that MD explanation to these examples
