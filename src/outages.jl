abstract type Outage <: Contingency end

supports_time_series(::Outage) = true

"""Get `internal`."""
get_internal(x::Outage) = x.internal

"""
Attribute that contains information regarding forced outages where the transition probabilities
are modeled with geometric distributions. The outage probabilities and recovery probabilities can be modeled as time
series.

# Arguments
- `time_to_recovery::Int`: Time elapsed to recovery after a failure in Milliseconds.
- `outage_transition_probability::Float64`: Characterizes the probability of failure (1 - p) in the geometric distribution.
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
struct GeometricDistributionForcedOutage <: Outage
    mean_time_to_recovery::Float64
    outage_transition_probability::Float64
    internal::InfrastructureSystemsInternal
end

function GeometricDistributionForcedOutage(;
    mean_time_to_recovery = 0.0,
    outage_transition_probability = 0.0,
    internal = InfrastructureSystemsInternal(),
)
    return GeometricDistributionForcedOutage(
        mean_time_to_recovery,
        outage_transition_probability,
        internal,
    )
end

"""Get [`GeometricDistributionForcedOutage`](@ref) `time_to_recovery`."""
get_mean_time_to_recovery(value::GeometricDistributionForcedOutage) =
    value.mean_time_to_recovery
"""Get [`GeometricDistributionForcedOutage`](@ref) `outage_transition_probability`."""
get_outage_transition_probability(value::GeometricDistributionForcedOutage) =
    value.outage_transition_probability

"""
Attribute that contains information regarding planned outages.

# Arguments
- `outage_schedule::String`: String name of the time series used for the scheduled outages
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
struct PlannedOutage <: Outage
    outage_schedule::String
    internal::InfrastructureSystemsInternal
end

function PlannedOutage(;
    outage_schedule,
    internal = InfrastructureSystemsInternal(),
)
    return PlannedOutage(
        outage_schedule,
        internal,
    )
end

"""Get [`PlannedOutage`](@ref) `outage_schedule`."""
get_outage_schedule(value::PlannedOutage) = value.outage_schedule

"""
Attribute that contains the representation of the status of the component forced outage.
The data can be obtained from the simulation of an stochastic process or historical information.

# Arguments
- `outage_status_scenario::String`: String name of the time series used for the forced outage status in the model. 1 is used represent outaged and 0 for available.
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
struct TimeSeriesForcedOutage <: Outage
    outage_status_scenario::String
    internal::InfrastructureSystemsInternal
end

function TimeSeriesForcedOutage(;
    outage_status_scenario,
    internal = InfrastructureSystemsInternal(),
)
    return TimeSeriesForcedOutage(outage_status_scenario, internal)
end

"""Get [`TimeSeriesForcedOutage`](@ref) `outage_status_scenario`."""
get_outage_status_scenario(value::TimeSeriesForcedOutage) = value.outage_status_scenario
