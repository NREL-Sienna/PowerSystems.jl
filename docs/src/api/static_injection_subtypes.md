# StaticInjection Subtypes Comparison

This document summarizes the similarities and differences between `StaticInjection` subtypes in PowerSystems.jl, with emphasis on generators, loads, storage, and sources. Some control-related subtypes--like FACTS devices--are omitted from the below charts, simply because they have very little in common with the other subtypes.

## Type Hierarchy

```
StaticInjection
├── Generator
│   ├── ThermalGen
│   │   ├── ThermalStandard
│   │   └── ThermalMultiStart
│   ├── RenewableGen
│   │   ├── RenewableDispatch
│   │   └── RenewableNonDispatch
│   └── HydroGen
│       ├── HydroDispatch
│       └── HydroUnit
│           ├── HydroTurbine
│           └── HydroPumpTurbine
├── ElectricLoad → StaticLoad
│   ├── PowerLoad
│   ├── StandardLoad (ZIP)
│   ├── ExponentialLoad
│   ├── MotorLoad
│   └── ControllableLoad
│       ├── InterruptiblePowerLoad
│       ├── InterruptibleStandardLoad
│       └── ShiftablePowerLoad
├── Storage
│   └── EnergyReservoirStorage
└── Source
```

* * *

## Power Limits Fields Comparison

### Generators

| Type                     | `active_power_limits` | `max_active_power` | `reactive_power_limits` | `max_reactive_power` |
|:------------------------ |:--------------------- |:------------------ |:----------------------- |:-------------------- |
| **ThermalStandard**      | ✅ `MinMax`            | ❌                  | ✅ `MinMax?`             | ❌                    |
| **ThermalMultiStart**    | ✅ `MinMax`            | ❌                  | ✅ `MinMax?`             | ❌                    |
| **RenewableDispatch**    | ❌                     | ❌ ¹                | ✅ `MinMax?`             | ❌                    |
| **RenewableNonDispatch** | ❌                     | ❌                  | ❌                       | ❌                    |
| **HydroDispatch**        | ✅ `MinMax`            | ❌                  | ✅ `MinMax?`             | ❌                    |
| **HydroTurbine**         | ✅ `MinMax`            | ❌                  | ✅ `MinMax?`             | ❌                    |
| **HydroPumpTurbine**     | ✅ `MinMax`            | ❌                  | ✅ `MinMax?`             | ❌                    |

### Loads

| Type                          | `active_power_limits` | `max_active_power` | `reactive_power_limits` | `max_reactive_power` |
|:----------------------------- |:--------------------- |:------------------ |:----------------------- |:-------------------- |
| **PowerLoad**                 | ❌                     | ✅ `Float64`        | ❌                       | ✅ `Float64`          |
| **StandardLoad**              | ❌                     | ⊕                  | ❌                       | ⊕                    |
| **ExponentialLoad**           | ❌                     | ✅ `Float64`        | ❌                       | ✅ `Float64`          |
| **MotorLoad**                 | ❌                     | ✅ `Float64`        | ✅ `MinMax?`             | ❌                    |
| **InterruptiblePowerLoad**    | ❌                     | ✅ `Float64`        | ❌                       | ✅ `Float64`          |
| **InterruptibleStandardLoad** | ❌                     | ⊕                  | ❌                       | ⊕                    |
| **ShiftablePowerLoad**        | ✅ `MinMax`            | ✅ `Float64`        | ❌                       | ✅ `Float64`          |

### Storage & Source

| Type                       | `active_power_limits` | `max_active_power` | `reactive_power_limits` | `max_reactive_power` |
|:-------------------------- |:--------------------- |:------------------ |:----------------------- |:-------------------- |
| **EnergyReservoirStorage** | ❌ ²                   | ❌                  | ✅ `MinMax?`             | ❌                    |
| **Source**                 | ✅ `MinMax`            | ❌                  | ✅ `MinMax?`             | ❌                    |

¹ Uses `rating * power_factor` dynamically; no stored field

² EnergyReservoirStorage uses `input_active_power_limits` and `output_active_power_limits` instead

Here, `MinMax?` means `Union{MinMax, Nothing}`.

⊕ = Split across 3 ZIP fields: `*_constant_*`, `*_impedance_*`, `*_current_*`

* * *

## Generator-Specific Fields

| Field              | Thermal* | RenewableDispatch | RenewableNonDispatch | HydroDispatch | HydroTurbine | HydroPumpTurbine |
|:------------------ |:-------- |:----------------- |:-------------------- |:------------- |:------------ |:---------------- |
| `rating`           | ✅        | ✅                 | ✅                    | ✅             | ✅            | ✅                |
| `prime_mover_type` | ✅        | ✅                 | ✅                    | ✅             | ✅            | ✅                |
| `fuel`             | ✅        | ❌                 | ❌                    | ❌             | ❌            | ❌                |
| `status`           | ✅        | ❌                 | ❌                    | ✅             | ❌            | ✅                |
| `must_run`         | ✅        | ❌                 | ❌                    | ❌             | ❌            | ✅                |
| `ramp_limits`      | ✅        | ❌                 | ❌                    | ✅             | ✅            | ✅                |
| `time_limits`      | ✅        | ❌                 | ❌                    | ✅             | ✅            | ✅                |
| `power_factor`     | ❌        | ✅                 | ✅                    | ❌             | ❌            | ❌                |
| `efficiency`       | ❌        | ❌                 | ❌                    | ❌             | ✅            | ✅                |
| `operation_cost`   | ✅        | ✅                 | ❌                    | ✅             | ✅            | ✅                |

\* Thermal = ThermalStandard, ThermalMultiStart

* * *

## Load-Specific Fields

| Field                   | PowerLoad | StandardLoad | ExponentialLoad | MotorLoad | Interruptible* | Shiftable |
|:----------------------- |:--------- |:------------ |:--------------- |:--------- |:-------------- |:--------- |
| `active_power`          | ✅         | ⊕            | ✅               | ✅         | ✅              | ✅         |
| `reactive_power`        | ✅         | ⊕            | ✅               | ✅         | ✅              | ✅         |
| `conformity`            | ✅         | ✅            | ✅               | ❌         | ✅              | ❌         |
| `operation_cost`        | ❌         | ❌            | ❌               | ❌         | ✅              | ✅         |
| `rating`                | ❌         | ❌            | ❌               | ✅         | ❌              | ❌         |
| `α`, `β` (voltage exp.) | ❌         | ❌            | ✅               | ❌         | ❌              | ❌         |

* * *

## Universal Fields (All StaticInjection)

| Field              | Present in ALL |
|:------------------ |:-------------- |
| `name`             | ✅              |
| `available`        | ✅              |
| `bus`              | ✅              |
| `base_power`       | ✅              |
| `services`         | ✅              |
| `dynamic_injector` | ✅              |
| `ext`              | ✅              |
| `internal`         | ✅              |

* * *

## Operation Cost Types by Device

| Device Category        | Cost Type                                    |
|:---------------------- |:-------------------------------------------- |
| Thermal generators     | `ThermalGenerationCost` or `MarketBidCost`   |
| Hydro generators       | `HydroGenerationCost` or `MarketBidCost`     |
| Renewable generators   | `RenewableGenerationCost` or `MarketBidCost` |
| Controllable loads     | `LoadCost` or `MarketBidCost`                |
| EnergyReservoirStorage | `StorageCost` or `MarketBidCost`             |
| Source                 | `ImportExportCost`                           |

* * *
