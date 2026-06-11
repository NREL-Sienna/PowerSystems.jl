# [Model generator outages](@id model_generator_outages)

This how-to shows how to attach outage supplemental attributes and configure
post-contingency monitoring. For background on outage types, see
[Outage and contingency data](@ref outage_and_contingency_data).

## Prerequisites

```@example model_generator_outages
using PowerSystems
using PowerSystemCaseBuilder

sys = build_system(PSISystems, "c_sys5_pjm")
```

## Attach a deterministic forced outage

[`FixedForcedOutage`](@ref) represents a generator that is either available (`0.0`) or
outaged (`1.0`):

```@example model_generator_outages
gens = collect(get_components(ThermalStandard, sys))
gen1, gen2 = gens[1], gens[2]

outage = FixedForcedOutage(; outage_status = 0.0)
add_supplemental_attribute!(sys, gen1, outage)
```

## Limit post-contingency monitoring

Every [`Outage`](@ref) carries a `monitored_components` set of [`Device`](@ref) UUIDs.
Populate it when a downstream security-constrained model should monitor only specific
equipment after this outage:

```@example model_generator_outages
outage = FixedForcedOutage(;
    outage_status = 0.0,
    monitored_components = [gen1, gen2],
)
add_supplemental_attribute!(sys, gen1, outage)

get_monitored_components(outage)
```

You can also populate from [`get_components`](@ref):

```@example model_generator_outages
outage_all = FixedForcedOutage(;
    outage_status = 0.0,
    monitored_components = get_components(ThermalStandard, sys),
)
```

Update the monitored set at any time. [`set_monitored_components!`](@ref) replaces the
entire set; singular and plural `add_/remove_*` methods append or remove individual entries:

```@example model_generator_outages
clear_monitored_components!(outage)
set_monitored_components!(outage, get_components(Line, sys))
add_monitored_component!(outage, gen2)
length(get_monitored_components(outage))
```

## Attach a planned outage

[`PlannedOutage`](@ref) references a named time series for the outage schedule. Add the
time series to the system first, then attach the attribute:

```@example model_generator_outages
planned = PlannedOutage(; outage_schedule = "maintenance_schedule")
add_supplemental_attribute!(sys, gen1, planned)
get_outage_schedule(planned)
```

## See also

  - [Outage and contingency data](@ref outage_and_contingency_data) — outage types and monitoring semantics
  - [Attach supplemental data to components](@ref attach_contextual_data) — general attachment pattern
  - [Working with Time Series](@ref "Working with Time Series Data") — time series for outage schedules
