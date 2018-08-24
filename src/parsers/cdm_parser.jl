function read_csv_data(file_path::String)
    """
    Reads in all the data stored in csv files
    The general format for data is
        folder:
            gen.csv
            branch.csv
            bus.csv
            ..
            load.csv
    Args:
        Path to folder with all the System data CSV's files

    Returns:
        Nested Data dictionary with key values as folder/file names and dataframes as values

    """
    files = (joinpath(Pkg.dir(),file_path))
    REGEX_DEVICE_TYPE = r"(.*?)\.csv"
    REGEX_IS_FOLDER = r"^[A-Za-z]+$"
    data =Dict{String,Any}()

    if length(files) == 0
        @error("No test files in the folder")
    end
    for d_file in readdir(files)
        try
            if match(REGEX_IS_FOLDER, d_file) != nothing
                print("Parsing csv timeseries files in $d_file ...\n")
                for file in readdir(files*"/$d_file")
                    if match(REGEX_DEVICE_TYPE, file) != nothing
                        data[d_file] = Dict{String,Any}()
                        file_path = files*"/$d_file/$file"
                        raw_data = CSV.read(file_path,header=1,datarow =2,rows_for_type_detect=1000)
                        data[d_file][split(file,r"[.]")[1]] = raw_data
                    end
                end
                println("Successfully parsed $d_file")
            elseif match(REGEX_DEVICE_TYPE, d_file) != nothing
                print("Parsing csv timeseries files in $d_file ...\n")
                file_path = files*"/$d_file"
                raw_data = CSV.read(file_path,header=1,datarow =2,rows_for_type_detect=1000)
                data[split(d_file,r"[.]")[1]] = raw_data
                println("Successfully parsed $d_file")
            end
        catch
            @warn("error while parsing $d_file")
            catch_stacktrace()
        end
    end
    return data
end

function csv2ps_dict(file_path::String)
    """
    Args:
        Path to folder with all the System data CSV's files
    Returns:
        A Power Systems Nested dictionary with keys as devices and values as data dictionary necessary to construct the device structs
        PS dictionary:
            "Bus" => Dict(bus_no => Dict("name" =>
                                         "number" => ... ) )
            "Generator" => Dict( "Thermal" => Dict( "name" =>
                                                    "tech" => ...)
                                 "Hydro"  => ..
                                 "Renewable" => .. )
            "Branch" => ...
            "Load" => ...
            "LoadZones" => ...
            "BaseKV" => ..
            ...
    """
    data =  read_csv_data(file_path)
    ps_dict =Dict{String,Any}()
    if haskey(data,"bus")
        ps_dict["bus"] =  PowerSystems.bus_csv_parser(data["bus"])
    else
        @error("Key error : key 'bus' not found in PowerSystems dictionary
            \n Cant Construct any PowerSystem Struct")
    end
    if haskey(data,"gen")
        ps_dict["gen"] =  PowerSystems.gen_csv_parser(data["gen"],ps_dict["bus"])
    else
        @warn("Key error : key 'gen' not found in PowerSystems dictionary,
          \n This will result in an ps_dict['gen'] = nothing")
         ps_dict["gen"] = nothing
    end
    if haskey(data,"branch")
        ps_dict["branch"] =  PowerSystems.branch_csv_parser(data["branch"],ps_dict["bus"])
    else
        @warn("Key error : key 'bus' not found in PowerSystems dictionary,
          \n This will result in an ps_dict['branch'] = nothing")
         ps_dict["branch"] = nothing
    end
    if haskey(data,"load")
        ps_dict["load_zone"] =  PowerSystems.loadzone_csv_parser(data["bus"],ps_dict["bus"])
        ps_dict["load"] =  PowerSystems.load_csv_parser(data["load"],data["bus"],ps_dict["bus"],ps_dict["load_zone"])
    else
        @warn("Key error : key 'load' not found in PowerSystems dictionary,
          \n This will result in an ps_dict['load'] = nothing")
         ps_dict["load"] = nothing
    end
    return ps_dict
end

###########
#Bus data parser
###########

function bus_csv_parser(bus_raw)
    """
    Args:
        A DataFrame with the same column names as in RTS_GMLC bus.csv file
        "Bus ID"	"Bus Name"	"BaseKV"	"Bus Type"	"MW Load"	"MVAR Load"	"V Mag"	"V Angle"	"MW Shunt G"	"MVAR Shunt B"	"Area"
    Returns:
        A Nested Dictionary with keys as Bus number and values as bus data dictionary with same keys as the device struct
    """
    Buses_dict = Dict{Int64,Any}()
    for i in 1:nrow(bus_raw)
        Buses_dict[bus_raw[i,1]] = Dict{String,Any}("number" =>bus_raw[i,1] ,
                                                "name" => bus_raw[i,2],
                                                "bustype" => bus_raw[i,4],
                                                "angle" => bus_raw[i,8],
                                                "voltage" => bus_raw[i,7],
                                                "voltagelimits" => (min=0.95,max=1.05),
                                                "basevoltage" => bus_raw[i,3]
                                                )
    end
    return Buses_dict
end


###########
#Generator data parser
###########

function gen_csv_parser(gen_raw::DataFrames.DataFrame, Buses::Dict{Int64,Any})
    """
    Args:
        A DataFrame with the same column names as in RTS_GMLC gen.csv file
        Parsed Bus PowerSystems dictionary
    Returns:
        A Nested Dictionary with keys as generator types/names and values as generator data dictionary with same keys as the device struct
    """
    Generators_dict = Dict{String,Any}()
    Generators_dict["Thermal"] = Dict{String,Any}()
    Generators_dict["Hydro"] = Dict{String,Any}()
    Generators_dict["Renewable"] = Dict{String,Any}()
    Generators_dict["Renewable"]["PV"]= Dict{String,Any}()
    Generators_dict["Renewable"]["RTPV"]= Dict{String,Any}()
    Generators_dict["Renewable"]["WIND"]= Dict{String,Any}()
    Generators_dict["Storage"] = Dict{String,Any}()
    for gen in 1:nrow(gen_raw)
        if gen_raw[gen,:Fuel] in ["Oil","Coal","NG","Nuclear"]
            var_cost = [float(gen_raw[gen,i]) for i in 31:40]
            fuel_cost = gen_raw[gen,30]./1000
            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,2]]
            Generators_dict["Thermal"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                            "available" => true,
                                            "bus" => make_bus(bus_id[1]),
                                            "tech" => Dict{String,Any}("realpower" => 0,
                                                                        "realpowerlimits" => (min=float(gen_raw[gen,12]),max=float(gen_raw[gen,11])),
                                                                        "reactivepower" => 0,
                                                                        "reactivepowerlimits" => (min=float(gen_raw[gen,14]),max=float(gen_raw[gen,13])),
                                                                        "ramplimits" => (up=gen_raw[gen,17],down=gen_raw[gen,17]),
                                                                        "timelimits" => (up=gen_raw[gen,16],down=gen_raw[gen,15])),
                                            "econ" => Dict{String,Any}("capacity" => gen_raw[gen,11],
                                                                        "variablecost" => var_cost,
                                                                        "fixedcost" => 0.0,
                                                                        "startupcost" => gen_raw[gen,21]*fuel_cost,
                                                                        "shutdncost" => 0.0,
                                                                        "annualcapacityfactor" => nothing)
                                            )

        elseif gen_raw[gen,:Fuel] in ["Hydro"]
            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,2]]
            Generators_dict["Hydro"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                            "available" => true, # change from staus to available
                                            "bus" => make_bus(bus_id[1]),
                                            "tech" => Dict{String,Any}( "installedcapacity" => float(gen_raw[gen,11]),
                                                                        "realpower" => 0.0,
                                                                        "realpowerlimits" => (min=float(gen_raw[gen,12]),max=float(gen_raw[gen,11])),
                                                                        "reactivepower" => 0.0,
                                                                        "reactivepowerlimits" => (min=float(gen_raw[gen,14]),max=float(gen_raw[gen,13])),
                                                                        "ramplimits" => (up=gen_raw[gen,17],down=gen_raw[gen,17]),
                                                                        "timelimits" => (up=gen_raw[gen,16],down=gen_raw[gen,15])),
                                            "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                        "interruptioncost" => nothing),
                                            "scalingfactor" => nothing
                                            )

        elseif gen_raw[gen,:Fuel] in ["Solar","Wind"]
            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,2]]
            if gen_raw[gen,5] == "PV"
                Generators_dict["Renewable"]["PV"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                                "available" => true, # change from staus to available
                                                "bus" => make_bus(bus_id[1]),
                                                "tech" => Dict{String,Any}("installedcapacity" => gen_raw[gen,11],
                                                                            "reactivepowerlimits" => (min=float(gen_raw[gen,14]),max=float(gen_raw[gen,13])),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing),
                                                "scalingfactor" => nothing
                                                )
            elseif gen_raw[gen,5] == "RTPV"
                Generators_dict["Renewable"]["RTPV"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                                "available" => true, # change from staus to available
                                                "bus" => make_bus(bus_id[1]),
                                                "tech" => Dict{String,Any}("installedcapacity" => gen_raw[gen,11],
                                                                            "reactivepowerlimits" => (min=float(gen_raw[gen,14]),max=float(gen_raw[gen,13])),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing),
                                                "scalingfactor" => nothing
                                                )
            elseif gen_raw[gen,5] == "WIND"
                Generators_dict["Renewable"]["WIND"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                                "available" => true, # change from staus to available
                                                "bus" => make_bus(bus_id[1]),
                                                "tech" => Dict{String,Any}("installedcapacity" => gen_raw[gen,11],
                                                                            "reactivepowerlimits" => (min=float(gen_raw[gen,14]),max=float(gen_raw[gen,13])),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing),
                                                "scalingfactor" => nothing
                                                )
            end
        elseif gen_raw[gen,:Fuel] in ["Storage"]
            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,2]]
            Generators_dict["Storage"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                            "available" => true, # change from staus to available
                                            "bus" => make_bus(bus_id[1]),
                                            "energy" => 0.0,
                                            "capacity" => (min=float(gen_raw[gen,12]),max=float(gen_raw[gen,11])),
                                            "realpower" => 0.0,
                                            "inputrealpowerlimit" => 0.0,
                                            "outputrealpowerlimit" => 0.0,
                                            "efficiency" => (in= 0.0, out = 0.0),
                                            "reactivepower" => 0.0,
                                            "reactivepowerlimits" => (min = 0.0, max = 0.0),
                                            )
        end
    end
    return Generators_dict
end

###########
#Branch data parser
###########

function branch_csv_parser(branch_raw,Buses)
    """
    Args:
        A DataFrame with the same column names as in RTS_GMLC branch.csv file
        Parsed Bus PowerSystems dictionary
    Returns:
        A Nested Dictionary with keys as branch types/names and values as line/transformer data dictionary with same keys as the device struct

    """
    Branches_dict = Dict{String,Any}()
    Branches_dict["Transformers"] = Dict{String,Any}()
    Branches_dict["Lines"] = Dict{String,Any}()
    for i in 1:length(branch_raw)
        bus_f = [Buses[f] for f in keys(Buses) if Buses[f]["number"] == branch_raw[i,2]]
        bus_t = [Buses[t] for t in keys(Buses) if Buses[t]["number"] == branch_raw[i,3]]
        if branch_raw[i,12] > 0.0
            Branches_dict["Transformers"][branch_raw[i,1]] = Dict{String,Any}("name" => branch_raw[i,1],
                                                        "available" => true,
                                                        "connectionpoints" => (from=make_bus(bus_f[1]),to=make_bus(bus_t[1])),
                                                        "r" => branch_raw[i,4],
                                                        "x" => branch_raw[i,5],
                                                        "primaryshunt" => branch_raw[i,6] ,  #TODO: add field in CSV
                                                       # "zb" => (primary=(branch_raw[i,6]/2),secondary=(branch_raw[i,6]/2)), TODO: Phase-Shifting Transformer angle
                                                        "tap" => branch_raw[i,12],
                                                        "rate" => branch_raw[i,7],
                                                        )
        else
            Branches_dict["Lines"][branch_raw[i,1]] = Dict{String,Any}("name" => branch_raw[i,1],
                                                        "available" => true,
                                                        "connectionpoints" => (from=make_bus(bus_f[1]),to=make_bus(bus_t[1])),
                                                        "r" => branch_raw[i,4],
                                                        "x" => branch_raw[i,5],
                                                        "b" => (from=(branch_raw[i,6]/2),to=(branch_raw[i,6]/2)),
                                                        "rate" =>  branch_raw[i,7],
                                                        "anglelimits" => (max =60.0,min=-60.0) #TODO: add field in CSV
                                                        )

        end
    end
    return Branches_dict
end


###########
#Load data parser
###########

function load_csv_parser(load_raw,bus_raw,Buses,LoadZone)
    """
    Args:
        A DataFrame with the same column names as in RTS_GMLC load.csv file
        A DataFrame with the same column names as in RTS_GMLC bus.csv file
        Parsed Bus PowerSystems dictionary
    Returns:
        A Nested Dictionary with keys as load names and values as load data dictionary with same keys as the device struct
    """
    Loads_dict = Dict{String,Any}()
    load_raw = read_datetime(load_raw)
    load_zone = nothing
    for (k_b,b) in Buses
        for (k_l,l)  in LoadZone
            bus_numbers = [b.number for b in l["buses"] ]
            if b["number"] in bus_numbers
                load_zone = k_l
            end
        end
        p = [bus_raw[n,5] for n in 1:nrow(bus_raw) if bus_raw[n,1] == b["number"]]
        q = [bus_raw[m,6] for m in 1:nrow(bus_raw) if bus_raw[m,1] == b["number"]]
        ts_raw =load_raw[:,load_zone]*(p[1]/LoadZone[load_zone]["maxrealpower"])
        Loads_dict[b["name"]] = Dict{String,Any}("name" => b["name"],
                                            "available" => true,
                                            "bus" => make_bus(b),
                                            "model" => "P",
                                            "maxrealpower" => p[1],
                                            "maxreactivepower" => q[1],
                                            "scalingfactor" => TimeSeries.TimeArray(load_raw[:,:DateTime],ts_raw) #TODO remove TS
                                            )
    end
    return Loads_dict
end

###########
#LoadZone data parser
###########

function loadzone_csv_parser(bus_raw,Buses)
    """
    Args:
        A DataFrame with the same column names as in RTS_GMLC bus.csv file
        Parsed Bus PowerSystems dictionary
    Returns:
        A Nested Dictionary with keys as loadzone names and values as loadzone data dictionary with same keys as the device struct
    """
    LoadZone_dict = Dict{Int64,Any}()
    load_zones,b_count =rle(bus_raw[:,11])
    for (count,zone) in zip(b_count,load_zones)
        b_numbers = [bus_raw[b,1] for b in 1:nrow(bus_raw) if bus_raw[b,11] == zone ]
        buses = [make_bus(Buses[i]) for i in keys(Buses) if Buses[i]["number"] in  b_numbers]
        realpower = [bus_raw[b,5] for b in 1:nrow(bus_raw) if bus_raw[b,11] == zone]
        reactivepower = [bus_raw[b,6] for b in 1:nrow(bus_raw) if bus_raw[b,11] == zone]
        LoadZone_dict[zone] = Dict{String,Any}("number" => zone,
                                                        "name" => zone ,
                                                        "buses" => buses,
                                                        "maxrealpower" => sum(realpower),
                                                        "maxreactivepower" => sum(reactivepower)
                                                        )
    end
    return LoadZone_dict
end

# Remove missing values form dataframes
#TODO : Remove "NA" Strings from the data created by CSV.read()
function remove_missing(df)
    """
    Arg:
        Any DataFrame with Missing values / "NA" strings that are either created by readtable() or CSV.read()
    Returns:
        DataFrame with missing values replaced by 0
    """
    for col in names(df)
        df[ismissing.(df[col]), col] = 0
    end
    return df
end





