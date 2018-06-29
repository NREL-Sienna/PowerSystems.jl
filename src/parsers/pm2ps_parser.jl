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
    base_kv = data["bus"][collect(keys(data["bus"]))[1]]["base_kv"] # Load base kv from first bus
    Buses = Dict{Int64,Any}()
    bus_types = ["PV", "PQ", "SF","isolated"] # Index into this using int val in buses
    for (d_key, d) in data["bus"] 
        # d id the data dict for each bus
        # d_key is bus key
        if haskey(d,"nus_name")
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
    
    Generators = Dict{String,Any}()
    Generators["Thermal"] = Dict{String,Any}()
    Generators["Hydro"] = Dict{String,Any}()
    Generators["Renewable"] = Dict{String,Any}()
    Generators["Renewable"]["PV"]= Dict{String,Any}()
    Generators["Renewable"]["RTPV"]= Dict{String,Any}()
    Generators["Renewable"]["WIND"]= Dict{String,Any}()
    Generators["Storage"] = Dict{String,Any}()
#     if haskey() TODO : check if key exist
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
            gen_name = d["name"]
        else
            gen_name = d_key
        end
        (bus_f,bus_t) = find_bus(Buses,d)
        if d["transformer"]
            Branches["Transformers"][gen_name] = Dict{String,Any}("name" => gen_name,
                                                        "available" => convert(Bool, d["br_status"]),
                                                        "connectionpoints" => @NT(from=make_bus(bus_f),to=make_bus(bus_t)),
                                                        "r" => d["br_r"],
                                                        "x" => d["br_x"],
                                                        "primaryshunt" => d["b_fr"] ,  #TODO: which b ??
                                                       # "zb" => @NT(primary=(branch_raw[i,6]/2),secondary=(branch_raw[i,6]/2)), TODO: Phase-Shifting Transformer angle
                                                        "tap" => d["tap"],
                                                        "rate" => d["rate_a"],
                                                        )               
        else
            Branches["Lines"][gen_name] = Dict{String,Any}("name" => gen_name,
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
    return ps_dict
end


function make_bus(bus_dict::Dict{String,Any})
    """
    Creates a PowerSystems.Bus from a PowerSystems bus dictionary
    """
    bus = PowerSystems.Bus(bus_dict["number"],
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
    else
        println("Provided Dict missing key/s  gen_bus or f_bus/t_bus or load_bus")
    end
    return value
end

