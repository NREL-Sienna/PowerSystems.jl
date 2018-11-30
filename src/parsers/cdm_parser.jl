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
    files = readdir(file_path)
    REGEX_DEVICE_TYPE = r"(.*?)\.csv"
    REGEX_IS_FOLDER = r"^[A-Za-z]+$"
    data =Dict{String,Any}()

    if length(files) == 0
        @error "No test files in the folder"
    end
    for d_file in files
        try
            if match(REGEX_IS_FOLDER, d_file) != nothing
                @info "Parsing csv files in $d_file ..."
                d_file_data = Dict{String,Any}()
                for file in readdir(joinpath(file_path,d_file))
                    if match(REGEX_DEVICE_TYPE, file) != nothing
                        @info "Parsing csv data in $file ..."
                        fpath = joinpath(file_path,d_file,file)
                        raw_data = CSV.File(fpath) |> DataFrame
                        d_file_data[split(file,r"[.]")[1]] = raw_data
                    end
                end

                if length(d_file_data) >0
                    data[d_file] = d_file_data
                    @info "Successfully parsed $d_file"
                end

            elseif match(REGEX_DEVICE_TYPE, d_file) != nothing
                @info "Parsing csv data in $d_file ..."
                fpath = joinpath(file_path,d_file)
                raw_data = CSV.File(fpath)|> DataFrame
                data[split(d_file,r"[.]")[1]] = raw_data
                @info "Successfully parsed $d_file"
            end
        catch
            @error "Error occurred while parsing $d_file"
            catch_stacktrace()
        end
    end

    if "timeseries_pointers" in keys(data)
        @info "parsing timeseries data"
        tsp_raw = data["timeseries_pointers"]
        data["timeseries_data"] = Dict()
        if :Simulation in names(tsp_raw)
            for sim in unique(tsp_raw[:Simulation])
                data["timeseries_data"][String(sim)] = Dict()
            end
        end

        for r in eachrow(tsp_raw)
            fpath = joinpath(file_path,r[Symbol("Data File")])
            if isfile(fpath)
                # read data and insert into dict
                @info "parsing timeseries data in $fpath for $(r.Object)"
                raw_data = CSV.File(fpath) |> DataFrame |> read_datetime

                if length([c for c in names(raw_data) if String(c) == String(r.Object)]) == 1
                    raw_data = TimeSeries.TimeArray(raw_data[:DateTime],raw_data[Symbol(r.Object)])
                end

                if :Simulation in names(tsp_raw)
                    data["timeseries_data"][String(r.Simulation)][String(r.Object)] = raw_data
                else
                    data["timeseries_data"][String(r.Object)] = raw_data
                end
            else
                @warn "File referenced in timeseries_pointers.csv doesn't exist : $fpath"
            end
        end
    end

    return data
end

function csv2ps_dict(data::Dict{String,Any})
    """
    Args:
        Dict with all the System data from CSV files ... see `read_csv_data()`'
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
    ps_dict =Dict{String,Any}()
    if haskey(data,"bus")
        ps_dict["bus"] =  PowerSystems.bus_csv_parser(data["bus"])
    else
        @error "Key error : key 'bus' not found in PowerSystems dictionary, cannot construct any PowerSystem Struct"
    end
    if haskey(data,"gen")
        ps_dict["gen"] =  PowerSystems.gen_csv_parser(data["gen"],ps_dict["bus"])
    else
        @warn "Key error : key 'gen' not found in PowerSystems dictionary, this will result in an ps_dict['gen'] = nothing"
         ps_dict["gen"] = nothing
    end
    if haskey(data,"branch")
        ps_dict["branch"] =  PowerSystems.branch_csv_parser(data["branch"],ps_dict["bus"])
    else
        @warn "Key error : key 'bus' not found in PowerSystems dictionary,
          \n This will result in an ps_dict['branch'] = nothing"
         ps_dict["branch"] = nothing
    end
    if haskey(data,"load")
        ps_dict["load_zone"] =  PowerSystems.loadzone_csv_parser(data["bus"],ps_dict["bus"])
        ps_dict["load"] =  PowerSystems.load_csv_parser(data["load"],data["bus"],ps_dict["bus"],ps_dict["load_zone"])
    else
        @warn "Key error : key 'load' not found in PowerSystems dictionary, this will result in an ps_dict['load'] = nothing"
         ps_dict["load"] = nothing
    end
    if haskey(data,"baseMVA")
        ps_dict["baseMVA"] = data["baseMVA"]
    else
        @warn "Key error : key 'baseMVA' not found in PowerSystems dictionary, this will result in a ps_dict['baseMVA'] = 100.0"
        ps_dict["baseMVA"] = 100.0
    end

    if haskey(data,"timeseries_data")
        gen_map = _retrieve(ps_dict["gen"],"name",Dict())
        if haskey(data["timeseries_data"],"DAY_AHEAD")
            @info "adding DAY-AHEAD generator forcasats"
            _add_nested_dict!(ps_dict,["forecast","DA","gen"],_format_fcdict(data["timeseries_data"]["DAY_AHEAD"],gen_map))
            @info "adding DAY-AHEAD load forcasats"
            ps_dict["forecast"]["DA"]["load"] = data["timeseries_data"]["DAY_AHEAD"]["Load"]
        end
        if haskey(data["timeseries_data"],"REAL_TIME")
            @info "adding REAL-TIME generator forcasats"
            _add_nested_dict!(ps_dict,["forecast","RT","gen"],_format_fcdict(data["timeseries_data"]["REAL_TIME"],gen_map))
            @info "adding REAL-TIME load forcasats"
            ps_dict["forecast"]["RT"]["load"] = data["timeseries_data"]["REAL_TIME"]["Load"]
        end
    end

    return ps_dict
end

function _add_nested_dict!(d,keylist,value = Dict())
    if !haskey(d,keylist[1])
        d[keylist[1]] = length(keylist)==1 ? value : Dict{String,Any}()
    end
    if length(keylist) > 1
        _add_nested_dict!(d[keylist[1]],keylist[2:end],value)
    end
end

function _format_fcdict(fc,obj_map)
    paths = Dict()
    for (k,d) in fc
        if haskey(obj_map, k)
            _add_nested_dict!(paths,obj_map[k],d)
        end
    end
    return paths
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
    ps_dict = csv2ps_dict(data)
    return ps_dict
end


###########
#Bus data parser
###########

function bus_csv_parser(bus_raw,colnames = nothing)
    """
    Args:
        A DataFrame with the same column names as in RTS_GMLC bus.csv file
        "Bus ID"	"Bus Name"	"BaseKV"	"Bus Type"	"MW Load"	"MVAR Load"	"V Mag"	"V Angle"	"MW Shunt G"	"MVAR Shunt B"	"Area"
    Returns:
        A Nested Dictionary with keys as Bus number and values as bus data dictionary with same keys as the device struct
    """

    if colnames isa Nothing
        need_cols = ["Bus ID", "Bus Name", "BaseKV", "Bus Type", "V Mag", "V Angle"]
        tbl_cols = string.(names(bus_raw))
        colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    Buses_dict = Dict{Int64,Any}()
    for i in 1:nrow(bus_raw)
        Buses_dict[bus_raw[i,1]] = Dict{String,Any}("number" =>bus_raw[i,colnames["Bus ID"]] ,
                                                "name" => bus_raw[i,colnames["Bus Name"]],
                                                "bustype" => bus_raw[i,colnames["Bus Type"]],
                                                "angle" => bus_raw[i,colnames["V Angle"]],
                                                "voltage" => bus_raw[i,colnames["V Mag"]],
                                                "voltagelimits" => (min=0.95,max=1.05),
                                                "basevoltage" => bus_raw[i,colnames["BaseKV"]]
                                                )
    end
    return Buses_dict
end


###########
#Generator data parser
###########

function gen_csv_parser(gen_raw::DataFrames.DataFrame, Buses::Dict{Int64,Any},colnames = nothing)
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

    if colnames isa Nothing
        need_cols = ["GEN UID", "Bus ID", "Fuel", "Unit Type",
                    "MW Inj", "MVAR Inj", "PMax MW", "PMin MW", "QMax MVAR", "QMin MVAR", 
                    "Min Down Time Hr", "Min Up Time Hr", "Ramp Rate MW/Min",  
                    "Start Heat Cold MBTU", "Non Fuel Start Cost \$", "Non Fuel Shutdown Cost \$", "Fuel Price \$/MMBTU", 
                    "Output_pct_0", "Output_pct_1", "Output_pct_2", "Output_pct_3", "Output_pct_4", "HR_avg_0", "HR_incr_1", "HR_incr_2", "HR_incr_3", "HR_incr_4", 
                    "Base MVA"]
        tbl_cols = string.(names(gen_raw))
        colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    cost_colnames = []
    for i in 0:length([n for n in names(gen_raw) if occursin("Output_pct_",String(n))])-1
        hr = [n for n in names(gen_raw) if !isa(match(Regex("HR_.*_$i"),String(n)),Nothing)][1]
        mw = Symbol("Output_pct_$i")
        push!(cost_colnames, (mw,hr))
    end

    for gen in 1:nrow(gen_raw)
        pmax = tryparse(Float64,"""$(gen_raw[gen,colnames["PMax MW"]])""")

        if gen_raw[gen,colnames["Fuel"]] in ["Oil","Coal","NG","Nuclear"]

            fuel_cost = gen_raw[gen,colnames["Fuel Price \$/MMBTU"]]./1000

            var_cost = [(tryparse(Float64,"$(gen_raw[gen,cn[1]])"), tryparse(Float64,"$(gen_raw[gen,cn[2]])")) for cn in cost_colnames]
            var_cost = [(c[1],c[1]*c[2]*fuel_cost).*pmax for c in var_cost if !in(nothing,c)]
            var_cost[2:end] = [(var_cost[i][1],var_cost[i-1][2]+var_cost[i][2]) for i in 2:length(var_cost)]

            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,colnames["Bus ID"]]]
            Generators_dict["Thermal"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                            "available" => true,
                                            "bus" => make_bus(bus_id[1]),
                                            "tech" => Dict{String,Any}("activepower" => gen_raw[gen,colnames["MW Inj"]],
                                                                        "activepowerlimits" => (min=tryparse(Float64,"""$(gen_raw[gen,colnames["PMin MW"]])"""),max=pmax),
                                                                        "reactivepower" => tryparse(Float64,"""$(gen_raw[gen,colnames["MVAR Inj"]])"""),
                                                                        "reactivepowerlimits" => (min=tryparse(Float64,"""$(gen_raw[gen,colnames["QMin MVAR"]])"""),max=tryparse(Float64,"""$(gen_raw[gen,colnames["QMax MVAR"]])""")),
                                                                        "ramplimits" => (up=gen_raw[gen,colnames["Ramp Rate MW/Min"]],down=gen_raw[gen,colnames["Ramp Rate MW/Min"]]),
                                                                        "timelimits" => (up=gen_raw[gen,colnames["Min Up Time Hr"]],down=gen_raw[gen,colnames["Min Down Time Hr"]])),
                                            "econ" => Dict{String,Any}("capacity" => pmax,
                                                                        "variablecost" => var_cost,
                                                                        "fixedcost" => 0.0,
                                                                        "startupcost" => gen_raw[gen,colnames["Start Heat Cold MBTU"]]*fuel_cost,
                                                                        "shutdncost" => 0.0,
                                                                        "annualcapacityfactor" => nothing)
                                            )

        elseif gen_raw[gen,colnames["Fuel"]] in ["Hydro"]
            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,colnames["Bus ID"]]]
            Generators_dict["Hydro"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                            "available" => true, # change from staus to available
                                            "bus" => make_bus(bus_id[1]),
                                            "tech" => Dict{String,Any}( "installedcapacity" => pmax,
                                                                        "activepower" => gen_raw[gen,colnames["MW Inj"]],
                                                                        "activepowerlimits" => (min=tryparse(Float64,"""$(gen_raw[gen,colnames["PMin MW"]])"""),max=pmax),
                                                                        "reactivepower" => gen_raw[gen,colnames["MVAR Inj"]],
                                                                        "reactivepowerlimits" => (min=tryparse(Float64,"""$(gen_raw[gen,colnames["QMin MVAR"]])"""),max=tryparse(Float64,"""$(gen_raw[gen,colnames["QMax MVAR"]])""")),
                                                                        "ramplimits" => (up=gen_raw[gen,colnames["Ramp Rate MW/Min"]],down=gen_raw[gen,colnames["Ramp Rate MW/Min"]]),
                                                                        "timelimits" => (up=gen_raw[gen,colnames["Min Down Time Hr"]],down=gen_raw[gen,colnames["Min Down Time Hr"]])),
                                            "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                        "interruptioncost" => nothing),
                                            "scalingfactor" => TimeArray(collect(DateTime(today()):Hour(1):DateTime(today()+Day(1))), ones(25)) # TODO: connect scaling factors
                                            )

        elseif gen_raw[gen,colnames["Fuel"]] in ["Solar","Wind"]
            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,colnames["Bus ID"]]]
            if gen_raw[gen,colnames["Unit Type"]] == "PV"
                Generators_dict["Renewable"]["PV"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                                "available" => true, # change from staus to available
                                                "bus" => make_bus(bus_id[1]),
                                                "tech" => Dict{String,Any}("installedcapacity" => pmax,
                                                                            "reactivepowerlimits" => (min=tryparse(Float64,"""$(gen_raw[gen,colnames["QMin MVAR"]])"""),max=tryparse(Float64,"""$(gen_raw[gen,colnames["QMax MVAR"]])""")),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing),
                                                "scalingfactor" => TimeArray(collect(DateTime(today()):Hour(1):DateTime(today()+Day(1))), ones(25)) # TODO: connect scaling factors
                                                )
            elseif gen_raw[gen,colnames["Unit Type"]] == "RTPV"
                Generators_dict["Renewable"]["RTPV"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                                "available" => true, # change from staus to available
                                                "bus" => make_bus(bus_id[1]),
                                                "tech" => Dict{String,Any}("installedcapacity" => pmax,
                                                                            "reactivepowerlimits" => (min=tryparse(Float64,"""$(gen_raw[gen,colnames["QMin MVAR"]])"""),max=tryparse(Float64,"""$(gen_raw[gen,colnames["QMax MVAR"]])""")),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing),
                                                "scalingfactor" => TimeArray(collect(DateTime(today()):Hour(1):DateTime(today()+Day(1))), ones(25)) # TODO: Connect scaling factors
                                                )
            elseif gen_raw[gen,colnames["Unit Type"]] == "WIND"
                Generators_dict["Renewable"]["WIND"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                                "available" => true, # change from staus to available
                                                "bus" => make_bus(bus_id[1]),
                                                "tech" => Dict{String,Any}("installedcapacity" => pmax,
                                                                            "reactivepowerlimits" => (min=tryparse(Float64,"""$(gen_raw[gen,colnames["QMin MVAR"]])"""),max=tryparse(Float64,"""$(gen_raw[gen,colnames["QMax MVAR"]])""")),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing),
                                                "scalingfactor" => TimeArray(collect(DateTime(today()):Hour(1):DateTime(today()+Day(1))), ones(25)) # TODO: connect scaling factors
                                                )
            end
        elseif gen_raw[gen,colnames["Fuel"]] in ["Storage"]
            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,colnames["Bus ID"]]]
            Generators_dict["Storage"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                            "available" => true, # change from staus to available
                                            "bus" => make_bus(bus_id[1]),
                                            "energy" => 0.0,
                                            "capacity" => (min=tryparse(Float64,"""$(gen_raw[gen,colnames["PMin MW"]])"""),max=pmax),
                                            "activepower" => gen_raw[gen,colnames["MW Inj"]],
                                            "inputactivepowerlimits" => (min=0.0,max=pmax),
                                            "outputactivepowerlimits" => (min=0.0,max=pmax),
                                            "efficiency" => (in= 0.0, out = 0.0),
                                            "reactivepower" => gen_raw[gen,colnames["MVAR Inj"]],
                                            "reactivepowerlimits" => (min = 0.0, max = 0.0),
                                            )
        end
    end
    return Generators_dict
end

###########
#Branch data parser
###########

function branch_csv_parser(branch_raw,Buses,colnames=nothing)
    """
    Args:
        A DataFrame with the same column names as in RTS_GMLC branch.csv file
        Parsed Bus PowerSystems dictionary
    Returns:
        A Nested Dictionary with keys as branch types/names and values as line/transformer data dictionary with same keys as the device struct

    """

    if colnames isa Nothing
        need_cols = ["From Bus", "To Bus", "Tr Ratio", "Cont Rating"]
        tbl_cols = string.(names(branch_raw))
        colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    Branches_dict = Dict{String,Any}()
    Branches_dict["Transformers"] = Dict{String,Any}()
    Branches_dict["Lines"] = Dict{String,Any}()
    for i in 1:length(branch_raw)
        bus_f = [Buses[f] for f in keys(Buses) if Buses[f]["number"] == branch_raw[i,Symbol("From Bus")]]
        bus_t = [Buses[t] for t in keys(Buses) if Buses[t]["number"] == branch_raw[i,Symbol("To Bus")]]
        if branch_raw[i,Symbol("Tr Ratio")] > 0.0
            Branches_dict["Transformers"][branch_raw[i,:UID]] = Dict{String,Any}("name" => branch_raw[i,:UID],
                                                        "available" => true,
                                                        "connectionpoints" => (from=make_bus(bus_f[1]),to=make_bus(bus_t[1])),
                                                        "r" => branch_raw[i,:R],
                                                        "x" => branch_raw[i,:X],
                                                        "primaryshunt" => branch_raw[i,:B] ,  #TODO: add field in CSV
                                                        "alpha" => (branch_raw[i,:B]/2) - (branch_raw[i,:B]/2), #TODO: Phase-Shifting Transformer angle
                                                        "tap" => branch_raw[i,Symbol("Tr Ratio")],
                                                        "rate" => branch_raw[i,Symbol("Cont Rating")],
                                                        )
        else
            Branches_dict["Lines"][branch_raw[i,:UID]] = Dict{String,Any}("name" => branch_raw[i,:UID],
                                                        "available" => true,
                                                        "connectionpoints" => (from=make_bus(bus_f[1]),to=make_bus(bus_t[1])),
                                                        "r" => branch_raw[i,:R],
                                                        "x" => branch_raw[i,:X],
                                                        "b" => (from=(branch_raw[i,:B]/2),to=(branch_raw[i,:B]/2)),
                                                        "rate" =>  branch_raw[i,Symbol("Cont Rating")],
                                                        "anglelimits" => (min=-60.0,max =60.0) #TODO: add field in CSV
                                                        )

        end
    end
    return Branches_dict
end


###########
#Load data parser
###########

function load_csv_parser(load_raw,bus_raw,Buses,LoadZone,load_colnames=nothing,bus_colnames=nothing)
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

    if bus_colnames isa Nothing
        need_cols = ["MW Load", "MVAR Load", "Bus ID"]
        tbl_cols = string.(names(bus_raw))
        bus_colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    if load_colnames isa Nothing
        need_cols = ["DateTime",]
        tbl_cols = string.(names(load_raw))
        load_colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    for (k_b,b) in Buses
        for (k_l,l)  in LoadZone
            bus_numbers = [b.number for b in l["buses"] ]
            if b["number"] in bus_numbers
                load_zone = k_l
            end
        end
        p = [bus_raw[n,bus_colnames["MW Load"]] for n in 1:nrow(bus_raw) if bus_raw[n,bus_colnames["Bus ID"]] == b["number"]]
        q = [bus_raw[m,bus_colnames["MVAR Load"]] for m in 1:nrow(bus_raw) if bus_raw[m,bus_colnames["Bus ID"]] == b["number"]]
        ts_raw =load_raw[load_zone]*(p[1]/LoadZone[load_zone]["maxactivepower"])
        Loads_dict[b["name"]] = Dict{String,Any}("name" => b["name"],
                                            "available" => true,
                                            "bus" => make_bus(b),
                                            "model" => "P",
                                            "maxactivepower" => p[1],
                                            "maxreactivepower" => q[1],
                                            "scalingfactor" => TimeSeries.TimeArray(load_raw[ :DateTime],ts_raw) #TODO remove TS
                                            )
    end
    return Loads_dict
end

###########
#LoadZone data parser
###########

function loadzone_csv_parser(bus_raw,Buses,colnames=nothing)
    """
    Args:
        A DataFrame with the same column names as in RTS_GMLC bus.csv file
        Parsed Bus PowerSystems dictionary
    Returns:
        A Nested Dictionary with keys as loadzone names and values as loadzone data dictionary with same keys as the device struct
    """
    if colnames isa Nothing
        need_cols = ["MW Load", "MVAR Load", "Bus ID", "Area"]
        tbl_cols = string.(names(bus_raw))
        colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    LoadZone_dict = Dict{Int64,Any}()
    lbs = zip(unique(bus_raw[colnames["Area"]]),[sum(bus_raw[colnames["Area"]].==a) for a in unique(bus_raw[colnames["Area"]])])
    for (zone,count) in lbs
        b_numbers = [bus_raw[b,colnames["Bus ID"]] for b in 1:nrow(bus_raw) if bus_raw[b,colnames["Area"]] == zone ]
        buses = [make_bus(Buses[i]) for i in keys(Buses) if Buses[i]["number"] in  b_numbers]
        activepower = [bus_raw[b,colnames["MW Load"]] for b in 1:nrow(bus_raw) if bus_raw[b,colnames["Area"]] == zone]
        reactivepower = [bus_raw[b,colnames["MVAR Load"]] for b in 1:nrow(bus_raw) if bus_raw[b,colnames["Area"]] == zone]
        LoadZone_dict[zone] = Dict{String,Any}("number" => zone,
                                                        "name" => zone ,
                                                        "buses" => buses,
                                                        "maxactivepower" => sum(activepower),
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
