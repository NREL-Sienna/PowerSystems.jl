
const CATEGORY_STR_TO_COMPONENT = Dict{String, DataType}(
    "Bus" => Bus,
    "Generator" => Generator,
    "Reserve" => Service,
    "LoadZone" => LoadZones,
    "ElectricLoad" => ElectricLoad,
)

"""Describes how to construct forecasts from raw timeseries data files."""
mutable struct TimeseriesFileMetadata
    simulation::String  # User description of simulation
    category::String  # String version of PowerSystems abstract type for forecast component.
                      # Refer to CATEGORY_STR_TO_COMPONENT.
    component_name::String  # Name of forecast component
    label::String  # Raw data column for source of timeseries
    scaling_factor::Union{String, Float64}  # Controls normalization of timeseries.
                                            # Use 1.0 for pre-normalized data.
                                            # Use 'Max' to divide the timeseries by the max
                                            #   value in the column.
                                            # Use any float for a custom scaling factor.
    data_file::String  # path to the timeseries data file
end

"""Reads forecast metadata and fixes relative paths to the data files."""
function read_timeseries_metadata(file_path::AbstractString)::Vector{TimeseriesFileMetadata}
    metadata = open(file_path) do io
        JSON2.read(io, Vector{TimeseriesFileMetadata})
    end

    directory = dirname(file_path)
    for ts_metadata in metadata
        ts_metadata.data_file = abspath(joinpath(directory, ts_metadata.data_file))
    end

    return metadata
end

struct ForecastInfo
    simulation::String
    component::Component
    label::String  # Component field on which timeseries data is based.
    scaling_factor::Union{String, Float64}
    data::TimeSeries.TimeArray
    file_path::String

    function ForecastInfo(simulation, component, label, scaling_factor, data, file_path)
        new(simulation, component, label, scaling_factor, data, abspath(file_path))
    end
end

function ForecastInfo(metadata::TimeseriesFileMetadata, component::Component,
                      timeseries::TimeSeries.TimeArray)
    return ForecastInfo(metadata.simulation, component, metadata.label,
                        metadata.scaling_factor, timeseries, metadata.data_file)
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
    add_forecasts!(sys::System, metadata_file::AbstractString; resolution=nothing)

Add forecasts to a system from a metadata file.

# Arguments
- `sys::System`: system
- `directory_or_file::AbstractString`: directory to searc for files or a specific file
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
        timeseries = _handle_scaling_factor(timeseries, forecast.scaling_factor)
        forecasts = [Deterministic(x, forecast.label, timeseries)
                     for x in forecast_components]
        add_forecasts!(sys, forecasts)
    end
end

function _get_forecast_component(sys::System, category, name)
    if isconcretetype(category)
        component = get_component(category, sys, name)
        if isnothing(component)
            throw(DataFormatError(
                "Did not find component for forecast category=$category name=$name"))
        end
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
    read_timeseries(file_path::AbstractString, component_name=nothing)

Return a TimeArray from a CSV file.

Pass component_name when the file does not have the component name in a column header.
"""
function read_timeseries(file_path::AbstractString, component_name=nothing; kwargs...)
    if !isfile(file_path)
        msg = "Timeseries file doesn't exist : $file_path"
        throw(DataFormatError(msg))
    end

    file = CSV.File(file_path)
    @debug "Read CSV data from $file_path."

    return read_timeseries(get_timeseries_format(file), file, component_name; kwargs...)
end

function add_forecast_info!(infos::ForecastInfos, sys::System,
                            metadata::TimeseriesFileMetadata)
    timeseries = _add_forecast_info!(infos, metadata.data_file, metadata.component_name)

    category = _get_category(metadata)
    component = _get_forecast_component(sys, category, metadata.component_name)
    forecast_info = ForecastInfo(metadata, component, timeseries)
    push!(infos.forecasts, forecast_info)
    @debug "Added ForecastInfo" metadata
end

function _get_category(metadata::TimeseriesFileMetadata)
    if !haskey(CATEGORY_STR_TO_COMPONENT, metadata.category)
        throw(DataFormatError("category=$(metadata.category) is invalid"))
    end

    category = CATEGORY_STR_TO_COMPONENT[metadata.category]

    return category
end

function _add_forecast_info!(infos::ForecastInfos, data_file::AbstractString,
                             component_name::Union{Nothing, String})
    if !haskey(infos.data_files, data_file)
        infos.data_files[data_file] = read_timeseries(data_file, component_name)
        @debug "Added timeseries file" data_file
    end

    return infos.data_files[data_file]
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

"""
    clear_forecasts!(sys::System)

Remove all forecast objects from a System
"""
function clear_forecasts!(sys::System)

    empty!(sys.forecasts.data)
    reset_info!(sys.forecasts)

    return
end

"""
    split_forecasts!(sys::System, 
                    forecasts, 
                    interval::Dates.Period, 
                    horizon::Int) where T <: Forecast

Replaces system forecasts with a set of forecasts by incrementing through an iterable 
set of forecasts by interval and horizon.

"""
function split_forecasts!(sys::System,
                         forecasts, # must be an iterable
                         interval::Dates.Period,
                         horizon::Int) where T <: Forecast

    split_forecasts = make_forecasts(forecasts, interval, horizon)

    clear_forecasts!(sys)

    add_forecasts!(sys, split_forecasts)

    return
end
