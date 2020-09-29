# DynamicInverter

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

```@autodocs
Modules = [PowerSystems]
Pages   = ["dynamic_inverter.jl"]
Order = [:type, :function]
Public = true
```
