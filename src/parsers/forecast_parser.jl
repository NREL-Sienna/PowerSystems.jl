# Parser for Forecasts dat files
function read_data_files(files::String)
    """
    Read all forecast CSV's in the path provided, the struct of the data should follow this format
    folder : PV  
                file : DAY_AHEAD
                file : REAL_TIME
    folder name should be the device type 
    files should only contain one real-time and day-ahead forecast
    # TODO : Stochasti/Multiple scenarios
    """
    REGEX_DEVICE_TYPE = r"(.*?)\.csv"
    REGEX_IS_FOLDER = r"^[A-Za-z]+$"
    data =Dict{String,Any}()

    if length(files) == 0
        error("No test files in the folder")
    end
    for folder in readdir(files)
        try
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
                        data[folder][key] = raw_data
                    end
                end
                println("Successfully parsed $folder")
            end
        catch
            warn("Error while parsing $folder")
            catch_stacktrace()
        end
    end
    return data
end
 # -Parse csv file to dict
function make_forecast_dict(time_series::Dict{String,Any},resolution::Base.Dates.Period,horizon::Int,Devices::Array{PowerSystems.Generator,1})
    """
    Returns an dictionary give the data file with generator name/index as colnames, resolution , horizon/lookahead
    and generator/PowerSystemDevice 
    """
    forecast = Dict{String,Any}()
    for device in Devices
        for (key_df,dict_df) in  time_series
            if device.name in convert(Array{String},names(dict_df["DA"]))
                df = dict_df["DA"]
                time_delta = Minute(df[2,:DateTime]-df[1,:DateTime])
                initialtime = df[1,:DateTime] # read the correct date/time when the was issued  forecast
                last_date = df[end,:DateTime]
                ts_dict = Dict{Any,Dict{Int,TimeSeries.TimeArray}}()
                for name in convert(Array{String},names(df))
                    if name == device.name #TODO : names start with x if using readtable but errors with CSV.resd()
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

# - Parse Dict to Forecast Struct

function make_forecast_array(dict)
    """
    Return a PowerSystems Forecast stuct array given a PowerSystems Forecast dictionary
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

function add_realtime_ts(data::Dict{String,Any},time_series::Dict{String,Any})
    if haskey(data,"gen")
        if haskey(data["gen"],"Hydro")
            if haskey(time_series,"HYDRO")
                data["gen"]["Hydro"] = PowerSystems.add_time_serise(data["gen"]["Hydro"],time_series["HYDRO"]["RT"])
            end
        end
        if haskey(data["gen"],"Renewable")
            if haskey(data["gen"]["Renewable"],"PV")
                if haskey(time_series,"PV")
                    data["gen"]["Renewable"]["PV"] = PowerSystems.add_time_serise(data["gen"]["Renewable"]["PV"],time_series["PV"]["RT"])
                end
            end
            if haskey(data["gen"]["Renewable"],"RTPV")
                if haskey(time_series,"RTPV")
                    data["gen"]["Renewable"]["RTPV"] = PowerSystems.add_time_serise(data["gen"]["Renewable"]["RTPV"],time_series["RTPV"]["RT"])
                end
            end
            if haskey(data["gen"]["Renewable"],"WIND")
                if haskey(time_series,"WIND")
                    data["gen"]["Renewable"]["WIND"] = PowerSystems.add_time_serise(data["gen"]["Renewable"]["WIND"],time_series["WIND"]["RT"])
                end
            end
        end
    end
    return data
end


function read_datetime(df)
    if df[25,:Period] > 24
        df[:DateTime] = collect(DateTime(df[1,:Year],df[1,:Month],df[1,:Day],floor(df[1,:Period]/12),Int(df[1,:Period])-1):Minute(5):
                        DateTime(df[end,:Year],df[end,:Month],df[end,:Day],floor(df[end,:Period]/12)-1,5*(Int(df[end,:Period])-(floor(df[end,:Period]/12)-1)*12) -5))
    else
        df[:DateTime] = collect(DateTime(df[1,:Year],df[1,:Month],df[1,:Day],(df[1,:Period]-1)):Hour(1):
                        DateTime(df[end,:Year],df[end,:Month],df[end,:Day],(df[end,:Period]-1)))
    end
    delete!(df, [:Year,:Month,:Day,:Period])
end

function add_time_serise(Device_dict,df)
    read_datetime(df) 
    for (device_key,device) in Device_dict
        if device_key in names(df)
            ts_raw = df[:,device_key]
            Device_dict[device_key]["scalingfactor"] = TimeSeries.TimeArray(df[:DateTime],ts_raw)
        end
    end
    return Device_dict
end