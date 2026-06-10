# [Per-unit Conventions](@id per_unit)

It is often useful to express power systems data in relative terms using per-unit conventions.
`PowerSystems.jl` supports conversion of data between three different unit systems:

 1. `NU` (natural units): The naturally defined units of each parameter (typically MW).
 2. `SU` (system base): Parameter values are divided by the system `base_power`.
 3. `DU` (device base): Parameter values are divided by the device `base_power`.

`PowerSystems.jl` supports these unit systems because different power system tools and data
sets use different units systems by convention, such as:

  - Dynamics data is often defined in device base
  - Network data (e.g., reactance, resistance) is often defined in system base
  - Production cost modeling data is often gathered from variety of data sources,
    which are typically defined in natural units

## Explicit units in accessors

As of PowerSystems 6, unit conversion is **explicit at every call site**: each unit-bearing
accessor takes a units argument, and each setter takes a unit-tagged value. There is no
system-wide mutable unit setting that changes what accessors return.

```julia
get_active_power(gen, SU)       # bare Float64, system-base per-unit
get_active_power(gen, DU)       # bare Float64, device-base per-unit
get_active_power(gen, NU)       # bare Float64, natural units (MW)
get_active_power(gen, MW)       # bare Float64 in an explicit Unitful unit
get_active_power_unitful(gen, SU)  # unit-bearing value (RelativeQuantity / Unitful.Quantity)

set_active_power!(gen, 0.9 * SU)    # values must carry their units
set_active_power!(gen, 90.0 * MW)
set_rating!(line, 1.2 * DU)
set_x!(transformer, 105.8 * OHMS)   # impedance/admittance fields accept Ω / S
```

Conversion between unit systems does not change the stored parameter values — storage is
in device base (`DU`) for most fields. Conversions happen when accessing parameters
through the accessor functions, making it imperative to use the accessors instead of "dot"
field access. The units of the stored values for each struct are defined in
`src/descriptors/power_system_structs.json`.

Bare `Float64` arguments to converted setters are rejected with an `ArgumentError`: the
caller must say what units the number is in (`val * SU`, `val * DU`, `val * MW`, …). The
unit-tagged per-unit values are [`RelativeQuantity`](@ref)s, whose unit marker is carried
in the type; mixing `DU`- and `SU`-tagged values in arithmetic or comparisons raises a
clear error instead of producing a silently wrong number.

## Migration guide: stateful → explicit units

Code written against PowerSystems 5 used a mutable system-wide unit setting:

| PowerSystems 5 (stateful)                                                       | PowerSystems 6 (explicit)                                                                       |
|:------------------------------------------------------------------------------- |:----------------------------------------------------------------------------------------------- |
| `set_units_base_system!(sys, "SYSTEM_BASE"); get_active_power(gen)`             | `get_active_power(gen, SU)`                                                                     |
| `with_units_base(sys, UnitSystem.NATURAL_UNITS) do; get_active_power(gen); end` | `get_active_power(gen, NU)`                                                                     |
| `set_active_power!(gen, 0.9)` (interpreted via system setting)                  | `set_active_power!(gen, 0.9 * SU)`                                                              |
| `get_rating(line)`                                                              | `get_rating(line, SU)`                                                                          |
| `scaling_factor_multiplier = get_max_active_power` (1-arg)                      | same name; the multiplier is invoked as `get_max_active_power(gen, units)` with `SU` by default |

Notes:

  - Time-series retrieval passes a units argument to two-argument scaling-factor
    multipliers; the default for PowerSystems components is `SU`. One-argument multipliers
    (custom closures) are still invoked with the owner only.
  - The `UnitSystem` enum (`get_units_base`, `set_units_base_system!`,
    `with_units_base`) is system metadata only (shown in the `System` summary); it does
    not affect any conversion.
  - `CostCurve`/`FuelCurve` take the marker instances (`NaturalUnit()`,
    `SystemBaseUnit()`, `DeviceBaseUnit()`) for `power_units`.

## Defining components

When you define components that aren't attached to a `System`, field values are stored as
given, in device base (`DU`), except for certain components that don't have their own
`base_power` rating, such as [`Line`](@ref)s, where values are relative to the system base
once attached. To define data in natural units, construct the component and then use the
explicit-units setters (e.g. `set_active_power!(gen, 90.0 * MW)`); the accessor does the
conversion to per-unit storage.

By default, downstream optimization packages work in `SU` because many optimization
problems won't converge when using natural units (for example in
[`PowerSimulations.jl`](https://sienna-platform.github.io/PowerSimulations.jl/stable/)).

!!! note

    Check the [`Transformers per unit explanation`](@ref transformers_pu) for details on how
    the per-unit is managed
