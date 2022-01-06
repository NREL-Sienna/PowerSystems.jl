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
    existing_ts = Set((typeof(x), get_name(x)) for x in get_time_series_multiple(subsystem))
    name_mapping = Dict{String, String}()
    for ts in get_time_series_multiple(subcomponent)
        name = get_name(ts)
        key = (typeof(ts), name)
        if !(key in existing_ts)
            new_name = make_subsystem_time_series_name(subcomponent, ts)
            if name in keys(name_mapping)
                IS.@assert_op new_name == name_mapping[name]
                continue
            end
            name_mapping[name] = new_name
        end
    end

    copy_time_series!(subsystem, subcomponent, name_mapping = name_mapping)
    @info "Copied time series from $(summary(subcomponent)) to $(summary(subsystem))"
end

function make_subsystem_time_series_name(subcomponent::Component, ts::TimeSeriesData)
    return IS.strip_module_name(typeof(subcomponent)) * "__" * get_name(ts)
end
