# Manipulating Static Data Sets using `get_component` and `set_*`

`PowerSystems` provides function interfaces to all data, and in this tutorial we will explore how to do this using the `get_*`, `set_*`, and `show_components` function. 

!!! note "Understanding the Behavior of getters and setters"
    `PowerSystems` returns Julia iterators in order to avoid unnecessary memory allocations. The `get_*` and `set_*` functions are uses as iterators to loop through data fields to access or set specific parameters. However, when using the `get_*` function you can use `collect` to return a vector.


We are going to begin by loading in a test case from the `PowerSystemCaseBuilder`, see the reference for [PSCB](https://nrel-sienna.github.io/PowerSystems.jl/stable/how_to/powersystembuilder/#psb) here. 
```@repl system
using PowerSystems;
using PowerSystemCaseBuilder;
sys = build_system(PSISystems, "c_sys5_pjm")
```

Recall that we can see the components of our system simply by printing it.
```@repl system
sys
```
#### Accessing types of data stored in our system
Let's grab all the thermal generators in our system using the `get_components` function. 
```@repl system
get_components(ThermalStandard, sys) 
```
!!! warning
    Using the "dot" access to get a parameter value from a component is actively discourages, use `get_*` functions instead. Julia syntax enables access to this data using the "dot" access, however this is actively discouraged for two reasons: 
        1. We make no guarantees on the stability of component structure definitions. We will maintain version stability on the accessor methods.
        2. Per-unit conversions are made in the return of data from the accessor functions. (see the [per-unit](https://nrel-sienna.github.io/PowerSystems.jl/stable/explanation/per_unit/#per_unit) section for more details)
We can see that we have 5 thermal generators in our system, and we can see the names of them using the `get_name` function. 
```@repl system 
get_name.(get_components(ThermalStandard, sys))
```
!!! warning 
    It is important to note that `set_name!` changes the container and not just the field within the component. Therefore, it is important that anytime you use `set_name!` you should do the following: 
```@repl system 
for thermal_gen in collect(get_components(ThermalStandard, sys))
    @show get_name(thermal_gen)
    set_name!(sys, thermal_gen, get_name(thermal_gen)*"-renamed")
end
```
```@repl system
get_name.(get_components(ThermalStandard, sys))
```


Now let's see if these thermal generators are available or not using the `show_components` function. 
```@repl system 
show_components(sys, ThermalStandard)
```
We can see that all of our thermal generators are available, but let's see how we can manipulate the availability of these generators. We will start by getting an iterator of all the thermal generators in our system. 
```@repl system 
thermal_iter = get_components(ThermalStandard, sys)
```
Now let's set all of our thermal generators to unavailable. 
```@repl system 
for i in thermal_iter
    set_available!(i, 0)
end
```
We can see the changes that we made by using the `show_components` function again. 
```@repl system 
show_components(ThermalStandard, sys)
```

Now, we are going to make all of our thermal generators availble except the Sundance generator. Let's grab an iterator for all of our thermal generators except Sundance. 
```@repl system 
avail_gen = [get_component(ThermalStandard, sys, "Solitude-renamed"), get_component(ThermalStandard, sys, "Park City-renamed"), get_component(ThermalStandard, sys, "Alta-renamed"), get_component(ThermalStandard, sys, "Brighton-renamed")]
```
```@repl system 
for i in avail_gen 
    set_available!(i, 1)
end
```
When we use the `get_available` function we can access components in the system that are available. 
```@repl system 
get_available.(get_components(ThermalStandard, sys))
```
In this case, we can see that all of our thermal generatos are available except Sundance. 

We can also access others paramenters of our thermal generators including the type of fuel it uses.
```@repl system
show_components(ThermalStandard, sys, [:fuel])
```
We can see that all of our thermal generators use coal as fuel. Let's change the Park City fuel to biofuel. 
```@repl system 
gen_bio = get_component(ThermalStandard, sys, "Park City-renamed")
```
```@repl system
set_fuel!(gen_bio, ThermalFuels.AG_BIPRODUCT)
```
```@repl system 
show_components(ThermalStandard, sys, [:fuel])
```
We can see that the Park City thermal generator is now fueled by agricultural crop byproducts. 

## Unit Base System
If we wanted to evaluate power flow with a different set point for out thermal generators, we can access and manipulate the `active_power`, `reactive_power`, and our `base_power` components.
```@repl system 
show_components(ThermalStandard, sys, [:active_power, :reactive_power, :base_power])
```
Let's check what unit base we are in. 
```@repl system 
get_units_base(sys)
```

We can see that we are in the `SYSTEM_BASE` units. Let's change our system base to `NATURAL_UNITS`, and see how this impacts our `active_power` and `reactive_power`
 
```@repl system 
set_units_base_system!(sys, UnitSystem.NATURAL_UNITS)
```
```@repl system  
show_components(ThermalStandard, sys, [:active_power, :reactive_power])
```
We can see that our values have changed, based on the unit base our system is in. 

Changing our unit base back to `SYSTEM_BASE`. 

```@repl system 
set_units_base_system!(sys, UnitSystem.SYSTEM_BASE)
```
Now we are going to change some of the `active_power` and `reactive_power` parameters of our thermal generators. 

```@repl system 
brighton = get_component(ThermalStandard, sys, "Brighton-renamed")
set_active_power!(brighton,  7.5 )
set_reactive_power!(brighton, 4.0)

```
Now when we look at our `active_power` and `reactive_power` we can see that they have changed. 

```@repl system
show_components(ThermalStandard, sys, [:active_power, :reactive_power])
```

Now lets focus on accessing all ACBuses and adjust their base voltages. We can access all the buses in the system using two key function, `get_components`, which we have already seen, and `get_buses`.

### Iterator Approach
A symmetrical approach, similar to the previous strategy, can be applied when using `get_components`. We start by getting an iterator for the AC buses in the system: 

```@repl system 
bus_iter = get_components(ACBus, sys)
```
We can set the base voltages all of the buses to 250 kV. 
```@repl system 
for i in bus_iter 
    set_base_voltage!(i, 250.0)
end
```
Now we can check what out base voltages currently are. 
```@repl system 
show_components(sys, ACBus, [:base_voltage])
```
### Vector Approach
We can also use a vector to collect all of our AC buses instead of an iterator. 
!!! tip "Iterator vs Vector"
    Depending on system size it can be beneficial to use an iterator over a vector because vectors can require a lot of memory. 
```@repl system
buses = collect(get_components(ACBus, sys))
```



So far we have seen that we can view different data types in our system using the `show_components` function, we can can access those types using the `get_*` function, and we can manipulate them using `set_*`. 

