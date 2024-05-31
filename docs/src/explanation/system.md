# [System](@id system_doc)

The `System` is the main container of components and the time series data references.
`PowerSystems.jl` uses a hybrid approach to data storage, where the component data and time
series references are stored in volatile memory while the actual time series data is stored
in an HDF5 file. This design loads into memory the portions of the data that are relevant
at time of the query, and so avoids overwhelming the memory resources.

```@raw html
<img src="../../assets/System.png" width="50%"/>
```

## Accessing components stored in the system

`PowerSystems.jl` implements a wide variety of methods to search for components to
aid in the development of models. The code block shows an example of
retrieving components through the type hierarchy with the [`get_components`](@ref)
function and exploiting the type hierarchy for modeling purposes.

The default implementation of the function [`get_components`](@ref) takes the desired device
type (concrete or abstract) and the system and it also accepts filter functions for a more
refined search. The container is optimized for iteration over abstract or concrete component
types as described by the [Type Structure](@ref type_structure). Given the potential size of the return,
`PowerSystems.jl` returns Julia iterators in order to avoid unnecessary memory allocations.

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

## [Accessing data stored in a component](@id dot_access)

__Using the "dot" access to get a parameter value from a component is actively discouraged, use "getter" functions instead__

Using code autogeneration, `PowerSystems.jl` implements accessor (or "getter") functions to
enable the retrieval of parameters defined in the component struct fields. Julia syntax enables
access to this data using the "dot" access (e.g. `component.field`), however
_this is actively discouraged_ for two reasons:

 1. We make no guarantees on the stability of component structure definitions. We will maintain version stability on the accessor methods.
 2. Per-unit conversions are made in the return of data from the accessor functions. (see the [per-unit section](@ref per_unit) for more details)

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

## JSON Serialization

`PowerSystems.jl` provides functionality to serialize an entire system to a JSON
file and then deserialize it back to a system. The main benefit is that
deserializing is significantly faster than reconstructing the system from raw
data files.

The function that serializes the system [`to_json`](@ref) requires the system and a file name

```julia
to_json(system, "system.json")
```

The serialization process stores 3 files

1. System data file (`*.json` file)
2. Validation data file (`*.json` file)
3. Time Series data file (`*.h5` file)

To deserialize:

```julia
system2 = System("system.json")
```

PowerSystems generates UUIDs for the System and all components in order to have
a way to uniquely identify objects. During deserialization it restores the same
UUIDs.  If you will modify the System or components after deserialization then
it is recommended that you set this flag to generate new UUIDs.

```julia
system2 = System("system.json", assign_new_uuids = true)
```

## Reducing REPL printing

By default `PowerSystems.jl` outputs to the REPL all Logging values, this can be overwhelming
in some cases. Use [`configure_logging`](@ref) to create a logger with your preferences
(console and/or file, levels, etc.). For more detail refer to [Logging](@ref logging).

**Example**: Set log output to only error messages

```julia
using PowerSystems
using Logging
configure_logging(console_level = Logging.Error)
```

**Note:** log messages are not automatically flushed to files. Call
`flush(logger)` to make this happen.

Refer to this
[page](https://nrel-sienna.github.io/InfrastructureSystems.jl/stable/dev_guide/logging/#Use-Cases)
for more logging configuration options. Note that it describes how to enable
debug logging for some log messages but not others.

## Viewing PowerSystems Data in JSON Format

PowerSystems data can be serialized and deserialized in JSON. This section shows how to
explore the data outside of Julia using.

```julia
system = System("system.json")
```

It can be useful to view and filter the PowerSystems data in this format. There
are many tools available to browse JSON data.

Here is an example [GUI tool](http://jsonviewer.stack.hu) that is available
online in a browser.

The command line utility [jq](https://stedolan.github.io/jq/) offers even more
features. The rest of this document provides example commands.

- View the entire file pretty-printed

```zsh
jq . system.json
```

- View the PowerSystems component types

```zsh
jq '.data.components | .[] | .__metadata__ | .type' system.json | sort | uniq
```

- View specific components

```zsh
jq '.data.components | .[] | select(.__metadata__.type == "ThermalStandard")' system.json
```

- Get the count of a component type

```zsh
# There is almost certainly a better way.
jq '.data.components | .[] | select(.__metadata__.type == "ThermalStandard")' system.json | grep -c ThermalStandard
```

- View specific component by name

```zsh
jq '.data.components | .[] | select(.__metadata__.type == "ThermalStandard" and .name == "107_CC_1")' system.json
```

- Filter on a field value

```zsh
jq '.data.components | .[] | select(.__metadata__.type == "ThermalStandard" and .active_power > 2.3)' system.json
```
