# Get the available generators in a System

```@setup get_gens
using PowerSystems; #hide
using PowerSystemCaseBuilder #hide
system = build_system(PSISystems, "modified_RTS_GMLC_DA_sys"); #hide
```

You can access use [`get_available_components`](@ref) or
[`get_components`](@ref get_components(::Type{T}, sys::System; subsystem_name = nothing, ) where {T <: Component})
to access all the available generators in an existing [`system`](@ref System).

#### Option 1a: Using `get_available_components` to get an iterator

Use [`get_available_components`](@ref) to get an iterator of all the available generators in
an existing [`system`](@ref System), which also prints a summary:

```@repl get_gens
gen_iter = get_available_components(Generator, system)
```

The iterator avoids unnecessary memory allocations if there are many generators, and it can
be used to view or update the generator data, such as seeing each of the names:

```@repl get_gens
get_name.(gen_iter)
```

!!! tip
    
    Above, we use the abstract supertype [`Generator`](@ref) to get all components that are
    subtypes of it. You can instead get all the components of a concrete type, such as:
    
    ```@repl get_gens
    gen_iter = get_available_components(RenewableDispatch, system)
    ```

#### Option 1b: Using `get_available_components` to get a vector

Use `collect` to get a vector of the generators instead of an iterator, which could require
a lot of memory:

```@repl get_gens
gens = collect(get_available_components(Generator, system));
```

#### Option 2: Using `get_components` to get an iterator

Alternatively, use [`get_components`](@ref get_components(::Type{T}, sys::System; subsystem_name = nothing, ) where {T <: Component})
with a filter to check for availability:

```@repl get_gens
gen_iter = get_components(get_available, Generator, system)
```

`collect` can also be used to turn this iterator into a vector.

#### See Also

  - How to: [Get the buses in a System](@ref)
