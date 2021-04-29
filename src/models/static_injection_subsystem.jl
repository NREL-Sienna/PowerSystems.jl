"""
Abstract type for a subsystem that contains multiple instances of StaticInjection

Subtypes must implement:
- get_subcomponents(subsystem::StaticInjectionSubsystem)
- make_unique_time_series_name(
      subsystem::StaticInjectionSubsystem,
      subcomponent::Component,
      name::AbstractString,
  )
- does_time_series_name_match_subcomponent(hybrid::HybridSystem, subcomponent, name)

The subcomponents in subtypes are not attached to the System.
"""
abstract type StaticInjectionSubystem <: StaticInjection end

function IS.get_time_series(
    ::Type{T},
    subsystem::StaticInjectionSubystem,
    subcomponent::InfrastructureSystemsComponent,
    name::AbstractString;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
    count::Union{Nothing, Int} = nothing,
) where {T <: TimeSeriesData}
    return get_time_series(
        T,
        subsystem,
        make_unique_time_series_name(subsystem, subcomponent, name),
        start_time = start_time,
        len = len,
        count = count,
    )
end

function IS.get_time_series_array(
    ::Type{T},
    subsystem::StaticInjectionSubystem,
    subcomponent::InfrastructureSystemsComponent,
    name::AbstractString;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
    ignore_scaling_factors = false,
) where {T <: TimeSeriesData}
    ts = get_time_series(
        T,
        subsystem,
        make_unique_time_series_name(subsystem, subcomponent, name),
        start_time = start_time,
        len = len,
    )
    return get_time_series_array(
        subcomponent,
        ts,
        get_initial_timestamp(ts),
        len = len,
        ignore_scaling_factors = ignore_scaling_factors,
    )
end

function IS.get_time_series_values(
    ::Type{T},
    subsystem::StaticInjectionSubystem,
    subcomponent::Component,
    name::AbstractString;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
    ignore_scaling_factors = false,
) where {T <: TimeSeriesData}
    ts = get_time_series(
        T,
        subsystem,
        make_unique_time_series_name(subsystem, subcomponent, name),
        start_time = start_time,
        len = len,
    )
    return get_time_series_values(
        subcomponent,
        ts,
        get_initial_timestamp(ts),
        len = len,
        ignore_scaling_factors = ignore_scaling_factors,
    )
end

function IS.get_time_series_timestamps(
    ::Type{T},
    subsystem::StaticInjectionSubystem,
    subcomponent::Component,
    name::AbstractString;
    start_time::Union{Nothing, Dates.DateTime} = nothing,
    len::Union{Nothing, Int} = nothing,
) where {T <: TimeSeriesData}
    ts = get_time_series(
        T,
        subsystem,
        make_unique_time_series_name(subsystem, subcomponent, name),
        start_time = start_time,
        len = len,
    )
    return get_time_series_timestamps(
        subcomponent,
        ts,
        get_initial_timestamp(ts),
        len = len,
    )
end

function IS.has_time_series(subsystem::StaticInjectionSubystem, subcomponent::Component)
    for key in IS.get_time_series_keys(subsystem)
        if does_time_series_name_match_subcomponent(subsystem, subcomponent, key.name)
            return true
        end
    end

    return false
end
