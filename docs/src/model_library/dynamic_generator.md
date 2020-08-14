# DynamicGenerator

Each generator is a data structure that is defined by the following components:

- [Machine](@ref Machine): That defines the stator electro-magnetic dynamics.
- [Shaft](@ref Shaft): That describes the rotor electro-mechanical dynamics.
- [Automatic Voltage Regulator](@ref AVR): Electromotive dynamics to model an AVR controller.
- [Power System Stabilizer](@ref PSS): Control dynamics to define an stabilization signal for the AVR.
- [Prime Mover and Turbine Governor](@ref TurbineGov): Thermo-mechanical dynamics and associated controllers.

```@raw html
<img src="../../assets/gen_metamodel.png" width="75%"/>
```

```@autodocs
Modules = [PowerSystems]
Pages   = ["dynamic_generator.jl"]
Order = [:type, :function]
Public = true
```
