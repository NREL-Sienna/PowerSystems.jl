abstract type Outage <: Contingency end

abstract type UnplannedOutage <: Outage end

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
struct GeometricDistributionForcedOutage <: UnplannedOutage
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
The time series data for fixed outages can be obtained from the simulation of a stochastic process or historical information.

# Arguments
- `outage_status::String`: The forced outage status in the model. 1 represents outaged and 0 represents available.
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
struct FixedForcedOutage <: UnplannedOutage
    outage_status::Float64
    internal::InfrastructureSystemsInternal
end

function FixedForcedOutage(;
    outage_status,
    internal = InfrastructureSystemsInternal(),
)
    return FixedForcedOutage(outage_status, internal)
end

"""Get [`FixedForcedOutage`](@ref) `outage_status`."""
get_outage_status(value::FixedForcedOutage) = value.outage_status
