struct ForecastInfo
    simulation::String
    component::Component
    label::String  # Component field on which timeseries data is based.
    per_unit::Bool  # Whether per_unit conversion is needed.
    data::TimeSeries.TimeArray
    file_path::String

    function ForecastInfo(simulation, component, label, per_unit, data, file_path)
        new(simulation, component, label, per_unit, data, abspath(file_path))
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
- `per_unit::Bool=false`: convert to per_unit
- `REGEX_FILE::Regex`: only look at files matching this regular expression

Refer to [`add_forecasts!`](@ref) for exceptions thrown.
"""
function forecast_csv_parser!(
                              sys::System,
                              directory_or_file::AbstractString,
                              simulation="Simulation",
                              category::Type{<:Component}=Component,
                              label="init",
                              ; resolution=nothing,
                              kwargs...
                             )
    forecast_infos = parse_forecast_data_files(sys, directory_or_file, simulation, category,
                                               label; kwargs...)

    return _forecast_csv_parser!(sys, forecast_infos, resolution)
end

function _forecast_csv_parser!(sys::System, forecast_infos::ForecastInfos, resolution)
    for forecast in forecast_infos.forecasts
        len = length(forecast.data)
        @assert len >= 2
        timestamps = TimeSeries.timestamp(forecast.data)
        res = timestamps[2] - timestamps[1]
        if !isnothing(resolution) && res != resolution
            @debug "Skip forecast with resolution=$res; doesn't match user=$resolution"
            continue
        end

        if forecast.component isa LoadZones
            uuids = Set([get_uuid(x) for x in forecast.component.buses])
            forecast_components = [load for load in get_components(ElectricLoad, sys)
                                   if get_bus(load) |> get_uuid in uuids]
        else
            forecast_components = [forecast.component]
        end

        timeseries = forecast.data[Symbol(get_name(forecast.component))]
        if forecast.per_unit
            # PERF
            # TimeSeries.TimeArray is immutable; forced to copy.
            timeseries = timeseries ./ sys.basepower
            @debug "Converted timeseries to per_unit" forecast
        end

        forecasts = [Deterministic(x, forecast.label, timeseries)
                     for x in forecast_components]
        add_forecasts!(sys, forecasts)
    end
end

function get_forecast_component(sys::System, category, name)
    if isconcretetype(category)
        component = get_component(category, sys, name)
    else
        components = get_components_by_name(category, sys, name)
        if length(components) == 0
            throw(DataFormatError(
                "Did not find component for forecast category=$category name=$name"))
        elseif length(components) == 1
            component = components[1]
        else
            msg = "Found duplicate names type=$(category) name=$(name)"
            throw(DataFormatError(msg))
        end
    end

    return component
end

"""
    read_time_array(file_path::AbstractString, component_name=nothing)

Return a TimeArray from a CSV file.

Pass component_name when the file does not have the component name in a column header.
"""
function read_time_array(file_path::AbstractString, component_name=nothing; kwargs...)
    if !isfile(file_path)
        msg = "Timeseries file doesn't exist : $file_path"
        throw(DataFormatError(msg))
    end

    file = CSV.File(file_path)
    @debug "Read CSV data from $file_path."

    return read_time_array(get_timeseries_format(file), file, component_name; kwargs...)
end

function parse_forecast_data_files(
                                   sys::System,
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

    per_unit = get(kwargs, :per_unit, false)
    for filename in filenames
        add_forecast_data!(sys, forecast_infos, simulation, category, label, per_unit,
                           filename)
    end

    return forecast_infos
end

function add_forecast_data!(
                            infos::ForecastInfos,
                            simulation::AbstractString,
                            component::Component,
                            label::AbstractString,
                            per_unit::Bool,
                            data_file::AbstractString,
                           )
    timeseries = _add_forecast_data!(infos, data_file, get_name(component))
    forecast = ForecastInfo(simulation, component, label, per_unit, timeseries, data_file)
    push!(infos.forecasts, forecast)
    @debug "Added ForecastInfo" forecast
end

function add_forecast_data!(
                            sys::System,
                            infos::ForecastInfos,
                            simulation::AbstractString,
                            category::Type{<:Component},
                            label::AbstractString,
                            per_unit::Bool,
                            data_file::AbstractString,
                           )
    timeseries = _add_forecast_data!(infos, data_file, nothing)

    for component_name in TimeSeries.colnames(timeseries)
        component = get_forecast_component(sys, category, string(component_name))
        forecast = ForecastInfo(simulation, component, label, per_unit, timeseries,
                                data_file)
        push!(infos.forecasts, forecast)
        @debug "Added ForecastInfo" forecast
    end
end

function _add_forecast_data!(infos::ForecastInfos, data_file::AbstractString,
                             component_name::Union{Nothing, String})
    if !haskey(infos.data_files, data_file)
        infos.data_files[data_file] = read_time_array(data_file, component_name)
        @debug "Added timeseries file" data_file
    end

    return infos.data_files[data_file]
end

"""Return a Vector of forecast data filenames."""
function get_forecast_files(rootpath::String; kwargs...)
    filenames = Vector{String}()
    regex = get(kwargs, :REGEX_FILE, r"^[^\.](.*?)\.csv")

    for (root, dirs, files) in walkdir(rootpath)
        # Skip hidden directories unless the user passed it in.
        if length([x for x in splitdir(root) if startswith(x, ".")]) > 0 && root != rootpath
            @debug "Skip hidden directory $root"
            continue
        end
        for filename in files
            if !isnothing(match(regex, filename))
                path_to_filename = joinpath(root, filename)
                push!(filenames, path_to_filename)
            end
        end
    end

    return filenames
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
            temp=JSON2.read(dicttxt,Dict{Any,Array{Dict}})  # parse and transform data
            Devices[name] = temp
            end
        end
    end
    return Devices
end
=#
