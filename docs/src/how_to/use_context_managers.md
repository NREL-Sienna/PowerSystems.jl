# [Use Context Managers for Efficient Bulk Operations](@id use_context_managers)

`PowerSystems.jl` provides several "context manager" functions that help you perform bulk
operations more efficiently and safely. These functions temporarily change system settings or
optimize batch operations, then automatically restore the original state when complete.

Context managers in `PowerSystems.jl` follow a pattern similar to `Logging.with_logger` in Julia.
They accept a function (typically as a `do` block) that executes with modified settings,
ensuring cleanup even if errors occur.

## Available Context Managers

`PowerSystems.jl` provides three main context managers:

 1. [`with_units_base`](@ref) - Temporarily change unit system for getting/setting component data
 2. [`begin_supplemental_attributes_update`](@ref) - Optimize bulk addition/removal of supplemental attributes
 3. [`begin_time_series_update`](@ref) - Optimize bulk addition of time series data

## Using `with_units_base`

The [`with_units_base`](@ref) function temporarily changes the [unit system](@ref per_unit)
for a [`System`](@ref) or [`Component`](@ref), executes your code, then automatically restores the original
unit system. This is useful when you need to retrieve or set values in a specific unit system
without permanently changing the system's configuration.

!!! note

    You can specify the unit system using either the `UnitSystem` enum (e.g.,
    `UnitSystem.NATURAL_UNITS`) or a string (e.g., `"NATURAL_UNITS"`). Both forms are
    supported and equivalent.

### Example: Getting Component Data in Natural Units

```@example use_context_managers
using PowerSystems
using PowerSystemCaseBuilder

# Load a system
sys = build_system(PSISystems, "c_sys5_pjm")
gen = first(get_components(ThermalStandard, sys))

# Get active power in natural units (MW) regardless of system's unit base
active_power_mw = with_units_base(sys, UnitSystem.NATURAL_UNITS) do
    get_active_power(gen)
end

# The system's unit base is automatically restored after the block
```

### Example: Setting Multiple Component Values in Natural Units

```@example use_context_managers
# Temporarily change units to add/modify multiple components in natural units
with_units_base(sys, "NATURAL_UNITS") do
    for gen in get_components(ThermalStandard, sys)
        # Set values in MW, MVA, etc.
        set_active_power!(gen, 150.0)  # MW
        set_rating!(gen, 200.0)        # MVA
    end
end

# System automatically returns to original unit base
```

### Component-Level Context Manager

You can also use `with_units_base` on individual components:

```@example use_context_managers
active_power_mw = with_units_base(gen, UnitSystem.NATURAL_UNITS) do
    get_active_power(gen)
end
```

!!! tip

    The `with_units_base` context manager is particularly useful when you need to work with
    data in natural units (MW, MVA, etc.) while keeping your system configured in per-unit
    for optimization or simulation purposes.

## Using `begin_supplemental_attributes_update`

The [`begin_supplemental_attributes_update`](@ref) function optimizes performance when adding
or removing many supplemental attributes. It batches operations together, reducing overhead
from repeated index updates.

If an error occurs during the update, all changes are automatically reverted, ensuring data
consistency.

```julia
begin_supplemental_attributes_update(sys) do
    for gen in get_components(ThermalStandard, sys)
        outage = GeometricDistributionForcedOutage(;
            mean_time_to_recovery = 8.0,
            outage_transition_probability = 0.001,
        )
        add_supplemental_attribute!(sys, gen, outage)
    end
end
```

Without the context manager, each individual call to `add_supplemental_attribute!` updates
internal indexes separately, which can be slow when adding many attributes. For a complete
worked example, see [Attach supplemental data to components](@ref attach_contextual_data).

## Using `begin_time_series_update`

The [`begin_time_series_update`](@ref) function optimizes performance when adding many time
series arrays by keeping the HDF5 file open and batching SQLite database operations. This
reduces the overhead of repeatedly opening/closing files and performing individual database
transactions.

If an error occurs during the update, changes are automatically reverted.

!!! note

    This context manager is not necessary for in-memory time series stores, only for
    HDF5-backed storage.

### Example: Adding Multiple Time Series

```@example use_context_managers
using PowerSystems
using Dates

# Create time series data
resolution = Dates.Hour(1)
data = Dict(
    DateTime("2020-01-01T00:00:00") => ones(24),
    DateTime("2020-01-02T00:00:00") => ones(24) * 1.1,
)

# Get components
generators = collect(get_components(ThermalStandard, sys))

# Use context manager for efficient bulk addition
begin_time_series_update(sys) do
    for (i, gen) in enumerate(generators)
        forecast = Deterministic(
            "max_active_power",
            data,
            resolution;
            scaling_factor_multiplier = get_max_active_power,
        )
        add_time_series!(sys, gen, forecast)
    end
end
```

!!! tip

    When adding thousands of time series arrays, using `begin_time_series_update` can
    provide significant performance improvements by reducing file I/O and database
    transaction overhead.

## Nesting Context Managers

Context managers can be nested if needed:

```julia
with_units_base(sys, "NATURAL_UNITS") do
    begin_time_series_update(sys) do
        # Add time series with natural unit scaling factors
        for gen in get_components(Generator, sys)
            # ... add time series ...
        end
    end
end
```

## See Also

  - [Per-unit Conventions](@ref per_unit) - Learn more about unit systems
  - [Supplemental attributes](@ref supplemental_attributes_explanation) — why contextual data is separate from components
  - [Attach supplemental data to components](@ref attach_contextual_data) — bulk attachment with `begin_supplemental_attributes_update`
  - [Working with Time Series Data](@ref "Working with Time Series Data") - Tutorial on time series handling
  - [Improve Performance with Time Series Data](@ref improve_ts_performance) - Additional time series performance tips
