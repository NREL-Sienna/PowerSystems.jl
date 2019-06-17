# Global method definition needs to be at top level in .7

"""
Takes a PowerSystems dictionary and return an array of PowerSystems struct for
Bus, Generator, Branch and load
"""
function ps_dict2ps_struct(data::Dict{String,Any})
    generators = Array{G where {G<:Generator},1}()
    storages = Array{S where {S<:Storage},1}()
    buses = Array{Bus,1}()
    branches = Array{B where {B<:Branch},1}()
    loads = Array{E where {E<:ElectricLoad},1}()
    shunts = Array{FixedAdmittance,1}()
    loadZones = Array{D where {D<:Device},1}()
    services = Array{S where {S<:Service},1}()

    # TODO: should we raise an exception in the following?

    if haskey(data, "bus")
        buses = PowerSystems.bus_dict_parse(data["bus"])
    else
        @warn "key 'bus' not found in PowerSystems dictionary, this will result in an empty Bus array"
    end
    if haskey(data, "gen")
        (generators, storage) = PowerSystems.gen_dict_parser(data["gen"])
    else
        @warn "key 'gen' not found in PowerSystems dictionary, this will result in an empty Generators and Storage array"
    end
    if haskey(data, "branch")
        branches = PowerSystems.branch_dict_parser(data["branch"], branches)
    else
        @warn "key 'branch' not found in PowerSystems dictionary, this will result in an empty Branches array"
    end
    if haskey(data, "load")
        loads = PowerSystems.load_dict_parser(data["load"])
    else
        @warn "key 'load' not found in PowerSystems dictionary, this will result in an empty Loads array"
    end
    if haskey(data, "loadzone")
        loadZones = PowerSystems.loadzone_dict_parser(data["loadzone"])
    else
        @warn "key 'loadzone' not found in PowerSystems dictionary, this will result in an empty LoadZones array"
    end
    if haskey(data, "shunt")
        shunts = PowerSystems.shunt_dict_parser(data["shunt"])
    else
        @warn "key 'shunt' not found in PowerSystems dictionary, this will result in an empty Shunts array"
    end
    if haskey(data, "dcline")
        branches = PowerSystems.dclines_dict_parser(data["dcline"], branches)
    else
        @warn "key 'dcline' not found in PowerSystems dictionary, this will result in an empty DCLines array"
    end
    if haskey(data, "services")
        services = PowerSystems.services_dict_parser(data["services"],generators)
    else
        @warn "key 'services' not found in PowerSystems dictionary, this will result in an empty services array"
    end
    if haskey(data,"forecasts")
        error("Creating forecasts from a ps_dict is not currently supported")
    else
        forecasts = Vector{Forecast}()
    end

    return sort!(buses, by = x -> x.number), generators, storage,  sort!(branches, by = x -> x.connectionpoints.from.number), loads, loadZones, shunts, forecasts, services

end

"""
Takes a string or symbol "name" and returns a list of devices within a collection
(Dict, Array, PowerSystem) that have matching names"""
function _get_device(name::Union{String,Symbol}, collection, devices = [])
    if isa(collection,Array) && !isempty(collection) && isassigned(collection)
            fn = fieldnames(typeof(collection[1]))
            if :name in fn
                [push!(devices,d) for d in collection if d.name == name]
            end
    elseif isa(collection, Dict) && !isempty(collection)
        for (key, val) in collection
            _get_device(name, val, devices)
        end
    else
        fn = fieldnames(typeof(collection))
        for f in fn
            _get_device(name,getfield(collection,f),devices)
        end
    end
    return devices
end

## - Parse Dict to Struct
function bus_dict_parse(dict::Dict{Int,Any})
    Buses = Vector{Bus}()
    for (k_b, b) in dict
        if b isa Bus
            push!(Buses, b)
        else
            push!(Buses, Bus(b["number"],b["name"], b["bustype"],b["angle"],b["voltage"],b["voltagelimits"],b["basevoltage"]))
        end
    end
    return Buses
end


## - Parse Dict to Array
function gen_dict_parser(dict::Dict{String,Any})
    Generators = Array{G where {G<:Generator},1}()
    Storage_gen = Array{S where {S<:Storage},1}()
    for (gen_type_key,gen_type_dict) in dict
        if gen_type_key =="Thermal"
            for (thermal_key,thermal_dict) in gen_type_dict
                push!(Generators,ThermalStandard(string(thermal_dict["name"]),
                                                            Bool(thermal_dict["available"]),
                                                            thermal_dict["bus"],
                                                            TechThermal(thermal_dict["tech"]["rating"],
                                                                        thermal_dict["tech"]["activepower"],
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
                push!(Generators,HydroDispatch(string(hydro_dict["name"]),
                                                            Bool(hydro_dict["available"]),
                                                            hydro_dict["bus"],
                                                            TechHydro(  hydro_dict["tech"]["rating"],
                                                                        hydro_dict["tech"]["activepower"],
                                                                        hydro_dict["tech"]["activepowerlimits"],
                                                                        hydro_dict["tech"]["reactivepower"],
                                                                        hydro_dict["tech"]["reactivepowerlimits"],
                                                                        hydro_dict["tech"]["ramplimits"],
                                                                        hydro_dict["tech"]["timelimits"]),
                                                            hydro_dict["econ"]["curtailcost"]
                            ))
            end
        elseif gen_type_key =="Renewable"
            for (ren_key,ren_dict) in  gen_type_dict
                if ren_key == "PV"
                    for (pv_key,pv_dict) in ren_dict
                        push!(Generators,RenewableDispatch(string(pv_dict["name"]),
                                                                    Bool( pv_dict["available"]),
                                                                    pv_dict["bus"],
                                                                    pv_dict["tech"]["rating"],
                                                                    EconRenewable(pv_dict["econ"]["curtailcost"],
                                                                                pv_dict["econ"]["interruptioncost"])
                                    ))
                    end
                elseif ren_key == "RTPV"
                    for (rtpv_key,rtpv_dict) in ren_dict
                        push!(Generators,RenewableFix(string(rtpv_dict["name"]),
                                                                    Bool(rtpv_dict["available"]),
                                                                    rtpv_dict["bus"],
                                                                    rtpv_dict["tech"]["rating"]
                                    ))
                    end
                elseif ren_key == "WIND"
                    for (wind_key,wind_dict) in ren_dict
                        push!(Generators,RenewableDispatch(string(wind_dict["name"]),
                                                                    Bool(wind_dict["available"]),
                                                                    wind_dict["bus"],
                                                                    wind_dict["tech"]["rating"],
                                                                    EconRenewable(wind_dict["econ"]["curtailcost"],
                                                                                wind_dict["econ"]["interruptioncost"])
                                    ))
                    end
                end
            end
        elseif gen_type_key =="Storage"
            for (storage_key,storage_dict) in  gen_type_dict
                push!(Storage_gen,GenericBattery(string(storage_dict["name"]),
                                                            Bool(storage_dict["available"]),
                                                            storage_dict["bus"],
                                                            storage_dict["energy"],
                                                            storage_dict["capacity"],
                                                            storage_dict["rating"],
                                                            storage_dict["activepower"],
                                                            storage_dict["inputactivepowerlimits"],
                                                            storage_dict["outputactivepowerlimits"],
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
                    push!(Branches,Transformer2W(string(trans_dict["name"]),
                                                Bool(trans_dict["available"]),
                                                trans_dict["connectionpoints"],
                                                trans_dict["r"],
                                                trans_dict["x"],
                                                trans_dict["primaryshunt"],
                                                trans_dict["rate"]
                                                ))
                elseif trans_dict["tap"] !=1.0
                    alpha = "α" in keys(trans_dict) ? trans_dict["α"] : 0.0
                    if alpha !=0.0 #TODO : 3W Transformer
                        push!(Branches,PhaseShiftingTransformer(string(trans_dict["name"]),
                                                    Bool(trans_dict["available"]),
                                                    trans_dict["connectionpoints"],
                                                    trans_dict["r"],
                                                    trans_dict["x"],
                                                    trans_dict["primaryshunt"],
                                                    trans_dict["tap"],
                                                    trans_dict["α"],
                                                    trans_dict["rate"]
                                                    ))
                    else
                        push!(Branches,TapTransformer(string(trans_dict["name"]),
                                                    Bool(trans_dict["available"]),
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
                push!(Branches,Line(string(line_dict["name"]),
                                    Bool(line_dict["available"]),
                                    line_dict["connectionpoints"],
                                    line_dict["r"],
                                    line_dict["x"],
                                    line_dict["b"],
                                    float(line_dict["rate"]),
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
        push!(Loads,PowerLoad(string(load_dict["name"]),
                Bool(load_dict["available"]),
                load_dict["bus"],
                load_dict["maxactivepower"],
                load_dict["maxreactivepower"]
                ))
    end
    return Loads
end

function loadzone_dict_parser(dict::Dict{Int64,Any})
    LoadZs =Array{D where {D<:Device},1}()
    for (lz_key,lz_dict) in dict
        push!(LoadZs,LoadZones(lz_dict["number"],
                                string(lz_dict["name"]),
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
        push!(Shunts,FixedAdmittance(string(s_dict["name"]),
                            Bool(s_dict["available"]),
                            s_dict["bus"],
                            s_dict["Y"]
                            )
            )
    end
    return Shunts
end


function dclines_dict_parser(dict::Dict{String,Any},Branches::Array{Branch,1})
    for (dct_key,dct_dict) in dict
        if dct_key == "HVDCLine"
            for (dcl_key,dcl_dict) in dct_dict
                push!(Branches,HVDCLine(string(dcl_dict["name"]),
                                    Bool(dcl_dict["available"]),
                                    dcl_dict["connectionpoints"],
                                    dcl_dict["activepowerlimits_from"],
                                    dcl_dict["activepowerlimits_to"],
                                    dcl_dict["reactivepowerlimits_from"],
                                    dcl_dict["reactivepowerlimits_to"],
                                    dcl_dict["loss"]
                                    ))
            end
        elseif dct_key == "VSCDCLine"
            for (dcl_key,dcl_dict) in dct_dict
                push!(Branches,VSCDCLine(string(dcl_dict["name"]),
                                    Bool(dcl_dict["available"]),
                                    dcl_dict["connectionpoints"],
                                    dcl_dict["rectifier_taplimits"],
                                    dcl_dict["rectifier_xrc"],
                                    dcl_dict["rectifier_firingangle"],
                                    dcl_dict["inverter_taplimits"],
                                    dcl_dict["inverter_xrc"],
                                    dcl_dict["inverter_firingangle"]
                                    ))
            end
        end
    end
    return Branches
end


function services_dict_parser(dict::Dict{String,Any},generators::Array{Generator,1})
    Services = Array{D where {D <: Service},1}()

    for (k,d) in dict
        contributingdevices = Array{D where {D<:PowerSystems.Device},1}()
        [PowerSystems._get_device(dev,generators) for dev in d["contributingdevices"]] |> (x->[push!(contributingdevices,d[1]) for d in x if length(d)==1])
        push!(Services,ProportionalReserve(d["name"],
                            contributingdevices,
                            Float64(d["timeframe"])
                            ))
    end
    return Services
end
