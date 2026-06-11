# [Add emissions to generators](@id add_emissions_to_generators)

This how-to shows how to attach [`EmissionsData`](@ref) supplemental attributes to
generators. For background on emissions metadata, see [Emissions metadata](@ref emissions_metadata).

## Prerequisites

```@example add_emissions_to_generators
using PowerSystems
using PowerSystemCaseBuilder

sys = build_system(PSITestSystems, "c_sys5_uc")
thermals = collect(get_components(ThermalStandard, sys))
```

## Create a constant-rate emissions attribute

A scalar `emission_rate` is automatically wrapped in a constant-rate [`IncrementalCurve`](@ref):

```@example add_emissions_to_generators
co2 = EmissionsData(;
    name = "co2_ccgt",
    pollutant = PollutantType.CO2,
    emission_rate = 117.6,
    basis = EmissionBasis.FUEL_INPUT,
    energy_unit = EnergyUnit.MMBTU,
)
```

## Create a varying-rate emissions attribute

Pass a [`ValueCurve`](@ref) directly for nonlinear or piecewise relationships:

```@example add_emissions_to_generators
nox = EmissionsData(;
    name = "nox_ccgt",
    pollutant = PollutantType.NOX,
    emission_rate = IncrementalCurve(LinearFunctionData(0.001, 0.01), nothing, nothing),
    basis = EmissionBasis.FUEL_INPUT,
    energy_unit = EnergyUnit.MMBTU,
    start_up_adder = 5.0,
)
```

## Attach to generators

Attach attributes with [`add_supplemental_attribute!`](@ref). The same [`EmissionsData`](@ref)
instance can be shared across multiple units:

```@example add_emissions_to_generators
add_supplemental_attribute!(sys, thermals[1], co2)
add_supplemental_attribute!(sys, thermals[2], co2)
add_supplemental_attribute!(sys, thermals[1], nox)
```

Verify attachments with [`get_component_supplemental_attribute_pairs`](@ref):

```@example add_emissions_to_generators
pairs = collect(
    get_component_supplemental_attribute_pairs(ThermalStandard, EmissionsData, sys),
)
length(pairs)
```

## See also

  - [Emissions metadata](@ref emissions_metadata) — emission rate, basis, and start-up adder concepts
  - [Attach supplemental data to components](@ref attach_contextual_data) — general attachment pattern
  - [`ValueCurve` Options](@ref curve_table) — curve types for `emission_rate`
  - [Grouping units and emissions](@ref "Grouping Units and Emissions") — hands-on tutorial
