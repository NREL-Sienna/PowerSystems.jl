function _get_name_and_csv(path_to_filename)
    df = CSV.File(path_to_filename) |> DataFrames.DataFrame
    folder = splitdir(splitdir(path_to_filename)[1])[2]
    return folder, df
end


# Parser for Forecasts dat files
"""
Read all forecast CSV's in the path provided, the struct of the data should
follow this format
folder : PV
            file : DAY_AHEAD
            file : REAL_TIME
Folder name should be the device type
Files should only contain one real-time and day-ahead forecast
Args:
    files: A string
Returns:
    A dictionary with the CSV files as dataframes and folder names as keys
# TODO : Stochasti/Multiple scenarios
"""
 function read_data_files(rootpath::String; kwargs...)
   if :REGEX_FILE in keys(kwargs)
        REGEX_FILE = kwargs[:REGEX_FILE]
    else
        REGEX_FILE = r"(.*?)\.csv"
    end

    DATA = Dict{String, Any}()
    data = Dict{String, Any}()
    DATA["gen"] = data

    for (root, dirs, files) in walkdir(rootpath)

        for filename in files

            path_to_filename = joinpath(root, filename)
            if match(REGEX_FILE, path_to_filename) != nothing
                folder_name, csv_data = _get_name_and_csv(path_to_filename)
                if folder_name == "load"
                    DATA["load"] = read_datetime(csv_data; kwargs...)
                else
                    data[folder_name] = read_datetime(csv_data; kwargs...)
                end
                @info "Successfully parsed $rootpath"
            else
                @warn "Unable to match regex with $path_to_filename"
            end
        end

    end

    return DATA
end


"""
Args:
    A System struct
    A dictonary of forecasts
Returns:
    A PowerSystems forecast stuct array
"""

function make_forecast_array(sys::Union{System,Array{Component,1}},ts_dict::Dict)
    ts_map = _retrieve(ts_dict, Union{TimeSeries.TimeArray,DataFrames.DataFrame},Dict(),[]) #find key-path to timeseries data fields
    fc = Array{Forecast}(undef, 0)
    for (key,val) in ts_map
        ts = _access(ts_dict,vcat(val,key)) #retrieve timeseries data
        if (typeof(ts)==DataFrames.DataFrame) & (size(ts,2) > 2)
            devices = reduce(vcat,[_get_device(c,sys) for c in string.(names(ts)) if c != "DateTime"]) #retrieve devices from system that are in the timeseries data
            for d in devices
                push!(fc,Deterministic(d,"scalingfactor",TimeSeries.TimeArray(ts.DateTime,ts[Symbol(d.name)]))) # TODO: unhardcode scalingfactor
            end
        else
            devices = _get_device(key,sys) #retrieve the device object
            cn = isa(ts,DataFrames.DataFrame) ? names(ts) : TimeSeries.colnames(ts)
            cn = [c for c in cn if c != :DateTime]
        
            if length(devices) > 0 
                devices = unique(values(devices))
                for d in devices
                    for c in cn #if a TimeArray has multiple value columns, create mulitiple forecasts for different parameters in the same device
                        timeseries = isa(ts,DataFrames.DataFrame) ? TimeSeries.TimeArray(ts.DateTime,ts[c]) : ts[c]
                        push!(fc,Deterministic(d,string(c),timeseries))
                    end
                end
            else
                @warn("no $key entries for devices in sys")
            end
        end
    end
    return fc
 end

 """
Args:
    A System struct
    A dictonary of forecasts
Returns:
    A PowerSystems forecast stuct array
"""

function make_forecast_array(sys::System,ts_dict::Dict)
    ts_map = _retrieve(ts_dict, Union{TimeSeries.TimeArray,DataFrames.DataFrame},Dict(),[]) #find key-path to timeseries data fields
    fc = Array{Forecast}(undef, 0)
    all_devices = collect(get_components(Component,sys))
    for (key,val) in ts_map
        ts = _access(ts_dict,vcat(val,key)) #retrieve timeseries data
        if (typeof(ts)==DataFrames.DataFrame) & (size(ts,2) > 2)
            devices = [d for d in all_devices if d.name in string.(names(ts))]
            for d in devices
                push!(fc,Deterministic(d,"scalingfactor",TimeSeries.TimeArray(ts.DateTime,ts[Symbol(d.name)]))) # TODO: unhardcode scalingfactor
            end
        else
            devices = [d for d in all_devices if d.name == key]

            cn = isa(ts,DataFrames.DataFrame) ? names(ts) : TimeSeries.colnames(ts)
            cn = [c for c in cn if c != :DateTime]
        
            if length(devices) > 0 
                for d in devices
                    for c in cn #if a TimeArray has multiple value columns, create mulitiple forecasts for different parameters in the same device
                        timeseries = isa(ts,DataFrames.DataFrame) ? TimeSeries.TimeArray(ts.DateTime,ts[c]) : ts[c]
                        push!(fc,Deterministic(d,string(c),timeseries))
                    end
                end
            else
                @warn("no $key entries for devices in sys")
            end
        end
    end
    return fc
 end

 # Write dict to Json

function write_to_json(filename,Forecasts_dict)
    for (type_key,type_fc) in Forecasts_dict
        for (device_key,device_dicts) in type_fc
            stringdata =JSON.json(device_dicts, 3)
            open("$filename/$device_key.json", "w") do f
                write(f, stringdata)
             end
        end
    end
end

#=
# Parse json to dict
#TODO : fix broken data formats
function parse_json(filename,device_names)
    Devices =Dict{String,Any}()
    for name in device_names
        if isfile("$filename/x$name.json")
            temp = Dict()
            open("$filename/x$name.json", "r") do f
            global temp
            dicttxt = readstring(f)  # file information to string
            temp=JSON.parse(dicttxt)  # parse and transform data
            Devices[name] = temp
            end
        end
    end
    return Devices
end
=#