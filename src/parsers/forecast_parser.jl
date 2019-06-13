struct ForecastInfo
    simulation::String
    category::Type{<:Component}
    component_name::String
    label::String
    data::TimeSeries.TimeArray
    file_path::String

    function ForecastInfo(simulation, category, component_name, label, data, file_path)
        new(simulation, category, component_name, label, data, abspath(file_path))
    end
end

struct ForecastInfos
    forecasts::Vector{ForecastInfo}
    data_files::Dict{String, TimeSeries.TimeArray}
end

function ForecastInfos()
    return ForecastInfos(Vector{ForecastInfo}(),
                         Dict{String, TimeSeries.TimeArray}())
end

"""
    forecast_csv_parser!(sys::System,
                         directory_or_file::AbstractString,
                         simulation="Simulation",
                         category::Type{<:Component}=Component,
                         label="scalingfactor";
                         resolution=nothing,
                         kwargs...)

Add forecasts to the System from CSV files.

# Arguments
- `sys::System`: system
- `directory_or_file::AbstractString`: directory to search for files or a specific file
- `simulation::AbstractString`: simulation name
- `category::DataType`: category of component for the forecast; can be abstract or concrete
- `label::AbstractString`: forecast label
- `resolution::Dates.DateTime=nothing`: only store forecasts with this resolution
- `REGEX_FILE::Regex`: only look at files matching this regular expression

Refer to [`add_forecasts!`](@ref) for exceptions thrown.
"""
function forecast_csv_parser!(
                              sys::System,
                              directory_or_file::AbstractString,
                              simulation="Simulation",
                              category::Type{<:Component}=Component,
                              label="scalingfactor",
                              ; resolution=nothing,
                              kwargs...
                             )
    forecast_infos = parse_forecast_data_files(directory_or_file, simulation, category,
                                               label; kwargs...)

    return _forecast_csv_parser!(sys, forecast_infos, resolution)
end

function _forecast_csv_parser!(sys::System, forecast_infos::ForecastInfos, resolution)
    # Cache name-to-component by category to avoid looping through components for every
    # forecast.
    component_mappings = Dict{DataType, LazyDictFromIterator{String, <:Component}}()

    for forecast in forecast_infos.forecasts
        len = length(forecast.data)
        @assert len >= 2
        timestamps = TimeSeries.timestamp(forecast.data)
        res = timestamps[2] - timestamps[1]
        if !isnothing(resolution) && res != resolution
            @debug "Skip forecast with resolution=$res; doesn't match user=$resolution"
            continue
        end

        component_type = forecast.category
        if !haskey(component_mappings, forecast.category)
            iter = get_components(component_type, sys)
            components = LazyDictFromIterator(String, component_type, iter, get_name)
            component_mappings[forecast.category] = components
        end

        component = get(component_mappings[forecast.category], forecast.component_name)
        if isnothing(component)
            @error("Did not find component for forecast", forecast.component_name,
                   forecast.category, forecast.file_path)
            continue
        end

        forecasts = Vector{Forecast}()
        forecast_components = component isa LoadZones ? component.buses : [component]
        for component_ in forecast_components
            timeseries = forecast.data[Symbol(forecast.component_name)]
            forecast_ = Deterministic(component_, forecast.label, timeseries)
            push!(forecasts, forecast_)
        end

        add_forecasts!(sys, forecasts)
    end
end

"""
    read_time_array(file_path::AbstractString, component_name=nothing)

Return a TimeArray from a CSV file.

Pass component_name when the file does not have the component name in a column header.
"""
function read_time_array(file_path::AbstractString, component_name=nothing; kwargs...)
    file = CSV.File(file_path)
    @debug "Read CSV data from $file_path."

    return read_time_array(get_timeseries_format(file), file, component_name; kwargs...)
end

function parse_forecast_data_files(
                                   path::AbstractString,
                                   simulation::AbstractString,
                                   category::Type{<:Component},
                                   label::AbstractString;
                                   kwargs...
                                  )
    forecast_infos = ForecastInfos()

    if isdir(path)
        filenames = get_forecast_files(path; kwargs...)
    elseif isfile(path)
        filenames = [path]
    else
        throw(InvalidParameter("$path is neither a directory nor file"))
    end

    for filename in filenames
        add_forecast_data!(forecast_infos, simulation, category, nothing, label,
                           path, filename)
    end

    return forecast_infos
end

function add_forecast_data!(
                            infos::ForecastInfos,
                            simulation::AbstractString,
                            category::Type{<:Component},
                            component_name::Union{AbstractString, Nothing},
                            label::AbstractString,
                            directory::AbstractString,
                            data_file::AbstractString,
                           )
    if !haskey(infos.data_files, data_file)
        file_path = joinpath(directory, data_file)

        if !isfile(file_path)
            msg = "Timeseries file doesn't exist : $file_path"
            throw(DataFormatError(msg))
        end

        infos.data_files[data_file] = read_time_array(file_path, component_name)

        @debug "Added timeseries file" data_file
    end

    timeseries = infos.data_files[data_file]
    component_names = isnothing(component_name) ?
                          [string(x) for x in TimeSeries.colnames(timeseries)] :
                          [component_name]

    for name in component_names
        forecast = ForecastInfo(simulation, category, name, label, timeseries, data_file)
        push!(infos.forecasts, forecast)
        @debug "Added ForecastInfo" forecast
    end
end

"""Return a Vector of forecast data filenames."""
function get_forecast_files(rootpath::String; kwargs...)
    filenames = Vector{String}()
    regex = get(kwargs, :REGEX_FILE, r"^[^\.](.*?)\.csv")

    for (root, dirs, files) in walkdir(rootpath)
        for filename in files
            if !isnothing(match(regex, filename))
                hidden = false
                for dir in splitdir(root)
                    if startswith(dir, ".")
                        hidden = true
                        break
                    end
                end

                if !hidden
                    path_to_filename = joinpath(root, filename)
                    push!(filenames, path_to_filename)
                end
            end
        end
    end

    return filenames
end

 """
Args:
    A System struct
    A dictonary of forecasts
Returns:
    A PowerSystems forecast stuct array
"""

function make_forecast_array(sys::System, parsed_forecasts::Vector{Dict})
    return make_forecast_array(get_components(Component, sys), parsed_forecasts)
end

function make_forecast_array(all_components, parsed_forecasts::Vector{Dict})
    forecasts = Vector{Forecast}()
    for forecast in parsed_forecasts
        data = forecast["data"]
        if data isa DataFrames.DataFrame && size(data, 2) > 2
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
