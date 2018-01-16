export plexoscsv_parser

function csv_mapping()

    CSV_MAPPING = Dict(
        "bus" => Dict(
            "zone" => 1,
            "bus_i" => "index_created_at",
            "bus_type" => 1,
            "qd" => "Load_Participation_Factor",
            "gs" => 0.0,
            "bs" => 0.0,
            "vmax" => 1.05,
            "area" => "Region",
            "bus_name" => "Bus_Name",
            "vmin" => 0.95,
            "index" => "index_created_at",
            "va" => 0.0,
            "vm" => 1.0,
            "base_kv" => 138.0,
            "pd" => "Load_Participation_Factor",
            "time_series" => Nullable{TimeArray}
        ),
        "gen" => Dict(
            "qc1max" => 0.0,
            "model" => 1,
            "startup" => "Start_Cost_",
            "qc2max" => 0.0,
            "qg" => 0.0,
            "gen_bus" => "bus_of_connection",
            "mbase" => "Rating",
            "pc2" => 0.0,
            "index" => "index_created_at",
            "qmax" => 9999.0,
            "pc1" => 0.0,
            "pg" => 0.0,
            "shutdown" => 0.0,
            "pmax" => "Max_Capacity_MW_",
            "vg" => 1.0,
            "cost" => [("Heat_Rate_Inc_Band_1_BTU_kWh_", "Load_Point_Band_1_MW_"),
                        ("Heat_Rate_Inc_Band_2_BTU_kWh_", "Load_Point_Band_2_MW_"),
                        ("Heat_Rate_Inc_Band_3_BTU_kWh_", "Load_Point_Band_3_MW_"),
                        ("Heat_Rate_Inc_Band_4_BTU_kWh_", "Load_Point_Band_4_MW_"),
                        ("Heat_Rate_Inc_Band_5_BTU_kWh_", "Load_Point_Band_5_MW_")],
            "gen_status" => 1,
            "qmin" => -9999.0,
            "qc1min" => 0.0,
            "qc2min" => 0.0,
            "pmin" => "Min_Stable_Level_MW_",
            "ncost" => 0, # will be updated when csv_to_pm converts the "cost" attribute
            "fixed_cost" => "Heat_Rate_Base_MMBTU_hr_",
            "max_ramp_u" => "Max_Ramp_Up_MW_min_",
            "max_ramp_d" => "Max_Ramp_Down_MW_min_",
            "min_dn_time" => "Min_Down_Time_h_",
            "min_up_time" => "Min_Up_Time_h_",
            "start_up_cost" => "Start_Cost_",
            "dispatchable" => true,
            "time_series" => Nullable{TimeArray}
    
        ),
        "branch" => Dict(
            "br_r" => "Resistance_p_u_",
            "rate_a" => "Max_Flow_MW_",
            "shift" => 0.0,
            "br_b" => 0.0,
            "rate_b" => "Max_Flow_MW_",
            "br_x" => "Reactance_p_u_",
            "rate_c" => 0.0,
            "f_bus" => "Bus_from",
            "br_status" => 0,
            "t_bus" => "Bus_to",
            "index" => "index_created_at",
            "angmin" => 0.0,
            "angmax" => 0.0,
            "transformer" => false,
            "tap" => 1.0
        ),
        "name" => "csv_case",
        "per_unit" => true,
        "baseMVA" => 100,
        "dcline" => Dict{String, Any}(),
        "version" => "Plexos csv data",
        "multinetwork" => false
    )

    return CSV_MAPPING

end

function parse_string(s::String)
    """
    Takes in a string and returns an Int64 or Float64 if possible. 
    If not, return the original string stripped of leading/ending whitespaces.

    Args:
        s: A string.
    """
    s = strip(s)
    val = tryparse(Int64, s)
    if isnull(val)
        val = tryparse(Float64, s)
        if isnull(val)
            return s
        end
    end
    return get(val)
end

function parse_devices(file_string::String)
    """
    Parses a CSV file denoting a list of devices into JuliaPower format.

    Args:
        file_string: A string.
    """
    devices = readtable(file_string)
    dict = Dict{String, Any}()
    attributes = names(devices)
    num_rows = size(devices, 1)
    num_cols = size(devices, 2)

    # Iterate over all rows
    for i in 1:num_rows
        row = devices[i, :]
        curr_device = Dict{String, Any}()

        # For each row, go through each column and add the column name and value to
        # the current dictionary representing the current device.
        for j in 1:num_cols
            curr_attr = attributes[j]
            val = row[curr_attr][1]
            if typeof(val) == String
                val = parse_string(val)
            end
            curr_device[string(curr_attr)] = val
        end
        curr_device["index_created_at"] = i
        dict[string(i)] = curr_device
    end
    return dict
end

function parse_csv(folder::String)
    """
    Parses all files in a folder which are CSV files into a JuliaPower dictionary.

    Args:
        folder: A string denoting a folder of CSV files.
    """
    
    REGEX_ITEM_NUM = r"[a-zA-Z]*(\d*)"
    REGEX_DEVICE_TYPE = r"(.*?)\.csv"

    case = Dict{String, Any}()
    # iterate through all files in folder
    for file_name in readdir(folder)
        # extract the device name from the file and call parse_devices 
        # on each csv file.
        file_path = "$folder/$file_name"
        device_type = match(REGEX_DEVICE_TYPE, file_name)[1]

        if device_type != "NetLoad"
            case[device_type] = parse_devices(file_path)
        # do something different if current file is NetLoad.csv
        else
            dict = Dict{String, Any}()
            loads = readtable(file_path)
            # ASSUMES LOADS ARE IN THE 2ND COLUMN AND DATETIMES ARE IN THE FIRST COLUMN
            #row_with_max_load = loads[loads[:2] .== maximum(loads[:2]), :]
            dict["max_load"] = maximum(loads[:2])
            dict["dt_at_max_load"] = DateTime(loads[indmax(loads[:2]),1], "m/d/Y H:M")
            series = TimeArray(DateTime(loads[:1], "m/d/Y H:M"),loads[:2]/maximum(loads[:2]))
            case[device_type] = dict
        end
        
    end
    return case
end

function csv_to_pm(csv_dict::Dict{String, Any})
    """
    Convert CSV dictionary to a JuliaPower dictionary. 
    For each type of item in JuliaPower format, go through the appropriate items
    in the CSV dictionary and use the mappings to fill in the JuliaPower dictionary. 

    Args:
        csv_dict: A dictionary. 
    """
    REGEX_ITEM_NUM = r"[a-zA-Z]*(\d*)"
    REGEX_DEVICE_TYPE = r"(.*?)\.csv"

    pm_dict = Dict{String, Any}()

    # keep track of sum of conventional generation at each bus
    gen_at_bus_dict = Dict{String, Any}()

    # iterate through the different types of devices 
    for (item_name, attrs) in csv_mapping()
        # get the appropriate devices to convert to julia power format.
        if item_name == "gen"
            curr_csv = csv_dict["Generators"]
        elseif item_name == "branch"
            curr_csv = csv_dict["Lines"] 
        elseif item_name == "bus"
            curr_csv = csv_dict["Buses"]
        else
            pm_dict[item_name] = attrs
            continue
        end

        # iterate through each of the appropriate devices 
        pm_dict[item_name] = Dict{String, Any}()
        for (csv_item_str, csv_attr) in curr_csv

            # if converting buses, make the item number the number in the bus name (i.e. bus01).
            csv_item_num_str = csv_item_str
            if item_name == "bus"
                item_num = tryparse(Int64, match(REGEX_ITEM_NUM, csv_attr["Bus_Name"])[1])
                if !isnull(item_num)
                    csv_attr["index_created_at"] = get(item_num)
                    csv_item_num_str = string(get(item_num))
                end
            end

            # iterate through each attribute in the current device from the csv dict
            pm_dict[item_name][csv_item_num_str] = Dict{String, Any}()
            for (julia_attr, mapped_attr) in attrs
                # do something specific for the pd attribute of buses.
                if julia_attr == "pd"
                    pm_dict[item_name][csv_item_num_str][julia_attr] = csv_dict["NetLoad"]["max_load"]*csv_attr[mapped_attr]
                # do something specific for the qd attribute of buses. 
                elseif julia_attr == "qd"
                    pm_dict[item_name][csv_item_num_str][julia_attr] = csv_dict["NetLoad"]["max_load"]*csv_attr[mapped_attr]*0.31/0.95
                # if mapped_attr is a string, its a string that refers to a csv attribute name.
                elseif typeof(mapped_attr) == String
                    if julia_attr == "gen_bus" || julia_attr == "f_bus" || julia_attr == "t_bus" || julia_attr == "bus_type"
                        bus_num = tryparse(Int64, match(REGEX_ITEM_NUM, csv_attr[mapped_attr])[1])
                        if !isnull(bus_num)
                            pm_dict[item_name][csv_item_num_str][julia_attr] = get(bus_num)

                            # update gen_at_bus dictionary
                            if julia_attr == "gen_bus"
                                bus_str = string(get(bus_num))
                                generation  = csv_attr["Rating"]
                                if !(isna(generation)) && !(typeof(generation) == String)
                                    if !(bus_str in keys(gen_at_bus_dict))
                                        gen_at_bus_dict[bus_str] = generation
                                    else
                                        gen_at_bus_dict[bus_str] += generation
                                    end
                                end
                            end
                            continue
                        end
                    end
                    val = csv_attr[mapped_attr]
                    if isna(val)
                        val = 0.0
                    end
                    pm_dict[item_name][csv_item_num_str][julia_attr] = val

                # do something specific for cost attribute in generators.
                elseif julia_attr == "cost"
                    cost = []
                    for tuple_attrs in mapped_attr
                        heat_rate = csv_attr[tuple_attrs[1]]
                        if isna(heat_rate)
                            continue
                        end
                        heat_rate = heat_rate / 1000
                        load_point = csv_attr[tuple_attrs[2]]
                        if isna(load_point)
                            continue
                        end                        
                        push!(cost, (heat_rate, load_point))
                    end                    
                    pm_dict[item_name][csv_item_num_str][julia_attr] = cost
                    pm_dict[item_name][csv_item_num_str]["ncost"] = length(cost)
                # case where mapped_attr is a default value.
                else
                    pm_dict[item_name][csv_item_num_str][julia_attr] = mapped_attr
                end
            end
        end
    end

    # go back and define bus types
    max_installed_conventional_generation = 0.0
    bus_with_max_gen = 0

    # iterate through buses and for appropriate buses, set bus_type=2
    for (bus_str, generation) in gen_at_bus_dict
        if generation > 0.2 * pm_dict["bus"][bus_str]["pd"]
            pm_dict["bus"][bus_str]["bus_type"] = 2
        end
        if generation > max_installed_conventional_generation
            max_installed_conventional_generation = generation
            bus_with_max_gen = bus_str
        end
    end
    # for the bus_with_max_gen, set bus_type=3
    if bus_with_max_gen != 0
        pm_dict["bus"][bus_with_max_gen]["bus_type"] = 3
    end

    return pm_dict
end


function plexoscsv_parser(folder::String) 

    csv_d = parse_csv(folder)
    pm_d = csv_to_pm(csv_d)

    return pm_d
end