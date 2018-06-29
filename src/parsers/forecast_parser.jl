# Parser for Forecasts dat files
function read_data_files(files::String)
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
    REGEX_DEVICE_TYPE = r"(.*?)\.csv"
    REGEX_IS_FOLDER = r"^[A-Za-z]+$"
    data =Dict{String,Any}()
    for folder in readdir(files)
        if match(REGEX_IS_FOLDER, folder) != nothing
            print("Parsing csv timeseries files in $folder ...\n")
            data[folder] = Dict{String,Any}()
            for file in readdir(files*"/$folder")
                if match(REGEX_DEVICE_TYPE, file) != nothing
                    file_path = files*"/$folder/$file"
                    raw_data = CSV.read(file_path,header=1,datarow =2,rows_for_type_detect=1000)
                    if raw_data[25,:Period] > 24
                        key = "RT"
                    else
                        key ="DA"
                    end
                    data[folder][key] = read_datetime(raw_data)
                end
            end
            println("Successfully parsed $folder")
        end
    end
    return data
end

 # -Parse csv file to dict
function make_forecast_dict(time_series::Dict{String,Any},resolution::Base.Dates.Period,horizon::Int,Devices::Array{PowerSystems.PowerSystemDevice,1})
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

function make_forecast_dict(time_series::Dict{String,Any},resolution::Base.Dates.Period,horizon::Int,Devices::Array{PowerSystems.PowerSystemDevice,1},LoadZones::Array{PowerSystems.PowerSystemDevice,1})
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
            warn("No forecast found for Loads ")
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
    Forecasts =Array{PowerSystems.Forecast}(0)
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
