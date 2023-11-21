abstract type OutageInfo <: IS.InfrastructureSystemsInfo end

struct ForcerdOutage <: OutageInfo
    forced_outage_rate::Float64
    mean_time_to_recovery::Int
    outage_probability::Float64
    recovery_probability::Float64
    ext::Dict{String, Any}
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    internal::InfrastructureSystemsInternal
end

function ForcerdOutage(
    forced_outage_rate::Float64,
    mean_time_to_recovery::Int,
    outage_probability::Float64,
    recovery_probability::Float64;
    ext::Dict{String, Any}
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    internal::InfrastructureSystemsInternal)
    return ForcerdOutage(forced_outage_rate, mttr, time_series_keys)
end

struct PlannedOutage <: OutageInfo
    mean_time_to_recovery::Int
    outage_schedule::Int
    ext::Dict{String, Any}
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    internal::InfrastructureSystemsInternal
end

function PlannedOutage(forced_outage_rate, mttr; time_series_keys = nothing)
    return PlannedOutage(forced_outage_rate, mttr, time_series_keys)
end


function add_outage!(sys::System, component::Component, outage::OutageInfo)
    IS.add_info!(sys.data.infos, outage, component)
    return
end

function has_outage(::Type{T}, sys::System, component::Component) where T <: OutageInfo
    return IS.has_info(T, sys.data.infos, component)
end

function get_outage(::Type{T}, sys::System, component::Component) where T <: OutageInfo
    _check_outage(sys, component)
    return sys.data.infos[T][get_uuid(component)]
end

function remove_outage!(sys::System, component::Component)
    if has_outage(sys, component)
        pop!(sys.outages, make_outage_key(component))
    end
    @info "Removed outage for component $(summary(component))"
end

function remove_outages!(sys::System)
    empty!(sys.outages)
    @info "Removed all outages"
end
