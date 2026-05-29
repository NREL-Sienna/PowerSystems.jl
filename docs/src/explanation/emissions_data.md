# [Emissions Data](@id emissions_data)

## Motivation

`EmissionsData` is a [`SupplementalAttribute`](@ref supplemental_attributes) that pairs a
pollutant identity (CO2, NOx, SO2, etc.) with an emission rate expressed as a
[`ValueCurve`](@ref). This supports both constant rates and nonlinear
relationships between fuel consumption / power output and emissions. By modeling
emissions as a supplemental attribute rather than a field on each generator type, a single
`EmissionsData` instance can be shared across multiple components (one-to-many attachment).
This avoids data duplication when several units at the same plant share the same emission
profile and allows emissions metadata to be added or removed without changing the component
struct definitions.

## Example

```julia
using PowerSystems
using PowerSystemCaseBuilder

# Load a test system with thermal generators
sys = build_system(PSITestSystems, "c_sys5_uc")
thermals = collect(get_components(ThermalStandard, sys))

# Create a constant-rate emissions attribute (scalar wraps into IncrementalCurve)
co2 = EmissionsData(;
    name = "co2_ccgt",
    pollutant = PollutantType.CO2,
    emission_rate = 117.6,    # kg/MMBtu (constant rate)
    basis = EmissionBasis.FUEL_INPUT,
    energy_unit = EnergyUnit.MMBTU,
)

# Create an emissions attribute with a linearly varying incremental rate
nox = EmissionsData(;
    name = "nox_ccgt",
    pollutant = PollutantType.NOX,
    emission_rate = IncrementalCurve(LinearFunctionData(0.001, 0.01), nothing, nothing),
    basis = EmissionBasis.FUEL_INPUT,
    energy_unit = EnergyUnit.MMBTU,
    start_up_adder = 5.0,     # 5 kg per cold start
)

# Attach to generators — the same CO2 attribute is shared
add_supplemental_attribute!(sys, thermals[1], co2)
add_supplemental_attribute!(sys, thermals[2], co2)  # shared instance
add_supplemental_attribute!(sys, thermals[1], nox)
```

## Emission Rate as ValueCurve

The `emission_rate` field accepts any [`ValueCurve`](@ref) subtype, typically an
[`IncrementalCurve`](@ref) representing the emission rate (pollutant per unit of
fuel or power):

  - **`IncrementalCurve(LinearFunctionData(0, rate), ...)`** — constant emission rate
  - **`IncrementalCurve(LinearFunctionData(slope, intercept), ...)`** — linearly varying rate
  - **`IncrementalCurve(PiecewiseStepData(...), ...)`** — piecewise step rate (`PiecewiseIncrementalCurve`)

When constructing with a scalar `Real` value, the rate is automatically wrapped in an
`IncrementalCurve` with constant rate. This makes simple constant-rate cases ergonomic
while supporting complex nonlinear relationships for advanced use cases.

## Start-Up Adder

The `start_up_adder` field captures the transient pollutant pulse that occurs during a cold
or warm start before combustion controls and post-combustion controls reach steady state.
The adder is expressed in `mass_unit` per start event. How it is multiplied by start events
is the responsibility of the consumer (e.g., a future PowerSimulations.jl integration will
tie it to the start binary variable in the unit commitment formulation).

## Scope and Future Work

The following features are out of scope for this version and tracked in follow-up issues:

  - Time-varying emission rates (time series support)
  - Hot/warm/cold split of the start-up adder
  - `EmissionsCap` and `EmissionsPrice` supplemental attribute types
  - Removal rate / pollution control fraction
  - PowerSimulations.jl integration
  - Parser support (CSV, Matpower, PSS/E, RTS data format)
