# Manipulating Datasets 

`PowerSystems` provides function interfaces to all data, and in this tutorial we will explore how to do this using the `get_*`, `set_*`, and `show_components` functions.  

!!! note "Understanding the Behavior of Getters and Setters"
    `PowerSystems` returns Julia iterators in order to avoid unnecessary memory allocations. The `get_components` function returns an iterator that loops through data fields to access specific parameters. The `set_*` function uses an iterator like `get_components` to manipulate specific parameters of components. 

## Viewing Components in the System 
We are going to begin by loading in a test case from the [`PowerSystemCaseBuilder.jl`](https://nrel-sienna.github.io/PowerSystems.jl/stable/how_to/powersystembuilder/#psb):
```@repl system
using PowerSystems;
using PowerSystemCaseBuilder;
sys = build_system(PSISystems, "c_sys5_pjm")
```

We can use the [`show_components`](@ref) function to view data in our system. Let's start by viewing all of the [`ThermalStandard`](@ref) components. 

```@repl system 
show_components(ThermalStandard, sys)
```
We can see there are five thermal generators in the system. 
Similarly, we can see all the [`ACBus`](@ref) components in the system. 
```@repl system 
show_components(ACBus, sys)
```
Notice in both the [`ACBus`](@ref) example and [`ThermalStandard`](@ref) example, a table with the name and availability are returned. The availability is the standard parameter returned when using [`show_components`](@ref).

We can also view specific parameters within components using the [`show_components`](@ref) function. For example, we can view the type of [`fuel`](@reftf_list) the thermal generators are using:
```@repl system 
show_components(ThermalStandard, sys, [:fuel])
```
If we are interested in viewing more than one parameter, like the `active power` and `reactive power` of the thermal generators: 
```@repl system
show_components(ThermalStandard, sys, [:active_power, :reactive_power])
```
We can see a table is returned with both `active_power` and `reactive_power`.
## Accessing and Updating a Component in a System
We can access a component in our system using the [`get_component`](@ref) function. For example, if we are interested in accessing a [`ThermalStandard`](@ref) component we can do so using the component [`type`](@id type_structure) and name. From above we know the names of the thermal generators. 
```@repl system 
solitude = get_component(ThermalStandard, sys, "Solitude")
```

Notice, the parameters associated with that generator are returned. If we are interested in accessing a particular parameter of that generator we can use a `get_*` function. For example, if we are interested in the [`fuel`](@reftf_list) we can use [`get_fuel`](@ref)
```@repl system 
get_fuel(solitude)
```
You should see the [`fuel`](@reftf_list) parameter returned. 

To recap, [`get_component`](@ref) will return all parameters of a component, but we can use a specific `get_*` function to return a particular parameter. 

To update a parameter we can use a specific `set_*` function. We can use [`set_fuel!`](@ref) to update the fuel parameter of Solitude to natural gas.  
```@repl system 
set_fuel!(solitude, ThermalFuels.NATURAL_GAS)
```
We can check that the `Solitude` fuel has been updated to `ThermalFuels.AG_BIPRODUCT`:
```@repl system 
show_components(ThermalStandard, sys, [:fuel])
```
Another example of using a specific `get_*` function and `set_*` function is when you are updating the `active_power` parameter. We can access this parameter by using the [`get_active_power`](@ref):
```@repl system 
get_active_power(solitude)
```
We can then update it using [`set_active_power!`](@ref):
```@repl system 
set_active_power!(solitude, 4.0)
```
We can see that our `active_power` parameter has been updated to 4.0. 

## Accessing and Updating Multiple Components in the System at Once 
We can also update more than one component at a time using the [`get_components`](@ref) and `set_*` functions. 

Let's say we were interested in updating the `base_voltage` parameter for all of the [`ACBus`](@ref) components. We can see that currently the `base_voltages` are:
```@repl system 
show_components(ACBus, sys, [:base_voltage])
```
But what if we are looking to change them to 250.0? Let's start by getting an iterator for all the buses using [`get_components`](@ref):
```@repl system 
buses = get_components(ACBus, sys)
```
Now using the [`set_base_voltage!`](@ref) function and a `for loop` we can update the voltage:
```@repl system 
for i in buses
set_base_voltage!(i, 250.0)
end 
```
We can see that all of the buses now have a `base_voltage` of 250.0:
```@repl system 
show_components(ACBus, sys, [:base_voltage])
```
If we are interested in updating the fuel in all the thermal generators, we would use a similar approach. We begin by grabbing an iterator for all the components in [`ThermalStandard`](@ref).
```@repl system 
thermal_gens = get_components(ThermalStandard, sys)
```
Now, using the [`set_fuel!`](@ref) and a for loop, we will update the fuel to `NATURAL_GAS`.    
```@repl system 
for i in thermal_gens
set_fuel!(i, ThermalFuels.NATURAL_GAS)
end
```
We can see that the fuel types for all the thermal generators has been updated. 
```@repl system 
show_components(ThermalStandard, sys, [:fuel])
```
We can also use a dot operator with a specific `get_*` function and the [`get_components`](@ref) function to return a vector of parameters for multiple components: 
```@repl system 
get_fuel.(get_components(ThermalStandard, sys))
```
Notice that the fuel type for all the thermal generators is returned.
!!! warning
    Using the "dot" access to get a parameter value from a component is actively discouraged, use `get_*` functions instead. Julia syntax enables access to this data using the "dot" access, however this is discouraged for two reasons: 
        1. We make no guarantees on the stability of component structure definitions. We will maintain version stability on the accessor methods.
        2. Per-unit conversions are made in the return of data from the accessor functions. (see the [per-unit](https://nrel-sienna.github.io/PowerSystems.jl/stable/explanation/per_unit/#per_unit) section for more details) 

## Filtering Specific Data
We have seen how to update a single component, and all the components of a specific type, but what if we are interested in updating particular components? We can do this using filter functions. For example, let's say we are interested in updating all the `active_power` parameters of the thermal generators except `Solitude`. 
Let's start by seeing the current `active_power` parameters. 
```@repl system 
show_components(ThermalStandard, sys, [:active_power])
```
Let's grab an iterator for the all the thermal generators except `Solitude` using a filter function: 
```@repl system 
thermal_not_solitude = get_components(x -> get_name(x) != "Solitude", ThermalStandard, sys)
```
We can see that four [`ThermalStandard`](@ref) components are returned. Now let's update the `active_power` parameter of these four thermal generators using the [`set_active_power`](@ref) function. 
```@repl system 
for i in thermal_not_solitude
set_active_power!(i, 0.0)
end
```
Let's check the update using [`show_components`](@ref):
```@repl system 
show_components(ThermalStandard, sys, [:active_power])
```
We can see that all the `active_power` parameters are 0.0, except `Solitude`. 

We can also filter using parameter values. For example, we can access all the thermal generators that have ratings of either 5.2 or 0.5:
```@repl system 
show_components(ThermalStandard, sys, [:rating])
```
We can see that `Solitude` has a rating of 5.2 and `Alta` has a rating of 0.5. 
```@repl system 
thermal_rating = get_components(x -> get_rating(x) == 5.2 || get_rating(x) == 0.5, ThermalStandard, sys )
```
We can see that two components are returned. If we wanted to update those ratings to 4.0: 
```@repl system 
for i in thermal_rating 
set_rating!(i, 4.0)
end
```
The rating parameters of `Solitude` and `Alta` are now 4.0: 
```@repl system 
show_components(ThermalStandard, sys, [:rating])
```

## Getting Available Components
The [`get_available_components`](@ref) function allows us to grab all the components of a particular type that are available. For example, if we are interested in grabbing all the available renewable generators: 
```@repl system 
get_available_components(RenewableDispatch, sys)
```
The two [`RenewableDispatch`](@ref) components are returned because they are available. 

We can update the availability of components using the [`set_available!`](@ref) function. Let's filter all of the thermal generators that have an `active_power` of 0.0, and set their availability to false.
```@repl system 
not_available = get_components(x -> get_active_power(x) == 0.0, ThermalStandard, sys)
```
```@repl system 
for i in not_available
set_available!(i, 0)
end
```
Let's check the availability of our [`ThermalStandard`](@ref) components.
```@repl system 
show_components(ThermalStandard, sys)
```
Recall that the default columns returned when using [`show_components`](@ref) are the name and availability. 

## Getting Buses
We can access the [`ACbus`](@ref) components in the system using the [`get_buses`](@ref) function. There are multiple approaches to using this function, but in this tutorial we are going to focus on getting buses using the ID numbers. 
Let's begin by accessing the ID numbers associated with the [`ACBus`](@ref) components using the [`get_bus_numbers`](@ref) function. 
```@repl system 
get_bus_numbers(sys)
```
We can see that a vector of values 1:5 is returned. Now let's grab the buses using the [`get_buses`](@ref) function. 
```@repl system 
get_buses(sys, Set(1:5))
```
The 5 buses in the system are returned.

## Updating Component Names

We can also access and update the component name parameter using the [`get_name](@ref) and [`set_name!`](@ref) functions. 
 
Recall that we created an iterator called `thermal_gens` for all the thermal generators. We can use the [`get_name`](@ref) function to access the `name` parameter for these components. 
```@repl system
for i in thermal_gens 
@show get_name(i)
end
```
To update the names we will use the [`set_name`](@ref) function. However, it is important to note that using [`set_name`](@ref) not only changes the field `name`, but also changes the container itself. Therefore, it is crucial to do the following: 
```@repl system 
for thermal_gen in collect(get_components(ThermalStandard, sys))
    set_name!(sys, thermal_gen, get_name(thermal_gen)*"-renamed")
end
```
Now we can check the names using the [`get_name`](@ref) function again. 
```@repl system 
get_name.(get_components(ThermalStandard,sys))
```


## Next Steps & Links
So far we have seen that we can view different data types in our system using the `show_components` function, we can access those types using the `get_*` function, and we can manipulate them using the `set_*` functions. 
Follow the next tutorials to learn how to [work with time series](https://nrel-sienna.github.io/PowerSystems.jl/stable/tutorials/working_with_time_series/).