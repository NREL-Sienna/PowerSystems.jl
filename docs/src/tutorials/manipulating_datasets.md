# Manipulating Static Data Sets using `get_component` and `set_*`

!!! note "Static vs Dynamic Data"
    Static and dynamic data can be manipulated using the `get_*` and `set_*` functions. However, it is important to note their differences. Static data encompasses all data necessary to run a steady state model. Dynamic data encompasses the data necessary to run a transient model. 

`PowerSystems` provides function interfaces to all data, and in this tutorial we will explore how to do this using the `get_*`, `set_*`, and `show_components` functions.  

!!! note "Understanding the Behavior of Getters and Setters"
    `PowerSystems` returns Julia iterators in order to avoid unnecessary memory allocations. The `get_*` and `set_*` functions are used as iterators to loop through data fields to access or set specific parameters. However, when using the `get_*` function you can use `collect` to return a vector.


We are going to begin by loading in a test case from the `PowerSystemCaseBuilder`, see the reference for [PSCB](https://nrel-sienna.github.io/PowerSystems.jl/stable/how_to/powersystembuilder/#psb). 
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
    Using the "dot" access to get a parameter value from a component is actively discouraged, use `get_*` functions instead. Julia syntax enables access to this data using the "dot" access, however this is discouraged for two reasons: 
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


Now let's check the availability of these thermal generators using the `show_components` function. 
```@repl system 
show_components(sys, ThermalStandard)
```
We can see that all of our thermal generators are available, but let's see how we can manipulate their availability. We will start by getting an iterator of the thermal generators in our system. 
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

Now, we are going to make all of our thermal generators availble except the Sundance generator. Let's grab an iterator for all of the thermal generators except Sundance. 
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
In this case, we can see that all of the thermal generatos are available except Sundance. 

We can also see others paramenters of our thermal generators including the type of fuel it uses.
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
If we wanted to evaluate power flow with a different set point for out thermal generators, we can do so by accessing and manipulating the `active_power`, `reactive_power`, and our `base_power` components.
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
We can use a filter function to group our `ThermalStandard` components based on their `active_power` and `reactive_power` parameters. 
```@repl system
my_active_power1 = 7.5
my_active_power2 = 1.7
collect(get_components(x -> get_active_power(x) == my_active_power1 || get_active_power(x) == my_active_power2, ThermalStandard, sys))
```
We can see that a 2-element vector containing `Brighton-renamed` and `Park City-renamed` is returned.  


Now lets focus on accessing all `ACBus` components and adjusting their base voltages. We can access all the buses in the system using two key function, `get_components`, which we have already seen, and `get_buses` which we will dive into now. 

### Iterator Approach

We are going to start by getting an iterator for some of the `ACBus` components. 

```@repl system 
bus_iter = [get_component(ACBus, sys, "nodeA"), get_component(ACBus, sys, "nodeC")]
```
We can set the base voltages for those buses to 250 kV. 
```@repl system 
for i in bus_iter 
    set_base_voltage!(i, 250.0)
end
```
Now we can check what the base voltages currently are. 
```@repl system 
show_components(sys, ACBus, [:base_voltage])
```
Additionally, we can use a filter function here to group our buses based on `base_voltage`.
```@repl system 

my_base_voltage = 250
collect(get_components(x -> get_base_voltage(x) == my_base_voltage, ACBus, sys))
```
A 2-element vector containing the buses with a `base_voltage` of 250.0 is returned. 

### Vector Approach
We can also use a vector to collect all of our `ACBus` components instead of an iterator. 
!!! tip "Iterator vs Vector"
    Depending on system size it can be beneficial to use an iterator over a vector because vectors can require a lot of memory. 
```@repl system
buses = collect(get_components(ACBus, sys))
```
### Using `get_bus` 
We can also use the `get_bus` function, when we know which `Area` or `LoadZone` we are interested in. However, because this is a small system there are no pre-built Areas, so we are going to begin by building some.
We are going to begin by grabbing two iterators that will grab all the buses. 
```@repl system 
area2_iter = [get_component(ACBus, sys, "nodeA"), get_component(ACBus, sys, "nodeC"), get_component(ACBus, sys, "nodeE")]
area1_iter = [get_component(ACBus, sys, "nodeB"), get_component(ACBus, sys, "nodeD")]
```
Next, we are going to create our `Areas` and add them to the system.
```@repl system 
area1 = Area(;
    name = "1"
)
add_component!(sys, area1)
```
```@repl system 
area2 = Area(;
    name = "2"
)
add_component!(sys, area2)

```
Now we are going to use the `set_area!` function to set the `Area` parameter of our nodes to the `Areas` we just created. 
```@repl system 
for i in area1_iter
    set_area!(i, area1)
end
```
```@repl system 
for i in area2_iter 
    set_area!(i, area2)
end
```
Now we can use the `get_buses` function. 
```@repl system 
area2 = get_component(Area, sys, "2")
area_buses = get_buses(sys, area2)
area1 = get_component(Area, sys, "1")
area_buses1 = get_buses(sys, area1)

```

We can also access all of our buses using their ID numbers. 
```@repl system 
buses_by_ID = get_buses(sys, Set(1:5))
```


So far we have seen that we can view different data types in our system using the `show_components` function, we can can access those types using the `get_*` function, and we can manipulate them using `set_*`. 
Follow the next tutorials to learn how to [work with time series](https://nrel-sienna.github.io/PowerSystems.jl/stable/tutorials/working_with_time_series/). 




