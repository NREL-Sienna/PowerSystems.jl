
function pm2ps_dict(data::Dict{String,Any})
    """
    Takes a dictionary parsered by PowerModels and returns a PowerSystems dictionary
    Currently Supports MATPOWER and PSSE data files paresed by PowerModels

    """
    if (length(data["bus"]) < 1)
        error("There are no busses in this matpower file")
    end
    ps_dict = Dict{String,Any}()
    ps_dict["name"] = data["name"]
    ps_dict["baseMVA"] = data["baseMVA"]
    ps_dict["source_type"] = data["source_type"]




    Buses = Dict{Int64,Any}()
    bus_types = ["PV", "PQ", "SF","isolated"] # Index into this using int val in buses
    for (d_key, d) in data["bus"]
        # d id the data dict for each bus
        # d_key is bus key
        if haskey(d,"bus_name")
            bus_name = d["bus_name"]
        else
            bus_name = string(d["bus_i"])
        end
        Buses[Int(d["bus_i"])] =  Dict{String,Any}("name" => bus_name ,
                                                "number" => d["bus_i"],
                                                "bustype" => bus_types[d["bus_type"]],
                                                "angle" => 0, # NOTE: angle 0, tuple(min, max)
                                                "voltage" => d["vm"],
                                                "voltagelimits" => @NT(min=d["vmin"], max=d["vmax"]),
                                                "basevoltage" => d["base_kv"]
                                                )
    end
    ps_dict["bus"] = Buses
        # If there is a load for this bus, only information so far is the installed load.
    Loads = Dict{String,Any}() # Using least constrained Load
    for (d_key,d) in data["load"]
        if d["pd"] != 0.0
            # NOTE: access nodes using index i in case numbering of original data not sequential/consistent
            bus = find_bus(Buses,d)
            Loads[string(d["index"])] = Dict{String,Any}("name" => bus["name"],
                                                "available" => true,
                                                "bus" => make_bus(bus),
                                                "model" => "P",
                                                "maxrealpower" => d["pd"],
                                                "maxreactivepower" => d["qd"],
                                                "scalingfactor" => TimeSeries.TimeArray(Dates.today(), [1.0])
                                                )

        end
    end
    ps_dict["load"] = Loads

    LoadZones = Dict{Int64,Any}()
    for (d_key,d) in data["areas"]
        b_array  = [b["bus_i"] for (b_key, b) in data["bus"] if b["area"] == d["index"] ]
        bus_l = [ make_bus(b) for (b_key, b) in Buses if b["number"] in b_array ]
        realpower  = [ l["pd"] for (l_key, l) in data["load"] if l["load_bus"] in b_array ]
        reactivepower  = [ l["qd"] for (l_key, l) in data["load"] if l["load_bus"] in b_array]
        LoadZones[d["index"]] = Dict{String,Any}("number" => d["index"],
                                                "name" => d_key ,
                                                "buses" => bus_l,
                                                "maxrealpower" => sum(realpower),
                                                "maxreactivepower" => sum(reactivepower)
                                                )
    end
    ps_dict["loadzone"] = LoadZones

    Generators = Dict{String,Any}()
    Generators["Thermal"] = Dict{String,Any}()
    Generators["Hydro"] = Dict{String,Any}()
    Generators["Renewable"] = Dict{String,Any}()
    Generators["Renewable"]["PV"]= Dict{String,Any}()
    Generators["Renewable"]["RTPV"]= Dict{String,Any}()
    Generators["Renewable"]["WIND"]= Dict{String,Any}()
    Generators["Storage"] = Dict{String,Any}()
    for (d_key,d) in data["gen"]
        if haskey(d,"fuel")
            fuel =d["fuel"]
        else
            fuel = "generic"
        end
        if haskey(d,"type")
            type_gen = d["type"]
        else
            type_gen = "generic"
        end
        if haskey(d,"name")
            gen_name = d["name"]
        elseif haskey(d,"source_id")
            gen_name = strip(string(d["source_id"][1])*"-"*d["source_id"][2])
        else
            gen_name = d_key
        end
        if fuel in ["Hydro"] || type_gen in ["hydro","HY"]
            bus =find_bus(Buses,d)
            Generators["Hydro"][gen_name] = Dict{String,Any}("name" => gen_name,
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

        elseif fuel in ["Solar","Wind"] || type_gen in ["W2,PV"]
            bus = find_bus(Buses,d)
            if type_gen == "PV"
                Generators["Renewable"]["PV"][gen_name] = Dict{String,Any}("name" => gen_name,
                                                                            "available" => d["gen_status"], # change from staus to available
                                                                            "bus" => make_bus(bus),
                                                                            "tech" => Dict{String,Any}("installedcapacity" => float(d["pmax"]),
                                                                                                        "reactivepowerlimits" => @NT(min=d["pmin"], max=d["pmax"]),
                                                                                                        "powerfactor" => 1),
                                                                            "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                                                        "interruptioncost" => nothing),
                                                                            "scalingfactor" => TimeSeries.TimeArray(Dates.today(), [1.0])
                                                                            )
            elseif type_gen == "RTPV"
                Generators["Renewable"]["RTPV"][gen_name] = Dict{String,Any}("name" => gen_name,
                                                                            "available" => d["gen_status"], # change from staus to available
                                                                            "bus" => make_bus(bus),
                                                                            "tech" => Dict{String,Any}("installedcapacity" => float(d["pmax"]),
                                                                                                        "reactivepowerlimits" => @NT(min=d["pmin"], max=d["pmax"]),
                                                                                                        "powerfactor" => 1),
                                                                            "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                                                        "interruptioncost" => nothing),
                                                                            "scalingfactor" => TimeSeries.TimeArray(Dates.today(), [1.0])
                                                                            )
            elseif type_gen in ["WIND","W2"]
                Generators["Renewable"]["WIND"][gen_name] = Dict{String,Any}("name" => gen_name,
                                                                            "available" => d["gen_status"], # change from staus to available
                                                                            "bus" => make_bus(bus),
                                                                            "tech" => Dict{String,Any}("installedcapacity" => float(d["pmax"]),
                                                                                                        "reactivepowerlimits" => @NT(min=d["pmin"], max=d["pmax"]),
                                                                                                        "powerfactor" => 1),
                                                                            "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                                                        "interruptioncost" => nothing),
                                                                            "scalingfactor" => TimeSeries.TimeArray(Dates.today(), [1.0])
                                                                            )
            end
        else
            bus =find_bus(Buses,d)
            Generators["Thermal"][gen_name] = Dict{String,Any}("name" => gen_name,
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
        end
    end
    ps_dict["gen"] = Generators

    Branches = Dict{String,Any}()
    Branches["Transformers"] = Dict{String,Any}()
    Branches["Lines"] = Dict{String,Any}()
    for (d_key,d) in data["branch"]
        if haskey(d,"name")
            b_name = d["name"]
        else
            b_name = d_key
        end
        (bus_f,bus_t) = find_bus(Buses,d)
        if d["transformer"]  #TODO : 3W Transformer
            Branches["Transformers"][b_name] = Dict{String,Any}("name" => b_name,
                                                        "available" => convert(Bool, d["br_status"]),
                                                        "connectionpoints" => @NT(from=make_bus(bus_f),to=make_bus(bus_t)),
                                                        "r" => d["br_r"],
                                                        "x" => d["br_x"],
                                                        "primaryshunt" => d["b_fr"] ,  #TODO: which b ??
                                                        "tap" => d["tap"],
                                                        "rate" => d["rate_a"],
                                                        "α" => d["shift"]
                                                        )
        else
            Branches["Lines"][b_name] = Dict{String,Any}("name" => b_name,
                                                        "available" => convert(Bool, d["br_status"]),
                                                        "connectionpoints" => @NT(from=make_bus(bus_f),to=make_bus(bus_t)),
                                                        "r" => d["br_r"],
                                                        "x" => d["br_x"],
                                                        "b" => @NT(from=d["b_fr"],to=d["b_to"]),
                                                        "rate" =>  d["rate_a"],
                                                        "anglelimits" => @NT(max =rad2deg(d["angmax"]),min=rad2deg(d["angmin"]))
                                                        )

        end
    end
    ps_dict["branch"] = Branches

    Shunts = Dict{String,Any}()
    for (d_key,d) in data["shunt"]
        if haskey(d,"name")
            s_name =d["name"]
        else
            s_name = d_key
        end
        bus = find_bus(Buses,d)
        Shunts[s_name] = Dict{String,Any}("name" => s_name,
                                            "available" => d["status"],
                                            "bus" => make_bus(bus),
                                            "Y" => (-d["gs"] + d["bs"]im)
                                            )
    end
    ps_dict["shunt"] = Shunts

    DCLines = Dict{String,Any}()
    for (d_key,d) in data["dcline"]
        if haskey(d,"name")
            l_name =d["name"]
        else
            l_name = d_key
        end
        (bus_f,bus_t) = find_bus(Buses,d)
        DCLines[l_name] = Dict{String,Any}("name" => l_name,
                                        "available" =>d["br_status"] ,
                                        "connectionpoints" => @NT(from = make_bus(bus_f),to = make_bus(bus_t) ) ,
                                        "realpowerlimits_from" => @NT(min= d["pminf"] , max = d["pmaxf"]) ,
                                        "realpowerlimits_to" => @NT(min= d["pmint"] , max =d["pmaxt"] ) ,
                                        "reactivepowerlimits_from" =>  @NT(min= d["qminf"], max =d["qmaxf"] ),
                                        "reactivepowerlimits_to" =>  @NT(min=d["qmint"] , max =d["qmaxt"] ),
                                        "loss" =>  @NT(l0=d["loss0"] , l1 =d["loss1"] )
                                        )
    end
    ps_dict["dcline"] = DCLines

    final_dict = check_thermal_limits(ps_dict)
    return final_dict
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
            f_bus =[ b for (key,b) in Buses if device_dict["f_bus"] == b["number"] ]
            t_bus =[ b for (key,b) in Buses if device_dict["t_bus"] == b["number"] ]
            value =(f_bus[1],t_bus[1])
        end
    elseif haskey(device_dict, "gen_bus")
        bus =[ b for (key,b) in Buses if device_dict["gen_bus"] == b["number"] ]
        value =bus[1]
    elseif haskey(device_dict, "load_bus")
        bus =[ b for (key,b) in Buses if device_dict["load_bus"] == b["number"] ]
        value =bus[1]
    elseif haskey(device_dict,"shunt_bus")
        bus =[ b for (key,b) in Buses if device_dict["shunt_bus"] == b["number"] ]
        value =bus[1]
    else
        println("Provided Dict missing key/s  gen_bus or f_bus/t_bus or load_bus")
    end
    return value
end

# Checks after parsing

function check_thermal_limits(data::Dict{String,Any})
    """
    Checks that each branch has a reasonable thermal rating, if not computes one
    Adopted from PowerModels.jl
    """

    mva_base = data["baseMVA"]
    for (type_key,type_dict) in data["branch"]
        if type_key =="Lines"
            for (b_key, b_dict) in type_dict
                theta_max = max(abs(b_dict["anglelimits"].min), abs(b_dict["anglelimits"].max))
                r = b_dict["r"]
                x = b_dict["x"]
                g =  r / (r^2 + x^2)
                b = -x / (r^2 + x^2)
                y_mag = sqrt(g^2 + b^2)
                fr_vmax = b_dict["connectionpoints"].from.voltagelimits.max
                to_vmax =  b_dict["connectionpoints"].to.voltagelimits.max
                m_vmax = max(fr_vmax, to_vmax)
                c_max = sqrt(fr_vmax^2 + to_vmax^2 - 2*fr_vmax*to_vmax*cos(theta_max))

                new_rate = y_mag*m_vmax*c_max
                if b_dict["rate"] <= 0.0
                    warn("This code only supports positive rate_a values, changing the value on branch $(b_dict["name"]) from $(mva_base*b_dict["rate"]) to $(mva_base*new_rate)")
                    b_dict["rate"] = new_rate
                elseif b_dict["rate"] > new_rate
                    warn("Current line rating for line $(b_dict["name"])  are larger than SIL ratings, changing the value from  $(mva_base*b_dict["rate"]) to $(mva_base*new_rate)")
                    b_dict["rate"] = new_rate
                end
            end
        end
    end
    return data
end
