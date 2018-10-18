# Parser for Forecasts dat files
function read_data_files(files::String; kwargs...)
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
    REGEX_IS_FOLDER = r"^[A-Za-z]+$"
    data =Dict{String,Any}()
    for folder in readdir(files)
        if match(REGEX_IS_FOLDER, folder) != nothing
            print("Parsing csv timeseries files in $folder ...\n")
            data[folder] = Dict{String,Any}()
            for file in readdir(files*"/$folder")
                if match(REGEX_FILE, file) != nothing
                    file_path = files*"/$folder/$file"
                    println("Parsing $file_path")
                    #raw_data = CSV.read(file_path,header=1,datarow =2,rows_for_type_detect=1000)
                    raw_data = DataFrame(CSVFiles.load(file_path))

                    println("Assigning DateTimes...")
                    raw_data = read_datetime(raw_data; kwargs...)

                    data[folder] = raw_data
                end
            end
            println("Successfully parsed $folder")
        end
    end
    return data
end

function assign_ts_data(ps_dict::Dict{String,Any},ts_dict::Dict{String,Any})
    """
    Args:
        PowerSystems Dictionary
        Dictionary of all the data files
    Returns:
        Returns an dictionary with Device name as key and PowerSystems Forecasts dictionary as values
    """
    gen_ts = Dict([(k=>ts_dict[k]) for k in keys(ts_dict) if k != "load"])
    if "load" in keys(ts_dict)
        ps_dict["load"] =  PowerSystems.add_time_series_load(ps_dict,ts_dict["load"])
    else
        @warn("Not assigning time series to loads")
    end
    
    for key in keys(gen_ts)
        ps_dict = PowerSystems.add_time_series(ps_dict,ts_dict[key])
    end
    
    return ps_dict
end

 # -Parse csv file to dict
function make_forecast_dict(time_series::Dict{String,Any},resolution::Dates.Period,horizon::Int,Devices::Array{Generator,1})
    """
    Args:
        Dictionary of all the data files
        Length of the forecast - Week()/Day()/Hour()
        Forecast horizon in hours - Int64
        Array of PowerSystems devices in the systems - Renewable Generators and Loads

    Returns:
        Returns an dictionary with Device name as key and PowerSystems Forecasts dictionary as values
    """
    forecast = Dict{String,Any}()
    for device in Devices
        for (key_df,dict_df) in  time_series
            if device.name in convert(Array{String},names(dict_df["DA"]))
                df = (dict_df["DA"])
                time_delta = Minute(df[2,:DateTime]-df[1,:DateTime])
                initialtime = df[1,:DateTime] # TODO :read the correct date/time when that was issued  forecast
                last_date = df[end,:DateTime]
                ts_dict = Dict{Any,Dict{Int,TimeSeries.TimeArray}}()
                for name in convert(Array{String},names(df))
                    if name == device.name
                        ts_raw = TimeSeries.TimeArray(df[:,:DateTime],df[:,Symbol(name)])
                        for ts in initialtime:resolution:last_date
                            ts_dict[ts] = Dict{Int,TimeSeries.TimeArray}(1 => ts_raw[ts:time_delta:(ts+resolution)])
                        end
                        forecast[device.name] = Dict{String,Any}("horizon" =>horizon,
                                                    "resolution" => resolution, #TODO : fix type conversion to JSON
                                                    "interval" => time_delta,   #TODO : fix type conversion to JSON
                                                    "initialtime" => initialtime,
                                                    "device" => device,
                                                    "data" => ts_dict
                                                        )
                    end
                end
            end
        end
        if !haskey(forecast,device.name)
            println("No forecast found for $(device.name) ")
        end
    end
    return forecast
end

function make_forecast_dict(time_series::Dict{String,Any},resolution::Dates.Period,horizon::Int,Devices::Array{ElectricLoad,1},LoadZones::Array{PowerSystemDevice,1})
    """
    Args:
        Dictionary of all the data files
        Length of the forecast - Week()/Day()/Hour()
        Forecast horizon in hours - Int64
        Array of PowerSystems devices in the systems- Loads
        Array of PowerSystems LoadZones

    Returns:
        Returns an dictionary with Device name as key and PowerSystems Forecasts dictionary as values
    """
    forecast = Dict{String,Any}()
    for device in Devices
        if haskey(time_series,"Load")
            for lz in LoadZones
                if device.bus in lz.buses
                    df = time_series["Load"]["DA"][:,[:DateTime,Symbol(lz.name)]]

                    time_delta = Minute(df[2,:DateTime]-df[1,:DateTime])
                    initialtime = df[1,:DateTime] # TODO :read the correct date/time when that was issued  forecast
                    last_date = df[end,:DateTime]
                    ts_dict = Dict{Any,Dict{Int,TimeSeries.TimeArray}}()
                    ts_raw =  TimeSeries.TimeArray(df[:,1],df[:,2])
                    for ts in initialtime:resolution:last_date
                        ts_dict[ts] = Dict{Int,TimeSeries.TimeArray}(1 => ts_raw[ts:time_delta:(ts+resolution)])
                    end
                    forecast[device.name] = Dict{String,Any}("horizon" =>horizon,
                                                            "resolution" => resolution, #TODO : fix type conversion to JSON
                                                            "interval" => time_delta,   #TODO : fix type conversion to JSON
                                                            "initialtime" => initialtime,
                                                            "device" => device,
                                                            "data" => ts_dict
                                                            )
                end
            end
        else
            @warn("No forecast found for Loads ")
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
    Forecasts =Array{Forecast}(0)
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
