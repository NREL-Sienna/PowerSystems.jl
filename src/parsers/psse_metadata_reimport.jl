# Parse the `*_export_metadata.json` file written alongside PSS/E files by PowerFlows.jl

# Currently the following mappings are used here:
#   area_mapping: maps Sienna name to PSS/E number for all areas
#   zone_mapping: maps Sienna name to PSS/E number for all load zones
#   bus_number_mapping: maps Sienna number to PSS/E number for all buses
#   load_name_mapping: maps (Sienna bus, Sienna name) to PSS/E name for all loads
#   shunt_name_mapping: maps (Sienna bus, Sienna name) to PSS/E name for all shunts
#   generator_name_mapping: maps (Sienna bus 1, Sienna bus 2, Sienna name) to PSS/E name for all generators
#   branch_name_mapping: maps (Sienna bus 1, Sienna bus 2, Sienna name) to PSS/E name for all non-transformer branches
#   transformer_ckt_mapping: maps (Sienna bus1, Sienna bus2, Sienna name) to PSS/E CKT field for all transformers

# Mappings are stored in the file in the Sienna -> PSS/E direction, so they need to be
# reversed for use here. Wherever a tuple is indicated above, the presentation in the file
# is of the elements joined with underscores to form a single string.

const PSSE_EXPORT_METADATA_EXTENSION = "_export_metadata.json"

reverse_dict(d::Dict) = Dict(map(reverse, collect(d)))

function split_first_rest(s::AbstractString; delim = "_")
    splitted = split(s, delim)
    return first(splitted), join(splitted[2:end], delim)
end

"Convert a s_bus_n_s_name => p_name dictionary to a (p_bus_n, p_name) => s_name dictionary"
deserialize_reverse_component_ids(
    mapping,
    bus_number_mapping,
    ::T,
) where {T <: Type{Int64}} =
    Dict(
        let
            (s_bus_n, s_name) = split_first_rest(s_bus_n_s_name)
            p_bus_n = bus_number_mapping[s_bus_n]
            (p_bus_n, p_name) => s_name
        end
        for (s_bus_n_s_name, p_name) in mapping)
deserialize_reverse_component_ids(
    mapping,
    bus_number_mapping,
    ::T,
) where {T <: Type{Tuple{Int64, Int64}}} =
    Dict(
        let
            (s_buses, s_name) = split_first_rest(s_buses_s_name)
            (s_bus_1, s_bus_2) = split(s_buses, "-")
            (p_bus_1, p_bus_2) = bus_number_mapping[s_bus_1], bus_number_mapping[s_bus_2]
            ((p_bus_1, p_bus_2), p_name) => s_name
        end
        for (s_buses_s_name, p_name) in mapping)

# TODO figure out where these are coming from and fix at the source
# I think it has to do with per-unit conversions creating a division by zero, because `set_[re]active_power!(..., 0.0)` doesn't fix it
"Iterate over all the `Generator`s in the system and, if any `active_power` or `reactive_power` fields are `NaN`, make them `0.0`"
function fix_nans!(sys::System)
    for gen in get_components(Generator, sys)
        isnan(get_active_power(gen)) && (gen.active_power = 0.0)
        isnan(get_reactive_power(gen)) && (gen.reactive_power = 0.0)
        all(isnan.(values(get_reactive_power_limits(gen)))) &&
            (gen.reactive_power_limits = (min = 0.0, max = 0.0))
        all(isnan.(values(get_active_power_limits(gen)))) &&
            (gen.active_power_limits = (min = 0.0, max = 0.0))
    end
end

"""
Use PSS/E exporter metadata to build a function that maps component names back to their
original Sienna values.
"""
function name_formatter_from_component_ids(raw_name_mapping, bus_number_mapping, sig)
    reversed_name_mapping =
        deserialize_reverse_component_ids(raw_name_mapping, bus_number_mapping, sig)
    function component_id_formatter(device_dict)
        (p_bus_n, p_name) = device_dict["source_id"][2:3]
        (p_bus_n isa Integer) || (p_bus_n = parse(Int64, p_bus_n))
        new_name = reversed_name_mapping[(p_bus_n, p_name)]
        return new_name
    end
    return component_id_formatter
end

function remap_bus_numbers!(sys::System, bus_number_mapping)
    p_bus_to_s_bus = reverse_dict(bus_number_mapping)
    for bus in collect(get_components(Bus, sys))
        set_number!(bus, parse(Int, p_bus_to_s_bus[get_number(bus)]))
    end
end

function System(raw_path::AbstractString, md::Dict)
    bus_name_map = reverse_dict(md["bus_name_mapping"])  # PSS/E bus name -> Sienna bus name
    all_branch_name_map = deserialize_reverse_component_ids(
        merge(md["branch_name_mapping"], md["transformer_ckt_mapping"]),
        md["bus_number_mapping"],
        Tuple{Int64, Int64},
    )

    bus_name_formatter = device_dict -> bus_name_map[device_dict["name"]]
    gen_name_formatter = name_formatter_from_component_ids(
        md["generator_name_mapping"],
        md["bus_number_mapping"],
        Int64,
    )
    load_name_formatter = name_formatter_from_component_ids(
        md["load_name_mapping"],
        md["bus_number_mapping"],
        Int64,
    )
    function branch_name_formatter(
        device_dict::Dict,
        bus_f::ACBus,
        bus_t::ACBus,
    )::String
        sid = device_dict["source_id"]
        (p_bus_1, p_bus_2, p_name) =
            (length(sid) == 6) ? [sid[2], sid[3], sid[5]] : last(sid, 3)
        return all_branch_name_map[((p_bus_1, p_bus_2), p_name)]
    end
    shunt_name_formatter = name_formatter_from_component_ids(
        md["shunt_name_mapping"],
        md["bus_number_mapping"],
        Int64,
    )
    loadzone_name_map = reverse_dict(md["zone_mapping"])
    loadzone_name_formatter = name -> loadzone_name_map[name]
    area_name_map = reverse_dict(md["area_mapping"])
    area_name_formatter = name -> area_name_map[name]

    sys =
        System(raw_path;
            bus_name_formatter = bus_name_formatter,
            gen_name_formatter = gen_name_formatter,
            load_name_formatter = load_name_formatter,
            branch_name_formatter = branch_name_formatter,
            shunt_name_formatter = shunt_name_formatter,
            loadzone_name_formatter = loadzone_name_formatter,
            area_name_formatter = area_name_formatter)
    # Remap bus numbers last because everything has been added to the system using PSS/E bus numbers
    remap_bus_numbers!(sys, md["bus_number_mapping"])
    fix_nans!(sys)
    return sys
end
