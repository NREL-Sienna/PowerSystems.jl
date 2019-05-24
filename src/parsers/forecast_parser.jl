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

function make_forecast_array(sys::System, parsed_forecasts::Vector{Dict})
    return make_forecast_array(get_components(Component, sys))
end

function make_forecast_array(all_components, parsed_forecasts::Vector{Dict})
    # TODO this code could be cleaner if the incoming data was only DataFrame or TimeArray
    forecasts = Vector{Forecast}()
    for forecast in parsed_forecasts
        data = forecast["data"]
        if data isa DataFrames.DataFrame && size(data, 2) > 2
            # TODO: I don't understand this code block
            components = [x for x in all_components if x.name in string.(names(data))]
            for component in components
                dd = isa(component, LoadZones) ? component.buses : [component]
                for b in dd
                    time_array = TimeSeries.TimeArray(data.DateTime, data[Symbol(d.name)])
                    forecast = Deterministic(b, "scalingfactor", time_array)
                    push!(forecasts, forecast) # TODO: unhardcode scalingfactor
                end
            end
        else
            components = [x for x in all_components if x.name == forecast["component"]["name"]]
            col_names = isa(data, DataFrames.DataFrame) ? names(data) :
                                                          TimeSeries.colnames(data)
            filter!(x -> x != :DateTime, col_names)
        
            if length(components) > 0 
                for component in components
                    dd = isa(component, LoadZones) ? component.buses : [component]
                    for b in dd
                        # If a TimeArray has multiple value columns, create mulitiple
                        # forecasts for different parameters in the same device.
                        for col in col_names
                            values = data[col]
                            if data isa DataFrames.DataFrame
                                timeseries = TimeSeries.TimeArray(data.DateTime, values)
                            else
                                timeseries = values
                            end

                            push!(forecasts, Deterministic(b, string(component), timeseries))
                        end
                    end
                end
            else
                @error("no $(forecast["component"]["name"]) entries for components in sys")
            end
        end
    end

    return forecasts
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
