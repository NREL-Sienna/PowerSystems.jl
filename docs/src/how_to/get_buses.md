# Get the buses in a System

```@setup get_buses
using PowerSystems; #hide
using PowerSystemCaseBuilder #hide
system = build_system(PSISystems, "modified_RTS_GMLC_DA_sys"); #hide
```

You can access all the buses in a `System` to view or manipulate their data using two
key functions: `get_components` or `get_buses`.

#### Option 1a: Get an iterator for all the buses

Use [`get_components`](@ref get_components(::Type{T}, sys::System; subsystem_name = nothing, ) where {T <: Component})
to get an iterator of all the AC buses in an existing [`system`](@ref System):

```@repl get_buses
bus_iter = get_components(ACBus, system)
```

The iterator avoids unnecessary memory allocations if there are many buses, and it can be
used to view or update the bus data.
For example, we can set the base voltage of all buses to 330 kV:
```@repl get_buses
for b in bus_iter
    set_base_voltage!(b, 330.0)
end
```

#### Option 1b: Get a vector of all the buses

Use `collect` to get a vector of the buses instead of an iterator, which could require a lot
of memory:
```@repl get_buses
buses = collect(get_components(ACBus, system))
```

#### Option 2a: Get the buses in an Area or LoadZone

Use [`get_buses`](@ref) to get a vector of buses when you know which [`Area`](@ref) or
[`LoadZone`](@ref) you are interested in.

First, we select an Area:
```@repl get_buses
show_components(Area, system) # See available Areas
area2 = get_component(Area, system, "2"); # Get Area named 2
```

Then call `get_buses` for that Area:
```@repl get_buses
area_buses = get_buses(system, area2)
```

####  Option 2b: Get buses by ID number

Finally, use [`get_buses`](@ref get_buses(sys::System, bus_numbers::Set{Int})) to get a
vector of buses by their ID numbers.

Example getting buses with ID numbers from 101 to 110:
```@repl get_buses
buses_by_ID = get_buses(system, Set(101:110))
```

!!! note
    You can combine this with Option 1 to first view all the bus numbers if needed:
    ```@repl get_buses
    get_number.(get_components(ACBus, system))
    ```
