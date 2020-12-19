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
`PowerSystems.jl`returns Julia iterators in order to avoid unnecessary memory allocations.

```@example get_components
using PowerSystems #hide
DATA_DIR = "../../../data" #hide
system = System(joinpath(DATA_DIR, "matpower/RTS_GMLC.m")) #hide
thermal_gens = get_components(ThermalStandard, system)
```

It is also possible to execute [`get_components`](@ref) with abstract types from the
[abstract tree](@ref type_structure). For instance, it is possible to retrieve all renewable
generators

```@example get_components
thermal_gens = get_components(RenewableGen, system)
```

The most common filtering requirement is by component name and for this case the method
[`get_component`](@ref) returns a single component taking the device type, system and name as arguments.

```@example get_components
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

```@example get_active_power_limits
using PowerSystems #hide
DATA_DIR = "../../../data" #hide
system = System(joinpath(DATA_DIR, "matpower/RTS_GMLC.m")) #hide
my_thermal_gen = get_component(ThermalStandard, system, "323_CC_1") #hide
get_active_power_limits(my_thermal_gen)
```

## [Per-unit conventions and data conversions](@id per_unit)

It is often useful to express power systems data in relative terms using per-unit conventions.
`PowerSystems.jl` supports the automatic conversion of data between three different unit systems:

 1. Natural Units: The naturally defined units of each parameter (typically MW).
 2. System Base: Parameter values are divided by the system `base_power`
 3. Device Base: Parameter values are divided by the component/device `base_mva`

To see the unit system setting of a `System`:

```@example get_units_base
using PowerSystems #hide
DATA_DIR = "../../../data" #hide
system = System(joinpath(DATA_DIR, "matpower/RTS_GMLC.m")) #hide
get_units_base(system)
```

To change the unit system setting of a `System`:

```julia
set_units_base_system!(system, "DEVICE_BASE")
```

The units of the parameter values stored in each struct are defined in
`src/descriptors/power_system_structs.json`. Conversion between unit systems does not change
the stored parameter values. Instead, unit system conversions are made when accessing
parameters using the accessor functions ([see above](@ref dot_access)), thus making it
imperative to utilize the accessor functions instead of the "dot" accessor methods to
ensure the return of the correct values.

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

## Reducing REPL printing

By default `PowerSystems.jl` outputs to the REPL all Logging values, this can be overwhelming
in some cases. Use [`configure_logging`](@ref) to create a logger with your preferences
(console and/or file, levels, etc.). For more detail refer to [Logging`(@ref logging).

**Example**: Set log output to only error messages

```julia
using PowerSystems
using Logging
configure_logging(console_level = Logging.Error)
```

**Note:** log messages are not automatically flushed to files. Call
`flush(logger)` to make this happen.

**Example**: Global logger configuration

```julia
logger = configure_logging(filename = "log.txt")
@info "hello world"
flush(logger)
@error "some error"
close(logger)
```

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
jq '.data.components | keys' system.json
```

- View specific components

```zsh
jq '.data.components.ThermalStandard' system.json
```

- Get the count of a component type

```zsh
jq '.data.components.Bus  | length' system.json
```

- View specific component by index

```zsh
jq '.data.components.ThermalStandard | .[0]' system.json
```

- View specific component by name

```zsh
jq '.data.components.ThermalStandard | .[] | select(.name == "107_CC_1")' system.json
```

- View the field names for a component

```zsh
jq '.data.components.ThermalStandard | .[0] | keys' system.json
```

- Filter on a field value

```zsh
jq '.data.components.ThermalStandard | .[] | select(.active_power > 2.3)' system.json
```

- Output a table with select fields

```zsh
jq -r '["name", "econ.capacity"], (.data.components.ThermalStandard | .[] | [.name, .active_power]) | @tsv' system.json
```

- View the time_series information for a component

```zsh
jq '.data.components.ThermalStandard | .[0] | .time_series' system.json
```
