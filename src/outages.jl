abstract type Outage <: Contigency end

"""Get `components_uuid`."""
get_component_uuids(x::Outage) = x.component_uuids
"""Get `internal`."""
get_internal(x::Outage) = x.internal
"""Get `time_series_container`."""
get_time_series_container(x::Outage) = x.time_series_container

"""
Attribute that contains information regarding forced outages modeled with a
geometric distribution. The outage probabilities and recovery times can be modeled as time
series.

# Arguments
- `time_to_recovery::Int`: Time elapsed to recovery after a failure in Milliseconds.
- `outage_probability::Float64`: Characterizes the probability of failure (1 - p) in the geometric distribution.
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
struct GeometricDistributionForcedOutage <: Outage
    time_to_recovery::Int
    outage_probability::Float64
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    component_uuids::InfrastructureSystems.ComponentUUIDs
    internal::InfrastructureSystemsInternal
end

function GeometricDistributionForcedOutage(;
    time_to_recovery = 0.0,
    outage_probability = 0.0,
    time_series_container = InfrastructureSystems.TimeSeriesContainer(),
    component_uuids = InfrastructureSystems.ComponentUUIDs(),
    internal = InfrastructureSystemsInternal(),
)
    return GeometricDistributionForcedOutage(
        time_to_recovery,
        outage_probability,
        time_series_container,
        component_uuids,
        internal,
    )
end

"""Get [`GeometricDistributionForcedOutage`](@ref) `time_to_recovery`."""
get_time_to_recovery(value::GeometricDistributionForcedOutage) = value.time_to_recovery
"""Get [`GeometricDistributionForcedOutage`](@ref) `outage_probability`."""
get_outage_probability(value::GeometricDistributionForcedOutage) = value.outage_probability

"""
Attribute that contains information regarding planned outages.

# Arguments
- `outage_schedule::String`: String name of the time series used for the scheduled outages
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
struct PlannedOutage <: Outage
    outage_schedule::String
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    component_uuids::InfrastructureSystems.ComponentUUIDs
    internal::InfrastructureSystemsInternal
end

function PlannedOutage(;
    outage_schedule,
    time_series_container = InfrastructureSystems.TimeSeriesContainer(),
    component_uuids = InfrastructureSystems.ComponentUUIDs(),
    internal = InfrastructureSystemsInternal(),
)
    return PlannedOutage(
        outage_schedule,
        time_series_container,
        component_uuids,
        internal,
    )
end

"""Get [`PlannedOutage`](@ref) `outage_schedule`."""
get_outage_schedule(value::PlannedOutage) = value.outage_schedule

"""
Attribute that contains information for time series representation for the start of forced outages.
The data can be obtained from a simulation or historical information.

# Arguments
- `time_to_recovery::Int`: Time elapsed to recovery after a failure in Milliseconds.
- `outage_scenario::String`: String name of the time series used for the forced outage in the model
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
struct TimeSeriesForcedOutage <: Outage
    outage_scenario::String
    time_to_recovery::Int
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    component_uuids::InfrastructureSystems.ComponentUUIDs
    internal::InfrastructureSystemsInternal
end

function TimeSeriesForcedOutage(;
    outage_scenario,
    time_series_container = InfrastructureSystems.TimeSeriesContainer(),
    component_uuids = InfrastructureSystems.ComponentUUIDs(),
    internal = InfrastructureSystemsInternal(),
)
    return TimeSeriesForcedOutage(
        outage_scenario,
        time_series_container,
        component_uuids,
        internal,
    )
end

"""Get [`GeometricDistributionForcedOutage`](@ref) `time_to_recovery`."""
get_time_to_recovery(value::GeometricDistributionForcedOutage) = value.time_to_recovery
"""Get [`TimeSeriesForcedOutage`](@ref) `outage_scenario`."""
get_outage_scenario(value::TimeSeriesForcedOutage) = value.outage_scenario
