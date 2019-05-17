
MAPPING_BUSNUMBER2INDEX = Dict{Int64, Int64}()

"""
Takes a dictionary parsed by PowerModels and returns a PowerSystems
dictionary.  Currently Supports MATPOWER and PSSE data files parsed by
PowerModels
"""
function pm2ps_dict(data::Dict{String,Any}; kwargs...)
    if length(data["bus"]) < 1
        throw(DataFormatError("There are no buses in this file."))
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
    Generators= read_gen(data, ps_dict["bus"]; kwargs...)
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


"""
Creates a PowerSystems.Bus from a PowerSystems bus dictionary
"""
function make_bus(bus_dict::Dict{String,Any})
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

"""
Finds the bus dictionary where a Generator/Load is located or the from & to bus
for a line/transformer
"""
function find_bus(Buses::Dict{Int64,Any},device_dict::Dict{String,Any})
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
        throw(DataFormatError("Provided Dict missing key/s:  gen_bus or f_bus/t_bus or load_bus"))
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
    data = sort(collect(data["bus"]), by = x->parse(Int64,x[1]))    
    for (i, (d_key, d)) in enumerate(data)
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
                            "maxreactivepower" => d["qd"]
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

function make_hydro_gen(gen_name, d, bus)
    ramp_agc = get(d, "ramp_agc", get(d, "ramp_10", get(d, "ramp_30", d["pmax"])))
    hydro =  Dict{String,Any}("name" => gen_name,
                            "available" => d["gen_status"], # change from staus to available
                            "bus" => make_bus(bus),
                            "tech" => Dict{String,Any}( "rating" => float(d["pmax"]),
                                                        "activepower" => d["pg"],
                                                        "activepowerlimits" => (min=d["pmin"], max=d["pmax"]),
                                                        "reactivepower" => d["qg"],
                                                        "reactivepowerlimits" => (min=d["qmin"], max=d["qmax"]),
                                                        "ramplimits" => (up=ramp_agc/d["mbase"],down=ramp_agc/d["mbase"]),
                                                        "timelimits" => nothing),
                            "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                        "interruptioncost" => nothing)
                            )
    return hydro
end

function make_ren_gen(gen_name, d, bus)
    gen_re = Dict{String,Any}("name" => gen_name,
                    "available" => d["gen_status"], # change from staus to available
                    "bus" => make_bus(bus),
                    "tech" => Dict{String,Any}("rating" => float(d["pmax"]),
                                                "reactivepowerlimits" => (min=d["pmin"], max=d["pmax"]),
                                                "powerfactor" => 1),
                    "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                "interruptioncost" => nothing)
                    )
    return gen_re
end

"""
The polynomial term follows the convention that for an n-degree polynomial, at least n + 1 components are needed.
    c(p) = c_n*p^n+...+c_1p+c_0
    c_o is stored in the fixed_cost field in of the Econ Struct
"""
function make_thermal_gen(gen_name, d, bus)
    if haskey(d,"model")
        model = GeneratorCostModel(d["model"])
        if model == PIECEWISE_LINEAR::GeneratorCostModel
            cost_component = d["cost"]		        
            power_p = [i for (ix,i) in enumerate(cost_component) if isodd(ix)]		        
            cost_p =  [i for (ix,i) in enumerate(cost_component) if iseven(ix)] 
            cost = [(p,c) for (p,c) in zip(cost_p,power_p)]		     
            fixedcost = cost[1][2]
        elseif model == POLYNOMIAL::GeneratorCostModel
            if d["ncost"] == 0		         
                cost = (0.0, 0.0)		           
                fixedcost = 0.0		                
            elseif d["ncost"] == 1		            
                cost = (0.0, 0.0)		                 
                fixedcost = d["cost"][1]		            
            elseif d["ncost"] == 2		                 
                cost = (0.0, d["cost"][1])		            
                fixedcost = d["cost"][2]		                
            elseif d["ncost"] == 3		            
                cost = (d["cost"][1], d["cost"][2]) 		                 
                fixedcost = d["cost"][3]		             
            else		                
                throw(DataFormatError("invalid value for ncost: $(d["ncost"]). PowerSystems only supports polynomials up to second degree"))
            end
        end
    else
        @warn "Generator cost data not included for Generator: $gen_name"
        tmpcost = EconThermal()
        cost = tmpcost.variablecost
        fixedcost = tmpcost.fixedcost
        startupcost = tmpcost.startupcost
        shutdncost = tmpcost.shutdncost
    end

    # TODO GitHub #148: ramp_agc isn't always present. This value may not be correct.
    ramp_agc = get(d, "ramp_agc", get(d, "ramp_10", get(d, "ramp_30", d["pmax"])))
    thermal_gen = Dict{String,Any}("name" => gen_name,
                                    "available" => d["gen_status"],
                                    "bus" => make_bus(bus),
                                    "tech" => Dict{String,Any}("rating" => d["pmax"],
                                                                "activepower" => d["pg"],
                                                                "activepowerlimits" => (min=d["pmin"], max=d["pmax"]),
                                                                "reactivepower" => d["qg"],
                                                                "reactivepowerlimits" => (min=d["qmin"], max=d["qmax"]),
                                                                "ramplimits" => (up=ramp_agc/d["mbase"], down=ramp_agc/d["mbase"]),
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

"""
Transfer generators to ps_dict according to their classification
"""
function read_gen(data, Buses; kwargs...)

    if :genmap_file in keys(kwargs)
        genmap_file = kwargs[:genmap_file]
    else # use default generator mapping config file
        genmap_file = joinpath(dirname(dirname(pathof(PowerSystems))),
                               "src/parsers/generator_mapping.yaml")
    end
    genmap_dict = open(genmap_file) do file
        YAML.load(file)
    end
    
    generators = Dict{String,Any}()
    generators["Thermal"] = Dict{String,Any}()
    generators["Hydro"] = Dict{String,Any}()
    generators["Renewable"] = Dict{String,Any}()
    generators["Renewable"]["PV"]= Dict{String,Any}()
    generators["Renewable"]["RTPV"]= Dict{String,Any}()
    generators["Renewable"]["WIND"]= Dict{String,Any}()
    generators["Storage"] = Dict{String,Any}() # not currently used? JJS 3/13/19
    
    if !haskey(data, "gen")
        return nothing
    end
    
    fuel = []
    gen_name =[]
    type_gen =[]
    for (d_key,d) in data["gen"]

        fuel = uppercase(get(d, "fuel", "generic"))
        type_gen = uppercase(get(d, "type", "generic"))
        if haskey(d, "name")
            gen_name = d["name"]
        elseif haskey(d, "source_id")
            gen_name = strip(string(d["source_id"][1])*"-"*d["source_id"][2])
        else
            gen_name = d_key
        end
        
        bus = find_bus(Buses, d)

        assigned = false 
        for (rkey, rval) in generators["Renewable"]
            fuelkeys = genmap_dict[rkey]["fuel"]
            typekeys = genmap_dict[rkey]["type"]
            if fuel in fuelkeys && type_gen in typekeys
                generators["Renewable"][rkey][gen_name] = make_ren_gen(gen_name, d, bus)
                assigned = true
                break
            end
        end
        if !assigned
            fuelkeys = genmap_dict["Hydro"]["fuel"]
            typekeys = genmap_dict["Hydro"]["type"]
            if fuel in fuelkeys && type_gen in typekeys
                generators["Hydro"][gen_name] = make_hydro_gen(gen_name, d, bus)
                assigned = true
            end
        end
        if !assigned
            # default to Thermal type if not already assigned
            generators["Thermal"][gen_name] = make_thermal_gen(gen_name, d, bus)
        end

    end # for (d_key,d) in data["gen"]

    return generators
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
