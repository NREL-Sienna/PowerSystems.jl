# System

The `System` is the main container of components and the time series data references.
`PowerSystems.jl` uses a hybrid approach to data storage, as shown in Figure \ref{fig:system`,
where the component data and time series references are stored in volatile memory while the
actual time series data is stored in an HDF5 file. This design loads into memory the portions
of the data that are relevant at time of the query, and so avoids overwhelming the memory resources.

`PowerSystems.jl` implements a wide variety of methods to search for components to
aid in the development of models. The code bloc shows an example of
retrieving components through the type hierarchy with the [`get_components`](@ref)
function and exploiting the type hierarchy for modeling purposes. The default implementation
of the function [`get_components`](@ref) takes the desired device type (concrete or abstract)
and the system and it also accepts filter functions for a more refined search. The most common
filtering requirement is by component name and for this case the method [`get_component`](@ref)
returns a single component taking the device type, system and name as arguments.
The container is optimized for iteration over abstract or concrete component types
as described by the type hierarchy. Given the potential size of the return, `PowerSystems.jl`
returns Julia iterators in order to avoid unnecessary memory allocations.
