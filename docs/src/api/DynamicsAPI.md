# PowerSystems Dynamic structs documentation

```@meta
CurrentModule = PowerSystems
DocTestSetup  = quote
    using PowerSystems
end
```

Dynamics API documentation

```@contents
Pages = ["DynamicsAPI.md"]
```

## Index

```@index
Pages = ["DynamicsAPI.md"]
```

## Dynamic Structs

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.DynamicInjection
```

## Generator Components

### Machines

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.Machine
```

### Shafts

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.Shaft
```

### Automatic Voltage Regulators

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.AVR
```

### Prime Movers / Turbine Governors

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.TurbineGov
```

### Power System Stabilizers

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.PSS
```

## Dynamic Inverter Components

### Converters

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.Converter
```

### Outer Controls

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> (t <: PowerSystems.OuterControl) | (t <: PowerSystems.ActivePowerControl) | (t <: PowerSystems.ReactivePowerControl)
```

### Inner Controls

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.InnerControl
```

### DC Sources

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.DCSource
```

### Frequency Estimators

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.FrequencyEstimator
```

### Filters

```@autodocs
Modules = [PowerSystems]
Order = [:type]
Filter = t -> t <: PowerSystems.Filter
```

