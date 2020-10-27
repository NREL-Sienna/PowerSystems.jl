# System

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
types as described by the [Type Structure](@ref). Given the potential size of the return,
`PowerSystems.jl`returns Julia iterators in order to avoid unnecessary memory allocations.

```@example get_components
using PowerSystems #hide
const PSY = PowerSystems #hide
DATA_DIR = "../../../data" #hide
system = System(joinpath(DATA_DIR, "matpower/RTS_GMLC.m")) #hide
thermal_gens = get_components(ThermalStandard, system)
```

The most common filtering requirement is by component name and for this case the method
[`get_component`](@ref) returns a single component taking the device type, system and name as arguments.

```@example get_components
using PowerSystems #hide
const PSY = PowerSystems #hide
DATA_DIR = "../../../data" #hide
system = System(joinpath(DATA_DIR, "matpower/RTS_GMLC.m")) #hide
my_thermal_gen = get_component(ThermalStandard, system, "323_CC_1")
```

## JSON Serialization

`PowerSystems.jl` provides functionality to serialize an entire system to a JSON
file and then deserialize it back to a system. The main benefit is that
deserializing is significantly faster than reconstructing the system from raw
data files.

The function that serializes the system [`to_json`](@ref) requires the system and a file name

```@example get_components
using PowerSystems #hide
const PSY = PowerSystems #hide
DATA_DIR = "../../../data" #hide
system = System(joinpath(DATA_DIR, "matpower/RTS_GMLC.m"))
to_json(system, "system.json")
```

The serialization process stores 3 files

1. System data file (`*.json` file)
2. Validation data file (`*.json` file)
3. Time Series data file (`*.h5` file)
