# [Emissions metadata](@id emissions_metadata)

## Motivation

[`EmissionsData`](@ref) is a [`SupplementalAttribute`](@ref) that pairs a pollutant identity
(CO₂, NOx, SO₂, etc.) with an emission rate expressed as a [`ValueCurve`](@ref). This
supports both constant rates and nonlinear relationships between fuel consumption or power
output and emissions.

By modeling emissions as a supplemental attribute rather than a field on each generator type,
a single [`EmissionsData`](@ref) instance can be shared across multiple components. This
avoids data duplication when several units at the same plant share the same emission profile
and allows emissions metadata to be added or removed without changing component struct
definitions.

## Emission rate and basis

The `emission_rate` field accepts any [`ValueCurve`](@ref) subtype, typically an
[`IncrementalCurve`](@ref) representing the emission rate (pollutant mass per unit of fuel
or power). When you pass a scalar `Real` value at construction, the rate is automatically
wrapped in a constant-rate [`IncrementalCurve`](@ref). More complex shapes — linearly varying
rates, piecewise steps — use the same [`ValueCurve`](@ref) machinery as cost curves. See
[`ValueCurve` Options](@ref curve_table) for the available curve types.

The `basis` field (`FUEL_INPUT` or `POWER_OUTPUT`) and `energy_unit` field (`MMBTU`, `GJ`,
or `MWH`) together define the denominator of the rate. These must be consistent: fuel-input
rates use heat units; power-output rates use `MWH`.

## Start-up adder

The `start_up_adder` field captures the transient pollutant pulse that occurs during a cold
or warm start before combustion controls and post-combustion controls reach steady state.
The adder is expressed in `mass_unit` per start event. How it is multiplied by start events
is the responsibility of the consumer (e.g., a future PowerSimulations.jl integration will
tie it to the start binary variable in the unit commitment formulation).

## Scope and future work

The following features are out of scope for the current version and tracked in follow-up issues:

  - Time-varying emission rates (time series support)
  - Hot/warm/cold split of the start-up adder
  - `EmissionsCap` and `EmissionsPrice` supplemental attribute types
  - Removal rate / pollution control fraction
  - PowerSimulations.jl integration
  - Parser support (CSV, Matpower, PSS/E, RTS data format)

## See also

  - [Supplemental attributes](@ref supplemental_attributes_explanation) — the general concept
  - [Add emissions to generators](@ref add_emissions_to_generators) — step-by-step attachment
  - [`EmissionsData`](@ref) — API reference
  - [`ValueCurve` Options](@ref curve_table) — curve types for `emission_rate`
