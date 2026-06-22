# [Model Outages](@id model_outages)

This how-to shows how to attach outage data to a [`Device`](@ref) and
configure post-contingency monitoring. The runnable examples use a line contingency on and monitor a [`MonitoredLine`](@ref) — a typical pattern for
security-constrained transmission studies. For background on outage types, see
[Outage and contingency data](@ref outage_and_contingency_data).

## Prerequisites

```@example model_outages
using PowerSystems
using PowerSystemCaseBuilder

sys = build_system(PSITestSystems, "c_sys5_ml")
```

The `c_sys5_ml` test system includes one [`MonitoredLine`](@ref) (`"1"`) with operator
flow limits alongside ordinary [`Line`](@ref)s.

## Attach a deterministic forced outage

[`FixedForcedOutage`](@ref) represents equipment that is either in service (`0.0`) or
outaged (`1.0`). Attach it with [`add_supplemental_attribute!`](@ref) to the contingency
element — here, [`Line`](@ref) `"2"`:

```@example model_outages
contingency_line = get_component(Line, sys, "2")

outage = FixedForcedOutage(; outage_status = 1.0)
add_supplemental_attribute!(sys, contingency_line, outage)
```

## Limit post-contingency monitoring

Every [`Outage`](@ref) carries a `monitored_components` set of [`Device`](@ref) UUIDs.
Populate it when a downstream security-constrained model should monitor only specific
equipment after this outage:

```@example model_outages
monitored_line = get_component(MonitoredLine, sys, "1")

outage = FixedForcedOutage(;
    outage_status = 1.0,
    monitored_components = [monitored_line],
)
add_supplemental_attribute!(sys, contingency_line, outage)

get_monitored_components(outage)
```

Update the monitored set at any time. [`set_monitored_components!`](@ref) replaces the
entire set; singular and plural `add_/remove_*` methods append or remove individual entries:

```@example model_outages
clear_monitored_components!(outage)
set_monitored_components!(outage, get_components(MonitoredLine, sys))
add_monitored_component!(outage, get_component(Line, sys, "3"))
length(get_monitored_components(outage))
```

## Attach a planned outage

[`PlannedOutage`](@ref) references a named time series for the outage schedule. Add the
time series with [`add_time_series!`](@ref) first, then attach the attribute:

```@example model_outages
planned = PlannedOutage(; outage_schedule = "maintenance_schedule")
add_supplemental_attribute!(sys, contingency_line, planned)
get_outage_schedule(planned)
```

## See also

  - [Outage and contingency data](@ref outage_and_contingency_data) — outage types and monitoring semantics
  - [Attach supplemental data to components](@ref attach_contextual_data) — general attachment pattern
  - [`MonitoredLine`](@ref) — transmission lines with operator flow limits for post-contingency monitoring
  - [Working with Time Series](@ref "Working with Time Series Data") — time series for outage schedules
