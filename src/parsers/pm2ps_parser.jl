
function pm2ps_dict(data::Dict{String,Any})
    """
    Takes a dictionary parsered by PowerModels and returns a PowerSystems dictionary
    Currently Supports MATPOWER and PSSE data files paresed by PowerModels

    """
    (length(data["bus"]) < 1) ? error("There are no busses in this file") : nothing
    ps_dict = Dict{String,Any}()
    ps_dict["name"] = data["name"]
    ps_dict["baseMVA"] = data["baseMVA"]
    ps_dict["source_type"] = data["source_type"]
    Buses = read_bus(data)
    !isa(Buses,Nothing) ? ps_dict["bus"] = Buses : error("No bus data found") # TODO : need for a model without a bus
    Loads= read_loads(data,ps_dict["bus"])
    LoadZones= read_loadzones(data,ps_dict["bus"])
    Generators= read_gen(data,ps_dict["bus"])
    Branches= read_branch(data,ps_dict["bus"])
    Shunts = read_shunt(data,ps_dict["bus"])
    DCLines= read_dcline(data,ps_dict["bus"])
   
    ps_dict["load"] = Loads
    !isa(LoadZones,Nothing) ? ps_dict["loadzone"] =  LoadZones : warn("There are no Loadzones data in this file")
    !isa(Generators,Nothing) ? ps_dict["gen"] = Generators : error("There are no Generator in this file")
    !isa(Branches,Nothing) ? ps_dict["branch"] = Branches : warn("There are no Branch data in this file")
    !isa(Shunts,Nothing) ? ps_dict["shunt"] = Shunts : warn("There are no shunt data in this file")
    !isa(DCLines,Nothing) ? ps_dict["dcline"] = DCLines : warn("There are no DClines data in this file")
    return ps_dict
end


function make_bus(bus_dict::Dict{String,Any})
    """
    Creates a PowerSystems.Bus from a PowerSystems bus dictionary
    """
    bus = Bus(bus_dict["number"],
                     bus_dict["name"],
                     bus_dict["bustype"],
                     bus_dict["angle"],
                     bus_dict["voltage"],
                     bus_dict["voltagelimits"],
                     bus_dict["basevoltage"]
                     )
     return bus
 end

 function find_bus(Buses::Dict{Int64,Any},device_dict::Dict{String,Any})
    """
    Finds the  bus dictionary where a Generator/Load is located or the from & to bus for a line/transformer
    """
  if haskey(device_dict, "t_bus")
        if haskey(device_dict, "f_bus")
            t_bus = Buses[Int(device_dict["t_bus"])]
            f_bus = Buses[Int(device_dict["f_bus"])]
            value =(f_bus,t_bus)
        end
    elseif haskey(device_dict, "gen_bus")
        bus = Buses[Int(device_dict["gen_bus"])]
        value =bus
    elseif haskey(device_dict, "load_bus")
        bus = Buses[Int(device_dict["load_bus"])]
        value =bus
    elseif haskey(device_dict,"shunt_bus")
        bus = Buses[Int(device_dict["shunt_bus"])]
        value =bus
    else
        println("Provided Dict missing key/s  gen_bus or f_bus/t_bus or load_bus")
    end
    return value
end

function make_bus(bus_name, d, bus_types)
    bus = Dict{String,Any}("name" => bus_name ,
                            "number" => d["bus_i"],
                            "bustype" => bus_types[d["bus_type"]],
                            "angle" => 0, # NOTE: angle 0, tuple(min, max)
                            "voltage" => d["vm"],
                            "voltagelimits" => @NT(min=d["vmin"], max=d["vmax"]),
                            "basevoltage" => d["base_kv"]
                            )
    return bus 
end

function read_bus(data)
    Buses = Dict{Int64,Any}()
    bus_types = ["PV", "PQ", "SF","isolated"]
    for (d_key, d) in data["bus"]
        # d id the data dict for each bus
        # d_key is bus key
        haskey(d,"bus_name") ? bus_name = d["bus_name"] : bus_name = string(d["bus_i"])
        Buses[Int(d["bus_i"])] =  make_bus(bus_name, d, bus_types)
    end
    return Buses
end

function make_load(d,bus)
    load =Dict{String,Any}("name" => bus["name"],
                            "available" => true,
                            "bus" => make_bus(bus),
                            "model" => "P",
                            "maxrealpower" => d["pd"],
                            "maxreactivepower" => d["qd"],
                            "scalingfactor" => TimeSeries.TimeArray(Dates.today(), [1.0])
                            )
    return load
end

function read_loads(data,Buses)
    if haskey(data,"load")
        Loads = Dict{String,Any}() # Using least constrained Load
        for d_key in keys(data["load"])
            d = data["load"][d_key]
            if d["pd"] != 0.0
                # NOTE: access nodes using index i in case numbering of original data not sequential/consistent
                bus = find_bus(Buses,d)
                Loads[string(d["index"])] = make_load(d,bus)
            end
        end
        return Loads
    else
        error("There are no loads in this file")
    end
end

function make_loadzones(d_key,d,bus_l,realpower, reactivepower)
    loadzone = Dict{String,Any}("number" => d["index"],
                                "name" => d_key ,
                                "buses" => bus_l,
                                "maxrealpower" => sum(realpower),
                                "maxreactivepower" => sum(reactivepower)
                                )
    return loadzone
end

function read_loadzones(data,Buses)
    if haskey(data,"areas")
        LoadZones = Dict{Int64,Any}()
        for (d_key,d) in data["areas"]
            b_array  = [b["bus_i"] for (b_key, b) in data["bus"] if b["area"] == d["index"] ]
            bus_l = [make_bus(Buses[Int(b_key)]) for b_key in b_array]
            realpower  = [ l["pd"] for (l_key, l) in data["load"] if l["load_bus"] in b_array ] #TODO: Fast Implementations
            reactivepower  = [ l["qd"] for (l_key, l) in data["load"] if l["load_bus"] in b_array]
            LoadZones[d["index"]] = make_loadzones(d_key,d,bus_l,realpower, reactivepower)
        end
        return LoadZones
    else 
        return nothing
    end
end

function make_hydro_gen(d,gen_name,bus)
    hydro =  Dict{String,Any}("name" => gen_name,
                            "available" => d["gen_status"], # change from staus to available
                            "bus" => make_bus(bus),
                            "tech" => Dict{String,Any}( "installedcapacity" => float(d["pmax"]),
                                                        "realpower" => d["pg"],
                                                        "realpowerlimits" => @NT(min=d["pmin"], max=d["pmax"]),
                                                        "reactivepower" => d["qg"],
                                                        "reactivepowerlimits" => @NT(min=d["qmin"], max=d["qmax"]),
                                                        "ramplimits" => @NT(up=d["ramp_agc"],down=d["ramp_agc"]),
                                                        "timelimits" => nothing),
                            "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                        "interruptioncost" => nothing),
                            "scalingfactor" => TimeSeries.TimeArray(Dates.today(), [1.0])
                            )
    return hydro
end

function make_ren_gen(gen_name, d, bus)
    gen_re = Dict{String,Any}("name" => gen_name,
                    "available" => d["gen_status"], # change from staus to available
                    "bus" => make_bus(bus),
                    "tech" => Dict{String,Any}("installedcapacity" => float(d["pmax"]),
                                                "reactivepowerlimits" => @NT(min=d["pmin"], max=d["pmax"]),
                                                "powerfactor" => 1),
                    "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                "interruptioncost" => nothing),
                    "scalingfactor" => TimeSeries.TimeArray(Dates.today(), [1.0])
                    )
    return gen_re
end

function make_thermal_gen(gen_name, d, bus)
    thermal_gen = Dict{String,Any}("name" => gen_name,
                                    "available" => d["gen_status"],
                                    "bus" => make_bus(bus),
                                    "tech" => Dict{String,Any}("realpower" => d["pg"],
                                                                "realpowerlimits" => @NT(min=d["pmin"], max=d["pmax"]),
                                                                "reactivepower" => d["qg"],
                                                                "reactivepowerlimits" => @NT(min=d["qmin"], max=d["qmax"]),
                                                                "ramplimits" => @NT(up=d["ramp_agc"],down=d["ramp_agc"]),
                                                                "timelimits" => nothing),
                                    "econ" => Dict{String,Any}("capacity" => d["pmax"],
                                                                "variablecost" => d["cost"],
                                                                "fixedcost" => 0.0,
                                                                "startupcost" => d["startup"],
                                                                "shutdncost" => d["shutdown"],
                                                                "annualcapacityfactor" => nothing)
                                    )
    return thermal_gen
end

function read_gen(data,Buses)
    Generators = Dict{String,Any}()
    Generators["Thermal"] = Dict{String,Any}()
    Generators["Hydro"] = Dict{String,Any}()
    Generators["Renewable"] = Dict{String,Any}()
    Generators["Renewable"]["PV"]= Dict{String,Any}()
    Generators["Renewable"]["RTPV"]= Dict{String,Any}()
    Generators["Renewable"]["WIND"]= Dict{String,Any}()
    Generators["Storage"] = Dict{String,Any}()
    if haskey(data,"gen")
        fuel = []
        gen_name =[]
        type_gen =[]
        for d_key in keys(data["gen"])
            d = data["gen"][d_key]
            haskey(d,"fuel") ? fuel =d["fuel"] : fuel = "generic"
            haskey(d,"type") ? type_gen = d["type"] : type_gen = "generic"
            haskey(d,"name") ? gen_name = d["name"] : haskey(d,"source_id") ? gen_name = strip(string(d["source_id"][1])*"-"*d["source_id"][2]) : gen_name = d_key
            
            if fuel in ["Hydro"] || type_gen in ["hydro","HY"]
                bus =find_bus(Buses,d)
                Generators["Hydro"][gen_name] = make_hydro_gen(d,gen_name,bus)
            elseif fuel in ["Solar","Wind"] || type_gen in ["W2,PV"]
                bus = find_bus(Buses,d)
                if type_gen == "PV"
                    Generators["Renewable"]["PV"][gen_name] =  make_ren_gen(gen_name, d, bus)
                elseif type_gen == "RTPV"
                    Generators["Renewable"]["RTPV"][gen_name] = make_ren_gen(gen_name, d, bus)
                elseif type_gen in ["WIND","W2"]
                    Generators["Renewable"]["WIND"][gen_name] = make_ren_gen(gen_name, d, bus)
                end
            else
                bus =find_bus(Buses,d)
                Generators["Thermal"][gen_name] = make_thermal_gen(gen_name, d, bus)
            end
        end
        return Generators
    else
        return nothing
    end
end

function make_transformer(b_name, d, bus_f, bus_t)
    trans = Dict{String,Any}("name" => b_name,
                            "available" => convert(Bool, d["br_status"]),
                            "connectionpoints" => @NT(from=make_bus(bus_f),to=make_bus(bus_t)),
                            "r" => d["br_r"],
                            "x" => d["br_x"],
                            "primaryshunt" => d["b_fr"] ,  #TODO: which b ??
                            "tap" => d["tap"],
                            "rate" => d["rate_a"],
                            "α" => d["shift"]
                            )
    return trans
end

function make_lines(b_name, d, bus_f, bus_t)
    line = Dict{String,Any}("name" => b_name,
                            "available" => convert(Bool, d["br_status"]),
                            "connectionpoints" => @NT(from=make_bus(bus_f),to=make_bus(bus_t)),
                            "r" => d["br_r"],
                            "x" => d["br_x"],
                            "b" => @NT(from=d["b_fr"],to=d["b_to"]),
                            "rate" =>  d["rate_a"],
                            "anglelimits" => @NT(max =rad2deg(d["angmax"]),min=rad2deg(d["angmin"]))
                            )
    return line 
end

function read_branch(data,Buses)
    Branches = Dict{String,Any}()
    Branches["Transformers"] = Dict{String,Any}()
    Branches["Lines"] = Dict{String,Any}()
    if haskey(data,"branch")
        b_name = []
        for (d_key,d) in data["branch"]
            haskey(d,"name") ? b_name = d["name"] :b_name = d_key
            (bus_f,bus_t) = find_bus(Buses,d)
            if d["transformer"]  #TODO : 3W Transformer
                Branches["Transformers"][b_name] = make_transformer(b_name, d, bus_f, bus_t)
            else
                Branches["Lines"][b_name] = make_lines(b_name, d, bus_f, bus_t)
            end
        end
        return Branches
    else
        return nothing
    end
end

function make_dcline(l_name, d, bus_f, bus_t)
    dcline = Dict{String,Any}("name" => l_name,
                            "available" =>d["br_status"] ,
                            "connectionpoints" => @NT(from = make_bus(bus_f),to = make_bus(bus_t) ) ,
                            "realpowerlimits_from" => @NT(min= d["pminf"] , max = d["pmaxf"]) ,
                            "realpowerlimits_to" => @NT(min= d["pmint"] , max =d["pmaxt"] ) ,
                            "reactivepowerlimits_from" =>  @NT(min= d["qminf"], max =d["qmaxf"] ),
                            "reactivepowerlimits_to" =>  @NT(min=d["qmint"] , max =d["qmaxt"] ),
                            "loss" =>  @NT(l0=d["loss0"] , l1 =d["loss1"] )
                            )
    return dcline 
end

function read_dcline(data,Buses)
    DCLines = Dict{String,Any}()
    if haskey(data,"dclines")
        for (d_key,d) in data["dcline"]
            haskey(d,"name") ? l_name =d["name"] : l_name = d_key
            (bus_f,bus_t) = find_bus(Buses,d)
            DCLines[l_name] = make_dcline(l_name, d, bus_f, bus_t)
        end
        return DCLines
    else
        return nothing
    end
end

function make_shunt(s_name, d, bus)
    shunt = Dict{String,Any}("name" => s_name,
                            "available" => d["status"],
                            "bus" => make_bus(bus),
                            "Y" => (-d["gs"] + d["bs"]im)
                            )
    return shunt 
end

function read_shunt(data,Buses)
    Shunts = Dict{String,Any}()
    if haskey(data,"shunt")
        s_name =[]
        for (d_key,d) in data["shunt"]
            haskey(d,"name") ? s_name =d["name"] : s_name = d_key
            bus = find_bus(Buses,d)
            Shunts[s_name] = make_shunt(s_name, d, bus)
        end
        return Shunts
    else
        return nothing
    end
end