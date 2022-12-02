"""
Abstract type for a subsystem that contains multiple instances of StaticInjection

Subtypes must implement:
- get_subcomponents(subsystem::StaticInjectionSubsystem)

The subcomponents in subtypes must be attached to the System as masked components.
"""
abstract type StaticInjectionSubsystem <: StaticInjection end

"""
Efficiently add all time series data in the subcomponent to the subsystem by copying the
underlying references.
"""
function copy_subcomponent_time_series!(
    subsystem::StaticInjectionSubsystem,
    subcomponent::Component,
)
    # the existing_ts can remove entries from the set if the Subsystem has two device of 
    # the same type with the same time series type and label. Currently in the HybridSystem 
    # use case there can only be one devoe of each type.
    existing_ts = Set(
        (typeof(ts), get_name(ts_m)) for
        (ts, ts_m) in IS.get_time_series_with_metadata_multiple(subsystem)
    )
    name_mapping = Dict{Tuple{String, String}, String}()
    device_name = get_name(subcomponent)
    for ts in get_time_series_multiple(subcomponent)
        name = get_name(ts)
        key = (typeof(ts), name)
        if !(key in existing_ts)
            new_name = make_subsystem_time_series_name(subcomponent, ts)
            if name in keys(name_mapping)
                IS.@assert_op new_name == name_mapping[(device_name, name)]
                continue
            end
            name_mapping[(device_name, name)] = new_name
        end
    end

    copy_time_series!(subsystem, subcomponent; name_mapping = name_mapping)
    @info "Copied time series from $(summary(subcomponent)) to $(summary(subsystem))"
end

function make_subsystem_time_series_name(subcomponent::Component, ts::TimeSeriesData)
    return make_subsystem_time_series_name(typeof(subcomponent), get_name(ts))
end

function make_subsystem_time_series_name(subcomponent::Component, label::String)
    return make_subsystem_time_series_name(typeof(subcomponent), label)
end

function make_subsystem_time_series_name(subcomponent::Type{<:Component}, label::String)
    return IS.strip_module_name(subcomponent) * "__" * label
end
