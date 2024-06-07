# Get component data

```@setup get_component_data
using PowerSystems #hide
BASE_DIR = abspath(joinpath(dirname(Base.find_package("PowerSystems")), "..")); #hide
include(joinpath(BASE_DIR, "test", "data_5bus_pu.jl")); #.jl file containing 5-bus system data
nodes_5 = nodes5(); # function to create 5-bus buses 
thermal_generators5(nodes_5); # function to create thermal generators in 5-bus buses 
renewable_generators5(nodes_5); # function to create renewable generators in 5-bus buses
loads5(nodes_5); # function to create the loads
branches5(nodes_5); # function to create the branches
sys = System(
           100.0,
           nodes_5,
           vcat(
             thermal_generators5(nodes_5),
             renewable_generators5(nodes_5)),
             loads5(nodes_5),
             branches5(nodes_5),
       ); #hide
```

PowerSystems provides functional interfaces to all data. The following examples outline
the intended approach to accessing data expressed using PowerSystems.

PowerSystems enforces unique `name` fields between components of a particular concrete type.
So, in order to retrieve a specific component, the user must specify the type of the component
along with the name and system

#### Accessing components and their data

```@repl get_components
get_component(ACBus, sys, "nodeA")
get_component(Line, sys, "1")
```

Similarly, you can access all the components of a particular type: *note: the return type
of get_components is a `FlattenIteratorWrapper`, so call `collect` to get an `Array`

```@repl get_components
get_components(ACBus, sys) |> collect
```

`get_components` also works on abstract types:

```@repl get_components
get_components(Branch, sys) |> collect
```

The fields within a component can be accessed using the `get_*` functions:
*It's highly recommended that users avoid using the `.` to access fields since we make no
guarantees on the stability field names and locations. We do however promise to keep the
accessor functions stable.*

```@repl get_components
bus1 = get_component(ACBus, sys, "nodeA")
@show get_name(bus1);
@show get_magnitude(bus1);
nothing #hide
```
