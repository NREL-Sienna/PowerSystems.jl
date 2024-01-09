abstract type Outage <: SupplementalAttribute end

struct ForcedOutage <: Outage
    forced_outage_rate::Float64
    mean_time_to_recovery::Int
    outage_probability::Float64
    recovery_probability::Float64
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    component_uuids::InfrastructureSystems.ComponentUUIDs
    internal::InfrastructureSystemsInternal
end

function ForcedOutage(;
    forced_outage_rate = 0.0,
    mean_time_to_recovery = 0,
    outage_probability = 0.0,
    recovery_probability = 0.0,
    time_series_container = InfrastructureSystems.TimeSeriesContainer(),
    component_uuids = InfrastructureSystems.ComponentUUIDs(),
    internal = InfrastructureSystemsInternal(),
)
    return ForcedOutage(
        forced_outage_rate,
        mean_time_to_recovery,
        outage_probability,
        recovery_probability,
        time_series_container,
        component_uuids,
        internal,
    )
end

get_component_uuids(x::ForcedOutage) = x.component_uuids
get_internal(x::ForcedOutage) = x.internal
get_time_series_container(x::ForcedOutage) = x.time_series_container

struct PlannedOutage <: Outage
    time_to_recovery::Int
    outage_schedule::Int
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    component_uuids::InfrastructureSystems.ComponentUUIDs
    internal::InfrastructureSystemsInternal
end

function PlannedOutage(;
    time_to_recovery = 0,
    outage_schedule = 0.0,
    time_series_container = InfrastructureSystems.TimeSeriesContainer(),
    component_uuids = InfrastructureSystems.ComponentUUIDs(),
    internal = InfrastructureSystemsInternal(),
)
    return PlannedOutage(
        time_to_recovery,
        outage_schedule,
        time_series_container,
        component_uuids,
        internal,
    )
end

get_component_uuids(x::PlannedOutage) = x.component_uuids
get_internal(x::PlannedOutage) = x.internal
get_time_series_container(x::PlannedOutage) = x.time_series_container
