# [Power Concepts: Base Power, Rating, and Max Active Power](@id power_concepts)

When working with generators in PowerSystems.jl, it's important to understand the distinction between three key power concepts: base power, rating, and maximum active power. These concepts serve different purposes and are stored using different unit conventions.

## Base Power

**Base power** is the reference power value used for per-unitization of a specific
device — the denominator when converting device parameters to per-unit values, typically
the nameplate capacity. It answers: "What is the natural scale of this device?"

Base power is a fundamental parameter for the per-unit system. For more details on per-unitization, see the [Per-unit Conventions](@ref per_unit) page.

## Rating

**Rating** represents the maximum AC side output power rating of the synchronous machine
or generator — the maximum apparent power (MVA) that the generator's electrical
components can safely handle, considering constraints such as:

  - Stator winding thermal limits
  - Rotor field winding limits
  - Cooling system capacity

The rating is typically determined by the electrical design and thermal limits of the synchronous machine itself. It represents the maximum capability of the electrical generator, independent of the prime mover.

## Maximum Active Power

**Maximum active power** represents the maximum real power (MW) output of the prime
mover, considering constraints such as:

  - Turbine capacity (for steam, gas, or hydro turbines)
  - Combustion chamber limits (for gas turbines)
  - Boiler capacity (for steam generators)
  - Fuel flow limitations

The maximum active power is determined by the mechanical system that drives the generator. This is often less than the rating when considering only real power production.

## Key Distinctions

### Storage Convention Summary

| Concept          | Storage Units       | Getter Function                  |
|:---------------- |:------------------- |:-------------------------------- |
| Base Power       | Natural units (MVA) | [`get_base_power()`](@ref)       |
| Rating           | Device base (p.u.)  | [`get_rating()`](@ref)           |
| Max Active Power | Device base (p.u.)  | [`get_max_active_power()`](@ref) |

### Example

Consider a thermal generator with:

  - `base_power = 100.0` MVA (stored in natural units)
  - `rating = 1.0` p.u. (equals 100 MVA when converted to natural units)
  - `max_active_power = 0.95` p.u. (equals 95 MW when converted to natural units)

In this example:

  - The generator's electrical components can handle up to 100 MVA
  - The prime mover (e.g., steam turbine) can deliver up to 95 MW of real power
  - The difference accounts for the fact that the turbine's mechanical power limit is slightly below the generator's electrical rating

### Unit System Conversions

When you access these values through the `PowerSystems.jl` getter functions, they are
automatically converted based on the current unit system setting. For a step-by-step
guide, see [Read Component Values in Different Unit Systems](@ref convert_unit_systems).

## See Also

  - [Per-unit Conventions](@ref per_unit) - Detailed explanation of unit systems in PowerSystems.jl
  - [`ThermalStandard`](@ref) - Generator type with these power parameters
  - [`get_units_base`](@ref) and [`set_units_base_system!`](@ref) - Functions for managing unit systems
