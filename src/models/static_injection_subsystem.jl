"""
Abstract type for a subsystem that contains multiple instances of StaticInjection

Subtypes must implement:
- get_subcomponents(subsystem::StaticInjectionSubsystem)
- make_unique_time_series_name(
      subsystem::StaticInjectionSubsystem,
      subcomponent::Component,
      name::AbstractString,
  )

The subcomponents in subtypes are not attached to the System.
"""
abstract type StaticInjectionSubystem <: StaticInjection end

function get_time_series(
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
