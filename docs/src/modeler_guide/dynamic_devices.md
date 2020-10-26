# Dynamic Devices

## Dynamic Generator

Each generator is a data structure that is defined by the following components:

- [Machine](@ref Machine): That defines the stator electro-magnetic dynamics.
- [Shaft](@ref Shaft): That describes the rotor electro-mechanical dynamics.
- [Automatic Voltage Regulator](@ref AVR): Electromotive dynamics to model an AVR controller.
- [Power System Stabilizer](@ref PSS): Control dynamics to define an stabilization signal for the AVR.
- [Prime Mover and Turbine Governor](@ref TurbineGov): Thermo-mechanical dynamics and associated controllers.

```@raw html
<img src="../../assets/gen_metamodel.png" width="75%"/>
```


Each inverter is a data structure that is defined by the following components:

- [DC Source](@ref DCSource): Defines the dynamics of the DC side of the converter.
- [Frequency Estimator](@ref FrequencyEstimator): That describes how the frequency of the grid can be estimated using the grid voltages. Typically a phase-locked loop (PLL).
- [Outer Loop Control](@ref OuterControl): That describes the active and reactive power control dynamics.
- [Inner Loop Control](@ref InnerControl): That can describe virtual impedance, voltage control and current control dynamics.
- [Converter](@ref Converter): That describes the dynamics of the pulse width modulation (PWM) or space vector modulation (SVM).
- [Filter](@ref Filter): Used to connect the converter output to the grid.

```@raw html
<img src="../../assets/inv_metamodel.png" width="75%"/>
``` ⠀
