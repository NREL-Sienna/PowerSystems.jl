export plexoscsv_parser

function csv_mappings()
    """
    This function returns a dictionary that, for each device,
    maps JuliaPower attributes to the appropriate column names
    found in the CSV files. Values in the dictionaries that aren't
    strings (except for "data_type" => "DA" and the default case
    parameters found at the bottom of the dictionary) are used as default
    values for their respective key/JuliaPower attribute.

    Keys that map to 'nothing' do not have default values because their value
    are determined by other JuliaPower attributes and will be calculated in
    a different order than the other attributes.
    """


    CSV_MAPPING = Dict(
        "bus" => Dict(
            "zone" => 1,
            "bus_i" => "index_created_at",
            "bus_type" => 1,
            "qd" => "Load_Participation_Factor",
            "gs" => 0.0,
            "bs" => 0.0,
            "vmax" => 1.06,
            "area" => "Region",
            "bus_name" => "Bus_Name",
            "vmin" => 0.94,
            "index" => "index_created_at",
            "va" => 0.0,
            "vm" => 1.0,
            "base_kv" => 138.0,
            "pd" => "Load_Participation_Factor",
            "time_series" => nothing, # will be updated when csv_to_pm_bus converts the "qd" attribute
            "data_type" => "DA" # DA or RT
        ),
        "gen" => Dict(
            "qc1max" => 0.0,
            "model" => 2, # Plexos uses PWL cost models and PowerModels uses polynomial
            "startup" => "Start_Cost_",
            "qc2max" => 0.0,
            "qg" => 0.0,
            "gen_bus" => "bus_of_connection",
            "mbase" => "Rating",
            "pc2" => 0.0,
            "index" => "index_created_at",
            "qmax" => 9999.0,
            "pc1" => 0.0,
            "pg" => nothing, # will be updated when csv_to_pm_gen converts the "mbase" attribute
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
            "ncost" => nothing, # will be updated when csv_to_pm_gen converts the "cost" attribute
            "fixed_cost" => "Heat_Rate_Base_MMBTU_hr_",
            "max_ramp_u" => "Max_Ramp_Up_MW_min_",
            "max_ramp_d" => "Max_Ramp_Down_MW_min_",
            "min_dn_time" => "Min_Down_Time_h_",
            "min_up_time" => "Min_Up_Time_h_",
            "dispatchable" => nothing, # will be updated when csv_to_pm_gen converts the "mbase" attribute
            "time_series" => nothing # will be updated when csv_to_pm_gen converts the "mbase" attribute

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

        # Default case parameters
        "name" => "csv_case",
        "per_unit" => true,
        "baseMVA" => 100,
        "dcline" => Dict{String, Any}(),
        "version" => "Plexos csv data",
        "multinetwork" => false
    )

    return CSV_MAPPING

end

function parse_devices(file_string::String)
    """
    Parses a CSV file denoting a list of devices into JuliaPower format.

    Iterates through all rows in the CSV and creates a dictionary for each row.
    Each created dictionary represents a device and has the column names as keys
    and the value in the row as the value. These dictionaries are stored in an
    outer dictionary. A dictionary's key in this outer dictionary is the index
    of the row in the CSV that represents the appropriate device.

    Args:
        file_string: A string.

    Returns:
        A dictionary with the csv attributes of many power system devices.
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

function parse_netloads(folder::String)
    """
    Parses a folder of CSV files where the 1st column is a datetime column and the
    2nd column is a column of loads of the whole system.

    An overall netload time series is created by outer joining all the CSV tables
    by datetime and summing up all the load data for a particular datetime. Then,
    some information is calculated, which is specified below.

    Args:
        folder: A file path to the folder of netload data

    Returns:
        A dictionary holding the max load, datetime of the max load, and the time series
        for each region and for the sum of the data from each region.
        The format is like this:
        {
            "RT" => {
                "R1" => {
                    "series" - the time series, divided by the load occuring at datetime of maxload in the netload
                    "max_load" - the max load in the above time series
                }
                "R2" => (same as above)
                ...
            }
            "DA" => {
                (same as the above)
            }
            "series" - the netload time series, divided by the maximum load
            "max_load" - the max load in the time series (before normalizing)
            "ind_at_max_load" - the index (an integer) in the netload time series where the max load occurs
            "dt_at_max_load" - a datetime object when the max load occurs in the netload time series
        }
    """
    REGEX_REGION_TYPE = r".*?(R\d)(.*?)\.csv"

    dict = Dict{String, Any}()
    dict["RT"] = Dict{String, Any}()
    dict["DA"] = Dict{String, Any}()

    files = readdir(folder)
    load_data = Dict{String, Any}()
    netload = nothing
    for file_of_loads in files
        regex_matches = match(REGEX_REGION_TYPE, file_of_loads)
        region = regex_matches[1]
        data_type = regex_matches[2]
        dict[data_type][region] = Dict{String, Any}()

        curr_loads = readtable("$folder/$file_of_loads")
        load_data[file_of_loads] = curr_loads

        if netload == nothing
            netload = curr_loads
        else
            netload = join(netload, curr_loads, on=:DATETIME)
            netload[:sum] = netload[:2] + netload[:3]
            netload = netload[[:DATETIME, :sum]]
        end
    end

    # Get max load, datetime of max load, and time series for netload
    #dropna(loads) # take out rows with NA's
    dict["max_load"] = maximum(netload[:2]) # get maximum load
    dict["ind_at_max_load"] = indmax(netload[:2])
    dict["dt_at_max_load"] = DateTime(netload[dict["ind_at_max_load"],1], "m/d/Y H:M") # get date where maximum load occurs
    netload[:dt] = DateTime(Array{String, 1}(netload[:1]), "m/d/Y H:M")
    sort!(netload, cols=[order(:dt)]) # sort data by dates
    dict["series"] = TimeArray(netload[:dt], netload[:2] / dict["max_load"])

    # Get max load, datetime of max load, and time series for load of each region
    for file_of_loads in files
        regex_matches = match(REGEX_REGION_TYPE, file_of_loads)
        region = regex_matches[1]
        data_type = regex_matches[2]

        curr_loads = load_data[file_of_loads]
        curr_loads[:dt] = DateTime(Array{String, 1}(curr_loads[:1]), "m/d/Y H:M")
        sort!(curr_loads, cols=[order(:dt)])
        dict[data_type][region]["series"] = TimeArray(curr_loads[:dt], curr_loads[:2]
                                                        / curr_loads[curr_loads[:dt] .== dict["dt_at_max_load"], :][:2][1])
        dict[data_type][region]["max_load"] = maximum(dict[data_type][region]["series"].values)
    end

    return dict
end

function parse_renewable_loads(file_path::String)
        """
    Parses a CSV file where the 1st column is a datetime column and the
    2nd column is a column of loads

    Args:
        file_path: A file path

    Returns:
        A dictionary holding the max load, datetime of the max load, and the time series.
        The format is like this:
        {
            "(renewable name)" => {
                "series" - the time series
                "max_load" - the max load in the time series
                "ind_at_max_load" - the index (an integer) in the time series where the max load occurs
                "dt_at_max_load" - a datetime object when the max load occurs in the time series
            }
            ...
        }
    """
    dict = Dict{String, Any}()
    loads = readtable(file_path)

    #dropna(loads) # take out rows with NA's
    dict["max_load"] = maximum(loads[:2]) # get maximum load
    dict["ind_at_max_load"] = indmax(loads[:2])
    dict["dt_at_max_load"] = DateTime(loads[dict["ind_at_max_load"],1], "m/d/Y H:M") # get date where maximum load occurs
    loads[:dt] = DateTime(Array{String, 1}(loads[:1]), "m/d/Y H:M")
    sort!(loads, cols=[order(:dt)]) # sort data by dates
    dict["series"] = TimeArray(loads[:dt], loads[:2])

    return dict
end

function parse_csv(folder::String)
    """
    Parses all files in a folder which are CSV files into a JuliaPower dictionary.

    Args:
        folder: A string denoting a folder of CSV files.

    Returns:
        A dictionary whos keys are device types and whos values are dictionaries that
        each represent a device and its attributes.
        The format is like this:
        {
            "Buses" => {
                "(device number)" => {
                    (csv attributes mapped to their value in the csv file)
                }
                ...
            }
            "Generators" => {
                (same as above)
            }
            "Branches" => {
                (same as above)
            }
        }
    """
    REGEX_DEVICE_TYPE = r"(.*?)\.csv"
    REGEX_IS_FOLDER = r"^[A-Za-z]+$"

    case = Dict{String, Any}()
    case["folder path"] = folder
    # iterate through all files in folder
    for file_name in readdir(folder)
        # extract the device name from the file and call parse_devices
        # on each csv file.
        file_path = "$folder/$file_name"

        # if current file name is a folder name, look into folder and call parse_loads on all files
        # assumes folders contain load data and all load data is in folders (besides netload)
        if match(REGEX_IS_FOLDER, file_name) != nothing

            # If parsing files in folder called "Load", parse the load files together to calculate net load
            if file_name == "Load"
                case["NetLoad"] = parse_netloads(file_path)
            else
                # else, go through each file in the folder and parse each load file individually
                for file_of_loads in readdir(file_path)
                    load_file = join(split(uppercase(strip(match(REGEX_DEVICE_TYPE, file_of_loads)[1]))))
                    case[load_file] = parse_renewable_loads("$file_path/$file_of_loads")
                end
            end

        # else, parse files specifying devices and netload.csv
        elseif match(REGEX_DEVICE_TYPE, file_name) != nothing
            device_type = match(REGEX_DEVICE_TYPE, file_name)[1]
            case[device_type] = parse_devices(file_path)
        end

    end

    device_types = ["Buses", "Generators", "Lines"]
    for device_name in device_types
        if !haskey(case, device_name)
            error("Did not find $(device_name).csv in order to get data for $(device_name)!")
        end
    end

    return case
end

function csv_to_pm(csv_dict::Dict{String, Any})
    """
    Convert CSV dictionary to a JuliaPower dictionary.
    For each type of item in JuliaPower format, call the appropriate function.
    At the end, fill in the default case parameters from csv_mappings() into pm_dict

    Args:
        csv_dict: A dictionary from the output of the function parse_csv.

    Returns:
        A dictionary in JuliaPower format.
        The format is like this:
        {
            "gen" => {
                "device number" => {
                    (JuliaPower attributes (see function "csv_mappings") mapped to their calculated value)
                }
                ...
            }
            "bus" => {
                (same as above)
            }
            "branch" => {
                (same as above)
            }
            ... (some case paramters - see function "csv_mappings")
        }
    """
    pm_dict = Dict{String, Any}()
    pm_dict["gen"], gen_at_bus_dict = csv_to_pm_gen(csv_dict)
    pm_dict["bus"] = csv_to_pm_bus(csv_dict, gen_at_bus_dict)
    pm_dict["branch"] = csv_to_pm_branch(csv_dict, pm_dict["bus"])

    default_pm_vals = csv_mappings()
    for (pm_attr, default_val) in default_pm_vals
        if !isa(default_val, Dict) || pm_attr == "dcline"
            pm_dict[pm_attr] = default_val
        end
    end

    return pm_dict
end

function csv_to_pm_gen(csv_dict::Dict{String, Any})
    """
    Convert CSV dictionary to a JuliaPower dictionary of GENERATORS ONLY.
    For each generators in the CSV dictionary, use the mappings to
    create a JuliaPower dictionary. Also return a dictionary mapping
    bus numbers (as strings) to the amount of conventional generation at that bus.

    Args:
        csv_dict: A dictionary from the output of the function parse_csv.

    Returns:
        pm_dict_gen: A dictionary in JuliaPower format.
        The format is like this:
        {
            "device number" => {
                (JuliaPower attributes (see function "csv_mappings") mapped to their calculated value)
            }
            ...
        }

        gen_at_bus_dict: A dictionary
        The format is like this:
        {
            "bus number" => sum of generation at that bus
            ...
        }
    """
    REGEX_ITEM_NUM = r"[a-zA-Z]*(\d*)"

    # keep track of sum of conventional generation at each bus
    gen_at_bus_dict = Dict{String, Any}()

    mappings = csv_mappings()
    attr_mappings = mappings["gen"]
    baseMVA = mappings["baseMVA"]
    pm_dict_gen = Dict{String, Any}()

    # iterate through each generator in csv_dict
    for (csv_item_num_str, csv_attrs) in csv_dict["Generators"]
        pm_dict_gen[csv_item_num_str] = Dict{String, Any}()

        # iterate through each julia attribute => csv attribute item in the mapping
        for (julia_attr, mapped_attr) in attr_mappings
            # if mapped_attr is a string, its a string that refers to a csv attribute name.
            if typeof(mapped_attr) == String
                # this julia attribute refers to bus names and we need to extract the number from the bus name
                if julia_attr == "gen_bus"
                    bus_num = tryparse(Int64, match(REGEX_ITEM_NUM, csv_attrs[mapped_attr])[1])
                    if !isnull(bus_num)
                        pm_dict_gen[csv_item_num_str][julia_attr] = get(bus_num)

                        # update gen_at_bus dictionary
                        if julia_attr == "gen_bus"
                            bus_str = string(get(bus_num))
                            generation  = csv_attrs["Rating"]
                            if !isna(generation) && !(typeof(generation) == String)
                                if !(bus_str in keys(gen_at_bus_dict))
                                    gen_at_bus_dict[bus_str] = generation
                                else
                                    gen_at_bus_dict[bus_str] += generation
                                end
                            end
                        end
                    else
                        warn("Could not get an integer from $(csv_attrs[mapped_attr]) for the $julia_attr attribute of generator $csv_item_num_str!")
                    end
                else
                    # get the mapped attribute. if its NA, make val = 0.0
                    val = csv_attrs[mapped_attr]
                    if isna(val)
                        val = 0.0
                    end
                    pm_dict_gen[csv_item_num_str][julia_attr] = val

                    # get the time series if the current generator is non-dispatchable
                    if julia_attr == "mbase"
                        if typeof(val) == String
                            pm_dict_gen[csv_item_num_str]["dispatchable"] = false

                            # Get the appropriate load time series
                            load_name = join(split(uppercase(strip(val))))
                            if !haskey(csv_dict, load_name) # try take out whitespaces everywhere
                                if haskey(csv_dict, "$(load_name)DA") # try adding DA
                                    load_name = "$(load_name)DA"
                                elseif haskey(csv_dict, "$(join(split(load_name, "0")))") # try taking away 0's
                                    load_name = "$(join(split(load_name, "0")))"
                                elseif haskey(csv_dict, "$(join(split(load_name, "0")))DA") # try taking away 0's and adding DA
                                    load_name ="$(join(split(load_name, "0")))DA"
                                else
                                    warn("\nCould not find load data with name '$(load_name)' in the csv dictionary for generator $(csv_item_num_str)!")
                                    continue
                                end
                            end

                            loads = csv_dict[load_name]
                            series = loads["series"]

                            # Fill the pg attribute
                            try
                                pm_dict_gen[csv_item_num_str]["pg"] = (series[csv_dict["NetLoad"]["dt_at_max_load"]].values / baseMVA)[1]
                            catch e
                                if isa(e, MethodError)
                                    warn("\nCould not find the date at max load from the NetLoad.csv ($(csv_dict["NetLoad"]["dt_at_max_load"])) in $load_name.csv. Trying to search by index...")
                                end
                                if length(csv_dict["NetLoad"]) == length(series)
                                    warn("\nFilled the pg attribute for generator $csv_item_num_str by index.")
                                    pm_dict_gen[csv_item_num_str]["pg"] = series.values[csv_dict["NetLoad"]["ind_at_max_load"]]
                                else
                                    warn("\nNetLoad and $load_name have mismatched lengths.\nTherefore, could not fill in pg attribute for generator $csv_item_num_str.")
                                end

                            end

                            # Normalize the series
                            if norm(loads["series"].values, 1) != 1
                                series = series ./ csv_attrs[attr_mappings["pmax"]]
                            end
                            pm_dict_gen[csv_item_num_str]["time_series"] = nothing
                        else
                            pm_dict_gen[csv_item_num_str]["dispatchable"] = true
                            pm_dict_gen[csv_item_num_str]["time_series"] = nothing
                            pm_dict_gen[csv_item_num_str]["pg"] = 0.0
                        end
                    end
                end
            # do something specific for cost attribute in generators.
            elseif julia_attr == "cost"
                cost = [100.0, 4000.0, 0.0]
                pm_dict_gen[csv_item_num_str][julia_attr] = cost
                pm_dict_gen[csv_item_num_str]["ncost"] = length(cost)
            # case where mapped_attr is a default value.
            elseif mapped_attr != nothing
                pm_dict_gen[csv_item_num_str][julia_attr] = mapped_attr
            end
        end
    end

    return pm_dict_gen, gen_at_bus_dict
end

function csv_to_pm_bus(csv_dict::Dict{String, Any}, gen_at_bus_dict::Dict{String, Any})
    """
    Convert CSV dictionary to a JuliaPower dictionary of BUSES ONLY.
    For each type generators in the CSV dictionary, use the mappings to
    create a JuliaPower dictionary.

    Args:
        csv_dict: A dictionary from the output of the function parse_csv.

    Returns:
        A dictionary in JuliaPower format.
        The format is like this:
        {
            "device number" => {
                (JuliaPower attributes (see function "csv_mappings") mapped to their calculated value)
            }
            ...
        }
    """
    REGEX_ITEM_NUM = r"[a-zA-Z]*(\d*)"

    mappings = csv_mappings()
    attr_mappings = mappings["bus"]
    baseMVA = mappings["baseMVA"]

    pm_dict_bus = Dict{String, Any}()

    # iterate through each bus in the csv_dict
    for (csv_item_num_str, csv_attrs) in csv_dict["Buses"]

        # if converting buses, make the item number the number in the bus name (i.e. bus01).
        item_num = tryparse(Int64, match(REGEX_ITEM_NUM, csv_attrs["Bus_Name"])[1])
        if !isnull(item_num)
            csv_attrs["index_created_at"] = get(item_num)
            csv_item_num_str = string(get(item_num))
        end
        pm_dict_bus[csv_item_num_str] = Dict{String, Any}()

        # iterate through each julia attribute => csv attribute item in the mapping
        for (julia_attr, mapped_attr) in attr_mappings
            # if mapped_attr is a string, its a string that refers to a csv attribute name.
            if typeof(mapped_attr) == String && julia_attr != "data_type"
                # these julia arguments refer to bus names and we need to extract the number from the bus name
                if julia_attr == "bus_type" || julia_attr == "bus_name"
                    bus_num = tryparse(Int64, match(REGEX_ITEM_NUM, csv_attrs[mapped_attr])[1])
                    if !isnull(bus_num)
                        pm_dict_bus[csv_item_num_str][julia_attr] = get(bus_num)
                    else
                        warn("Could not get an integer from $(csv_attrs[mapped_attr]) for the $julia_attr attribute of bus $(csv_item_num_str)!")
                    end
                else
                    # get the mapped attribute. if its NA, make val = 0.0
                    val = csv_attrs[mapped_attr]
                    if isna(val)
                        val = 0.0
                    end
                    pm_dict_bus[csv_item_num_str][julia_attr] = val
                end
            # case where mapped_attr is a default value.
            elseif mapped_attr != nothing
                pm_dict_bus[csv_item_num_str][julia_attr] = mapped_attr
            end
        end
    end

    # go back and define the pd and qd attributes
    # iterate through each bus in the pm_dict_bus
    for (bus_num_str, curr_bus) in pm_dict_bus
        load_participation = pm_dict_bus[bus_num_str]["pd"]

        # do something specific for the pd attribute of buses.
        pm_dict_bus[bus_num_str]["pd"] = csv_dict["NetLoad"][curr_bus["data_type"]][curr_bus["area"]]["max_load"] *
                                            pm_dict_bus[bus_num_str]["pd"] /
                                            baseMVA

        # do something specific for the qd attribute of buses.
        pm_dict_bus[bus_num_str]["qd"] = (csv_dict["NetLoad"][curr_bus["data_type"]][curr_bus["area"]]["max_load"] *
                                            pm_dict_bus[bus_num_str]["pd"] *
                                            0.31/0.95) /
                                            baseMVA
        if load_participation > 0
            pm_dict_bus[bus_num_str]["time_series"] = nothing
        else
            pm_dict_bus[bus_num_str]["time_series"] = nothing
        end
    end


    # go back and define bus types
    max_installed_conventional_generation = 0.0
    bus_with_max_gen = 0

    # iterate through buses and for appropriate buses, set bus_type=2
    for (bus_str, generation) in gen_at_bus_dict
        if generation > 0.2 * pm_dict_bus[bus_str]["pd"]
            pm_dict_bus[bus_str]["bus_type"] = 2
        end
        if generation > max_installed_conventional_generation
            max_installed_conventional_generation = generation
            bus_with_max_gen = bus_str
        end
    end
    # for the bus_with_max_gen, set bus_type=3
    if bus_with_max_gen != 0
        pm_dict_bus[bus_with_max_gen]["bus_type"] = 3
    end

    return pm_dict_bus
end

function csv_to_pm_branch(csv_dict::Dict{String, Any}, pm_dict_bus::Dict{String,Any})
    """
    Convert CSV dictionary to a JuliaPower dictionary of BRANCHES ONLY.
    For each type generators in the CSV dictionary, use the mappings to
    create a JuliaPower dictionary.

    Args:
        csv_dict: A dictionary from the output of the function parse_csv.

    Returns:
        A dictionary in JuliaPower format.
        The format is like this:
        {
            "device number" => {
                (JuliaPower attributes (see function "csv_mappings") mapped to their calculated value)
            }
            ...
        }
    """

    REGEX_ITEM_NUM = r"[a-zA-Z]*(\d*)"

    pm_dict_branch = Dict{String, Any}()
    attr_mappings = csv_mappings()["branch"]

    # iterate through each branch in csv_dict
    for (csv_item_num_str, csv_attrs) in csv_dict["Lines"]
        pm_dict_branch[csv_item_num_str] = Dict{String, Any}()

        # iterate through each julia attribute => csv attribute in the mapping
        for (julia_attr, mapped_attr) in attr_mappings
            if typeof(mapped_attr) == String
                # these julia arguments refer to bus names and we need to extract the number from the bus name
                if julia_attr == "f_bus" || julia_attr == "t_bus"
                    bus_num = tryparse(Int64, match(REGEX_ITEM_NUM, csv_attrs[mapped_attr])[1])
                    if !isnull(bus_num)
                        pm_dict_branch[csv_item_num_str][julia_attr] = get(bus_num)
                    else
                        warn("Could not get an integer from $(csv_attrs[mapped_attr]) for the $julia_attr attribute of branch $(csv_item_num_str)!")
                    end
                else
                    # get the mapped attribute. if its NA, make val = 0.0
                    val = csv_attrs[mapped_attr]
                    if isna(val)
                        val = 0.0
                    end
                    pm_dict_branch[csv_item_num_str][julia_attr] = val
                end
            # case where mapped_attr is a default value.
            elseif mapped_attr != nothing
                pm_dict_branch[csv_item_num_str][julia_attr] = mapped_attr
            end
        end
    end

    return pm_dict_branch
end


function parse_string(s::String)
    """
    Takes in a string and returns an Int64 or Float64 if possible.
    If not, return the original string stripped of leading/ending whitespaces.

    Args:
        s: A string.

    Returns:
        The parsed value
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

function plexoscsv_parser(folder::String)
    """
    Parses a folder of CSV files into a JuliaPower dictionary.

    Args:
        folder: A file path as a string to the folder of relevant CSV files.

    Returns:
        A dictionary in JuliaPower format.
    """

    csv_d = parse_csv(folder)
    pm_d = csv_to_pm(csv_d)

    PowerModels.check_network_data(pm_d)
    return pm_d
end
