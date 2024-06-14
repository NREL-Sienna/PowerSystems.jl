# Getting Started

Welcome to PowerSystems.jl!

In this tutorial, we will create a power system and add some components to it,
including some nodes, a transmission line, transformer, load, and both renewable
and fossil fuel generators. 

### Setup 

To get started, ensure you have followed the [installation instructions](@ref install).

Start Julia from the command line if you haven't already:
```
$ julia
```

Load the PowerSystems.jl package:
```@repl basics
using PowerSystems
```

### Creating a Power `System`

In PowerSystems.jl, data is held in a [`System`](@ref) that holds all of the individual components
along with some metadata about the power system itself.

There are many ways to define a `System`, but let's start with an empty system.
All we need to define is a base power of 100 MVA for [per-unitization](@ref per_unit). 

```@repl basics
sys = System(100.0)
```

Notice that this system is a 60 Hz system with a base power of 100 MVA.

Now, let's add some components to our system.

### Adding Buses

We'll start by creating some buses. By referring to the documentation for
[ACBus](@ref), notice that we need define some basic data, including the bus's
unique identifier and name, base voltage, and whether it's a [load, generator,
or reference bus](@ref acbustypes_list). 

Let's start with a reference bus:

```@repl basics
bus1 = ACBus(1, "bus1", ACBusTypes.REF, 0.0, 1.0, (min = 0.9, max = 1.05), 230.0)
```
This bus is on a 230 kV AC transmission network, with an allowable voltage range of
0.9 to 1.05 p.u. We are assuming it is currently operating at 1.0 p.u. voltage and
an angle of 0 radians. 

Let's add this bus to our `System` with [`add_component!`](@ref):
```@repl basics
add_component!(sys, bus1)
sys
```
Notice that `System` now shows a summary of components in the system.

Let's create a second bus:
```@repl basics
bus2 = ACBus(2, "bus2", ACBusTypes.PV, 0.0, 1.0, (min = 0.9, max = 1.05), 230.0)
```
Notice that we've defined this bus with [power and voltage variables,](@ref acbustypes_list)
in case we do a power flow.

Let's also add this to our `System`:
```@repl basics
add_component!(sys, bus2)
```

Now, let's use [`show_components`](@ref) to verify some basic information about
the buses:
```@repl basics
show_components(sys, ACBus)
```

### Adding a Transmission Line
Let's connect our buses. We'll add a transmission [`Line`](@ref) between `bus1` and `bus2`: 
```@repl basics
line = Line(
        "line1",
        true,
        0.0,
        0.0,
        Arc(from = bus1, to = bus2),
        0.00281,
        0.0281,
        (from = 0.00356, to = 0.00356),
        200.0,
        (min = -0.7, max = 0.7),
    )
```
Note that we also had to define an [`Arc`](@ref) in the process to define the connection between
the two buses.

Let's also add this to our `System`:
```@repl basics
add_components!(sys, line)
```

Finally, let's check our `System` summary to see all the network topology components we have added
are attached:
```@repl basics
sys
```

### Adding a Load

Now that our network topology is complete, we'll start adding components that [inject](@ref I) or
withdraw power from the network.

We'll start with defining a 10 MW [load](@ref PowerLoad) to `bus1`:
```@repl basics
load = PowerLoad("load1", true, bus1, 0.0, 0.0, 10.0, 10.0, 0.0)
```
And add it to the system:
```@repl basics
add_components(sys, load)
```

### Adding Generators
Finally, we'll add two generators: one renewable and one thermal.

We'll add a 5 MW solar power plant to `bus2`:
```@repl basics
solar = RenewableDispatch("solar1", true, bus2, 0.0, 0.0, 5.0, PrimeMovers.PVe, (min=0.0, max=0.25), 1.0, RenewableGenerationCost(nothing), 5.0)
```
Note that we've used a generic renewable generator to model solar, but we
can specify that it is solar through the [prime mover](@ref pm_list). 

Finally, we'll also add a gas generator:
```@repl basics
gas = ThermalStandard(
        "gas1",
        true,
        bus2,
        0.0,
        0.0,
        30.0,
        (min=10.0, max=30.0),
        nothing,
        (up=5.0, down=5.0),
        ThermalGenerationCost(nothing),
        30.0;
        must_run = false,
        prime_mover_type = PrimeMovers.CC,
        fuel = ThermalFuels.NATURAL_GAS)
```

Again, we complete the step by adding all these new components :

This time, let's add these components to our `System` using [`add_components!`](@ref)
to add them at the same time:
```@repl basics
add_components!(sys, [solar, gas])
```

### Exploring the System

You have built a power system including buses, a transmission line, a transformer,
a load, and different types of generators. 

Remember that we can see a summary of our `System` using the print statement:
```@repl basics
sys
```

Now, let's use [`show_components`](@ref) again to look at all our generators:
```@repl basics
show_components(sys, Generator)
```

### Next Steps

Next, you might want to:
- [Learn how to add time series data to components](@ref tutorial_time_series)
- [Import a `System` from an existing Matpower or PSSE file instead of creating it manually](@ref parse_files)
- [Create your own `System` from .csv files instead of creating it manually](@ref tabular_parser)
