# This file contains code to convert serialized data from old formats to work with newer
# code.

#
# In version 1.0.1 the DeterministicMetadata struct added field time_series type.
# Deserialization needs to add this field and value.
#

function pre_deserialize_conversion!(raw, sys::System)
    old = raw["data_format_version"]
    if old == "1.0.0"
        for component in raw["data"]["components"]
            for ts_metadata in get(component, "time_series_container", [])
                if ts_metadata["__metadata__"]["type"] == "DeterministicMetadata" &&
                   !haskey(ts_metadata, "time_series_type")
                    # This will allow deserialization to work.
                    # post_deserialize_conversion will fix the type.
                    ts_metadata["time_series_type"] = Dict(
                        "__metadata__" => Dict(
                            "module" => "InfrastructureSystems",
                            "type" => "AbstractDeterministic",
                        ),
                    )
                end
            end
        end
    elseif old == "1.0.1" || old == "2.0.0"
        @warn(
            "System is saved in the data format version 2.0.0. Deseralizing HVDC related data might fail. \
            If there are no errors during deserialization, the data be automatically upgraded to 3.0.0 upon saving"
        )
        return
    else
        error("conversion of data from $old to $DATA_FORMAT_VERSION is not supported")
    end
end

function post_deserialize_conversion!(sys::System, raw)
    old = raw["data_format_version"]
    if old == "1.0.0"
        for component in IS.iterate_components_with_time_series(sys.data.components)
            ts_container = get_time_series_container(component)
            for key in keys(ts_container.data)
                if key.time_series_type == IS.DeterministicMetadata
                    ts_metadata = ts_container.data[key]
                    ts = get_time_series(
                        AbstractDeterministic,
                        component,
                        get_name(ts_metadata);
                        len = get_horizon(ts_metadata),
                        count = 1,
                    )
                    ts_metadata.time_series_type = typeof(ts)
                end
            end
        end
    elseif old == "1.0.1" || old == "2.0.0"
        # Version 1.0.1 can be converted
        raw["data_format_version"] = DATA_FORMAT_VERSION
        @warn(
            "System is saved in the data format version $old will be automatically upgraded to $DATA_FORMAT_VERSION upon saving"
        )
        return
    else
        error("conversion of data from $old to $DATA_FORMAT_VERSION is not supported")
    end
end
