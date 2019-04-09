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
    Path to folder with all the System data CSV files

Returns:
    Nested Data dictionary with key values as folder/file names and dataframes
    as values

"""
function read_csv_data(file_path::String, baseMVA::Float64)
    files = readdir(file_path)
    REGEX_DEVICE_TYPE = r"(.*?)\.csv"
    REGEX_IS_FOLDER = r"^[A-Za-z]+$"
    data =Dict{String,Any}()

    if length(files) == 0
        error("No files in the folder")
    else
        data["baseMVA"] = baseMVA
    end

    encountered_files = 0
    for d_file in files
        try
            if match(REGEX_IS_FOLDER, d_file) != nothing
                @info "Parsing csv files in $d_file ..."
                d_file_data = Dict{String,Any}()
                for file in readdir(joinpath(file_path,d_file))
                    if match(REGEX_DEVICE_TYPE, file) != nothing
                        @info "Parsing csv data in $file ..."
                        encountered_files += 1
                        fpath = joinpath(file_path,d_file,file)
                        raw_data = CSV.File(fpath) |> DataFrames.DataFrame
                        d_file_data[split(file,r"[.]")[1]] = raw_data
                    end
                end

                if length(d_file_data) > 0
                    data[d_file] = d_file_data
                    @info "Successfully parsed $d_file"
                end

            elseif match(REGEX_DEVICE_TYPE, d_file) != nothing
                @info "Parsing csv data in $d_file ..."
                encountered_files += 1
                fpath = joinpath(file_path,d_file)
                raw_data = CSV.File(fpath)|> DataFrames.DataFrame
                data[split(d_file,r"[.]")[1]] = raw_data
                @info "Successfully parsed $d_file"
            end
        catch ex
            @error "Error occurred while parsing $d_file" exception=ex
        end
    end
    if encountered_files == 0 
        error("No csv files or folders in $file_path")
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
                #@info "parsing timeseries data in $fpath for $(String(r.Object))"
                param  = :Parameter in names(tsp_raw) ? r.Parameter : :scalingfactor
                raw_data = read_datetime(CSV.File(fpath) |> DataFrames.DataFrame, valuecolname = Symbol(r.Object))

                if length([c for c in names(raw_data) if String(c) == String(r.Object)]) == 1
                    raw_data = TimeSeries.TimeArray(raw_data[:DateTime],raw_data[Symbol(r.Object)],Symbol.([param]))
                end

                d = :Simulation in names(tsp_raw) ? data["timeseries_data"][String(r.Simulation)] : data["timeseries_data"] 
                d[String(r.Object)] = haskey(d,String(r.Object)) ? merge(d[String(r.Object)],raw_data) : raw_data
            else
                #@warn "File referenced in timeseries_pointers.csv doesn't exist : $fpath"
            end
        end
    end

    return data
end


"""
Args:
    Dict with all the System data from CSV files ... see `read_csv_data()`'
Returns:
    A Power Systems Nested dictionary with keys as devices and values as data
    dictionary necessary to construct the device structs
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
function csv2ps_dict(data::Dict{String,Any})
    ps_dict =Dict{String,Any}()

    if haskey(data,"baseMVA")
        ps_dict["baseMVA"] = data["baseMVA"]
    else
        @warn "Key error : key 'baseMVA' not found in PowerSystems dictionary, this will result in a ps_dict['baseMVA'] = 100.0"
        ps_dict["baseMVA"] = 100.0
    end

    if haskey(data,"bus")
        ps_dict["bus"] =  PowerSystems.bus_csv_parser(data["bus"])
        if :Area in names(data["bus"])
            ps_dict["loadzone"] =  PowerSystems.loadzone_csv_parser(data["bus"], ps_dict["bus"])
            ps_dict["load"] =  PowerSystems.load_csv_parser(data["bus"], ps_dict["bus"], ps_dict["loadzone"], ps_dict["baseMVA"], haskey(data,"load") ? data["load"] : nothing)
        else
            @warn "Missing Data : no 'Area' information for buses, cannot create loads based on areas" 
            ps_dict["load"] =  PowerSystems.load_csv_parser(data["bus"], ps_dict["bus"], ps_dict["baseMVA"], haskey(data,"load") ? data["load"] : nothing)
        end
    else
        error("Key error : key 'bus' not found in PowerSystems dictionary, cannot construct any PowerSystem Struct")
    end
    if haskey(data,"gen")
        ps_dict["gen"] =  PowerSystems.gen_csv_parser(data["gen"], ps_dict["bus"], ps_dict["baseMVA"])
    else
        @warn "Key error : key 'gen' not found in PowerSystems dictionary, this will result in an ps_dict['gen'] = nothing"
         ps_dict["gen"] = nothing
    end
    if haskey(data,"branch")
        ps_dict["branch"] =  PowerSystems.branch_csv_parser(data["branch"], ps_dict["bus"], ps_dict["baseMVA"])
    else
        @warn "Key error : key 'branch' not found in PowerSystems dictionary,
          \n This will result in an ps_dict['branch'] = nothing"
         ps_dict["branch"] = nothing
    end
    if haskey(data,"dc_branch")
        ps_dict["dcline"] =  PowerSystems.dc_branch_csv_parser(data["dc_branch"], ps_dict["bus"], ps_dict["baseMVA"])
    else
        @warn "Key error : key 'dc_branch' not found in PowerSystems dictionary,
          \n This will result in an ps_dict['dcline'] = nothing"
         ps_dict["dcline"] = nothing
    end
    if haskey(data,"reserves")
        ps_dict["services"] = PowerSystems.services_csv_parser(data["reserves"],data["gen"],data["bus"])
    else
        @warn "Key error : key 'reserves' not found in PowerSystems dictionary, this will result in a ps_dict['services'] =  nothing"
        ps_dict["services"] = nothing
    end

    if haskey(data,"timeseries_data")
        gen_map = _retrieve(ps_dict["gen"],"name",Dict(),[])
        device_map = _retrieve(ps_dict,"name",Dict(),[])

        if haskey(data["timeseries_data"],"DAY_AHEAD")
            @info "adding DAY-AHEAD generator forcasats"
            _add_nested_dict!(ps_dict,["forecasts","DA"],_format_fcdict(data["timeseries_data"]["DAY_AHEAD"],device_map))

            #_add_nested_dict!(ps_dict,["forecasts","DA","gen"],_format_fcdict(data["timeseries_data"]["DAY_AHEAD"],gen_map))
            @info "adding DAY-AHEAD load forcasats"
            ps_dict["forecasts"]["DA"]["load"] = data["timeseries_data"]["DAY_AHEAD"]["Load"]
        end
        if haskey(data["timeseries_data"],"REAL_TIME")
            @info "adding REAL-TIME generator forcasats"
            _add_nested_dict!(ps_dict,["forecasts","RT","gen"],_format_fcdict(data["timeseries_data"]["REAL_TIME"],gen_map))
            @info "adding REAL-TIME load forcasats"
            ps_dict["forecasts"]["RT"]["load"] = data["timeseries_data"]["REAL_TIME"]["Load"]
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


"""
Args:
    Path to folder with all the System data CSV's files
Returns:
    A Power Systems Nested dictionary with keys as devices and values as data
    dictionary necessary to construct the device structs
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
function csv2ps_dict(file_path::String, baseMVA::Float64)
    data =  read_csv_data(file_path, baseMVA)
    ps_dict = csv2ps_dict(data)
    return ps_dict
end


###########
#Bus data parser
###########


"""
Args:
    A DataFrame with the same column names as in RTS_GMLC bus.csv file

    "Bus ID" "Bus Name" "BaseKV" "Bus Type" "MW Load" "MVAR Load" "V Mag" "V
    Angle" "MW Shunt G" "MVAR Shunt B" "Area"

Returns:
    A Nested Dictionary with keys as Bus number and values as bus data
    dictionary with same keys as the device struct
"""
function bus_csv_parser(bus_raw::DataFrames.DataFrame,colnames = nothing)

    if colnames isa Nothing
        need_cols = ["Bus ID", "Bus Name", "BaseKV", "Bus Type", "V Mag", "V Angle"]
        tbl_cols = string.(names(bus_raw))
        colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    Buses_dict = Dict{Int64,Any}()
    for i in 1:DataFrames.nrow(bus_raw)
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

function _get_value_or_nothing(value::Union{Real, String})::Union{Float64, Nothing}
    if value == "NA"
        return nothing
    end

    return Float64(value)
end

###########
#Generator data parser
###########

"""
Args:
    A DataFrame with the same column names as in RTS_GMLC gen.csv file
    Parsed Bus PowerSystems dictionary
Returns:
    A Nested Dictionary with keys as generator types/names and values as
    generator data dictionary with same keys as the device struct
"""
function gen_csv_parser(gen_raw::DataFrames.DataFrame, Buses::Dict{Int64,Any}, baseMVA::Float64, colnames = nothing)
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
        push!(cost_colnames, (hr,mw))
    end

    pu_cols = ["PMin MW", "PMax MW", "MVAR Inj", "MW Inj", "QMin MVAR", "QMax MVAR", "Ramp Rate MW/Min"]
    [gen_raw[colnames[c]] = gen_raw[colnames[c]]./baseMVA for c in pu_cols] # P.U. conversion

    for gen in 1:DataFrames.nrow(gen_raw)
        pmax = _get_value_or_nothing(gen_raw[gen,colnames["PMax MW"]])

        if gen_raw[gen,colnames["Fuel"]] in ["Oil","Coal","NG","Nuclear"]

            fuel_cost = gen_raw[gen,colnames["Fuel Price \$/MMBTU"]]./1000

            var_cost = [(_get_value_or_nothing(gen_raw[gen,cn[1]]), _get_value_or_nothing(gen_raw[gen,cn[2]])) for cn in cost_colnames]
            var_cost = [(c[1]*c[2]*fuel_cost*baseMVA, c[2]).*pmax for c in var_cost if !in(nothing,c)]
            var_cost[2:end] = [(var_cost[i-1][1]+var_cost[i][1], var_cost[i][2]) for i in 2:length(var_cost)]

            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,colnames["Bus ID"]]]

            Generators_dict["Thermal"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                            "available" => true,
                                            "bus" => make_bus(bus_id[1]),
                                            "tech" => Dict{String,Any}("activepower" => gen_raw[gen,colnames["MW Inj"]],
                                                                        "activepowerlimits" => (min=_get_value_or_nothing(gen_raw[gen, colnames["PMin MW"]]), max=pmax),
                                                                        "reactivepower" => _get_value_or_nothing(gen_raw[gen, colnames["MVAR Inj"]]),
                                                                        "reactivepowerlimits" => (min=_get_value_or_nothing(gen_raw[gen, colnames["QMin MVAR"]]), max=_get_value_or_nothing(gen_raw[gen, colnames["QMax MVAR"]])),
                                                                        "ramplimits" => (up=gen_raw[gen,colnames["Ramp Rate MW/Min"]], down=gen_raw[gen, colnames["Ramp Rate MW/Min"]]),
                                                                        "timelimits" => (up=gen_raw[gen,colnames["Min Up Time Hr"]], down=gen_raw[gen, colnames["Min Down Time Hr"]])),
                                            "econ" => Dict{String,Any}("capacity" => pmax,
                                                                        "variablecost" => var_cost,
                                                                        "fixedcost" => 0.0,
                                                                        "startupcost" => gen_raw[gen,colnames["Start Heat Cold MBTU"]]*fuel_cost*1000,
                                                                        "shutdncost" => 0.0,
                                                                        "annualcapacityfactor" => nothing)
                                            )

        elseif gen_raw[gen,colnames["Fuel"]] in ["Hydro"]
            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,colnames["Bus ID"]]]
            Generators_dict["Hydro"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                            "available" => true,
                                            "bus" => make_bus(bus_id[1]),
                                            "tech" => Dict{String,Any}( "installedcapacity" => pmax,
                                                                        "activepower" => gen_raw[gen, colnames["MW Inj"]],
                                                                        "activepowerlimits" => (min=_get_value_or_nothing(gen_raw[gen, colnames["PMin MW"]]), max=pmax),
                                                                        "reactivepower" => gen_raw[gen, colnames["MVAR Inj"]],
                                                                        "reactivepowerlimits" => (min=_get_value_or_nothing(gen_raw[gen, colnames["QMin MVAR"]]), max=_get_value_or_nothing(gen_raw[gen, colnames["QMax MVAR"]])),
                                                                        "ramplimits" => (up=gen_raw[gen, colnames["Ramp Rate MW/Min"]], down=gen_raw[gen, colnames["Ramp Rate MW/Min"]]),
                                                                        "timelimits" => (up=gen_raw[gen, colnames["Min Down Time Hr"]], down=gen_raw[gen, colnames["Min Down Time Hr"]])),
                                            "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                        "interruptioncost" => nothing)
                                                )

        elseif gen_raw[gen,colnames["Fuel"]] in ["Solar","Wind"]
            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,colnames["Bus ID"]]]
            if gen_raw[gen,colnames["Unit Type"]] == "PV"
                Generators_dict["Renewable"]["PV"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                                "available" => true,
                                                "bus" => make_bus(bus_id[1]),
                                                "tech" => Dict{String, Any}("installedcapacity" => pmax,
                                                                            "reactivepowerlimits" => (min=_get_value_or_nothing(gen_raw[gen, colnames["QMin MVAR"]]), max=_get_value_or_nothing(gen_raw[gen, colnames["QMax MVAR"]])),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing)
                                                )
            elseif gen_raw[gen,colnames["Unit Type"]] == "RTPV"
                Generators_dict["Renewable"]["RTPV"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                                "available" => true,
                                                "bus" => make_bus(bus_id[1]),
                                                "tech" => Dict{String, Any}("installedcapacity" => pmax,
                                                                            "reactivepowerlimits" => (min=_get_value_or_nothing(gen_raw[gen, colnames["QMin MVAR"]]), max=_get_value_or_nothing(gen_raw[gen, colnames["QMax MVAR"]])),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing)
                                                )
            elseif gen_raw[gen,colnames["Unit Type"]] == "WIND"
                Generators_dict["Renewable"]["WIND"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                                "available" => true,
                                                "bus" => make_bus(bus_id[1]),
                                                "tech" => Dict{String, Any}("installedcapacity" => pmax,
                                                                            "reactivepowerlimits" => (min=_get_value_or_nothing(gen_raw[gen, colnames["QMin MVAR"]]), max=_get_value_or_nothing(gen_raw[gen, colnames["QMax MVAR"]])),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing)
                                                )
            end
        elseif gen_raw[gen,colnames["Fuel"]] in ["Storage"]
            bus_id =[Buses[i] for i in keys(Buses) if Buses[i]["number"] == gen_raw[gen,colnames["Bus ID"]]]
            Generators_dict["Storage"][gen_raw[gen,colnames["GEN UID"]]] = Dict{String,Any}("name" => gen_raw[gen,colnames["GEN UID"]],
                                            "available" => true,
                                            "bus" => make_bus(bus_id[1]),
                                            "energy" => 0.0,
                                            "capacity" => (min=_get_value_or_nothing(gen_raw[gen,colnames["PMin MW"]]),max=pmax),
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

"""
Args:
    A DataFrame with the same column names as in RTS_GMLC branch.csv file
    Parsed Bus PowerSystems dictionary
Returns:
    A Nested Dictionary with keys as branch types/names and values as
    line/transformer data dictionary with same keys as the device struct
"""
function branch_csv_parser(branch_raw::DataFrames.DataFrame, Buses::Dict, baseMVA::Float64, colnames=nothing)

    if colnames isa Nothing
        need_cols = ["From Bus", "To Bus", "Tr Ratio", "Cont Rating","UID","R","X","B"]
        tbl_cols = string.(names(branch_raw))
        colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    pu_cols = ["Cont Rating"]
    [branch_raw[colnames[c]] = branch_raw[colnames[c]]./baseMVA for c in pu_cols] # P.U. conversion

    Branches_dict = Dict{String,Any}()
    Branches_dict["Transformers"] = Dict{String,Any}()
    Branches_dict["Lines"] = Dict{String,Any}()
    for i in 1:DataFrames.nrow(branch_raw)
        bus_f = [Buses[f] for f in keys(Buses) if Buses[f]["number"] == branch_raw[i,colnames["From Bus"]]]
        bus_t = [Buses[t] for t in keys(Buses) if Buses[t]["number"] == branch_raw[i,colnames["To Bus"]]]
        if branch_raw[i,Symbol("Tr Ratio")] > 0.0
            Branches_dict["Transformers"][branch_raw[i,colnames["UID"]]] = Dict{String,Any}("name" => branch_raw[i,colnames["UID"]],
                                                        "available" => true,
                                                        "connectionpoints" => (from=make_bus(bus_f[1]),to=make_bus(bus_t[1])),
                                                        "r" => branch_raw[i,colnames["R"]],
                                                        "x" => branch_raw[i,colnames["X"]],
                                                        "primaryshunt" => branch_raw[i,colnames["B"]] ,  #TODO: add field in CSV
                                                        "alpha" => (branch_raw[i,colnames["B"]]/2) - (branch_raw[i,colnames["B"]]/2), #TODO: Phase-Shifting Transformer angle
                                                        "tap" => branch_raw[i,colnames["Tr Ratio"]],
                                                        "rate" => branch_raw[i,colnames["Cont Rating"]],
                                                        )
        else
            Branches_dict["Lines"][branch_raw[i,:UID]] = Dict{String,Any}("name" => branch_raw[i,:UID],
                                                        "available" => true,
                                                        "connectionpoints" => (from=make_bus(bus_f[1]),to=make_bus(bus_t[1])),
                                                        "r" => branch_raw[i,colnames["R"]],
                                                        "x" => branch_raw[i,colnames["X"]],
                                                        "b" => (from=(branch_raw[i,colnames["B"]]/2),to=(branch_raw[i,colnames["B"]]/2)),
                                                        "rate" =>  branch_raw[i,colnames["Cont Rating"]],
                                                        "anglelimits" => (min=-60.0,max =60.0) #TODO: add field in CSV
                                                        )

        end
    end
    return Branches_dict
end


###########
#DC Branch data parser
###########

"""
Args:
    A DataFrame with the same column names as in RTS_GMLC dc_branch.csv file
    Parsed Bus PowerSystems dictionary
Returns:
    A Nested Dictionary with keys as dc_branch types/names and values as
    dc_branch data dictionary with same keys as the device struct
"""
function dc_branch_csv_parser(dc_branch_raw::DataFrames.DataFrame, Buses::Dict, baseMVA::Float64, colnames=nothing)

    if colnames isa Nothing
        need_cols = ["UID","From Bus", "To Bus", "Control Mode", "Margin", "From X Commutating", "From Tap Min", "From Tap Max","From Min Firing Angle","From Max Firing Angle", "To X Commutating", "To Tap Min", "To Tap Max","To Min Firing Angle","To Max Firing Angle", "MW Load"]
        tbl_cols = string.(names(dc_branch_raw))
        colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols if c in tbl_cols]))
    end

    pu_cols = ["MW Load"]
    [dc_branch_raw[colnames[c]] = dc_branch_raw[colnames[c]]./baseMVA for c in pu_cols] # P.U. conversion

    DCBranches_dict = Dict{String,Any}()
    DCBranches_dict["HVDCLine"] = Dict{String,Any}()
    DCBranches_dict["VSCDCLine"] = Dict{String,Any}()

    for i in 1:DataFrames.nrow(dc_branch_raw)
        bus_f = [Buses[f] for f in keys(Buses) if Buses[f]["number"] == dc_branch_raw[i,colnames["From Bus"]]]
        bus_t = [Buses[t] for t in keys(Buses) if Buses[t]["number"] == dc_branch_raw[i,colnames["To Bus"]]]
        if dc_branch_raw[i,colnames["Control Mode"]] != "Power"
            DCBranches_dict["VSCDCLine"][dc_branch_raw[i,colnames["UID"]]] = Dict{String,Any}("name" => dc_branch_raw[i,colnames["UID"]],
                                                        "available" => true,
                                                        "connectionpoints" => (from=make_bus(bus_f[1]),to=make_bus(bus_t[1])),
                                                        "rectifier_taplimits" => (min=dc_branch_raw[i,colnames["From Tap Min"]],max=dc_branch_raw[i,colnames["From Tap Max"]]),
                                                        "rectifier_xrc" => dc_branch_raw[i,colnames["From X Commutating"]], #TODO: What is this?
                                                        "rectifier_firingangle" => (min=dc_branch_raw[i,colnames["From Min Firing Angle"]],max=dc_branch_raw[i,colnames["From Max Firing Angle"]]),
                                                        "inverter_taplimits" => (min=dc_branch_raw[i,colnames["To Tap Min"]],max=dc_branch_raw[i,colnames["To Tap Max"]]),
                                                        "inverter_xrc" => dc_branch_raw[i,colnames["To X Commutating"]],  #TODO: What is this?
                                                        "inverter_firingangle" => (min=dc_branch_raw[i,colnames["To Min Firing Angle"]],max=dc_branch_raw[i,colnames["To Max Firing Angle"]])
                                                        )
        else
            DCBranches_dict["HVDCLine"][dc_branch_raw[i,colnames["UID"]]] = Dict{String,Any}("name" => dc_branch_raw[i,colnames["UID"]],
                                                        "available" => true,
                                                        "connectionpoints" => (from=make_bus(bus_f[1]),to=make_bus(bus_t[1])),
                                                        "activepowerlimits_from" => (min=-1*dc_branch_raw[i,colnames["MW Load"]], max=dc_branch_raw[i,colnames["MW Load"]]), #TODO: is there a better way to calculate this?
                                                        "activepowerlimits_to" => (min=-1*dc_branch_raw[i,colnames["MW Load"]], max=dc_branch_raw[i,colnames["MW Load"]]), #TODO: is there a better way to calculate this?
                                                        "reactivepowerlimits_from" => (min=0.0, max=0.0), #TODO: is there a better way to calculate this?
                                                        "reactivepowerlimits_to" => (min=0.0, max=0.0), #TODO: is there a better way to calculate this?
                                                        "loss" => (l0=0.0, l1=dc_branch_raw[i,colnames["Margin"]]) #TODO: Can we infer this from the other data?
                                                        )

        end
    end
    return DCBranches_dict
end


###########
#Load data parser
###########

"""
Args:
    A DataFrame with the same column names as in RTS_GMLC bus.csv file
    Parsed Bus entry of PowerSystems dictionary
    Parsed LoadZone entry of PowerSystems dictionary
Optional Args:
    DataFrame of LoadZone timeseries data
    Dict of bus column names
    Dict of load LoadZone timeseries column names
Returns:
    A Nested Dictionary with keys as load names and values as load data
    dictionary with same keys as the device struct
"""
function load_csv_parser(bus_raw::DataFrames.DataFrame, Buses::Dict, LoadZone::Dict, baseMVA::Float64, load_raw=nothing,bus_colnames=nothing,load_colnames=nothing)
    Loads_dict = Dict{String,Any}()
    load_zone = nothing

    if bus_colnames isa Nothing
        need_cols = ["MW Load", "MVAR Load", "Bus ID"]
        tbl_cols = string.(names(bus_raw))
        bus_colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    if !isa(load_raw,Nothing)
        load_raw = read_datetime(load_raw)
        if load_colnames isa Nothing
            need_cols = ["DateTime",]
            tbl_cols = string.(names(load_raw))
            load_colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
        end
    end

    pu_cols = ["MW Load", "MVAR Load"]
    [bus_raw[bus_colnames[c]] = bus_raw[bus_colnames[c]]./baseMVA for c in pu_cols] # P.U. conversion

    for (k_b,b) in Buses
        for (k_l,l)  in LoadZone
            bus_numbers = [b.number for b in l["buses"] ]
            if b["number"] in bus_numbers
                load_zone = k_l
            end
        end
        p = [bus_raw[n,bus_colnames["MW Load"]] for n in 1:DataFrames.nrow(bus_raw) if bus_raw[n,bus_colnames["Bus ID"]] == b["number"]]
        q = [bus_raw[m,bus_colnames["MVAR Load"]] for m in 1:DataFrames.nrow(bus_raw) if bus_raw[m,bus_colnames["Bus ID"]] == b["number"]]
        Loads_dict[b["name"]] = Dict{String,Any}("name" => b["name"],
                                            "available" => true,
                                            "bus" => make_bus(b),
                                            "maxactivepower" => p[1],
                                            "maxreactivepower" => q[1])
    end
    return Loads_dict
end


"""
Args:
    A DataFrame with the same column names as in RTS_GMLC bus.csv file
    Parsed Bus entry of PowerSystems dictionary
Optional Args:
    DataFrame of LoadZone timeseries data
    Dict of bus column names
    Dict of load LoadZone timeseries column names
Returns:
    A Nested Dictionary with keys as load names and values as load data
    dictionary with same keys as the device struct
"""
function load_csv_parser(bus_raw::DataFrames.DataFrame, Buses::Dict, baseMVA::Float64, load_raw=nothing, bus_colnames=nothing, load_colnames=nothing)
    Loads_dict = Dict{String,Any}()
    load_zone = nothing

    if bus_colnames isa Nothing
        need_cols = ["MW Load", "MVAR Load", "Bus ID"]
        tbl_cols = string.(names(bus_raw))
        bus_colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    if !isa(load_raw,nothing)
        load_raw = read_datetime(load_raw)
        if load_colnames isa Nothing
            need_cols = ["DateTime"]
            tbl_cols = string.(names(load_raw))
            load_colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
        end
    end

    pu_cols = ["MW Load", "MVAR Load"]
    [bus_raw[colnames[c]] = bus_raw[colnames[c]]./baseMVA for c in pu_cols] # P.U. conversion

    for (k_b,b) in Buses
        p = [bus_raw[n,bus_colnames["MW Load"]] for n in 1:DataFrames.nrow(bus_raw) if bus_raw[n,bus_colnames["Bus ID"]] == b["number"]]
        q = [bus_raw[m,bus_colnames["MVAR Load"]] for m in 1:DataFrames.nrow(bus_raw) if bus_raw[m,bus_colnames["Bus ID"]] == b["number"]]
        Loads_dict[b["name"]] = Dict{String,Any}("name" => b["name"],
                                            "available" => true,
                                            "bus" => make_bus(b),
                                            "maxactivepower" => p[1],
                                            "maxreactivepower" => q[1])
    end
    return Loads_dict
end

###########
#LoadZone data parser
###########

"""
Args:
    A DataFrame with the same column names as in RTS_GMLC bus.csv file
    Parsed Bus PowerSystems dictionary
Returns:
    A Nested Dictionary with keys as loadzone names and values as loadzone data
    dictionary with same keys as the device struct
"""
function loadzone_csv_parser(bus_raw::DataFrames.DataFrame, Buses::Dict, colnames=nothing)
    if colnames isa Nothing
        need_cols = ["MW Load", "MVAR Load", "Bus ID", "Area"]
        tbl_cols = string.(names(bus_raw))
        colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    LoadZone_dict = Dict{Int64,Any}()
    lbs = zip(unique(bus_raw[colnames["Area"]]),[sum(bus_raw[colnames["Area"]].==a) for a in unique(bus_raw[colnames["Area"]])])
    for (zone,count) in lbs
        b_numbers = [bus_raw[b,colnames["Bus ID"]] for b in 1:DataFrames.nrow(bus_raw) if bus_raw[b,colnames["Area"]] == zone ]
        buses = [make_bus(Buses[i]) for i in keys(Buses) if Buses[i]["number"] in  b_numbers]
        activepower = [bus_raw[b,colnames["MW Load"]] for b in 1:DataFrames.nrow(bus_raw) if bus_raw[b,colnames["Area"]] == zone]
        reactivepower = [bus_raw[b,colnames["MVAR Load"]] for b in 1:DataFrames.nrow(bus_raw) if bus_raw[b,colnames["Area"]] == zone]
        LoadZone_dict[zone] = Dict{String,Any}("number" => zone,
                                                        "name" => zone ,
                                                        "buses" => buses,
                                                        "maxactivepower" => sum(activepower),
                                                        "maxreactivepower" => sum(reactivepower)
                                                        )
    end
    return LoadZone_dict
end


###########
#reserves data parser
###########

"""
Args:
    A DataFrame with the same column names as in RTS_GMLC reserves.csv file
    A DataFrame with the same column names as in RTS_GMLC gen.csv file
    A DataFrame with the same column names as in RTS_GMLC bus.csv file
Returns:
    A Nested Dictionary with keys as loadzone names and values as loadzone data
    dictionary with same keys as the device struct
"""
function services_csv_parser(rsv_raw::DataFrames.DataFrame,gen_raw::DataFrames.DataFrame,bus_raw::DataFrames.DataFrame,colnames=nothing, gen_colnames = nothing,bus_colnames = nothing)
    if colnames isa Nothing
        need_cols = ["Reserve Product", "Timeframe (sec)", "Eligible Regions", "Eligible Gen Categories"]
        tbl_cols = string.(names(rsv_raw))
        colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    if gen_colnames isa Nothing
        need_cols = ["GEN UID", "Bus ID", "Category"]
        tbl_cols = string.(names(gen_raw))
        gen_colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end

    if bus_colnames isa Nothing
        need_cols = ["Bus ID", "Area"]
        tbl_cols = string.(names(bus_raw))
        bus_colnames = Dict(zip(need_cols,[findall(tbl_cols.==c)[1] for c in need_cols]))
    end
    
    services_dict = Dict{String,Any}()
    for r in 1:DataFrames.nrow(rsv_raw)
        gen_cats = strip(rsv_raw[r,colnames["Eligible Gen Categories"]],[i for i in "()"]) |> (x->split(x, ","))
        regions = strip(rsv_raw[r,colnames["Eligible Regions"]],[i for i in "()"]) |> (x->split(x,","))
        contributingdevices = []
        [push!(contributingdevices,gen_raw[g,gen_colnames["GEN UID"]]) for g in 1:DataFrames.nrow(gen_raw) if 
                    (gen_raw[g,gen_colnames["Category"]] in gen_cats) & 
                    (string(bus_raw[bus_raw[bus_colnames["Bus ID"]] .== gen_raw[g,gen_colnames["Bus ID"]],bus_colnames["Area"]][1]) in regions)];


        services_dict[rsv_raw[r,colnames["Reserve Product"]]] = Dict{String,Any}("name" => rsv_raw[r,colnames["Reserve Product"]],
                                                                "contributingdevices" => contributingdevices,
                                                                "timeframe" => rsv_raw[r,colnames["Timeframe (sec)"]])
    end


    return services_dict
end


# Remove missing values form dataframes
#TODO : Remove "NA" Strings from the data created by CSV.read()
"""
Arg:
    Any DataFrame with Missing values / "NA" strings that are either created by
    readtable() or CSV.read()
Returns:
    DataFrame with missing values replaced by 0
"""
function remove_missing(df)
    for col in names(df)
        df[ismissing.(df[col]), col] = 0
    end
    return df
end
