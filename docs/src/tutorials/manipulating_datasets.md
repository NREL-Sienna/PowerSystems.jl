# Manipulating Data Sets 

`PowerSystems` provides function interfaces to all data, and in this tutorial we will explore how to do this using the `get_*`, `set_*`, and `show_components` functions.  

!!! note "Understanding the Behavior of Getters and Setters"
    `PowerSystems` returns Julia iterators in order to avoid unnecessary memory allocations. The `get_components` function is an iterator that loops through data fields to access specific parameters. The `set_*` function uses an iterator like `get_components` to manipulate specific parameters of components. 

## Viewing Components in the System 
We are going to begin by loading in a test case from the [`PowerSystemCaseBuilder.jl`](https://nrel-sienna.github.io/PowerSystems.jl/stable/how_to/powersystembuilder/#psb):
```@repl system
using PowerSystems;
using PowerSystemCaseBuilder;
sys = build_system(PSISystems, "c_sys5_pjm")
```

We can use the [`show_components`](https://nrel-sienna.github.io/PowerSystems.jl/stable/api/public/#PowerSystems.show_components) function to view data in our system. 

Let's start by viewing all of the [`ThermalStandard`](https://nrel-sienna.github.io/PowerSystems.jl/stable/model_library/generated_ThermalStandard/#PowerSystems.ThermalStandard) components in the system. 

```@repl system 
show_components(ThermalStandard, sys)
```
We can see there are five thermal generators in the system. 
Similarly we can see all of the [`ACBus`](https://nrel-sienna.github.io/PowerSystems.jl/stable/model_library/generated_ACBus/#PowerSystems.ACBus) components in our system. 
```@repl system 
show_components(ACBus, sys)
```
Notice in both the `ACBus` example and `ThermalStandard` example, a table with the name and availability are returned. Availability is the standard parameter returned when using `show_components`.

We can also view specific parameters within components using the `show_components` function. 

For example, we can view the type of `fuel` the thermal generators are using:
```@repl system 
show_components(ThermalStandard, sys, [:fuel])
```
If we were interested in viewing more than one parameter, like the `active power` and `reactive power` of the thermal generators: 
```@repl system
show_components(ThermalStandard, sys, [:active_power, :reactive_power])
```
We can see a table is returned of the parameters we were interested in. 
## Accessing Components in a System
We can access and manipulate components in our system using the [`get_component`](https://nrel-sienna.github.io/PowerSystems.jl/stable/api/public/#PowerSystems.get_component-Union{Tuple{T},%20Tuple{Type{T},%20System,%20AbstractString}}%20where%20T%3C:Component) and the [`get_components`](https://nrel-sienna.github.io/PowerSystems.jl/stable/api/public/#PowerSystems.get_components-Union{Tuple{T},%20Tuple{Type{T},%20System}}%20where%20T%3C:Component) functions. An important note to make is that both `get_component` and `get_components` are iterators that loop through data fields to access specific components and parameters.

!!! warning
    Using the "dot" access to get a parameter value from a component is actively discouraged, use `get_*` functions instead. Julia syntax enables access to this data using the "dot" access, however this is discouraged for two reasons: 
        1. We make no guarantees on the stability of component structure definitions. We will maintain version stability on the accessor methods.
        2. Per-unit conversions are made in the return of data from the accessor functions. (see the [per-unit](https://nrel-sienna.github.io/PowerSystems.jl/stable/explanation/per_unit/#per_unit) section for more details)

Let's access a thermal generator in the system. The `get_component` function takes in a [`type`](https://nrel-sienna.github.io/PowerSystems.jl/stable/api/type_tree/), the system and a name. 

From above we know the names of the thermal generators.
```@repl system 
get_component(ThermalStandard, sys, "Solitude")
```
The parameters associated with that generator should be returned.

If we were intersted in accessing multiple components in the system, we can use the `get_components` function. 
```@repl system 
get_components(ThermalStandard, sys)
```
We can see the five thermal generators in a system. 

## Updating Data in a Component
Now that we have learned how to view and access data in the system, we are going to learn how to update it using certain `set_*` functions. The `set_*` function uses iterators to loop through and update parameters and components. 

If we were interested in updating the [`fuel`](https://nrel-sienna.github.io/PowerSystems.jl/stable/api/enumerated_types/#tf_list) parameter of the thermal generators we would use the [`set_fuel!`](https://nrel-sienna.github.io/PowerSystems.jl/stable/model_library/generated_ThermalStandard/#PowerSystems.set_fuel!-Tuple{ThermalStandard,%20Any}) function.

Let's start by grabbing the `Solitude` thermal generator 
```@repl system
solitude = get_component(ThermalStandard, sys, "Solitude")
```
Now we can update the `fuel` for that thermal generator using the [`set_fuel!`](https://nrel-sienna.github.io/PowerSystems.jl/stable/model_library/generated_ThermalStandard/#PowerSystems.set_fuel!-Tuple{ThermalStandard,%20Any}) function:

```@repl system 
set_fuel!(solitude, ThermalFuels.AG_BIPRODUCT)
```
We can check that our fuel updated using `show_components`
```@repl system 
show_components(ThermalStandard, sys, [:fuel])
```
We can see that the `Solitude` fuel has been updated to `ThermalFuels.AG_BIPRODUCT`

## Updating Many Components at Once
We can also update more than one component at a time using `get_components` and the `set_*` functions. 

Let's say we were interested in updating the `base_voltage` parameter for all of the `ACBus` components. We can see that currently the `base_voltages` are:
```@repl system 
show_components(ACBus, sys, [:base_voltage])
```
But what if we are looking to change them to 250.0. Let's start by getting an iterator for all the buses using `get_components`
```@repl system 
buses = get_components(ACBus, sys)
```
Now using the [`set_base_voltage!`](https://nrel-sienna.github.io/PowerSystems.jl/stable/model_library/generated_ACBus/#PowerSystems.set_base_voltage!-Tuple{ACBus,%20Any}) function and a `for loop` we can update the voltage. 
```@repl system 
for i in buses
set_base_voltage!(i, 250.0)
end 
```
We can see that all of the buses now have a `base_voltage` of 250.0:
```@repl system 
show_components(ACBus, sys, [:base_voltage])
```
If we were interested in updating the fuel in all the thermal generators, we would use a similar approach. We begin by grabbing an iterator for all the components in `ThermalStandard`.
```@repl system 
thermal_gens = get_components(ThermalStandard, sys)
```
Now, using a the [`set_fuel!`](https://nrel-sienna.github.io/PowerSystems.jl/stable/model_library/generated_ThermalStandard/#PowerSystems.set_fuel!-Tuple{ThermalStandard,%20Any}) and a for loop, we will update the fuel to `NATURAL_GAS`.    
```@repl system 
for i in thermal_gens
set_fuel!(i, ThermalFuels.NATURAL_GAS)
end
```
We can see that all the fuel type for all the thermal gens has been updated. 
```@repl system 
show_components(ThermalStandard, sys, [:fuel])
```

## Filtering Specific Data
We have seen how to update a single component, and all the components of a particular type, but what if we are interested in updating particular components? We can do this using filter functions. For example, let's say we are interested in updating all the `active_power` parameters of the thermal generators except `Solitude`. 

Let's start by seeing the current `active_power` parameters. 
```@repl system 
show_components(ThermalStandard, sys, [:active_power])
```
Let's grab an iterator for the all the thermal generators except `Solitdue`
```@repl system 
thermal_not_solitude = get_components(x -> get_name(x) != "Solitude", ThermalStandard, sys)
```
We can see that four `ThermalStandard` components are returned. Now let's update the `active_power` parameter of these 4 thermal generators using the [`set_active_power`](https://nrel-sienna.github.io/PowerSystems.jl/stable/model_library/generated_EnergyReservoirStorage/#PowerSystems.set_active_power!-Tuple{EnergyReservoirStorage,%20Any}) function. 
```@repl system 
for i in thermal_not_solitude
set_active_power!(i, 0.0)
end
```
Let's check the update using `show_components`.
```@repl system 
show_components(ThermalStandard, sys, [:active_power])
```
We can see that all the `active_power` parameters are 0.0, except sundance. 

## Getting Available Components
The [`get_available_components`](https://nrel-sienna.github.io/PowerSystems.jl/stable/api/public/#PowerSystems.get_available_components-Union{Tuple{T},%20Tuple{Type{T},%20System}}%20where%20T%3C:Component) function allows us to grab all the components of a particular type that are available. For example, if we were interested in grabbing all the available renewable generators: 
```@repl system 
get_available_components(RenewableDispatch, sys)
```
The two `RenewableDispatch` components are returned because they are available. 

We can update the availability of componets using the [`set_available!`](https://nrel-sienna.github.io/PowerSystems.jl/stable/model_library/generated_AGC/#PowerSystems.set_available!-Tuple{AGC,%20Any}) function. 

Let's filter all of the thermal generators that have an `active_power` of 0.0, and set their availability to false.
```@repl system 
not_available = get_components(x -> get_active_power(x) == 0.0, ThermalStandard, sys)
```
```@repl system 
for i in not_available
set_available!(i, 0)
end
```
Let's check the availability of our `ThermalStandard` components.
```@repl system 
show_components(ThermalStandard, sys)
```
Recall that the default columns returned when using `show_components` are the name and availability. 

## Getting Buses
We can access the `ACbus` components in the system using the [`get_buses`](https://nrel-sienna.github.io/PowerSystems.jl/stable/api/public/#PowerSystems.get_buses-Tuple{System,%20Set{Int64}}) function. There are multiple approaches in using this function, but in this tutorial we are going to focus on using the ID numbers of our buses. 

Let's begin by viewing the ID numbers associated with the `ACBus` components using the [`get_bus_numbers`](https://nrel-sienna.github.io/PowerSystems.jl/stable/api/public/#PowerSystems.get_bus_numbers-Tuple{System}) function. 
```@repl system 
get_bus_numbers(sys)
```
We can see that a vector of values 1:5 is returned. Now let's grab the buses using the `get_buses` function. 
```@repl system 
get_buses(sys, Set(1:5))
```
The 5 buses in the system are returned. Notice, that this returns a 5-element vector not an iterator. 

## Updating Component Names
When we are updating a component name using the function [`set_name!`](https://nrel-sienna.github.io/PowerSystems.jl/stable/api/public/#InfrastructureSystems.set_name!-Tuple{System,%20AbstractString}) it is important to note that this not only changes the field `name`, but also changes the container itself.

Recall that we created an iterator called `thermal_gens` for all the thermal generators. We can use the [`get_name`](https://nrel-sienna.github.io/PowerSystems.jl/stable/model_library/generated_SimplifiedSingleCageInductionMachine/#InfrastructureSystems.get_name-Tuple{SimplifiedSingleCageInductionMachine}) function to access the `name` parameter for these components. 
```@repl system
for i in thermal_gens 
@show get_name(i)
end
```
To update the names we will use the `set_name` function. 
```@repl system 
for thermal_gen in collect(get_components(ThermalStandard, sys))
    set_name!(sys, thermal_gen, get_name(thermal_gen)*"-renamed")
end
```
Now we can check the names using the `get_name` function again.
```@repl system 
get_name.(get_components(ThermalStandard,sys))
```

Notice how we used 

## Next Steps & Links
So far we have seen that we can view different data types in our system using the `show_components` function, we can can access those types using the `get_*` function, and we can manipulate them using `set_*`. 
Follow the next tutorials to learn how to [work with time series](https://nrel-sienna.github.io/PowerSystems.jl/stable/tutorials/working_with_time_series/). 



