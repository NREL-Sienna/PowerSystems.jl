# Manipulating Datasets

`PowerSystems` provides function interfaces to all data, and in this tutorial we will explore how to do this using the `show_components`,
`get_components`, and getter (`get_*`) and setter (`set_*`) functions.

## Viewing Components in the System

We are going to begin by loading in a test case from the [`PowerSystemCaseBuilder.jl`](@ref psb):

```@repl system
using PowerSystems;
using PowerSystemCaseBuilder;
sys = build_system(PSISystems, "c_sys5_pjm")
```

We can use the [`show_components`](@ref) function to view data in our system. Let's start by viewing all of the [`ThermalStandard`](@ref) components.

```@repl system
show_components(ThermalStandard, sys)
```

We can see there are five thermal generators in the system, and the availability is the standard field returned when using [`show_components`](@ref).

We can also view specific fields within components using the [`show_components`](@ref)
function. For example, we can view the type of `fuel` the thermal generators are using,
and their `active_power` and `reactive_power`:

```@repl system
show_components(ThermalStandard, sys, [:fuel, :active_power, :reactive_power])
```

Notice all our thermal generators are currently fueled by coal.

## Accessing and Updating a Component in a System

We can access a component in our system using the
[`get_component`](@ref get_component(::Type{T}, sys::System, name::AbstractString) where {T <: Component})
function. For example, if we are interested in accessing a [`ThermalStandard`](@ref) component we can
do so using the component's name and `Type` from `PowerSystems.jl`'s [Type Tree](@ref).
From above we know the names of the thermal generators.

```@repl system
solitude = get_component(ThermalStandard, sys, "Solitude")
```

Notice that all of Solitude's fields are pretty-printed with the return statment for
quick reference. However, what is returned is a [`ThermalStandard`](@ref) object we can
manipulate:

```@repl system
typeof(solitude)
```

If we are interested in accessing a particular field, we can use a `get_*` function, also known as a getter,
on this object. For example, if we are interested in the `fuel` we can use [`get_fuel`](@ref get_fuel(value::ThermalStandard)):

```@repl system
get_fuel(solitude)
```

You can see a [`ThermalFuels`](@ref tf_list) option returned.

To recap, [`get_component`](@ref) will return a component object, but we can use a specific `get_*` function to return the data in a particular field.

!!! warning
    
    Using the "dot" access to get a field value from a component is actively discouraged, use `get_*` functions instead.
    Julia syntax enables access to this data using the "dot" access (e.g., `solitude.fuel`), however this is discouraged for two reasons:
    1. We make no guarantees on the stability of component structure definitions. We will maintain version stability on the accessor methods.
    2. Per-unit conversions are made in the return of data from the accessor functions. (see the [per-unit](https://nrel-sienna.github.io/PowerSystems.jl/stable/explanation/per_unit/#per_unit) section for more details)

To update a field we can use a specific `set_*`, or setter, function. We can use [`set_fuel!`](@ref) to update the `fuel` field of Solitude to natural gas.

```@repl system
set_fuel!(solitude, ThermalFuels.NATURAL_GAS)
```

We can use [`show_components`](@ref) again to check that the `Solitude` `fuel` has been
updated to [`ThermalFuels.NATURAL_GAS`](@ref tf_list):

```@repl system
show_components(ThermalStandard, sys, [:fuel])
```

Similarly, you can updated the `active_power` field using its specific `get_*` and `set_*` functions. We can access this field by using the [`get_active_power`](@ref):

```@repl system
get_active_power(solitude)
```

We can then update it using [`set_active_power!`](@ref):

```@repl system
set_active_power!(solitude, 4.0)
```

We can see that our `active_power` field has been updated to 4.0.

## Accessing and Updating Multiple Components in the System at Once

We can also update more than one component at a time using the [`get_components`](@ref get_components(
filter_func::Function,
::Type{T},
sys::System;
subsystem_name = nothing,
) where {T <: Component}) and `set_*` functions.

Let's say we were interested in updating the `base_voltage` field for all of the [`ACBus`](@ref).
We can see that currently the `base_voltages` are:

```@repl system
show_components(ACBus, sys, [:base_voltage])
```

But what if we are looking to change them to 250.0? Let's start by getting an iterator for all the buses using [`get_components`](@ref get_components(
filter_func::Function,
::Type{T},
sys::System;
subsystem_name = nothing,
) where {T <: Component}):

```@repl system
buses = get_components(ACBus, sys)
```

See that the pretty-print summarizes this set of components, but let's check what was actually returned:

```@repl system
typeof(buses)
```

!!! tip
    
    Notice that `PowerSystems.jl` returns Julia iterators in order to avoid unnecessary memory allocations
    that might occur for very large data sets. The [`get_components`](@ref get_components(
    filter_func::Function,
    ::Type{T},
    sys::System;
    subsystem_name = nothing,
    ) where {T <: Component}) function returns an
    iterator that allows you to access and manipulate data without a large memory allocation.
    Use [`collect`](https://docs.julialang.org/en/v1/base/collections/#Base.collect-Tuple%7BAny%7D)
    to gather the data to a vector instead.

Now using the [`set_base_voltage!`](@ref) function and a `for` loop we can update the voltage:

```@repl system
for i in buses
    set_base_voltage!(i, 250.0)
end
```

We could use [`show_components`](@ref) to verify the results, but we can also use a
`get_*` function and Julia's dot notation over our bus iterator to get the data for
a specific field from multiple components:

```@repl system
get_base_voltage.(buses)
```

We can see that all of the buses now have a `base_voltage` of 250.0 kV.

If we are interested in updating the `fuel` in all the thermal generators, we would use a similar approach. We begin by grabbing an iterator for all the components in [`ThermalStandard`](@ref).

```@repl system
thermal_gens = get_components(ThermalStandard, sys)
```

Now, using the [`set_fuel!`](@ref set_fuel!(value::ThermalStandard)) and a `for` loop, we will update the `fuel` to `NATURAL_GAS`.

```@repl system
for i in thermal_gens
    set_fuel!(i, ThermalFuels.NATURAL_GAS)
end
```

We can verify that the `fuel` types for all the thermal generators has been updated,
using dot notation again to access the `fuel` fields:

```@repl system
get_fuel.(get_components(ThermalStandard, sys))
```

## Filtering Specific Data

We have seen how to update a single component, and all the components of a specific type, but what if we are interested in updating only particular components? We can do this using filter functions. For example, let's say we are interested in updating all the `active_power` values of the thermal generators except `Solitude`.
Let's start by seeing the current `active_power` values.

```@repl system
show_components(ThermalStandard, sys, [:active_power])
```

Let's grab an iterator for the all the thermal generators except `Solitude` by adding a filter function
to [`get_components`](@ref get_components(
filter_func::Function,
::Type{T},
sys::System;
subsystem_name = nothing,
) where {T <: Component}):

```@repl system
thermal_not_solitude = get_components(x -> get_name(x) != "Solitude", ThermalStandard, sys)
```

We can see that four [`ThermalStandard`](@ref) components are returned. Now let's update the `active_power` field of these four thermal generators using the [`set_active_power!`](@ref) function.

```@repl system
for i in thermal_not_solitude
    set_active_power!(i, 0.0)
end
```

Let's check the update using [`show_components`](@ref):

```@repl system
show_components(ThermalStandard, sys, [:active_power])
```

We can see that all the `active_power` values are 0.0, except `Solitude`.

We can filter on any component field. Similarly, let's filter all of the thermal generators
that now have an `active_power` of 0.0, and also set their availability to false.

```@repl system
for i in get_components(x -> get_active_power(x) == 0.0, ThermalStandard, sys)
    set_available!(i, 0)
end
```

## Getting Available Components

The [`get_available_components`](@ref) function is a useful short-hand function with a
built-in filter for grabbing all the components of a particular type that are available.

For example, if we are interested in grabbing all the available [`ThermalStandard`](@ref):

```@repl system
get_available_components(ThermalStandard, sys)
```

We only retrieved one component, because the rest have been set to unavailable:

```@repl system
show_components(ThermalStandard, sys)
```

## Getting Buses

We can retrieve the [`ACBus`](@ref) components using
[`get_buses`](@ref get_buses(sys::System, bus_numbers::Set{Int})),
by [ID number](@ref get_buses(sys::System, bus_numbers::Set{Int})) or
[`Area` or `LoadZone`](@ref get_buses(sys::System, aggregator::AggregationTopology)).

Let's begin by accessing the ID numbers associated with the [`ACBus`](@ref)
components using the [`get_bus_numbers`](@ref) function.

```@repl system
get_bus_numbers(sys)
```

We can see that these bus IDs are numbered 1 through 5.
Now let's specifically grab buses 2 and 3 using the [`get_buses`](@ref) function:

```@repl system
high_voltage_buses = get_buses(sys, Set(2:3))
```

and update their base voltage to 330 kV:

```@repl system
for i in high_voltage_buses
    set_base_voltage!(i, 330.0)
end
```

As usual, we can review the updated data with [`show_components`](@ref):

```@repl system
show_components(ACBus, sys, [:bus_number, :base_voltage])
```

## Updating Component Names

We can also access and update the component name field using the [`get_name`](@ref) and [set_name!](@ref) functions.

Recall that we created an iterator called `thermal_gens` for all the thermal generators.
We can use the [`get_name`](@ref) function to access the `name` field for these components.

```@repl system
for i in thermal_gens
    @show get_name(i)
end
```

To update the names we will use the [set_name!](@ref) function.

!!! warning
    
    Specifically when using [set_name!](@ref), it is important to note that using
    [set_name!](@ref) not only changes the field `name`, but also changes the iterator itself
    as you are iterating over it, which will result in unexpected outcomes and errors.

Therefore, rather than using [set_name!](@ref) on an iterator, only use it on a vector by first
calling [`collect`](https://docs.julialang.org/en/v1/base/collections/#Base.collect-Tuple%7BAny%7D)
on the iterator:

```@repl system
for thermal_gen in collect(get_components(ThermalStandard, sys))
    set_name!(sys, thermal_gen, get_name(thermal_gen) * "-renamed")
end
```

Now we can check the names using the [`get_name`](@ref) function again.

```@repl system
get_name.(get_components(ThermalStandard, sys))
```

## Next Steps & Links

So far we have seen that we can view different data types in our system using the
[`show_components`](@ref) function, access components with [`get_components`](@ref get_components(
filter_func::Function,
::Type{T},
sys::System;
subsystem_name = nothing,
) where {T <: Component}), access component field data with the `get_*` functions, and manipulate
them using the `set_*` functions.
Follow the next tutorials to learn how to [work with time series](@ref tutorial_time_series).
