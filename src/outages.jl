"""
Supertype for outage contingencies representing planned or unplanned equipment outages.

Concrete subtypes include [`GeometricDistributionForcedOutage`](@ref),
[`PlannedOutage`](@ref), and [`FixedForcedOutage`](@ref).

# Interface for custom subtypes

Subtypes are expected to provide the following fields, or override the matching
accessors via multiple dispatch:

- `monitored_components::Set{Base.UUID}` — UUIDs of devices whose
  post-contingency state should be modeled. The default
  [`get_monitored_components`](@ref) reads `value.monitored_components`; override
  it if your subtype does not carry the field directly.
- `internal::InfrastructureSystemsInternal` — accessed via `get_internal`.

The default [`supports_time_series`](@ref) returns `true`; override for custom
outage types that do not support time series.
"""
abstract type Outage <: Contingency end

"""
Abstract supertype for unplanned (forced) outage events.

See also: [`Outage`](@ref), [`GeometricDistributionForcedOutage`](@ref), [`FixedForcedOutage`](@ref)
"""
abstract type UnplannedOutage <: Outage end

"""
All `PowerSystems.jl` [`Outage`](@ref) types support time series. This can be overridden for custom 
outage types that do not support time series.
"""
supports_time_series(::Outage) = true

"""Return the `internal` field of the [`Outage`](@ref)."""
get_internal(x::Outage) = x.internal

# Public API for monitored_components accepts UUIDs or Devices interchangeably.
_as_uuid(uuid::Base.UUID) = uuid
_as_uuid(device::Device) = IS.get_uuid(device)

"""
Get the set of [`Device`](@ref) UUIDs whose post-contingency state should be modeled
when this outage occurs. PowerSystems does not assign meaning to an empty set;
downstream consumers (e.g., PowerSimulations) decide whether empty means "monitor
nothing" or "monitor everything".
"""
get_monitored_components(value::Outage) = value.monitored_components

"""
Replace the monitored-components set for an [`Outage`](@ref) with the contents
of `items`. Accepts any iterable whose elements are `Base.UUID` or
[`Device`](@ref) (e.g., a `Vector`, a generator, or the iterator returned by
[`get_components`](@ref)). Devices are converted to their UUIDs internally.
Pass an empty iterable (or call [`clear_monitored_components!`](@ref)) to
clear the set.
"""
function set_monitored_components!(value::Outage, items)
    empty!(value.monitored_components)
    for x in items
        push!(value.monitored_components, _as_uuid(x))
    end
    return value.monitored_components
end

"""
Empty the monitored-components set of an [`Outage`](@ref). Returns the (now empty)
underlying set.
"""
function clear_monitored_components!(value::Outage)
    empty!(value.monitored_components)
    return value.monitored_components
end

"""
Add a `Base.UUID` or [`Device`](@ref) to the monitored-components set of
an [`Outage`](@ref). Adding an existing UUID is a no-op.
"""
function add_monitored_component!(value::Outage, x::Union{Base.UUID, Device})
    push!(value.monitored_components, _as_uuid(x))
    return value.monitored_components
end

"""
Add every element of `items` (each a `Base.UUID` or [`Device`](@ref)) to
the monitored-components set of an [`Outage`](@ref). Accepts any iterable, including
the iterator returned by [`get_components`](@ref). Adding an existing UUID is a no-op.
"""
function add_monitored_components!(value::Outage, items)
    for x in items
        add_monitored_component!(value, x)
    end
    return value.monitored_components
end

"""
Remove a `Base.UUID` or [`Device`](@ref) from the monitored-components set
of an [`Outage`](@ref). No-op when the entry is not present.
"""
function remove_monitored_component!(value::Outage, x::Union{Base.UUID, Device})
    delete!(value.monitored_components, _as_uuid(x))
    return
end

"""
Remove every element of `items` (each a `Base.UUID` or [`Device`](@ref)) from
the monitored-components set of an [`Outage`](@ref). Accepts any iterable.
"""
function remove_monitored_components!(value::Outage, items)
    for x in items
        remove_monitored_component!(value, x)
    end
    return
end

"""
    struct GeometricDistributionForcedOutage <: UnplannedOutage
        mean_time_to_recovery::Float64
        outage_transition_probability::Float64
        internal::InfrastructureSystemsInternal
    end

Supplemental attribute for unplanned forced outages with transition probabilities modeled
by geometric distributions. Both the outage probability and the recovery probability can
vary over time and be attached as time series data.

# Arguments
- `mean_time_to_recovery::Float64`: Expected time elapsed to recovery after a failure, in
    milliseconds.
- `outage_transition_probability::Float64`: Per-timestep probability of failure;
    parameterizes the geometric distribution as `(1 - p)`.
- `monitored_components::Set{Base.UUID}`: UUIDs of devices whose post-contingency
    state should be modeled when this outage occurs. Empty by default; semantics of an
    empty set are decided by the downstream consumer.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal
    reference.

# See Also
- [`FixedForcedOutage`](@ref): Unplanned outage type with a fixed (deterministic) outage
    status.
- [`PlannedOutage`](@ref): Scheduled outage type driven by a time series.
"""
struct GeometricDistributionForcedOutage <: UnplannedOutage
    mean_time_to_recovery::Float64
    outage_transition_probability::Float64
    monitored_components::Set{Base.UUID}
    internal::InfrastructureSystemsInternal
end

"""
    GeometricDistributionForcedOutage(; mean_time_to_recovery, outage_transition_probability, monitored_components, internal)

Construct a [`GeometricDistributionForcedOutage`](@ref).

# Arguments
- `mean_time_to_recovery::Float64`: (default: `0.0`) Expected time elapsed to recovery
    after a failure, in milliseconds.
- `outage_transition_probability::Float64`: (default: `0.0`) Per-timestep probability of
    failure; parameterizes the geometric distribution as `(1 - p)`.
- `monitored_components`: (default: `Base.UUID[]`) Any iterable of `Base.UUID` or [`Device`](@ref).
    Devices are converted to their UUIDs internally; duplicates are collapsed.
- `internal::InfrastructureSystemsInternal`: (default: `InfrastructureSystemsInternal()`)
    (**Do not modify.**) PowerSystems.jl internal reference.
"""
function GeometricDistributionForcedOutage(;
    mean_time_to_recovery = 0.0,
    outage_transition_probability = 0.0,
    monitored_components = Base.UUID[],
    internal = InfrastructureSystemsInternal(),
)
    return GeometricDistributionForcedOutage(
        mean_time_to_recovery,
        outage_transition_probability,
        Set{Base.UUID}(_as_uuid(x) for x in monitored_components),
        internal,
    )
end

"""Return the `mean_time_to_recovery` field of [`GeometricDistributionForcedOutage`](@ref)."""
get_mean_time_to_recovery(value::GeometricDistributionForcedOutage) =
    value.mean_time_to_recovery
"""Return the `outage_transition_probability` field of [`GeometricDistributionForcedOutage`](@ref)."""
get_outage_transition_probability(value::GeometricDistributionForcedOutage) =
    value.outage_transition_probability

"""
    struct PlannedOutage <: Outage
        outage_schedule::String
        internal::InfrastructureSystemsInternal
    end

Supplemental attribute for planned (scheduled) outages. The outage schedule is stored as
a time series identified by the `outage_schedule` name string.

# Arguments
- `outage_schedule::String`: Name of the time series containing the outage schedule.
- `monitored_components::Set{Base.UUID}`: UUIDs of devices whose post-contingency
    state should be modeled when this outage occurs. Empty by default; semantics of an
    empty set are decided by the downstream consumer.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal
    reference.

# See Also
- [`GeometricDistributionForcedOutage`](@ref): Unplanned outage type with geometric
    distribution transition probabilities.
- [`FixedForcedOutage`](@ref): Unplanned outage type with a fixed outage status.
"""
struct PlannedOutage <: Outage
    outage_schedule::String
    monitored_components::Set{Base.UUID}
    internal::InfrastructureSystemsInternal
end

"""
    PlannedOutage(; outage_schedule, monitored_components, internal)

Construct a [`PlannedOutage`](@ref).

# Arguments
- `outage_schedule::String`: Name of the time series containing the outage schedule.
- `monitored_components`: (default: `Base.UUID[]`) Any iterable of `Base.UUID` or [`Device`](@ref).
    Devices are converted to their UUIDs internally; duplicates are collapsed.
- `internal::InfrastructureSystemsInternal`: (default: `InfrastructureSystemsInternal()`)
    (**Do not modify.**) PowerSystems.jl internal reference.
"""
function PlannedOutage(;
    outage_schedule,
    monitored_components = Base.UUID[],
    internal = InfrastructureSystemsInternal(),
)
    return PlannedOutage(
        outage_schedule,
        Set{Base.UUID}(_as_uuid(x) for x in monitored_components),
        internal,
    )
end

"""Return the `outage_schedule` field of [`PlannedOutage`](@ref)."""
get_outage_schedule(value::PlannedOutage) = value.outage_schedule

"""
    struct FixedForcedOutage <: UnplannedOutage
        outage_status::Float64
        internal::InfrastructureSystemsInternal
    end

Supplemental attribute for forced outages with a deterministic (fixed) outage status.
The status value can be derived from stochastic process simulations or historical data,
and may vary over time via attached time series data.

# Arguments
- `outage_status::Float64`: Forced outage status of the component: `1.0` indicates
    outaged (unavailable), `0.0` indicates available.
- `monitored_components::Set{Base.UUID}`: UUIDs of devices whose post-contingency
    state should be modeled when this outage occurs. Empty by default; semantics of an
    empty set are decided by the downstream consumer.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal
    reference.

# See Also
- [`GeometricDistributionForcedOutage`](@ref): Unplanned outage type with geometric
    distribution transition probabilities.
- [`PlannedOutage`](@ref): Scheduled outage type driven by a time series.
"""
struct FixedForcedOutage <: UnplannedOutage
    outage_status::Float64
    monitored_components::Set{Base.UUID}
    internal::InfrastructureSystemsInternal
end

"""
    FixedForcedOutage(; outage_status, monitored_components, internal)

Construct a [`FixedForcedOutage`](@ref).

# Arguments
- `outage_status::Float64`: Forced outage status of the component: `1.0` indicates
    outaged (unavailable), `0.0` indicates available.
- `monitored_components`: (default: `Base.UUID[]`) Any iterable of `Base.UUID` or [`Device`](@ref).
    Devices are converted to their UUIDs internally; duplicates are collapsed.
- `internal::InfrastructureSystemsInternal`: (default: `InfrastructureSystemsInternal()`)
    (**Do not modify.**) PowerSystems.jl internal reference.
"""
function FixedForcedOutage(;
    outage_status,
    monitored_components = Base.UUID[],
    internal = InfrastructureSystemsInternal(),
)
    return FixedForcedOutage(
        outage_status,
        Set{Base.UUID}(_as_uuid(x) for x in monitored_components),
        internal,
    )
end

"""Return the `outage_status` field of [`FixedForcedOutage`](@ref)."""
get_outage_status(value::FixedForcedOutage) = value.outage_status
