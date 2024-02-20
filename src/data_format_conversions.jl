# This file contains code to convert serialized data from old formats to work with newer
# code.

#
# In version 1.0.1 the DeterministicMetadata struct added field time_series type.
# Deserialization needs to add this field and value.
#

function _convert_data!(
    raw::Dict{String, Any},
    ::Val{Symbol("1.0.0")},
    ::Val{Symbol("2.0.0")},
)
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
    return
end

function _convert_data!(
    raw::Dict{String, Any},
    ::Val{Symbol("2.0.0")},
    ::Val{Symbol("3.0.0")},
)
    for component in raw["data"]["components"]
        if component["__metadata__"]["type"] == "Bus"
            component["__metadata__"]["type"] = "ACBus"
            continue
        end
        if component["__metadata__"]["type"] == "HVDCLine"
            component["__metadata__"]["type"] = "TwoTerminalHVDCLine"
            continue
        end
        if component["__metadata__"]["type"] == "VSCDCLine"
            component["__metadata__"]["type"] = "TwoTerminalVSCDCLine"
            continue
        end
        if haskey(component, "prime_mover") && haskey(component, "dynamic_injector")
            component["prime_mover_type"] = pop!(component, "prime_mover")
        end
    end
    return
end

function _convert_data!(
    raw::Dict{String, Any},
    ::Val{Symbol("1.0.0")},
    ::Val{Symbol("3.0.0")},
)
    _convert_data!(raw, Val{Symbol("1.0.0")}(), Val{Symbol("2.0.0")}())
    _convert_data!(raw, Val{Symbol("2.0.0")}(), Val{Symbol("3.0.0")}())
    return
end

function _convert_data!(
    raw::Dict{String, Any},
    ::Val{Symbol("1.0.1")},
    ::Val{Symbol("3.0.0")},
)
    _convert_data!(raw, Val{Symbol("2.0.0")}(), Val{Symbol("3.0.0")}())
    return
end

# Conversions to occur immediately after the data is loaded from disk
function pre_read_conversion!(raw)
    if VersionNumber(raw["data_format_version"]) < v"4.0.0"
        haskey(raw["data"], "subsystems") ||
            (raw["data"]["subsystems"] = Dict{String, Any}())
        haskey(raw["data"], "attributes") || (raw["data"]["attributes"] = Any[])
    end
end

# Conversions to occur before deserialize_components!
function pre_deserialize_conversion!(raw, sys::System)
    old = raw["data_format_version"]
    if old == DATA_FORMAT_VERSION
        return
    else
        _convert_data!(raw, Val{Symbol(old)}(), Val{Symbol(DATA_FORMAT_VERSION)}())
        @warn(
            "System is saved in the data format version $old will be automatically upgraded to $DATA_FORMAT_VERSION upon saving"
        )
    end
end

# Conversions to occur at the end of deserialization
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
