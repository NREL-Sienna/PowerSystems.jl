function get_name_and_csv(path_to_filename)
    df = CSV.File(path_to_filename) |> DataFrames.DataFrame
    folder = splitdir(splitdir(path_to_filename)[1])[2]
    return folder, df
end


# Parser for Forecasts dat files
function read_data_files(rootpath::String; kwargs...)
    """
    Read all forecast CSV's in the path provided, the struct of the data should follow this format
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
                folder_name, csv_data = get_name_and_csv(path_to_filename)
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

function assign_ts_data(ps_dict::Dict{String,Any},ts_dict::Dict{String,Any})
    """
    Args:
        PowerSystems Dictionary
        Dictionary of all the data files
    Returns:
        Returns an dictionary with Device name as key and PowerSystems Forecasts dictionary as values
    """
    if haskey(ts_dict,"load")
        ps_dict["load"] =  PowerSystems.add_time_series_load(ps_dict,ts_dict["load"])
    else
        @warn "Not assigning time series to loads"
    end

    if haskey(ts_dict,"gen")
        ts_map = _retrieve(ts_dict["gen"], Union{TimeSeries.TimeArray,DataFrames.DataFrame})
        for (key,val) in ts_map
            ts = _access(ts_dict["gen"],vcat(val,key))
            dd_map = _retrieve(ps_dict["gen"],key)
            if length(dd_map) > 0 
                dd_map = string.(unique(values(dd_map))[1]) 
            else
                @warn("no $key entries in psdict")
                continue
            end
            dd = _access(ps_dict["gen"],vcat(dd_map,key))
            dd = PowerSystems.add_time_series(dd,ts)
        end
    else
        @warn "Not assigning time series to gens"
    end

    return ps_dict
end

function make_device_forecast(device::D, df::DataFrames.DataFrame, resolution::Dates.Period,horizon::Int) where {D<:PowerSystemDevice}
    time_delta = Dates.Minute(df[2,:DateTime]-df[1,:DateTime])
    initialtime = df[1,:DateTime] # TODO :read the correct date/time when that was issued  forecast
    last_date = df[end,:DateTime]
    ts_dict = Dict{Any,Dict{Int,TimeSeries.TimeArray}}()
    ts_raw =  TimeSeries.TimeArray(df[1],df[2])
    for ts in initialtime:resolution:last_date
        ts_dict[ts] = Dict{Int,TimeSeries.TimeArray}(1 => ts_raw[ts:time_delta:(ts+resolution)])
    end
    forecast = Dict{String,Any}("horizon" =>horizon,
                                            "resolution" => resolution, #TODO : fix type conversion to JSON
                                            "interval" => time_delta,   #TODO : fix type conversion to JSON
                                            "initialtime" => initialtime,
                                            "device" => device,
                                            "data" => ts_dict
                                            )
    return forecast
end

 # -Parse csv file to dict
function make_forecast_dict(name::String,time_series::Dict{String,Any},resolution::Dates.Period,horizon::Int,Devices::Array{Generator,1})
    """
    Args:
        Dictionary of all the data files
        Length of the forecast - Week()/Dates.Day()/Dates.Hour()
        Forecast horizon in hours - Int64
        Array of PowerSystems devices in the systems - Renewable Generators and Loads

    Returns:
        Returns an dictionary with Device name as key and PowerSystems Forecasts dictionary as values
    """
    forecast = Dict{String,Any}()
    for device in Devices
        for (key_df,df) in time_series
            if device.name in map(String, names(df))
                for name in map(String, names(df))
                    if name == device.name
                        forecast[device.name] = make_device_forecast(device, df[[:DateTime, Symbol(device.name)]], resolution, horizon)
                    end
                end
            end
        end
        if !haskey(forecast,device.name)
            @info "No forecast found for $(device.name) "
        end
    end
    return forecast
end

function make_forecast_dict(name::String,time_series::Dict{String,Any},resolution::Dates.Period,horizon::Int,Devices::Array{ElectricLoad,1})
    """
    Args:
        Dictionary of all the data files
        Length of the forecast - Week()/Dates.Day()/Dates.Hour()
        Forecast horizon in hours - Int64
        Array of PowerSystems devices in the systems- Loads
    Returns:
        Returns an dictionary with Device name as key and PowerSystems Forecasts dictionary as values
    """
    forecast = Dict{String,Any}()
    for device in Devices
        if haskey(time_series,"load")
            if device.bus.name in  map(String, names(time_series["load"]))
                df = time_series["load"][[:DateTime,Symbol(device.bus.name)]]
                forecast[device.name] = make_device_forecast(device, df, resolution, horizon)
            end
        else
            @warn "No forecast found for Loads"
        end
    end
    return forecast
end


function make_forecast_dict(name::String,time_series::Dict{String,Any},resolution::Dates.Period,horizon::Int,Devices::Array{ElectricLoad,1},LoadZones::Array{PowerSystemDevice,1})
    """
    Args:
        Dictionary of all the data files
        Length of the forecast - Week()/Dates.Day()/Dates.Hour()
        Forecast horizon in hours - Int64
        Array of PowerSystems devices in the systems- Loads
        Array of PowerSystems LoadZones

    Returns:
        Returns an dictionary with Device name as key and PowerSystems Forecasts dictionary as values
    """
    forecast = Dict{String,Any}()
    for device in Devices
        if haskey(time_series,"load")
            for lz in LoadZones
                if device.bus in lz.buses
                    df = time_series["load"][[:DateTime,Symbol(lz.name)]]
                    forecast[device.name] = make_device_forecast(device, df, resolution, horizon)
                end
            end
        else
            @warn "No forecast found for Loads"
        end
    end
    return forecast
end


# - Parse Dict to Forecast Struct

function make_forecast_array(dict)
    """
    Args:
        A PowerSystems forecast dictionary
    Returns:
        A PowerSystems forecast stuct array
    """
    Forecasts = Array{Forecast}(undef, 0)
    for (device_key,device_dict) in dict
                push!(Forecasts,Deterministic(device_dict["device"],device_dict["horizon"],
                                device_dict["resolution"],device_dict["interval"],
                                device_dict["initialtime"],
                                device_dict["data"]
                                ))
    end
    return Forecasts
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
