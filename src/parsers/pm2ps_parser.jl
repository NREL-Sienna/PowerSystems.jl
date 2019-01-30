
MAPPING_BUSNUMBER2INDEX = Dict{Int64, Int64}()

function pm2ps_dict(data::Dict{String,Any})
    """
    Takes a dictionary parsered by PowerModels and returns a PowerSystems dictionary
    Currently Supports MATPOWER and PSSE data files paresed by PowerModels

    """
    if length(data["bus"]) < 1
        @error "There are no buses in this file" # TODO: raise error here?
    end
    ps_dict = Dict{String,Any}()
    ps_dict["name"] = data["name"]
    ps_dict["baseMVA"] = data["baseMVA"]
    ps_dict["source_type"] = data["source_type"]
    @info "Reading bus data"
    Buses = read_bus(data)
    if !isa(Buses,Nothing)
         ps_dict["bus"] = Buses
    else
        @error "No bus data found" # TODO : need for a model without a bus
    end
    @info "Reading load data"
    Loads= read_loads(data,ps_dict["bus"])
    LoadZones= read_loadzones(data,ps_dict["bus"])
    @info "Reading generator data"
    Generators= read_gen(data,ps_dict["bus"])
    @info "Reading branch data"
    Branches= read_branch(data,ps_dict["bus"])
    Shunts = read_shunt(data,ps_dict["bus"])
    DCLines= read_dcline(data,ps_dict["bus"])

    ps_dict["load"] = Loads
    if !isa(LoadZones,Nothing)
        ps_dict["loadzone"] = LoadZones
    else
        @info "There are no Load Zones data in this file"
    end
    if !isa(Generators,Nothing)
        ps_dict["gen"] = Generators
    else
        @error "There are no Generators in this file"
    end
    if !isa(Branches,Nothing)
        ps_dict["branch"] = Branches
    else
        @info "There is no Branch data in this file"
    end
    if !isa(Shunts,Nothing)
        ps_dict["shunt"] = Shunts
    else
        @info "There is no shunt data in this file"
    end
    if !isa(DCLines,Nothing)
        ps_dict["dcline"] = DCLines
    else
        @info "There is no DClines data in this file"
    end

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
            t_bus = Buses[MAPPING_BUSNUMBER2INDEX[Int(device_dict["t_bus"])]]
            f_bus = Buses[MAPPING_BUSNUMBER2INDEX[Int(device_dict["f_bus"])]]
            value =(f_bus,t_bus)
        end
    elseif haskey(device_dict, "gen_bus")
        bus = Buses[MAPPING_BUSNUMBER2INDEX[Int(device_dict["gen_bus"])]]
        value =bus
    elseif haskey(device_dict, "load_bus")
        bus = Buses[MAPPING_BUSNUMBER2INDEX[Int(device_dict["load_bus"])]]
        value =bus
    elseif haskey(device_dict,"shunt_bus")
        bus = Buses[MAPPING_BUSNUMBER2INDEX[Int(device_dict["shunt_bus"])]]
        value =bus
    else
        @info "Provided Dict missing key/s  gen_bus or f_bus/t_bus or load_bus"
    end
    return value
end

function make_bus(bus_name, d, bus_types)
    bus = Dict{String,Any}("name" => bus_name ,
                            "number" => MAPPING_BUSNUMBER2INDEX[d["bus_i"]],
                            "bustype" => bus_types[d["bus_type"]],
                            "angle" => 0, # NOTE: angle 0, tuple(min, max)
                            "voltage" => d["vm"],
                            "voltagelimits" => (min=d["vmin"], max=d["vmax"]),
                            "basevoltage" => d["base_kv"]
                            )
    return bus
end

function read_bus(data)
    Buses = Dict{Int64,Any}()
    bus_types = ["PV", "PQ", "SF","isolated"]
    for (i, (d_key, d)) in enumerate(data["bus"])
        # d id the data dict for each bus
        # d_key is bus key
        haskey(d,"bus_name") ? bus_name = d["bus_name"] : bus_name = string(d["bus_i"])
        bus_number = Int(d["bus_i"])
        MAPPING_BUSNUMBER2INDEX[bus_number] = i
        Buses[MAPPING_BUSNUMBER2INDEX[bus_number]] =  make_bus(bus_name, d, bus_types)
    end
    return Buses
end

function make_load(d,bus)
    load =Dict{String,Any}("name" => bus["name"],
                            "available" => true,
                            "bus" => make_bus(bus),
                            "maxactivepower" => d["pd"],
                            "maxreactivepower" => d["qd"],
                            "scalingfactor" => TimeSeries.TimeArray(collect(Dates.DateTime(Dates.today()):Dates.Hour(1):Dates.DateTime(Dates.today()+Dates.Day(1))), ones(25))
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
        @error "There are no loads in this file"
    end
end

function make_loadzones(d_key,d,bus_l,activepower, reactivepower)
    loadzone = Dict{String,Any}("number" => d["index"],
                                "name" => d_key ,
                                "buses" => bus_l,
                                "maxactivepower" => sum(activepower),
                                "maxreactivepower" => sum(reactivepower)
                                )
    return loadzone
end

function read_loadzones(data,Buses)
    if haskey(data,"areas")
        LoadZones = Dict{Int64,Any}()
        for (d_key,d) in data["areas"]
            b_array  = [MAPPING_BUSNUMBER2INDEX[b["bus_i"]] for (b_key, b) in data["bus"] if b["area"] == d["index"] ]
            bus_l = [make_bus(Buses[Int(b_key)]) for b_key in b_array]
            activepower  = [ l["pd"] for (l_key, l) in data["load"] if MAPPING_BUSNUMBER2INDEX[l["load_bus"]] in b_array ] #TODO: Fast Implementations
            reactivepower  = [ l["qd"] for (l_key, l) in data["load"] if MAPPING_BUSNUMBER2INDEX[l["load_bus"]] in b_array]
            LoadZones[d["index"]] = make_loadzones(d_key,d,bus_l,activepower, reactivepower)
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
                                                        "activepower" => d["pg"],
                                                        "activepowerlimits" => (min=d["pmin"], max=d["pmax"]),
                                                        "reactivepower" => d["qg"],
                                                        "reactivepowerlimits" => (min=d["qmin"], max=d["qmax"]),
                                                        "ramplimits" => (up=d["ramp_agc"],down=d["ramp_agc"]),
                                                        "timelimits" => nothing),
                            "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                        "interruptioncost" => nothing),
                            "scalingfactor" => TimeSeries.TimeArray(collect(Dates.DateTime(Dates.today()):Dates.Hour(1):Dates.DateTime(Dates.today()+Dates.Day(1))), ones(25))
                            )
    return hydro
end

function make_ren_gen(gen_name, d, bus)
    gen_re = Dict{String,Any}("name" => gen_name,
                    "available" => d["gen_status"], # change from staus to available
                    "bus" => make_bus(bus),
                    "tech" => Dict{String,Any}("installedcapacity" => float(d["pmax"]),
                                                "reactivepowerlimits" => (min=d["pmin"], max=d["pmax"]),
                                                "powerfactor" => 1),
                    "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                "interruptioncost" => nothing),
                    "scalingfactor" => TimeSeries.TimeArray(collect(Dates.DateTime(Dates.today()):Dates.Hour(1):Dates.DateTime(Dates.today()+Dates.Day(1))), ones(25))
                    )
    return gen_re
end

function make_thermal_gen(gen_name, d, bus)
    if d["model"] ==1
        cost_component = d["cost"]
        power_p = [i for (ix,i) in enumerate(cost_component) if isodd(ix)]
        cost_p =  [i for (ix,i) in enumerate(cost_component) if iseven(ix)]./power_p
        cost = [(p,c) for (p,c) in zip(cost_p,power_p)]
        fixedcost = cost[1][2]
    elseif d["model"] ==2
        if d["ncost"] == 2
            cost = x-> d["cost"][1]*x + d["cost"][2]
        elseif d["ncost"] == 3
            cost = x-> d["cost"][1]*x^2 + d["cost"][2]*x + d["cost"][3]
        elseif d["ncost"] == 4
            cost = x-> d["cost"][1]*x^3 + d["cost"][2]*x^2 + d["cost"][3]*x + d["cost"][4]
        end
        fixedcost = cost(0)
    else
        cost = d["cost"]
        fixedcost = 0.0
    end
    thermal_gen = Dict{String,Any}("name" => gen_name,
                                    "available" => d["gen_status"],
                                    "bus" => make_bus(bus),
                                    "tech" => Dict{String,Any}("activepower" => d["pg"],
                                                                "activepowerlimits" => (min=d["pmin"], max=d["pmax"]),
                                                                "reactivepower" => d["qg"],
                                                                "reactivepowerlimits" => (min=d["qmin"], max=d["qmax"]),
                                                                "ramplimits" => (up=d["ramp_agc"],down=d["ramp_agc"]),
                                                                "timelimits" => nothing),
                                    "econ" => Dict{String,Any}("capacity" => d["pmax"],
                                                                "variablecost" => cost,
                                                                "fixedcost" => fixedcost,
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
        for (d_key,d) in data["gen"]
            haskey(d,"fuel") ? fuel =d["fuel"] : haskey(data,"genfuel") ? fuel = data["genfuel"][d_key]["col_1"] : fuel = "generic"
            haskey(d,"type") ? type_gen = d["type"] : haskey(data,"gentype") ? type_gen = data["gentype"][d_key]["col_1"] : type_gen = "generic"
            haskey(d,"name") ? gen_name = d["name"] : haskey(d,"source_id") ? gen_name = strip(string(d["source_id"][1])*"-"*d["source_id"][2]) : gen_name = d_key

            if uppercase(fuel) in ["HYDRO"] || uppercase(type_gen) in ["HYDRO","HY"]
                bus = find_bus(Buses,d)
                Generators["Hydro"][gen_name] = make_hydro_gen(d,gen_name,bus)
            elseif uppercase(fuel) in ["SOLAR","WIND"] || uppercase(type_gen) in ["W2","PV"]
                bus = find_bus(Buses,d)
                if uppercase(type_gen) == "PV"
                    Generators["Renewable"]["PV"][gen_name] =  make_ren_gen(gen_name, d, bus)
                elseif uppercase(type_gen) == "RTPV"
                    Generators["Renewable"]["RTPV"][gen_name] = make_ren_gen(gen_name, d, bus)
                elseif uppercase(type_gen) in ["WIND","W2"]
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
                            "available" => Bool(d["br_status"]),
                            "connectionpoints" => (from=make_bus(bus_f),to=make_bus(bus_t)),
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
                            "available" => Bool(d["br_status"]),
                            "connectionpoints" => (from=make_bus(bus_f),to=make_bus(bus_t)),
                            "r" => d["br_r"],
                            "x" => d["br_x"],
                            "b" => (from=d["b_fr"],to=d["b_to"]),
                            "rate" =>  d["rate_a"],
                            "anglelimits" => (min=rad2deg(d["angmin"]),max =rad2deg(d["angmax"]))
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
            haskey(d,"name") ? b_name = d["name"] : b_name = d_key
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
                            "connectionpoints" => (from = make_bus(bus_f),to = make_bus(bus_t) ) ,
                            "activepowerlimits_from" => (min= d["pminf"] , max = d["pmaxf"]) ,
                            "activepowerlimits_to" => (min= d["pmint"] , max =d["pmaxt"] ) ,
                            "reactivepowerlimits_from" =>  (min= d["qminf"], max =d["qmaxf"] ),
                            "reactivepowerlimits_to" =>  (min=d["qmint"] , max =d["qmaxt"] ),
                            "loss" =>  (l0=d["loss0"] , l1 =d["loss1"] )
                            )
    return dcline
end

function read_dcline(data,Buses)
    DCLines = Dict{String,Any}()
    if haskey(data,"dcline")
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
