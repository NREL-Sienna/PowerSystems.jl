# Global method definition needs to be at top level in .7
# Convert bool to int
Base.convert(::Type{Bool}, x::Int) = x==0 ? false : x==1 ? true : throw(Inexacterror())
#############################################

function ps_dict2ps_struct(data::Dict{String,Any})
    """
    Takes a PowerSystems dictionary and return an array of PowerSystems struct for Bus, Generator, Branch and load
    """
    Generators = Array{G where {G<:Generator},1}()
    Storages = Array{S where {S<:Storage},1}()
    Buses =Array{Bus,1}()
    Branches = Array{B where {B<:Branch},1}()
    Loads =Array{E where {E<:ElectricLoad},1}()
    Shunts =Array{FixedAdmittance,1}()
    LoadZones =Array{D where {D<:PowerSystemDevice},1}()

    haskey(data, "bus") ? Buses = bus_dict_parse(data["bus"]) : @error("Key error : key 'bus' not found in PowerSystems dictionary, this will result in an empty Bus array")
    haskey(data, "gen") ? (Generators, Storages) = gen_dict_parser(data["gen"]) : @error("Key error : key 'gen' not found in PowerSystems dictionary, this will result in an empty Generators and Storage array")
    haskey(data, "branch") ? Branches = branch_dict_parser(data["branch"],Branches) : @warn("Key error : key 'branch' not found in PowerSystems dictionary, this will result in an empty Branches array")
    haskey(data, "load") ? Loads = load_dict_parser(data["load"]) : @error("Key error : key 'load'  not found in PowerSystems dictionary, this will result in an empty Loads array")
    haskey(data, "loadzone") ? LoadZones = loadzone_dict_parser(data["loadzone"]) : @info("Key error : key 'loadzone'  not found in PowerSystems dictionary, this will result in an empty LoadZones array")
    haskey(data, "shunt") ? Shunts = shunt_dict_parser(data["shunt"]) : @info("Key error : key 'shunt'  not found in PowerSystems dictionary, this will result in an empty Shunts array")
    haskey(data, "dcline") ? Branches = dclines_dict_parser(data["dcline"],Branches) : @info("Key error : key 'dcline'  not found in PowerSystems dictionary, this will result in an empty DCLines array")
    return sort!(Buses, by = x -> x.number), Generators, Storages,  sort!(Branches, by = x -> x.connectionpoints.from.number), Loads, LoadZones, Shunts
end



function add_realtime_ts(data::Dict{String,Any},time_series::Dict{String,Any})
    """
    Args:
        PowerSystems dictionary
        Dictionary of timeseries dataframes
    Returns:
        PowerSystems dictionary with timerseries component added
    """
    if haskey(data,"gen")
        if haskey(data["gen"],"Hydro") & haskey(time_series,"HYDRO")
            data["gen"]["Hydro"] = add_time_series(data["gen"]["Hydro"],time_series["HYDRO"]["RT"])
        end
        if haskey(data["gen"],"Renewable")
            if haskey(data["gen"]["Renewable"],"PV") & haskey(time_series,"PV")
                data["gen"]["Renewable"]["PV"] = add_time_series(data["gen"]["Renewable"]["PV"],time_series["PV"]["RT"])
            end
            if haskey(data["gen"]["Renewable"],"RTPV") & haskey(time_series,"RTPV")
                data["gen"]["Renewable"]["RTPV"] = add_time_series(data["gen"]["Renewable"]["RTPV"],time_series["RTPV"]["RT"])
            end
            if haskey(data["gen"]["Renewable"],"WIND") & haskey(time_series,"WIND")
                data["gen"]["Renewable"]["WIND"] = add_time_series(data["gen"]["Renewable"]["WIND"],time_series["WIND"]["RT"])
            end
        end
    end
    if haskey(data,"load") & haskey(time_series,"Load")
        data["load"] = add_time_series_load(data,time_series["Load"]["RT"])
    end
    return data
end


function read_datetime(df; kwargs...)
    """
    Arg:
        Dataframes which includes a timerseries columns of either:
            Year, Month, Day, Period 
          or
            DateTime
          or
            nothing (creates a today referenced DateTime Column)
    Returns:
        Dataframe with a DateTime columns
    """
    if [c for c in [:Year,:Month,:Day,:Period] if c in names(df)] == [:Year,:Month,:Day,:Period]
        if Hour(DataFrames.maximum(df[:Period])) <= Hour(25)
            df[:DateTime] = collect(DateTime(df[1,:Year],df[1,:Month],df[1,:Day],(df[1,:Period]-1)) :Hour(1) :
                            DateTime(df[end,:Year],df[end,:Month],df[end,:Day],(df[end,:Period]-1)))
        elseif (Minute(5) * DataFrames.maximum(df[:Period]) >= Minute(1440))& (Minute(5) * DataFrames.maximum(df[:Period]) <= Minute(1500))
            df[:DateTime] = collect(DateTime(df[1,:Year],df[1,:Month],df[1,:Day],floor(df[1,:Period]/12),Int(df[1,:Period])-1) :Minute(5) :
                            DateTime(df[end,:Year],df[end,:Month],df[end,:Day],floor(df[end,:Period]/12)-1,5*(Int(df[end,:Period])-(floor(df[end,:Period]/12)-1)*12) -5))
        else
            error("I don't know what the period length is, reformat timeseries")
        end

        delete!(df, [:Year,:Month,:Day,:Period])

    elseif :DateTime in names(df)
        df[:DateTime] = Datetime(df[:DateTime])
    else 
        if :startdatetime in keys(kwargs)
            startdatetime = kwargs[:startdatetime]
        else
            @warn("No reference date given, assuming today")
            startdatetime = today()
        end
        df[:DateTime] = collect(DateTime(startdatetime):Hour(1):DateTime(startdatetime)+Hour(size(df)[1]-1))
    end
    return df
end

function add_time_series(Device_dict::Dict{String,Any}, df::DataFrames.DataFrame)
    """
    Arg:
        Device dictionary - Generators
        Dataframe contains device Realtime/Forecast TimeSeries
    Returns:
        Device dictionary with timeseries added
    """
    for (device_key,device) in Device_dict
        if device_key in convert(Array{String},names(df))
            ts_raw = df[:,Symbol(device_key)]
            Device_dict[device_key]["scalingfactor"] = TimeSeries.TimeArray(df[:DateTime],ts_raw)
        end
    end
    return Device_dict
end

function add_time_series_load(data::Dict{String,Any}, df::DataFrames.DataFrame)
    """
    Arg:
        Load dictionary
        LoadZones dictionary
        Dataframe contains device Realtime/Forecast TimeSeries
    Returns:
        Device dictionary with timeseries added
    """
    load_dict = data["load"]
    if "loadzone" in keys(data)
        load_zone_dict = data["loadzone"]
        for (l_key,l) in load_dict
            for (lz_key,lz) in load_zone_dict
                if l["bus"] in lz["buses"]
                    ts_raw = df[:,lz_key]*(l["maxactivepower"]/lz["maxactivepower"])
                    load_dict[l_key]["scalingfactor"] = TimeSeries.TimeArray(df[:DateTime],ts_raw)
                end
            end
        end
    else
        for (l_key,l) in load_dict
            load_dict[l_key]["scalingfactor"] = TimeSeries.TimeArray(df[:DateTime],df[:,l_key])
        end
    end
    return load_dict
end

## - Parse Dict to Struct
function bus_dict_parse(dict::Dict{Int,Any})
    Buses = [Bus(b["number"],b["name"], b["bustype"],b["angle"],b["voltage"],b["voltagelimits"],b["basevoltage"]) for (k_b,b) in dict ]
    return Buses
end


## - Parse Dict to Array
function gen_dict_parser(dict::Dict{String,Any})
    Generators = Array{G where {G<:Generator},1}()
    Storage_gen = Array{S where {S<:Storage},1}()
    for (gen_type_key,gen_type_dict) in dict
        if gen_type_key =="Thermal"
            for (thermal_key,thermal_dict) in gen_type_dict
                push!(Generators,ThermalDispatch(convert(String,thermal_dict["name"]),
                                                            convert(Bool, thermal_dict["available"]),
                                                            thermal_dict["bus"],
                                                            TechThermal(thermal_dict["tech"]["activepower"],
                                                                        thermal_dict["tech"]["activepowerlimits"],
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
                push!(Generators,HydroCurtailment(convert(String,hydro_dict["name"]),
                                                            hydro_dict["available"],
                                                            hydro_dict["bus"],
                                                            TechHydro(  hydro_dict["tech"]["installedcapacity"],
                                                                        hydro_dict["tech"]["activepower"],
                                                                        hydro_dict["tech"]["activepowerlimits"],
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
                        push!(Generators,RenewableCurtailment(convert(String,pv_dict["name"]),
                                                                    convert(Bool, pv_dict["available"]),
                                                                    pv_dict["bus"],
                                                                    pv_dict["tech"]["installedcapacity"],
                                                                    EconRenewable(pv_dict["econ"]["curtailcost"],
                                                                                pv_dict["econ"]["interruptioncost"]),
                                                                    pv_dict["scalingfactor"]
                                    ))
                    end
                elseif ren_key == "RTPV"
                    for (rtpv_key,rtpv_dict) in ren_dict
                        push!(Generators,RenewableFix(convert(String,rtpv_dict["name"]),
                                                                    convert(Bool,rtpv_dict["available"]),
                                                                    rtpv_dict["bus"],
                                                                    rtpv_dict["tech"]["installedcapacity"],
                                                                    rtpv_dict["scalingfactor"]
                                    ))
                    end
                elseif ren_key == "WIND"
                    for (wind_key,wind_dict) in ren_dict
                        push!(Generators,RenewableCurtailment(convert(String,wind_dict["name"]),
                                                                    convert(Bool,wind_dict["available"]),
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
                push!(Storage_gen,GenericBattery(convert(String,storage_dict["name"]),
                                                            convert(Bool,storage_dict["available"]),
                                                            storage_dict["bus"],
                                                            storage_dict["energy"],
                                                            storage_dict["capacity"],
                                                            storage_dict["activepower"],
                                                            storage_dict["inputactivepowerlimit"],
                                                            storage_dict["outputactivepowerlimit"],
                                                            storage_dict["efficiency"],
                                                            storage_dict["reactivepower"],
                                                            storage_dict["reactivepowerlimits"]
                            ))
            end
        end
    end
    return (Generators, Storage_gen)
end

# - Parse Dict to Array

function branch_dict_parser(dict::Dict{String,Any},Branches::Array{B,1}) where {B<:Branch}
    for (branch_key,branch_dict) in dict
        if branch_key == "Transformers"
            for (trans_key,trans_dict) in branch_dict
                if trans_dict["tap"] ==1.0
                    push!(Branches,Transformer2W(convert(String,trans_dict["name"]),
                                                convert(Bool,trans_dict["available"]),
                                                trans_dict["connectionpoints"],
                                                trans_dict["r"],
                                                trans_dict["x"],
                                                trans_dict["primaryshunt"],
                                                trans_dict["rate"]
                                                ))
                elseif trans_dict["tap"] !=1.0
                    if trans_dict["α"] !=0.0 #TODO : 3W Transformer
                        push!(Branches,PhaseShiftingTransformer(convert(String,trans_dict["name"]),
                                                    convert(Bool,trans_dict["available"]),
                                                    trans_dict["connectionpoints"],
                                                    trans_dict["r"],
                                                    trans_dict["x"],
                                                    trans_dict["primaryshunt"],
                                                    trans_dict["tap"],
                                                    trans_dict["α"],
                                                    trans_dict["rate"]
                                                    ))
                    else
                        push!(Branches,TapTransformer(convert(String,trans_dict["name"]),
                                                    convert(Bool,trans_dict["available"]),
                                                    trans_dict["connectionpoints"],
                                                    trans_dict["r"],
                                                    trans_dict["x"],
                                                    trans_dict["primaryshunt"],
                                                    trans_dict["tap"],
                                                    trans_dict["rate"]
                                                    ))
                    end
                end
            end
        else branch_key == "Lines"
            for (line_key,line_dict) in branch_dict
                push!(Branches,Line(convert(String,line_dict["name"]),
                                    convert(Bool,line_dict["available"]),
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


function load_dict_parser(dict::Dict{String,Any})
    Loads =Array{L where {L<:ElectricLoad},1}()
    for (load_key,load_dict) in dict
        push!(Loads,StaticLoad(convert(String,load_dict["name"]),
                convert(Bool,load_dict["available"]),
                load_dict["bus"],
                load_dict["model"],
                load_dict["maxactivepower"],
                load_dict["maxreactivepower"],
                load_dict["scalingfactor"]
                ))
    end
    return Loads
end

function loadzone_dict_parser(dict::Dict{Int64,Any})
    LoadZs =Array{D where {D<:PowerSystemDevice},1}()
    for (lz_key,lz_dict) in dict
        push!(LoadZs,LoadZones(lz_dict["number"],
                                convert(String,lz_dict["name"]),
                                lz_dict["buses"],
                                lz_dict["maxactivepower"],
                                lz_dict["maxreactivepower"]
                                ))
    end
    return LoadZs
end

function shunt_dict_parser(dict::Dict{String,Any})
    Shunts = Array{FixedAdmittance,1}()
    for (s_key,s_dict) in dict
        push!(Shunts,FixedAdmittance(convert(String,s_dict["name"]),
                            convert(Bool,s_dict["available"]),
                            s_dict["bus"],
                            s_dict["Y"]
                            )
            )
    end
    return Shunts
end


function dclines_dict_parser(dict::Dict{String,Any},Branches::Array{Branch,1})
    for (dcl_key,dcl_dict) in dict
        push!(Branches,HVDCLine(convert(String,dcl_dict["name"]),
                            convert(Bool,dcl_dict["available"]),
                            dcl_dict["connectionpoints"],
                            dcl_dict["activepowerlimits_from"],
                            dcl_dict["activepowerlimits_to"],
                            dcl_dict["reactivepowerlimits_from"],
                            dcl_dict["reactivepowerlimits_to"],
                            dcl_dict["loss"]
                            ))
    end
    return Branches
end