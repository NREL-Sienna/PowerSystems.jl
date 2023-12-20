abstract type Outage <: IS.InfrastructureSystemsInfo end

function add_outage!(sys::System, component::Component, outage::Outage)
    IS.add_info!(sys.data.infos, outage, component)
    return
end

function has_outage(::Type{T}, sys::System, component::Component) where T <: Outage
    return IS.has_info(T, sys.data.infos, component)
end

function get_outage(::Type{T}, sys::System, component::Component) where T <: Outage
    _check_outage(sys, component)
    return sys.data.infos[T][get_uuid(component)]
end

function remove_outage!(::Type{T}, sys::System, component::Component) where T <: Outage
    remove_info!(sys.data.infos, component)

    if has_outage(T, sys, component)
        pop!(sys.outages, make_outage_key(component))
    end
    @info "Removed outage for component $(summary(component))"
end

function remove_outages!(sys::System)
    empty!(sys.outages)
    @info "Removed all outages"
end

struct ForcerdOutage <: Outage
    forced_outage_rate::Float64
    mean_time_to_recovery::Int
    outage_probability::Float64
    recovery_probability::Float64
    ext::Dict{String, Any}
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    internal::InfrastructureSystemsInternal
end

function ForcerdOutage(;
    forced_outage_rate::Float64 = 0.0,
    mean_time_to_recovery::Int = 0,
    outage_probability::Float64 = 0.0,
    recovery_probability::Float64 = 0.0,
    ext = Dict{String, Any}(),
    time_series_container = InfrastructureSystems.TimeSeriesContainer(),
    internal = InfrastructureSystemsInternal(),
    )
    return ForcerdOutage(forced_outage_rate,
                         mean_time_to_recovery,
                         outage_probability,
                         recovery_probability,
                         ext,
                         time_series_container,
                         internal)
end

struct PlannedOutage <: Outage
    time_to_recovery::Int
    outage_schedule::Int
    ext::Dict{String, Any}
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    internal::InfrastructureSystemsInternal
end

function PlannedOutage(;
    time_to_recovery::Int = 0,
    outage_schedule::Float64 = 0.0,
    ext = Dict{String, Any}(),
    time_series_container = InfrastructureSystems.TimeSeriesContainer(),
    internal = InfrastructureSystemsInternal(),
    )
    return PlannedOutage(time_to_recovery,
                         outage_schedule,
                         ext,
                         time_series_container,
                         internal)
end
