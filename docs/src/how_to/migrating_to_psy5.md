# [Migrating from version 4.0 to 5.0](@id psy5_migration)

This guide outlines the code updates required to upgrade from PowerSystems.jl version 4.0
to 5.0, which was released in May 2025 and includes breaking changes. Most the changes are related
to modeling in more detail AC transmission technologies.

The changes are:

  - [AC Branches Type Hierarchy Change](@ref)
  - [Renamed Types and Parameters](@ref)
  - [New and Eliminated Types](@ref)
  - [Updates to Hydro Storage related devices](@ref Hyd_updates)
  - [Updates to fuel categories](@ref)

## AC Branches Type Hierarchy Change

New abstract type [`ACTransmission`](@ref) and was created to better distinguish between AC transmission objects connected between [`ACBus`](@ref) the new added [`TwoTerminalHVDC`](@ref) abstract type to caputre HVDC links connected between [`ACBus`](@ref).

## Renamed Types and Parameters

Some `Types` and fields were renamed, which should require a trivial search and replace:

Renamed `Types`:

  - [`TwoTerminalHVDCLine`](@ref) is now named [`TwoTerminalGenericHVDCLine`](@ref) and a method has been included to read old `TwoTerminalHVDCLine` data. See [Deprecated Methods](@ref logging)
  - `TimeSeriesForcedOutage` is now named [`FixedForcedOutage`](@ref) and the method has been removed but the functionality remains.

New parameters:

  - The [`ACTransmission`](@ref) objects now have rating fields for `b` and `c` ratings to enable modeling security constrained problems. These components now also include a field for their base power, in situations where the base power for the transformer is not availble (e.g., when parsing Matpower) the default behavior is to use the system base.

Affected Types are:

      + [`Line`](@ref)
      + [`MonitoredLine`](@ref)
      + [`PhaseShiftingTransformer`](@ref)
      + [`TapTransformer`](@ref)
      + [`Transformer2W`](@ref)

  - `FuelCurve`(@ref) now has a new field for fuel offtake at the start of a thermal unit. This field defaults to a `LinearCurve(0.0)` value.

## New and Eliminated Types

  - [`Transformer3W`](@ref) (see [Handle 3-windig transformer data](@ref 3wtdata))
  - [`TwoTerminalLCCLine`](@ref)
  - [`TwoTerminalVSCLine`](@ref)
  - [`HydroReservoir`](@ref)
  - [`HydroTurbine`](@ref)
  - [`HydroPumpTurbine`](@ref)
  - [`ShiftablePowerLoad`](@ref)
  - [`DiscreteControlledACBranch`](@ref)
  - [`FACTSControlDevice`](@ref)
  - [`ImpedanceCorrectionData`](@ref)
  - [`ImportExportCost`](@ref)
  - [`SynchronousCondenser`](@ref)

These types are no longer part of PowerSystems.jl:

  - `TwoTerminalVSDCLine`
  - `HydroPumpedStorage` (see [Updates to Hydro Storage related devices](@ref Hyd_updates))
  - `HydroEnergyReservoir` (see [Updates to Hydro Storage related devices](@ref Hyd_updates))

## [Updates to Hydro Storage related devices](@id Hyd_updates)

In previous versions of PowerSystems.jl hydropower connected to reservoirs was modeled as a single plant connected to a single reservoir. Further, the model was

## Updates to fuel categories
