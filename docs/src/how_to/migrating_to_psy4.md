# [Migrating from version 3.0 to 4.0](@id psy4_migration)

This guide outlines the code updates required to upgrade from PowerSystems.jl version 3.0
to 4.0, which was released in June 2024 and includes breaking changes. These are:

  - [Renamed Types and Parameters](@ref)
  - [New and Eliminated Types](@ref)
  - [Updates to Energy Storage Parameters](@ref esr_migration)
  - [Hydropower `status` added](@ref)
  - [New Cost Functions](@ref)
  - [New Time Series Horizon Format](@ref)
  - [Minor Type Hierarchy Change](@ref)
  - [(Temporary) Use Version 3.0 for `HybridSystem` (+ new parameter)](@ref)

## Renamed Types and Parameters

Some `Types` and fields were renamed, which should require a trivial search and replace:

Renamed `Types`:

  - `RenewableFix` is now named [`RenewableNonDispatch`](@ref)
  - `StaticReserve` is now named [`ConstantReserve`](@ref)
  - `StaticReserveGroup` is now named [`ConstantReserveGroup`](@ref)
  - `StaticReserveNonSpinning` is now named [`ConstantReserveNonSpinning`](@ref)
  - `PriorityCurrentLimiter` is now named [`PriorityOutputCurrentLimiter`](@ref)
  - `MagnitudeCurrentLimiter` is now named [`MagnitudeOutputCurrentLimiter`](@ref)
  - `InstantaneousCurrentLimiter` is now named [`InstantaneousOutputCurrentLimiter`](@ref)

Renamed parameters:

  - The `rate` parameter is now named `rating` for subtypes of `Branch`, for
    consistency with other Types. Affected Types are:
    
      + [`Line`](@ref)
      + [`MonitoredLine`](@ref)
      + [`PhaseShiftingTransformer`](@ref)
      + [`TapTransformer`](@ref)
      + [`Transformer2W`](@ref)

## New and Eliminated Types

In addition to cost-related types detailed in [New Cost Functions](@ref), these new types
have been added:

  - [`AreaInterchange`](@ref)
  - [`HybridOutputCurrentLimiter`](@ref)
  - [`SaturationOutputCurrentLimiter`](@ref)

These types are no longer part of PowerSystems.jl, although there are future plans to rework
some of them:

  - `RegulationDevice`
  - `Transfer`
  - `BatteryEMS`
  - `GenericBattery` (see [Updates to Energy Storage Parameters](@ref esr_migration))

## [Updates to Energy Storage Parameters](@id esr_migration)

[`EnergyReservoirStorage`](@ref) is now the default battery and energy storage model,
replacing `GenericBattery`.

There are also changes to the data fields compared to `GenericBattery` to improve clarity
and modeling flexibility.

New data fields:

  - `storage_capacity` for the maximum storage capacity (can be in units of,
    e.g., MWh for batteries or liters for hydrogen)
    
      + Example: 10000.0 for 10,000 liters hydrogen

  - `storage_level_limits` for the minimum and maximum allowable storage levels
    on [0, 1], which can be used to model derates or other restrictions, such as
    state-of-charge restrictions on battery cycling
    
      + Example: Minimum of 0.2 and maximum of 1.0 to restrict the storage from dropping below
        20% capacity to keep some reserve margin available at all times
  - `initial_storage_capacity_level` for the initial storage capacity level as
    a ratio [0, 1.0] of `storage_capacity`
    
      + Example: 0.5 to start the storage at 50% full
  - `conversion_factor` is the (optional) conversion factor of `storage_capacity` to MWh, if
    different than 1.0 (i.e., no conversion is needed if the `storage_capacity` is in MWh)
    
      + Example: 0.0005 for 0.5 kWh/l hydrogen

Removed data fields:

  - `state_of_charge_limits` with units of p.u.-hr
  - `initial_energy` with units of p.u.-hr

## Hydropower `status` added

A new required parameter, `status`, was added to [`HydroEnergyReservoir`](@ref) and
[`HydroPumpedStorage`](@ref), for the initial condition of the generator.

  - For [`HydroEnergyReservoir`](@ref), `status` can be `true` = on or `false` = off.
  - For [`HydroPumpedStorage`](@ref), `status` can be `PumpHydroStatus.PUMP`,
    `PumpHydroStatus.GEN`, or `PumpHydroStatus.OFF`

## New Cost Functions

## New Time Series Horizon Format

The [horizon](@ref H) for a forecast has changed from a **count** of time steps (as an
`Int`) to a **duration**, as a
[`Dates.Period`](https://docs.julialang.org/en/v1/stdlib/Dates/#Period-Types)

**Example day-ahead forecast:** A forecast with hourly [resolution](@ref R) for the next
24 hours, with a new forecast available every 24 hours (i.e., 24-hour [interval](@ref I))

  - The horizon is now `Dates.Hour(24)` or `Dates.Day(1)`
  - Previously in version 3.0, the horizon would have been `24` for the 24 1-hour time-steps
    in each forecast

**Example hour-ahead forecast:** A forecast with 5-minute [resolution](@ref R) for the next
1 hour, with a new forecast available every hour (i.e., 1-hour [interval](@ref I))

  - The horizon is now `Dates.Hour(1)`
  - Previously in version 3.0, the horizon would have been `12` for the 12 5-minute time-steps
    in each forecast

## Minor Type Hierarchy Change

  - [`ControllableLoad`](@ref) is now a subtype of [`StaticLoad`](@ref) rather than
    `ElectricLoad`

The vast majority of users are not expected to be impacted by this change.

## (Temporary) Use Version 3.0 for `HybridSystem` (+ new parameter)

The [`HybridSystem`](@ref) is currently not supported in the rest of the Sienna ecosystem,
such as PowerSimulations.jl. To use `HybridSystem` in simulation, revert to version 3.0.
There are plans to update `HybridSystem` for version 4.0, but they have not been completed.

In addition, `HybridSystem` has a new required parameter: `interconnection_efficiency`
