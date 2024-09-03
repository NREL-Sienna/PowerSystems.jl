# [System](@id system_doc)

The `System` is the main container of components and the time series data references.
`PowerSystems.jl` uses a hybrid approach to data storage, where the component data and time
series references are stored in volatile memory while the actual time series data is stored
in an HDF5 file. This design loads into memory the portions of the data that are relevant
at time of the query, and so avoids overwhelming the memory resources.

```@raw html
<img src="../../assets/System.png" width="50%"/>
```

## Accessing components stored in the `System`

`PowerSystems.jl` implements a wide variety of methods to search for components to
aid in data manipulation. Most of these use the [Type Structure](@ref type_structure) to
retrieve all components of a certain `Type`.

For example, the most common search function is [`get_components`](@ref), which
takes a desired device `Type` (concrete or abstract) and retrieves all components in that
category from the `System`. It also accepts filter functions for a more
refined search. 

Given the potential size of the return,
`PowerSystems.jl` returns Julia iterators in order to avoid unnecessary memory allocations.
The container is optimized for iteration over abstract or concrete component
types as described by the [Type Structure](@ref type_structure). 

## [Accessing data stored in a component](@id dot_access)

__Using the "dot" access to get a parameter value from a component is actively discouraged, use "getter" functions instead__

Using code autogeneration, `PowerSystems.jl` implements accessor (or "getter") functions to
enable the retrieval of parameters defined in the component struct fields. Julia syntax enables
access to this data using the "dot" access (e.g. `component.field`), however
_this is actively discouraged_ for two reasons:

 1. We make no guarantees on the stability of component structure definitions. We will maintain version stability on the accessor methods.
 2. Per-unit conversions are made in the return of data from the accessor functions. (see the [per-unit section](@ref per_unit) for more details)