# - Parse Json_dict to Struct

function json2ps_struct(data::Dict{String,Any})
    """
    Takes a PowerSystems dictionary and return an array of PowerSystems struct for Bus, Generator, Branch and load
    """
    if haskey(data, "bus")
        Buses = bus_json_parse(data["bus"])
    else
        @error "Key error : key 'bus' not found in PowerSystems dictionary, this will result in an empty Bus array"
        Buses =[]
    end
    if haskey(data, "gen")
        Generators, Storage = gen_json_parser(data["gen"])
    else
        @error "Key error : key 'gen' not found in PowerSystems dictionary, this will result in an empty Generators and Storage array"
        Generators =[]
        Storage = []
    end
    if haskey(data, "branch")
        Branches = branch_json_parser(data["branch"])
    else
        @warn "Key error : key 'branch' not found in PowerSystems dictionary, this will result in an empty Branches array"
        Branches =[]
    end
    if haskey(data, "load")
        Loads = load_json_parser(data["load"])
    else
        @error "Key error : key 'load'  not found in PowerSystems dictionary, this will result in an empty Loads array"
        Loads =[]
    end
    return Buses, Generators, Storage, Branches, Loads
end

function bus_json_parse(dict::Dict{String,Any})
    Buses = Array{Bus}(undef, 0)
    for (bus_key,bus_dict) in dict
        push!(Buses,Bus(bus_dict["number"],
                                    bus_dict["name"],
                                    bus_dict["bustype"],
                                    bus_dict["angle"],
                                    bus_dict["voltage"],
                                    (min =bus_dict["voltagelimits"]["min"],max=bus_dict["voltagelimits"]["max"]),
                                    bus_dict["basevoltage"]
                                    ))
    end
    return Buses
end


function gen_json_parser(dict::Dict{String,Any})
    Generators = Array{Generator}(undef, 0)
    Storage_gen = Array{Storage}(undef, 0)
    for (gen_type_key,gen_type_dict) in dict
        if gen_type_key =="Thermal"
            for (thermal_key,thermal_dict) in gen_type_dict
                push!(Generators,ThermalStandard(thermal_dict["name"],
                                                            thermal_dict["available"],
                                                            Bus(thermal_dict["bus"]["number"],
                                                                            thermal_dict["bus"]["name"],
                                                                            thermal_dict["bus"]["bustype"],
                                                                            thermal_dict["bus"]["angle"],
                                                                            thermal_dict["bus"]["voltage"],
                                                                            (min =thermal_dict["bus"]["voltagelimits"]["min"],max=thermal_dict["bus"]["voltagelimits"]["max"]),
                                                                            thermal_dict["bus"]["basevoltage"] ),
                                                            TechThermal(thermal_dict["tech"]["activepower"],
                                                                        (min =thermal_dict["tech"]["activepowerlimits"]["min"],max =thermal_dict["tech"]["activepowerlimits"]["max"]),
                                                                        thermal_dict["tech"]["reactivepower"],
                                                                        (min =thermal_dict["tech"]["reactivepowerlimits"]["min"],max =thermal_dict["tech"]["reactivepowerlimits"]["min"]),
                                                                        (up=thermal_dict["tech"]["ramplimits"]["up"],down=thermal_dict["tech"]["ramplimits"]["down"]),
                                                                        (up=thermal_dict["tech"]["timelimits"]["up"],down=thermal_dict["tech"]["timelimits"]["down"])),
                                                            ThreePartCost(json_var_cost(thermal_dict["econ"]["variable"]),
                                                                          thermal_dict["econ"]["fixedcost"],
                                                                          thermal_dict["econ"]["startup"],
                                                                          thermal_dict["econ"]["shutdn"])
                            ))
            end
        elseif gen_type_key =="Hydro"
            for (hydro_key,hydro_dict) in gen_type_dict
                push!(Generators,HydroDispatch(hydro_dict["name"],
                                                            hydro_dict["available"],
                                                            Bus(hydro_dict["bus"]["number"],
                                                                            hydro_dict["bus"]["name"],
                                                                            hydro_dict["bus"]["bustype"],
                                                                            hydro_dict["bus"]["angle"],
                                                                            hydro_dict["bus"]["voltage"],
                                                                            (min =hydro_dict["bus"]["voltagelimits"]["min"],max=hydro_dict["bus"]["voltagelimits"]["max"]),
                                                                            hydro_dict["bus"]["basevoltage"] ),
                                                            TechHydro(  hydro_dict["tech"]["rating"],
                                                                        hydro_dict["tech"]["activepower"],
                                                                        (min =hydro_dict["tech"]["activepowerlimits"]["min"],max =hydro_dict["tech"]["activepowerlimits"]["max"]),
                                                                        hydro_dict["tech"]["reactivepower"],
                                                                        (min =hydro_dict["tech"]["reactivepowerlimits"]["min"],max =hydro_dict["tech"]["reactivepowerlimits"]["max"]),
                                                                        (up=hydro_dict["tech"]["ramplimits"]["up"],down=hydro_dict["tech"]["ramplimits"]["down"]),
                                                                        (up=hydro_dict["tech"]["timelimits"]["up"],down=hydro_dict["tech"]["timelimits"]["down"])),
                                                            hydro_dict["econ"]["curtailcost"],
                                                            dict_to_timearray(hydro_dict["scalingfactor"])
                            ))
            end
        elseif gen_type_key =="Renewable"
            for (ren_key,ren_dict) in  gen_type_dict
                if ren_key == "PV"
                    for (pv_key,pv_dict) in ren_dict
                        push!(Generators,RenewableDispatch(pv_dict["name"],
                                                                    pv_dict["available"],
                                                                    Bus(pv_dict["bus"]["number"],
                                                                            pv_dict["bus"]["name"],
                                                                            pv_dict["bus"]["bustype"],
                                                                            pv_dict["bus"]["angle"],
                                                                            pv_dict["bus"]["voltage"],
                                                                            (min =pv_dict["bus"]["voltagelimits"]["min"],max=pv_dict["bus"]["voltagelimits"]["max"]),
                                                                            pv_dict["bus"]["basevoltage"] ),
                                                                    pv_dict["tech"]["rating"],
                                                                    TwoPartCost(pv_dict["econ"]["curtailcost"],
                                                                                pv_dict["econ"]["interruptioncost"]),
                                                                    dict_to_timearray(pv_dict["scalingfactor"])
                                    ))
                    end
                elseif ren_key == "RTPV"
                    for (rtpv_key,rtpv_dict) in ren_dict
                        push!(Generators,RenewableFix(rtpv_dict["name"],
                                                                    rtpv_dict["available"],
                                                                    Bus(rtpv_dict["bus"]["number"],
                                                                            rtpv_dict["bus"]["name"],
                                                                            rtpv_dict["bus"]["bustype"],
                                                                            rtpv_dict["bus"]["angle"],
                                                                            rtpv_dict["bus"]["voltage"],
                                                                            (min =rtpv_dict["bus"]["voltagelimits"]["min"],max=rtpv_dict["bus"]["voltagelimits"]["max"]),
                                                                            rtpv_dict["bus"]["basevoltage"] ),
                                                                    rtpv_dict["tech"]["rating"],
                                                                    dict_to_timearray(rtpv_dict["scalingfactor"])
                                    ))
                    end
                elseif ren_key == "WIND"
                    for (wind_key,wind_dict) in ren_dict
                        push!(Generators,RenewableDispatch(wind_dict["name"],
                                                                    wind_dict["available"],
                                                                    Bus(wind_dict["bus"]["number"],
                                                                            wind_dict["bus"]["name"],
                                                                            wind_dict["bus"]["bustype"],
                                                                            wind_dict["bus"]["angle"],
                                                                            wind_dict["bus"]["voltage"],
                                                                            (min =wind_dict["bus"]["voltagelimits"]["min"],max=wind_dict["bus"]["voltagelimits"]["max"]),
                                                                            wind_dict["bus"]["basevoltage"] ),
                                                                    wind_dict["tech"]["rating"],
                                                                    TwoPartCost(wind_dict["econ"]["curtailcost"],
                                                                                wind_dict["econ"]["interruptioncost"]),
                                                                    dict_to_timearray(wind_dict["scalingfactor"])
                                    ))
                    end
                end
            end
        elseif gen_type_key =="Storage"
            for (storage_key,storage_dict) in  gen_type_dict
                push!(Storage_gen,GenericBattery(storage_dict["name"],
                                                            storage_dict["available"],
                                                            Bus(storage_dict["bus"]["number"],
                                                                            storage_dict["bus"]["name"],
                                                                            storage_dict["bus"]["bustype"],
                                                                            storage_dict["bus"]["angle"],
                                                                            storage_dict["bus"]["voltage"],
                                                                            (min =storage_dict["bus"]["voltagelimits"]["min"],max=storage_dict["bus"]["voltagelimits"]["max"]),
                                                                            storage_dict["bus"]["basevoltage"] ),
                                                            storage_dict["energy"],
                                                            (min=storage_dict["capacity"]["min"],max=storage_dict["capacity"]["max"]),
                                                            storage_dict["activepower"],
                                                            storage_dict["inputactivepowerlimit"],
                                                            storage_dict["outputactivepowerlimit"],
                                                            (in =storage_dict["efficiency"]["in"],out=storage_dict["efficiency"]["out"]),
                                                            storage_dict["reactivepower"],
                                                            (min=storage_dict["reactivepowerlimits"]["min"],max=storage_dict["reactivepowerlimits"]["max"])
                            ))
            end
        end
    end
    return Generators, Storage_gen
end


function branch_json_parser(dict)
    Branches = Array{Branch}(undef, 0)
    for (branch_key,branch_dict) in dict
        if branch_key == "Transformers"
            for (trans_key,trans_dict) in branch_dict
                bus_f =Bus(trans_dict["arch"]["from"]["number"],
                                        trans_dict["arch"]["from"]["name"],
                                        trans_dict["arch"]["from"]["bustype"],
                                        trans_dict["arch"]["from"]["angle"],
                                        trans_dict["arch"]["from"]["voltage"],
                                        (min =trans_dict["arch"]["from"]["voltagelimits"]["min"],max=trans_dict["arch"]["from"]["voltagelimits"]["max"]),
                                        trans_dict["arch"]["from"]["basevoltage"] )
                bus_t =Bus(trans_dict["arch"]["to"]["number"],
                                        trans_dict["arch"]["to"]["name"],
                                        trans_dict["arch"]["to"]["bustype"],
                                        trans_dict["arch"]["to"]["angle"],
                                        trans_dict["arch"]["to"]["voltage"],
                                        (min =trans_dict["arch"]["to"]["voltagelimits"]["min"],max=trans_dict["arch"]["to"]["voltagelimits"]["max"]),
                                        trans_dict["arch"]["to"]["basevoltage"] )
                if trans_dict["tap"] ==1.0
                    push!(Branches,Transformer2W(trans_dict["name"],
                                                trans_dict["available"],
                                                (from = bus_f,to = bus_t),
                                                trans_dict["r"],
                                                trans_dict["x"],
                                                trans_dict["primaryshunt"],
                                                trans_dict["rate"]
                                                ))
                elseif trans_dict["tap"] !=1.0
                    push!(Branches,TapTransformer(trans_dict["name"],
                                                trans_dict["available"],
                                                (from = bus_f,to = bus_t),
                                                trans_dict["r"],
                                                trans_dict["x"],
                                                trans_dict["primaryshunt"],
                                                trans_dict["tap"],
                                                trans_dict["rate"]
                                                ))
                end
            end
        elseif branch_key == "Lines"
            for (line_key,line_dict) in branch_dict
                bus_t =Bus(line_dict["arch"]["to"]["number"],
                                        line_dict["arch"]["to"]["name"],
                                        line_dict["arch"]["to"]["bustype"],
                                        line_dict["arch"]["to"]["angle"],
                                        line_dict["arch"]["to"]["voltage"],
                                        (min =line_dict["arch"]["to"]["voltagelimits"]["min"],max=line_dict["arch"]["to"]["voltagelimits"]["max"]),
                                        line_dict["arch"]["to"]["basevoltage"] )
                bus_f =Bus(line_dict["arch"]["from"]["number"],
                                        line_dict["arch"]["from"]["name"],
                                        line_dict["arch"]["from"]["bustype"],
                                        line_dict["arch"]["from"]["angle"],
                                        line_dict["arch"]["from"]["voltage"],
                                        (min =line_dict["arch"]["from"]["voltagelimits"]["min"],max=line_dict["arch"]["from"]["voltagelimits"]["max"]),
                                        line_dict["arch"]["from"]["basevoltage"] )
                push!(Branches,Line(line_dict["name"],
                                    line_dict["available"],
                                    (from = bus_f, to = bus_t),
                                    line_dict["r"],
                                    line_dict["x"],
                                    (from =line_dict["b"]["from"],to=line_dict["b"]["to"]),
                                    line_dict["rate"],
                                    line_dict["anglelimits"]
                                    ))
            end
        end
    end
    return Branches
end


function load_json_parser(dict)
    Loads = Array{ElectricLoad}(undef, 0)
    for (load_key,load_dict) in dict
        push!(Loads, PowerLoad(load_dict["name"],
                load_dict["available"],
                Bus(load_dict["bus"]["number"],
                                load_dict["bus"]["name"],
                                load_dict["bus"]["bustype"],
                                load_dict["bus"]["angle"],
                                load_dict["bus"]["voltage"],
                                (min =load_dict["bus"]["voltagelimits"]["min"],max=load_dict["bus"]["voltagelimits"]["max"]),
                                load_dict["bus"]["basevoltage"] ),
                load_dict["model"],
                load_dict["maxactivepower"],
                load_dict["maxreactivepower"],
                dict_to_timearray(load_dict["scalingfactor"])
                ))
    end
    return Loads
end

# Write dict to json file
function dict_to_json(dict,filename)
    stringdata =JSON2.write(dict)
    open("$filename.json", "w") do f
        write(f, stringdata)
    end
end

# Read json save file as a dict
function json_parser(filename)
    data =Dict{String,Any}()
    if isfile("../data/CDM/RTS/JSON/RTS-GMLC_Test_Case.json")
        temp =Dict{}()
        open("../data/CDM/RTS/JSON/RTS-GMLC_Test_Case.json", "r") do f
        global temp
        dicttxt = readstring(f)  # file information to string
        temp = JSON2.read(dicttxt, Dict{Any,Array{Dict}})  # parse and transform data
        data = temp
        end
    else
        @warn "JSON file doesn't exist"
    end
    Buses = bus_json_parse(data["Buses"])
    Generators,Storages = gen_json_parser(data["Generators"])
    Branches = branch_json_parser(data["Branches"])
    Loads = load_json_parser(data["Loads"]);
    return Buses,Generators,Branches,Loads
end


# Read back array of Variable cost from json dict
function json_var_cost(array)
    var_cost = [float(array[i][1]) for i in 1:length(array)]
    return var_cost
end

# Read back timeseries time array from json dict
function dict_to_timearray(dict)
    ts_string =[dict["timestamp"][i] for i in 1:length(dict["timestamp"])]
    ts_values =[dict["values"][i] for i in 1:length(dict["values"])]
    ts_raw =TimeSeries.TimeArray(Dates.DateTime(ts_string),ts_values)
    return ts_raw
end
