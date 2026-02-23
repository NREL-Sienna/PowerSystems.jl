# [Per-unit Conventions](@id per_unit)

It is often useful to express power systems data in relative terms using per-unit (p.u.) conventions.
`PowerSystems.jl` supports the automatic conversion of data between three different unit systems:

 1. `"NATURAL_UNITS"`: The naturally defined units of each parameter (typically MW).
 2. `"SYSTEM_BASE"`: Parameter values are divided by the system `base_power`.
 3. `"DEVICE_BASE"`: Parameter values are divided by the device `base_power`.

`PowerSystems.jl` supports these unit systems because different power system tools and data
sets use different units systems by convention, such as:

  - Dynamics data is often defined in device base
  - Network data (e.g., reactance, resistance) is often defined in system base
  - Production cost modeling data is often gathered from variety of data sources,
    which are typically defined in natural units

These three unit bases allow easy conversion between unit systems.
This allows `PowerSystems.jl` users to input data in the formats they have available,
as well as view data in the unit system that is most intuitive to them.

You can get and set the unit system setting of a `System` with [`get_units_base`](@ref) and
[`set_units_base_system!`](@ref). To support a less stateful style of programming,
`PowerSystems.jl` provides the `Logging.with_logger`-inspired "context manager"-type
function [`with_units_base`](@ref), which sets the unit system to a particular value,
performs some action, then automatically sets the unit system back to its previous value.

Conversion between unit systems does not change
the stored parameter values. Instead, unit system conversions are made when accessing
parameters using the [getter functions](@ref dot_access), thus making it
imperative to utilize the getter functions instead of the "dot" accessor methods to
ensure the return of the correct values. The units of the parameter values stored in each
struct are defined in `src/descriptors/power_system_structs.json`.

There are some unit system conventions in `PowerSystems.jl` when defining new components.
Currently, when you define components that aren't attached to a `System`,
you must define all fields in `"DEVICE_BASE"`, except for certain components that don't
have their own `base_power` rating, such as [`Line`](@ref)s, where the `rating` must be
defined in `"SYSTEM_BASE"`.

In the future, `PowerSystems.jl` hopes to support defining components in natural units.
For now, if you want to define data in natural units, you must first
set the system units to `"NATURAL_UNITS"`, define an empty component, and then use the
[getter functions](@ref dot_access) (e.g., getters and setters), to define each field
within the component. The getter functions will then do the data conversion from your
input data in natural units (e.g., MW or MVA) to per-unit.

By default, `PowerSystems.jl` uses `"SYSTEM_BASE"` because many optimization problems won't
converge when using natural units. If you change the unit setting, it's suggested that you
switch back to `"SYSTEM_BASE"` before solving an optimization problem (for example in
[`PowerSimulations.jl`](https://nrel-sienna.github.io/PowerSimulations.jl/stable/)).

## Transformer per unit transformations
Per-unit conventions with transformers simplify calculations by normalizing all quantities (voltage, current, power, impedance) to a common base. This effectively "retains" the ideal transformer from the circuit diagram because the per-unit impedance of a transformer remains the same when referred from one side to the other.

!!! note

    The return value of the getter functions, e.g., [`get_x`](@ref) for the transformer impedances will perform the transformations following the convention in [`Per-unit Conventions`](@ref per_unit).