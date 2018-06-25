# Parser for Forecasts

function add_date_time(df)
    df[:DateTime] = collect(DateTime(df[1,:Year],df[1,:Month],df[1,:Day],floor(df[1,:Period]/12),Int(df[1,:Period])-1):Minute(5):
         DateTime(df[end,:Year],df[end,:Month],df[end,:Day],floor(df[end,:Period]/12)-1,5*(Int(df[end,:Period])-(floor(df[end,:Period]/12)-1)*12) -5))
     delete!(df, [:Year,:Month,:Day,:Period])
     
 end

 # -Parse csv file to dict
function make_forecast_dict(df,resolution::Base.Dates.Period,horizon::Int,device::PowerSystems.PowerSystemDevice)
    Forecasts = Dict{String,Any}()
    Forecasts["Deterministic"] = Dict{String,Any}()
    time_delta = Minute(df[2,:DateTime]-df[1,:DateTime])
    initialtime = df[1,:DateTime] # read the correct date/time when the was issued  forecast
    last_date = df[end,:DateTime]
    ts_dict = Dict{Any,Dict{Int,TimeSeries.TimeArray}}()
    for name in convert(Array{String},names(df))
        if name == "x"*device.name #TODO : names start with x if using readtable but errors with CSV.resd()
            ts_raw = TimeSeries.TimeArray(df[:,:DateTime],df[:,Symbol(name)])
            for ts in initialtime:resolution:last_date
                ts_dict[ts] = Dict{Int,TimeSeries.TimeArray}(1 => ts_raw[ts:time_delta:(ts+resolution)])
            end
            Forecasts["Deterministic"][name]=Dict{String,Any}("horizon" =>horizon,
                                                            "resolution" => resolution,#TODO : use @NT(day=,hour=,min=)?
                                                            "interval" => time_delta,#TODO : use @NT(day=,hour=,min=)?
                                                            "initialtime" => initialtime,
                                                            "device" => device,
                                                            "data" => ts_dict
                                                                )
        end
    end
    return Forecasts
end

# - Parse Dict to Forecast Struct

function make_forecast_array(dict)
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


# parse json to dict
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