# [Outage and contingency data](@id outage_and_contingency_data)

## Role in the data model

Outage supplemental attributes describe when equipment is unavailable and which parts of the
network a downstream simulation should monitor after a contingency occurs. They sit under the
[`Contingency`](@ref) and [`Outage`](@ref) abstract types in the supplemental attribute
hierarchy. PowerSystems.jl stores the data; the mathematical treatment of outages in
optimization or reliability models is the responsibility of downstream packages such as
PowerSimulations.jl.

## Outage types and when to use them

| Type                                        | Modeling role                                                                                                            |
|:------------------------------------------- |:------------------------------------------------------------------------------------------------------------------------ |
| [`FixedForcedOutage`](@ref)                 | Deterministic forced outage with a fixed status (0 = available, 1 = outaged). Can be time-varying via time series.       |
| [`GeometricDistributionForcedOutage`](@ref) | Stochastic forced outages via geometric transition probabilities, with optional time-varying failure and recovery rates. |
| [`PlannedOutage`](@ref)                     | Scheduled outages driven by a named time series (`outage_schedule`).                                                     |

Choose [`FixedForcedOutage`](@ref) when you know the outage state deterministically (for
example, a generator flagged out for maintenance in a production cost model). Choose
[`GeometricDistributionForcedOutage`](@ref) when failure and recovery are modeled as random
events. Choose [`PlannedOutage`](@ref) when you have an explicit outage schedule as time
series data.

## Post-contingency monitoring

Every concrete [`Outage`](@ref) carries a `monitored_components` field of type
`Set{Base.UUID}`. It identifies the [`Device`](@ref)s whose post-contingency state a
downstream simulation package should model when this outage occurs. Limiting the set reduces
the number of post-outage variables and constraints in security-constrained models.

PowerSystems itself does not attach meaning to the contents of the set. In particular, an
empty `monitored_components` is left for the consumer to interpret — typical conventions
are "monitor nothing" (skip post-contingency modeling) or "monitor everything" (preserve
full N-1 behavior). Pick the policy that matches your downstream model.

The constructor and setter functions accept any iterable whose elements are `Base.UUID` or
[`Device`](@ref) — for example a `Vector`, a generator expression, or the iterator returned
by [`get_components`](@ref). Devices are converted to UUIDs internally.

When `system.runchecks == true`, [`add_supplemental_attribute!`](@ref) resolves each UUID
against the parent system and raises an `ArgumentError` for any UUID that does not point
to a `Device` in the system. With `runchecks = false`, UUIDs are accepted as-is and
resolution is deferred to the consumer.

## See also

  - [Supplemental attributes](@ref supplemental_attributes_explanation) — the general concept
  - [Model generator outages](@ref model_generator_outages) — step-by-step attachment and monitoring setup
  - [Working with Time Series](@ref "Working with Time Series Data") — time series for outage schedules and stochastic rates
