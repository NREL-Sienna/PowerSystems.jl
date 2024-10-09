# Manipulating Static Data Sets using `get_component` and `set_*`

PowerSystems provides functional interfaces to all data. In this tutorial we will explore how to manipulate various static data sets using the `get_component` and `set_*` functions. By the end of this tutorial you will be able to access the data stored in your system and be able to manipulate it. 

We are going to begin by loading in a test case from the `PowerSystemCaseBuilder`.

```@repl system
using PowerSystems;
using PowerSystemCaseBuilder;
sys = build_system(PSISystems, "RTS_GMLC_DA_sys")
```

Recall that we can see the components of our system simply by printing it.
```@repl system
sys
```

#### Accessing types of data stored in our system
If we are interested in seeing a certain data type stored in our system, for example the thermal generators, we can call them using the `get_components` function. 
```@repl system
get_components(ThermalStandard, sys) |> collect
```
Here we can see all 76 thermal generators. 
Similarly, if we were intersted in seeing all of the buses in the system we can call those as well using the `get_componets` function. 
```@repl system
get_components(ACBus, sys) |> collect
```
Here we can see all 73 buses.

We can also access data that are abstract types in the same way. Let's access all of the components under the abstract type `Branch`.
```@repl system
get_components(Branch, sys) |> collect
```
It is also possible to execute and define types stored in the system using `get_components` function. In this case, we are collecting all of the renewable generators in the system and defining them as `Renewable_gens`
```@repl system
Renewable_gens = get_components(RenewableDispatch, sys)
```
## Accessing components stored in the system
 Now that we have a grasp on accessing different types of data within our system, we are going to access specific components within these types. The most common filtering requirement is by component name and for this case the method [`get_component`](@ref) returns a single component taking the device type, system and name as arguments. PowerSystems enforces unique `name` fields between components of a particular concrete type. So, in order to retrieve a specific component, the user must specify the type of the component along with the name and system. For example, we are going to call generator `322_CT_6` that is of type ThermalStandard, as well as line `C31-2` that is of type Line.
```@repl system
get_component(ThermalStandard, sys, "322_CT_6") 
get_component(Line, sys, "C31-2")
```
Notice that in the first line the `name`  is `322_CT_6` and the type is 'ThermalStandard', while in the second line the `name` is `C31-2`, and the type is Line.

Now we can define a specific generator called `my_thermal_gen` within the ThermalStandard type. 
```@repl system
my_thermal_gen = get_component(ThermalStandard, sys, "322_CT_6")
```
## Accessing data stored in a specific component
Now, say we are intersted in accessing parameters within a specific component, we can do this using the `get_*` function. In this next case we are going to access the `name` and `base_power` parameters of `my_thermal_gen`
```@repl system
bus1 = get_component(ThermalStandard, sys, "322_CT_6")
@show get_name(bus1);
@show get_base_power(bus1);
```
Now let's access the `max_active_power` and `fuel` parameters of our `my_thermal_gen` genertor. 
```@repl system
get_max_active_power(my_thermal_gen)
get_fuel(my_thermal_gen)
```
We can see that for generator `311_CT_6`, the max active power is 0.859375 and the fuel is Coal. 

You can also view data from all instances of a concrete type in one table with the function `show_components` in three different ways.

The simplest way is to view the standard fields of the component. 

```@repl system
show_components(sys, ThermalStandard)
```
In this example, the standard field shown is the component's availability. 

Let's see the renewables in the system. 
```@repl system
show_components(sys, RenewableDispatch)
```
The second option is to pass a dictionary into the function where the names are keys and the values are functions that accept a component as a single arguement.
```@repl system
show_components(sys, ThermalStandard, Dict("has_time_series" => x -> has_time_series(x)))
```
In this case we can see all of the thermal generators, their availability, and whether or not they have time series attached to them. 

The third option is to pass a vector of symbols into the function that are field names of the type. 

```@repl system
show_components(sys, ThermalStandard, [:active_power, :reactive_power])
```
In this example we can see the thermal generators, their availability, and both their active and reactive power. 

## Using the `set_*` function
There are going to be instances where it is necessary to make changes to our system. This can be done using the `set_*` function. 

For example, if we want to change the fuel type for `my_thermal_gen` we would do so like this.
```@repl system 
set_fuel!(my_thermal_gen, ThermalFuels.NATURAL_GAS)
```
We can now see that the fuel associated with the thermal generator is no longer coal, but natural gas. 

If we are intersted in changing a parameter for multiple components of a certain type we would approach it like this.
```@repl system
thermal_gen = get_components(ThermalStandard, sys) |> collect
for i in 1:length(thermal_gen)
    set_fuel!(thermal_gen[i], ThermalFuels.COAL)
end
```
We can see that all of the thermal generators now are coal fueled. 
```@repl system 
show_components(sys, ThermalStandard, [:fuel])
```
The Julia language makes use of multiple dispatch. Certain function will return different outputs based on the input arguements. For example the `set_max_active_power` function can return different outputs based on which input arguments are passed through it. 

```@repl system
load = get_components(PowerLoad, sys) |> collect
for i in 1:length(load)
    set_max_active_power!(load[i],  0.45)
end
show_components(sys, PowerLoad, [:max_active_power])
```
We can see that in this example we have set all of the loads to have a `max_active_power` of 0.45.




 
