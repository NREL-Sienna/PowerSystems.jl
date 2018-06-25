
###########
#Bus data parser
###########


## - Parse CSV to Dict 
function bus_csv_parser(bus_raw)
    Buses_dict = Dict{Int64,Any}()
    for i in 1:nrow(bus_raw)
        Buses_dict[bus_raw[i,1]] = Dict{String,Any}("number" =>bus_raw[i,1] ,
                                                "name" => bus_raw[i,2],
                                                "bustype" => bus_raw[i,4],
                                                "angle" => bus_raw[i,8],
                                                "voltage" => bus_raw[i,7],
                                                "voltagelimits" => @NT(min=0.95,max=1.05),
                                                "basevoltage" => bus_raw[i,3]
                                                )
    end
    return Buses_dict
end

## - Parse Dict to Struct
function bus_dict_parse(dict::Dict{Int,Any})
    Buses = Array{PowerSystems.Bus}(0)
    for (bus_key,bus_dict) in dict
        push!(Buses,PowerSystems.Bus(bus_dict["number"],
                                    bus_dict["name"],
                                    bus_dict["bustype"],
                                    bus_dict["angle"],
                                    bus_dict["voltage"],
                                    bus_dict["voltagelimits"],
                                    bus_dict["basevoltage"]
                                    ))
    end
    return Buses
end

# - Parse Json_dict to Struct

function bus_json_parse(dict::Dict{String,Any})
    Buses = Array{PowerSystems.Bus}(0)
    for (bus_key,bus_dict) in dict
        push!(Buses,PowerSystems.Bus(bus_dict["number"],
                                    bus_dict["name"],
                                    bus_dict["bustype"],
                                    bus_dict["angle"],
                                    bus_dict["voltage"],
                                    @NT(min =bus_dict["voltagelimits"]["min"],max=bus_dict["voltagelimits"]["max"]),
                                    bus_dict["basevoltage"]
                                    ))
    end
    return Buses
end

###########
#Generator data parser
###########

function date_time(df)
    DayAhead = collect(DateTime(df[1,:Year],df[1,:Month],df[1,:Day],0,0,0):Minute(5):
                        DateTime(df[end,:Year],df[end,:Month],df[end,:Day],23,55,0))
    return DayAhead
end

## - Parse CSV to Dict

function gen_csv_parser(gen_raw, Buses, HydroTS_raw, PVTS_raw, RTPVTS_raw, WindTS_raw, CSPTS_raw)
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
            fuel_cost = gen_raw[gen,:Fuel_Price_MMBTU] ## TODO: MMBTU -->> MBTU
            bus_id =[Buses[i] for i in 1:length(Buses) if Buses[i].number == gen_raw[gen,:Bus_ID]]
            Generators_dict["Thermal"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                            "available" => true,
                                            "bus" => bus_id[1],
                                            "tech" => Dict{String,Any}("realpower" => 0,
                                                                        "realpowerlimits" => @NT(min=float(gen_raw[gen,12]),max=float(gen_raw[gen,11])),
                                                                        "reactivepower" => 0,
                                                                        "reactivepowerlimits" => @NT(min=float(gen_raw[gen,14]),max=float(gen_raw[gen,13])),
                                                                        "ramplimits" => @NT(up=gen_raw[gen,:Ramp_Rate_MW_Min],down=gen_raw[gen,:Ramp_Rate_MW_Min]),
                                                                        "timelimits" => @NT(up=gen_raw[gen,:Min_Up_Time_Hr],down=gen_raw[gen,:Min_Down_Time_Hr])),
                                            "econ" => Dict{String,Any}("capacity" => gen_raw[gen,11],
                                                                        "variablecost" => var_cost,
                                                                        "fixedcost" => 0.0,
                                                                        "startupcost" => gen_raw[gen,:Start_Heat_Warm_MBTU]*fuel_cost,
                                                                        "shutdncost" => 0.0,
                                                                        "annualcapacityfactor" => nothing)
                                            ) 

        elseif gen_raw[gen,:Fuel] in ["Hydro"]
            bus_id =[Buses[i] for i in 1:length(Buses) if Buses[i].number == gen_raw[gen,:Bus_ID]]
            ts_raw = HydroTS_raw[:,Symbol("x"*gen_raw[gen,:GEN_UID])]
            DayAhead = date_time(HydroTS_raw)
            Generators_dict["Hydro"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                            "available" => true, # change from staus to available
                                            "bus" => bus_id[1],
                                            "tech" => Dict{String,Any}( "installedcapacity" => float(gen_raw[gen,11]),
                                                                        "realpower" => 0.0,
                                                                        "realpowerlimits" => @NT(min=float(gen_raw[gen,12]),max=float(gen_raw[gen,11])),
                                                                        "reactivepower" => 0.0,
                                                                        "reactivepowerlimits" => @NT(min=float(gen_raw[gen,14]),max=float(gen_raw[gen,13])),
                                                                        "ramplimits" => @NT(up=gen_raw[gen,:Ramp_Rate_MW_Min],down=gen_raw[gen,:Ramp_Rate_MW_Min]),
                                                                        "timelimits" => @NT(up=gen_raw[gen,:Min_Up_Time_Hr],down=gen_raw[gen,:Min_Down_Time_Hr])),
                                            "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                        "interruptioncost" => nothing),
                                            "scalingfactor" => TimeSeries.TimeArray(DayAhead,ts_raw)
                                            )         

        elseif gen_raw[gen,:Fuel] in ["Solar","Wind"]
            bus_id =[Buses[i] for i in 1:length(Buses) if Buses[i].number == gen_raw[gen,:Bus_ID]]
            if gen_raw[gen,5] == "PV"
                ts_raw = PVTS_raw[:,Symbol("x"*gen_raw[gen,:GEN_UID])]
                DayAhead = date_time(PVTS_raw)
                Generators_dict["Renewable"]["PV"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                                "available" => true, # change from staus to available
                                                "bus" => bus_id[1],
                                                "tech" => Dict{String,Any}("installedcapacity" => gen_raw[gen,11],
                                                                            "reactivepowerlimits" => @NT(min=float(gen_raw[gen,14]),max=float(gen_raw[gen,13])),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing),
                                                "scalingfactor" => TimeSeries.TimeArray(DayAhead,ts_raw)
                                                )            
            elseif gen_raw[gen,5] == "RTPV"
                ts_raw = RTPVTS_raw[:,Symbol("x"*gen_raw[gen,:GEN_UID])]
                DayAhead = date_time(RTPVTS_raw)
                Generators_dict["Renewable"]["RTPV"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                                "available" => true, # change from staus to available
                                                "bus" => bus_id[1],
                                                "tech" => Dict{String,Any}("installedcapacity" => gen_raw[gen,11],
                                                                            "reactivepowerlimits" => @NT(min=float(gen_raw[gen,14]),max=float(gen_raw[gen,13])),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing),
                                                "scalingfactor" => TimeSeries.TimeArray(DayAhead,ts_raw)
                                                )
            elseif gen_raw[gen,5] == "WIND"
                ts_raw = WindTS_raw[:,Symbol("x"*gen_raw[gen,:GEN_UID])]
                DayAhead = date_time(WindTS_raw)
                Generators_dict["Renewable"]["WIND"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                                "available" => true, # change from staus to available
                                                "bus" => bus_id[1],
                                                "tech" => Dict{String,Any}("installedcapacity" => gen_raw[gen,11],
                                                                            "reactivepowerlimits" => @NT(min=float(gen_raw[gen,14]),max=float(gen_raw[gen,13])),
                                                                            "powerfactor" => 1),
                                                "econ" => Dict{String,Any}("curtailcost" => 0.0,
                                                                            "interruptioncost" => nothing),
                                                "scalingfactor" => TimeSeries.TimeArray(DayAhead,ts_raw)
                                                )
            end
        elseif gen_raw[gen,:Fuel] in ["Storage"]
            bus_id =[Buses[i] for i in 1:length(Buses) if Buses[i].number == gen_raw[gen,:Bus_ID]]
            Generators_dict["Storage"][gen_raw[gen,1]] = Dict{String,Any}("name" => gen_raw[gen,1],
                                            "available" => true, # change from staus to available
                                            "bus" => bus_id[1],
                                            "energy" => 0.0,
                                            "capacity" => @NT(min=float(gen_raw[gen,12]),max=float(gen_raw[gen,11])),
                                            "realpower" => 0.0,
                                            "inputrealpowerlimit" => 0.0,
                                            "outputrealpowerlimit" => 0.0,
                                            "efficiency" => @NT(in= 0.0, out = 0.0),
                                            "reactivepower" => 0.0,
                                            "reactivepowerlimits" => @NT(min = 0.0, max = 0.0),
                                            )
        end
    end
    return Generators_dict
end

## - Parse Dict to Array
function gen_dict_parser(dict::Dict{String,Any})
    Generators =Array{PowerSystems.Generator}(0)
    Storage_gen =Array{PowerSystems.Storage}(0)
    for (gen_type_key,gen_type_dict) in dict
        if gen_type_key =="Thermal"
            for (thermal_key,thermal_dict) in gen_type_dict
                push!(Generators,PowerSystems.ThermalDispatch(thermal_dict["name"],
                                                            thermal_dict["available"],
                                                            thermal_dict["bus"],
                                                            TechThermal(thermal_dict["tech"]["realpower"],
                                                                        thermal_dict["tech"]["realpowerlimits"],
                                                                        thermal_dict["tech"]["reactivepower"],
                                                                        thermal_dict["tech"]["reactivepowerlimits"],
                                                                        thermal_dict["tech"]["ramplimits"],
                                                                        thermal_dict["tech"]["timelimits"]),
                                                            EconThermal(thermal_dict["econ"]["capacity"],
                                                                        thermal_dict["econ"]["variablecost"],
                                                                        thermal_dict["econ"]["fixedcost"],
                                                                        thermal_dict["econ"]["startupcost"],
                                                                        thermal_dict["econ"]["shutdncost"],
                                                                        thermal_dict["econ"]["annualcapacityfactor"])
                            ))
            end
        elseif gen_type_key =="Hydro"
            for (hydro_key,hydro_dict) in gen_type_dict
                push!(Generators,PowerSystems.HydroCurtailment(hydro_dict["name"],
                                                            hydro_dict["available"],
                                                            hydro_dict["bus"],
                                                            TechHydro(  hydro_dict["tech"]["installedcapacity"],
                                                                        hydro_dict["tech"]["realpower"],
                                                                        hydro_dict["tech"]["realpowerlimits"],
                                                                        hydro_dict["tech"]["reactivepower"],
                                                                        hydro_dict["tech"]["reactivepowerlimits"],
                                                                        hydro_dict["tech"]["ramplimits"],
                                                                        hydro_dict["tech"]["timelimits"]),
                                                            hydro_dict["econ"]["curtailcost"],
                                                            hydro_dict["scalingfactor"]
                            ))
            end
        elseif gen_type_key =="Renewable"
            for (ren_key,ren_dict) in  gen_type_dict  
                if ren_key == "PV"
                    for (pv_key,pv_dict) in ren_dict
                        push!(Generators,PowerSystems.RenewableCurtailment(pv_dict["name"],
                                                                    pv_dict["available"],
                                                                    pv_dict["bus"],
                                                                    pv_dict["tech"]["installedcapacity"],
                                                                    EconRenewable(pv_dict["econ"]["curtailcost"],
                                                                                pv_dict["econ"]["interruptioncost"]),
                                                                    pv_dict["scalingfactor"]
                                    ))
                    end
                elseif ren_key == "RTPV"
                    for (rtpv_key,rtpv_dict) in ren_dict
                        push!(Generators,PowerSystems.RenewableFix(rtpv_dict["name"],
                                                                    rtpv_dict["available"],
                                                                    rtpv_dict["bus"],
                                                                    rtpv_dict["tech"]["installedcapacity"],
                                                                    rtpv_dict["scalingfactor"]
                                    ))
                    end
                elseif ren_key == "WIND"
                    for (wind_key,wind_dict) in ren_dict
                        push!(Generators,PowerSystems.RenewableCurtailment(wind_dict["name"],
                                                                    wind_dict["available"],
                                                                    wind_dict["bus"],
                                                                    wind_dict["tech"]["installedcapacity"],
                                                                    EconRenewable(wind_dict["econ"]["curtailcost"],
                                                                                wind_dict["econ"]["interruptioncost"]),
                                                                    wind_dict["scalingfactor"]
                                    ))
                    end
                end
            end
        elseif gen_type_key =="Storage"
            for (storage_key,storage_dict) in  gen_type_dict 
                push!(Storage_gen,PowerSystems.GenericBattery(storage_dict["name"],
                                                            storage_dict["available"],
                                                            storage_dict["bus"],
                                                            storage_dict["energy"],
                                                            storage_dict["capacity"],
                                                            storage_dict["realpower"],
                                                            storage_dict["inputrealpowerlimit"],
                                                            storage_dict["outputrealpowerlimit"],
                                                            storage_dict["efficiency"],
                                                            storage_dict["reactivepower"],
                                                            storage_dict["reactivepowerlimits"]
                            ))
            end
        end
    end
    return Generators, Storage_gen
end

# - Parse Json_dict to Struct

function gen_json_parser(dict::Dict{String,Any})
    Generators =Array{PowerSystems.Generator}(0)
    Storage_gen =Array{PowerSystems.Storage}(0)
    for (gen_type_key,gen_type_dict) in dict
        if gen_type_key =="Thermal"
            for (thermal_key,thermal_dict) in gen_type_dict
                push!(Generators,PowerSystems.ThermalDispatch(thermal_dict["name"],
                                                            thermal_dict["available"],
                                                            PowerSystems.Bus(thermal_dict["bus"]["number"],
                                                                            thermal_dict["bus"]["name"],
                                                                            thermal_dict["bus"]["bustype"],
                                                                            thermal_dict["bus"]["angle"],
                                                                            thermal_dict["bus"]["voltage"],
                                                                            @NT(min =thermal_dict["bus"]["voltagelimits"]["min"],max=thermal_dict["bus"]["voltagelimits"]["max"]),
                                                                            thermal_dict["bus"]["basevoltage"] ),
                                                            TechThermal(thermal_dict["tech"]["realpower"],
                                                                        @NT(min =thermal_dict["tech"]["realpowerlimits"]["min"],max =thermal_dict["tech"]["realpowerlimits"]["max"]),
                                                                        thermal_dict["tech"]["reactivepower"],
                                                                        @NT(min =thermal_dict["tech"]["reactivepowerlimits"]["min"],max =thermal_dict["tech"]["reactivepowerlimits"]["min"]),
                                                                        @NT(up=thermal_dict["tech"]["ramplimits"]["up"],down=thermal_dict["tech"]["ramplimits"]["down"]),
                                                                        @NT(up=thermal_dict["tech"]["timelimits"]["up"],down=thermal_dict["tech"]["timelimits"]["down"])),
                                                            EconThermal(thermal_dict["econ"]["capacity"],
                                                                        json_var_cost(thermal_dict["econ"]["variablecost"]),
                                                                        thermal_dict["econ"]["fixedcost"],
                                                                        thermal_dict["econ"]["startupcost"],
                                                                        thermal_dict["econ"]["shutdncost"],
                                                                        thermal_dict["econ"]["annualcapacityfactor"])
                            ))
            end
        elseif gen_type_key =="Hydro"
            for (hydro_key,hydro_dict) in gen_type_dict
                push!(Generators,PowerSystems.HydroCurtailment(hydro_dict["name"],
                                                            hydro_dict["available"],
                                                            PowerSystems.Bus(hydro_dict["bus"]["number"],
                                                                            hydro_dict["bus"]["name"],
                                                                            hydro_dict["bus"]["bustype"],
                                                                            hydro_dict["bus"]["angle"],
                                                                            hydro_dict["bus"]["voltage"],
                                                                            @NT(min =hydro_dict["bus"]["voltagelimits"]["min"],max=hydro_dict["bus"]["voltagelimits"]["max"]),
                                                                            hydro_dict["bus"]["basevoltage"] ),
                                                            TechHydro(  hydro_dict["tech"]["installedcapacity"],
                                                                        hydro_dict["tech"]["realpower"],
                                                                        @NT(min =hydro_dict["tech"]["realpowerlimits"]["min"],max =hydro_dict["tech"]["realpowerlimits"]["max"]),
                                                                        hydro_dict["tech"]["reactivepower"],
                                                                        @NT(min =hydro_dict["tech"]["reactivepowerlimits"]["min"],max =hydro_dict["tech"]["reactivepowerlimits"]["max"]),
                                                                        @NT(up=hydro_dict["tech"]["ramplimits"]["up"],down=hydro_dict["tech"]["ramplimits"]["down"]),
                                                                        @NT(up=hydro_dict["tech"]["timelimits"]["up"],down=hydro_dict["tech"]["timelimits"]["down"])),
                                                            hydro_dict["econ"]["curtailcost"],
                                                            dict_to_timearray(hydro_dict["scalingfactor"])
                            ))
            end
        elseif gen_type_key =="Renewable"
            for (ren_key,ren_dict) in  gen_type_dict  
                if ren_key == "PV"
                    for (pv_key,pv_dict) in ren_dict
                        push!(Generators,PowerSystems.RenewableCurtailment(pv_dict["name"],
                                                                    pv_dict["available"],
                                                                    PowerSystems.Bus(pv_dict["bus"]["number"],
                                                                            pv_dict["bus"]["name"],
                                                                            pv_dict["bus"]["bustype"],
                                                                            pv_dict["bus"]["angle"],
                                                                            pv_dict["bus"]["voltage"],
                                                                            @NT(min =pv_dict["bus"]["voltagelimits"]["min"],max=pv_dict["bus"]["voltagelimits"]["max"]),
                                                                            pv_dict["bus"]["basevoltage"] ),
                                                                    pv_dict["tech"]["installedcapacity"],
                                                                    EconRenewable(pv_dict["econ"]["curtailcost"],
                                                                                pv_dict["econ"]["interruptioncost"]),
                                                                    dict_to_timearray(pv_dict["scalingfactor"])
                                    ))
                    end
                elseif ren_key == "RTPV"
                    for (rtpv_key,rtpv_dict) in ren_dict
                        push!(Generators,PowerSystems.RenewableFix(rtpv_dict["name"],
                                                                    rtpv_dict["available"],
                                                                    PowerSystems.Bus(rtpv_dict["bus"]["number"],
                                                                            rtpv_dict["bus"]["name"],
                                                                            rtpv_dict["bus"]["bustype"],
                                                                            rtpv_dict["bus"]["angle"],
                                                                            rtpv_dict["bus"]["voltage"],
                                                                            @NT(min =rtpv_dict["bus"]["voltagelimits"]["min"],max=rtpv_dict["bus"]["voltagelimits"]["max"]),
                                                                            rtpv_dict["bus"]["basevoltage"] ),
                                                                    rtpv_dict["tech"]["installedcapacity"],
                                                                    dict_to_timearray(rtpv_dict["scalingfactor"])
                                    ))
                    end
                elseif ren_key == "WIND"
                    for (wind_key,wind_dict) in ren_dict
                        push!(Generators,PowerSystems.RenewableCurtailment(wind_dict["name"],
                                                                    wind_dict["available"],
                                                                    PowerSystems.Bus(wind_dict["bus"]["number"],
                                                                            wind_dict["bus"]["name"],
                                                                            wind_dict["bus"]["bustype"],
                                                                            wind_dict["bus"]["angle"],
                                                                            wind_dict["bus"]["voltage"],
                                                                            @NT(min =wind_dict["bus"]["voltagelimits"]["min"],max=wind_dict["bus"]["voltagelimits"]["max"]),
                                                                            wind_dict["bus"]["basevoltage"] ),
                                                                    wind_dict["tech"]["installedcapacity"],
                                                                    EconRenewable(wind_dict["econ"]["curtailcost"],
                                                                                wind_dict["econ"]["interruptioncost"]),
                                                                    dict_to_timearray(wind_dict["scalingfactor"])
                                    ))
                    end
                end
            end
        elseif gen_type_key =="Storage"
            for (storage_key,storage_dict) in  gen_type_dict 
                push!(Storage_gen,PowerSystems.GenericBattery(storage_dict["name"],
                                                            storage_dict["available"],
                                                            PowerSystems.Bus(storage_dict["bus"]["number"],
                                                                            storage_dict["bus"]["name"],
                                                                            storage_dict["bus"]["bustype"],
                                                                            storage_dict["bus"]["angle"],
                                                                            storage_dict["bus"]["voltage"],
                                                                            @NT(min =storage_dict["bus"]["voltagelimits"]["min"],max=storage_dict["bus"]["voltagelimits"]["max"]),
                                                                            storage_dict["bus"]["basevoltage"] ),
                                                            storage_dict["energy"],
                                                            @NT(min=storage_dict["capacity"]["min"],max=storage_dict["capacity"]["max"]),
                                                            storage_dict["realpower"],
                                                            storage_dict["inputrealpowerlimit"],
                                                            storage_dict["outputrealpowerlimit"],
                                                            @NT(in =storage_dict["efficiency"]["in"],out=storage_dict["efficiency"]["out"]),
                                                            storage_dict["reactivepower"],
                                                            @NT(min=storage_dict["reactivepowerlimits"]["min"],max=storage_dict["reactivepowerlimits"]["max"])
                            ))
            end
        end
    end
    return Generators, Storage_gen
end

###########
#Branch data parser
###########

## - Parse CSV to Dict

function branch_csv_parser(branch_raw,Buses)
    Branches_dict = Dict{String,Any}()
    Branches_dict["Transformers"] = Dict{String,Any}()
    Branches_dict["Lines"] = Dict{String,Any}()
    for i in 1:length(branch_raw)
        bus_f = [Buses[f] for f in 1:length(Buses) if Buses[f].number == branch_raw[i,2]]
        bus_t = [Buses[t] for t in 1:length(Buses) if Buses[t].number == branch_raw[i,3]]
        if branch_raw[i,:Tr_Ratio] > 0.0
            Branches_dict["Transformers"][branch_raw[i,1]] = Dict{String,Any}("name" => branch_raw[i,1],
                                                        "available" => true,
                                                        "connectionpoints" => @NT(from=bus_f[1],to=bus_t[1]),
                                                        "r" => branch_raw[i,4],
                                                        "x" => branch_raw[i,5],
                                                        "zb" => @NT(primary=branch_raw[i,6],secondary=branch_raw[i,6]),#TODO: divide by 2 ?
                                                        "tap" => branch_raw[i,:Tr_Ratio],
                                                        "rate" => branch_raw[i,7]
                                                        )                 
        else
            Branches_dict["Lines"][branch_raw[i,1]] = Dict{String,Any}("name" => branch_raw[i,1],
                                                        "available" => true,
                                                        "connectionpoints" => @NT(from=bus_f[1],to=bus_t[1]),
                                                        "r" => branch_raw[i,4],
                                                        "x" => branch_raw[i,5],
                                                        "b" => @NT(from=branch_raw[i,6],to=branch_raw[i,6]),#TODO: divide by 2 
                                                        "rate" =>  branch_raw[i,7],
                                                        "anglelimits" => nothing
                                                        )

        end
    end
    return Branches_dict
end

# - Parse Dict to Array

function branch_dict_parser(dict)
    Branches = Array{PowerSystems.Branch}(0)
    for (branch_key,branch_dict) in dict
        if branch_key == "Transformers"
            for (trans_key,trans_dict) in branch_dict
                push!(Branches,Transformer2W(trans_dict["name"],
                                            trans_dict["available"],
                                            trans_dict["connectionpoints"],
                                            trans_dict["r"],
                                            trans_dict["x"],
                                            trans_dict["zb"],
                                            trans_dict["tap"],
                                            trans_dict["rate"]
                                            ))
            end
        else branch_key == "Lines"
            for (line_key,line_dict) in branch_dict
                push!(Branches,Line(line_dict["name"],
                                    line_dict["available"],
                                    line_dict["connectionpoints"],
                                    line_dict["r"],
                                    line_dict["x"],
                                    line_dict["b"],
                                    line_dict["rate"],
                                    line_dict["anglelimits"]
                                    ))
            end
        end
    end
    return Branches
end

# - Parse Json dict to Struct

function branch_json_parser(dict)
    Branches = Array{PowerSystems.Branch}(0)
    for (branch_key,branch_dict) in dict
        if branch_key == "Transformers"
            for (trans_key,trans_dict) in branch_dict
                bus_f =PowerSystems.Bus(trans_dict["connectionpoints"]["from"]["number"],
                                        trans_dict["connectionpoints"]["from"]["name"],
                                        trans_dict["connectionpoints"]["from"]["bustype"],
                                        trans_dict["connectionpoints"]["from"]["angle"],
                                        trans_dict["connectionpoints"]["from"]["voltage"],
                                        @NT(min =trans_dict["connectionpoints"]["from"]["voltagelimits"]["min"],max=trans_dict["connectionpoints"]["from"]["voltagelimits"]["max"]),
                                        trans_dict["connectionpoints"]["from"]["basevoltage"] )
                bus_t =PowerSystems.Bus(trans_dict["connectionpoints"]["to"]["number"],
                                        trans_dict["connectionpoints"]["to"]["name"],
                                        trans_dict["connectionpoints"]["to"]["bustype"],
                                        trans_dict["connectionpoints"]["to"]["angle"],
                                        trans_dict["connectionpoints"]["to"]["voltage"],
                                        @NT(min =trans_dict["connectionpoints"]["to"]["voltagelimits"]["min"],max=trans_dict["connectionpoints"]["to"]["voltagelimits"]["max"]),
                                        trans_dict["connectionpoints"]["to"]["basevoltage"] )
                push!(Branches,Transformer2W(trans_dict["name"],
                                            trans_dict["available"],
                                            @NT(from = bus_f,to = bus_t),
                                            trans_dict["r"],
                                            trans_dict["x"],
                                            @NT(primary =trans_dict["zb"]["primary"],secondary =trans_dict["zb"]["secondary"]),
                                            trans_dict["tap"],
                                            trans_dict["rate"]
                                            ))
            end
        elseif branch_key == "Lines"
            for (line_key,line_dict) in branch_dict
                bus_t =PowerSystems.Bus(line_dict["connectionpoints"]["to"]["number"],
                                        line_dict["connectionpoints"]["to"]["name"],
                                        line_dict["connectionpoints"]["to"]["bustype"],
                                        line_dict["connectionpoints"]["to"]["angle"],
                                        line_dict["connectionpoints"]["to"]["voltage"],
                                        @NT(min =line_dict["connectionpoints"]["to"]["voltagelimits"]["min"],max=line_dict["connectionpoints"]["to"]["voltagelimits"]["max"]),
                                        line_dict["connectionpoints"]["to"]["basevoltage"] )
                bus_f =PowerSystems.Bus(line_dict["connectionpoints"]["from"]["number"],
                                        line_dict["connectionpoints"]["from"]["name"],
                                        line_dict["connectionpoints"]["from"]["bustype"],
                                        line_dict["connectionpoints"]["from"]["angle"],
                                        line_dict["connectionpoints"]["from"]["voltage"],
                                        @NT(min =line_dict["connectionpoints"]["from"]["voltagelimits"]["min"],max=line_dict["connectionpoints"]["from"]["voltagelimits"]["max"]),
                                        line_dict["connectionpoints"]["from"]["basevoltage"] )
                push!(Branches,Line(line_dict["name"],
                                    line_dict["available"],
                                    @NT(from = bus_f, to = bus_t),
                                    line_dict["r"],
                                    line_dict["x"],
                                    @NT(from =line_dict["b"]["from"],to=line_dict["b"]["to"]),
                                    line_dict["rate"],
                                    line_dict["anglelimits"]
                                    ))
            end
        end
    end
    return Branches
end

###########
#Load data parser
###########

#- Parse CSV to Dict

function load_csv_parser(load_raw,bus_raw,Buses)
    Loads_dict = Dict{String,Any}()
    Peak_p1=sum(bus_raw[(bus_raw[:11] .== 1),5])
    Peak_p2=sum(bus_raw[(bus_raw[:11] .== 2),5])
    Peak_p3=sum(bus_raw[(bus_raw[:11] .== 3),5])
    DayAhead  = collect(DateTime("1/1/2024  0:00:00", "d/m/y  H:M:S"):Hour(1):DateTime("31/12/2024  23:00:00", "d/m/y  H:M:S"))
    for b in Buses
        p = [bus_raw[n,5] for n in 1:nrow(bus_raw) if bus_raw[n,1] == b.number]
        q = [bus_raw[m,6] for m in 1:nrow(bus_raw) if bus_raw[m,1] == b.number] 
        region = [bus_raw[r,:11] for r in 1:nrow(bus_raw) if bus_raw[r,1] == b.number]
        if region[1] ==1
            ts_raw = load_raw[:,5]*(p[1]/Peak_p1)
        elseif region[1] ==2
            ts_raw = load_raw[:,6]*(p[1]/Peak_p2)
        elseif region[1] ==3
            ts_raw = load_raw[:,7]*(p[1]/Peak_p3)
        end
        Loads_dict[b.name] = Dict{String,Any}("name" => b.name,
                                            "available" => true,
                                            "bus" => b,
                                            "model" => "P",
                                            "maxrealpower" => p[1],
                                            "maxreactivepower" => q[1],
                                            "scalingfactor" => TimeSeries.TimeArray(DayAhead,ts_raw)
                                            )
    end
    return Loads_dict
end

## - Parse Dict to Array

function load_dict_parser(dict)
    Loads =Array{PowerSystems.ElectricLoad}(0)
    for (load_key,load_dict) in dict
        push!(Loads,StaticLoad(load_dict["name"],
                load_dict["available"],
                load_dict["bus"],
                load_dict["model"],
                load_dict["maxrealpower"],
                load_dict["maxreactivepower"],
                load_dict["scalingfactor"]
                ))
    end
    return Loads
end

# - Parse Json dict to Struct

function load_json_parser(dict)
    Loads =Array{PowerSystems.ElectricLoad}(0)
    for (load_key,load_dict) in dict
        push!(Loads,StaticLoad(load_dict["name"],
                load_dict["available"],
                PowerSystems.Bus(load_dict["bus"]["number"],
                                load_dict["bus"]["name"],
                                load_dict["bus"]["bustype"],
                                load_dict["bus"]["angle"],
                                load_dict["bus"]["voltage"],
                                @NT(min =load_dict["bus"]["voltagelimits"]["min"],max=load_dict["bus"]["voltagelimits"]["max"]),
                                load_dict["bus"]["basevoltage"] ),
                load_dict["model"],
                load_dict["maxrealpower"],
                load_dict["maxreactivepower"],
                dict_to_timearray(load_dict["scalingfactor"])
                ))
    end
    return Loads
end

#########
# Other Parsing function 
#########

# Write dict to json file
function dict_to_json(dict,filename)
    stringdata =JSON.json(dict, 3)
    open("$filename.json", "w") do f
        write(f, stringdata)
    end
end

# Remove missing values form dataframes 
function remove_missing(df)
    for col in names(df)
        df[ismissing.(df[col]), col] = 0
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
        temp=JSON.parse(dicttxt)  # parse and transform data
        data =temp
        end
        
    else
        println("JSON file doesn't exist")
    end
    Buses = PowerSystems.bus_json_parse(data["Buses"])
    Generators,Storages = PowerSystems.gen_json_parser(data["Generators"])
    Branches = PowerSystems.branch_json_parser(data["Branches"])
    Loads = PowerSystems.load_json_parser(data["Loads"]);
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
    ts_raw =TimeSeries.TimeArray(DateTime(ts_string),ts_values)
    return ts_raw
end
