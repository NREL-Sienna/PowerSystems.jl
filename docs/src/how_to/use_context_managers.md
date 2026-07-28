# Use Context Managers for Efficient Bulk Operations

`PowerSystems.jl` provides several "context manager" functions that help you perform bulk
operations more efficiently and safely. These functions temporarily change system settings or
optimize batch operations, then automatically restore the original state when complete.

Context managers in PowerSystems follow a pattern similar to `Logging.with_logger` in Julia.
They accept a function (typically as a `do` block) that executes with modified settings,
ensuring cleanup even if errors occur.

## Available Context Managers

PowerSystems provides two main context managers:

 1. [`begin_supplemental_attributes_update`](@ref) - Optimize bulk addition/removal of supplemental attributes
 2. [`time_series_transaction`](@ref) - Optimize bulk addition of time series data

!!! note

    Earlier versions of PowerSystems also provided a `with_units_base` context manager for
    temporarily changing a stateful, system-wide unit setting. Units are explicit at every
    call site now (see [Per-unit Conventions](@ref per_unit)), so that mechanism has been
    removed.

## Using `begin_supplemental_attributes_update`

The [`begin_supplemental_attributes_update`](@ref) function optimizes performance when adding
or removing many supplemental attributes. It batches operations together, reducing overhead
from repeated index updates.

If an error occurs during the update, all changes are automatically reverted, ensuring data
consistency.

### Example: Adding Multiple Supplemental Attributes

```julia
using PowerSystems

# Define some supplemental attributes (e.g., outage data)
outage1 = FixedForcedOutage(;
    mean_time_to_recovery = 8.0,
    mean_time_to_failure = 1000.0,
)

outage2 = FixedForcedOutage(;
    mean_time_to_recovery = 12.0,
    mean_time_to_failure = 800.0,
)

# Get components to attach attributes to
gen1 = get_component(ThermalStandard, sys, "322_CT_6")
gen2 = get_component(ThermalStandard, sys, "323_CC_1")

# Use context manager for efficient bulk addition
begin_supplemental_attributes_update(sys) do
    add_supplemental_attribute!(sys, gen1, outage1)
    add_supplemental_attribute!(sys, gen2, outage2)
    # Add many more attributes...
end
```

### Example: Bulk Operations with Error Handling

```julia
# If an error occurs, all changes are automatically reverted
try
    begin_supplemental_attributes_update(sys) do
        add_supplemental_attribute!(sys, component1, attribute1)
        add_supplemental_attribute!(sys, component2, attribute2)
        # ... more operations ...
        error("Something went wrong!")  # All changes will be reverted
    end
catch e
    @warn "Operation failed, changes were reverted" exception=e
end
```

!!! note

    Without using this context manager, each individual call to
    `add_supplemental_attribute!` updates internal indexes separately, which can be slow
    when adding many attributes. The context manager batches all updates together for
    better performance.

## Using `time_series_transaction`

The [`time_series_transaction`](@ref) function optimizes performance when adding many time
series arrays. It yields a **context**: pass it to each `add_time_series!` in the block and
the additions are buffered and written to the store as one bulk call, instead of one write
per series.

The block is also a transaction. If it throws, everything it did is rolled back — including
**removals**, which are irreversible outside a block, because the store frees a time series
array as soon as its last reference goes.

!!! warning

    An open block holds the store's write lock. Gather your data first — reading CSVs,
    querying a database — and keep the block to the writes themselves.

!!! note

    Blocks nest innermost-first: an inner block must finish before the one enclosing it.

### Example: Adding Multiple Time Series

```julia
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

# Use a transaction for efficient bulk addition
time_series_transaction(sys) do txn
    for (i, gen) in enumerate(generators)
        forecast = Deterministic(
            "max_active_power",
            data,
            resolution;
            scaling_factor_multiplier = get_max_active_power,
        )
        add_time_series!(txn, gen, forecast)
    end
end
```

### Example: Adding Time Series from Multiple Sources

```julia
# When you have time series data from multiple sources
time_series_transaction(sys) do txn
    for component in get_components(Generator, sys)
        # Create time series data specific to each component
        # (In practice, this might come from CSV files, databases, or other sources)
        component_data = Dict(
            DateTime("2020-01-01T00:00:00") => rand(24),
            DateTime("2020-01-02T00:00:00") => rand(24),
        )

        forecast = Deterministic(
            "max_active_power",
            component_data,
            resolution;
            scaling_factor_multiplier = get_max_active_power,
        )
        add_time_series!(txn, component, forecast)
    end
end
```

!!! tip

    When adding thousands of time series arrays, `time_series_transaction` can provide
    large performance improvements — but only for the additions made on the yielded
    transaction. An `add_time_series!` on `sys` inside the block writes on its own.

## Best Practices

 1. **Always use context managers for bulk operations**: When adding multiple supplemental
    attributes or time series, use the appropriate context manager to improve performance.

 2. **Automatic rollback**: If the block throws, `time_series_transaction` rolls its
    transaction back, so the store is left exactly as it was — additions and removals alike.

 3. **Nested context managers**: You can nest context managers if needed:

    ```julia
    begin_supplemental_attributes_update(sys) do
        time_series_transaction(sys) do context
            for gen in get_components(Generator, sys)
                # ... add supplemental attributes and time series ...
            end
        end
    end
    ```

 4. **Error handling**: The context managers automatically handle cleanup, but you can still
    use `try-catch` blocks for application-specific error handling:

    ```julia
    try
        time_series_transaction(sys) do context
            # ... operations ...
        end
    catch e
        @error "Time series update failed" exception=e
        # Handle application-specific recovery
    end
    ```

## See Also

  - [Per-unit Conventions](@ref per_unit) - Learn more about unit systems
  - [Supplemental Attributes](@ref supplemental_attributes) - Details on supplemental attribute usage
  - [Working with Time Series Data](@ref tutorial_time_series) - Tutorial on time series handling
  - [Improve Performance with Time Series Data](@ref) - Additional time series performance tips
