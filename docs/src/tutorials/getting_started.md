# Getting Started

Welcome to PowerSystems.jl!

In this tutorial, we will create a power system and add some components to it,
including some nodes, lines, generators, and loads. 

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

Let's start with a reference bus, with the minimum necessary information:

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

Now, let's create two other buses:
```@repl basics
bus2 = ACBus(2, "bus2", ACBusTypes.PV, 0.0, 1.0, (min = 0.9, max = 1.05), 230.0)
bus3 = ACBus(3, "bus3", ACBusTypes.PQ, 0.0, 1.0, (min = 0.9, max = 1.05), 110.0)
```
What's different about these buses? `bus2` is
[a bus with a generator](@ref acbustypes_list), and `bus3` is a load bus with 110
kV base voltage.

Let's also add these to our `System`, using [`add_components!`](@ref) to add them
at the same time:
```@repl basics
add_components!(sys, [bus2, bus3])
sys
```

### Adding Transmission Lines
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
        2.0,
        (min = -0.7, max = 0.7),
    )
```
and a [transformer](@ref Transformer2W) between our 230 kV `bus2` and 110 kV `bus3`:
```@repl basics
transformer = Transformer2W(
        "transformer1",
        true,
        0.0,
        0.0,
        Arc(from = bus2, to = bus3),
        0.00281,
        0.0281,
        0.01,
        2.0,
    )
```

Let's also add these to our `System` and print our system summary:
```@repl basics
add_components!(sys, [line, transformer])
sys
```
Notice now we see all the network topology components we have added are included
in the system. 

### Adding Generators and Loads

