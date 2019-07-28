
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
- `metadata_file::AbstractString`: path to metadata file
- `resolution::{Nothing, Dates.Period}`: skip any forecasts that don't match this resolution

See [`TimeseriesFileMetadata`](@ref) for description of what the file should contain.
"""
function add_forecasts!(sys::System, metadata_file::AbstractString; resolution=nothing)
    add_forecasts!(sys, read_timeseries_metadata(metadata_file); resolution=resolution)
end

"""
    add_forecasts!(sys::System, timeseries_metadata::Vector{TimeseriesFileMetadata};
                   resolution=nothing)

Add forecasts to a system from a vector of TimeseriesFileMetadata values.
#
# Arguments
- `sys::System`: system
- `timeseries_metadata::Vector{TimeseriesFileMetadata}`: metadata values
- `resolution::{Nothing, Dates.Period}`: skip any forecasts that don't match this resolution
"""
function add_forecasts!(sys::System, timeseries_metadata::Vector{TimeseriesFileMetadata};
                        resolution=nothing)
    forecast_infos = ForecastInfos()
    for ts_metadata in timeseries_metadata
        add_forecast_info!(forecast_infos, sys, ts_metadata)
    end

    _add_forecasts!(sys, forecast_infos, resolution)
end

"""
    add_forecast!(sys::System, filename::AbstractString, component::Component,
                  label::AbstractString, scaling_factor::Union{String, Float64}=1.0)

Add a forecast to a system from a CSV file.

See [`TimeseriesFileMetadata`](@ref) for description of scaling_factor.
"""
function add_forecast!(sys::System, filename::AbstractString, component::Component,
                       label::AbstractString, scaling_factor::Union{String, Float64}=1.0)
    component_name = get_name(component)
    data = read_timeseries(filename, component_name)
    timeseries = data[Symbol(component_name)]
    _add_forecast!(sys, component, label, timeseries, scaling_factor)
end

"""
    add_forecast!(sys::System, data::TimeSeries.TimeArray, component::Component,
                  label::AbstractString, scaling_factor::Union{String, Float64}=1.0)

Add a forecast to a system from a TimeSeries.TimeArray.

See [`TimeseriesFileMetadata`](@ref) for description of scaling_factor.
"""
function add_forecast!(sys::System, data::TimeSeries.TimeArray, component::Component,
                       label::AbstractString, scaling_factor::Union{String, Float64}=1.0)
    timeseries = data[Symbol(get_name(component))]
    _add_forecast!(sys, component, label, timeseries, scaling_factor)
end

"""
    add_forecast!(sys::System, df::DataFrames.DataFrame, component::Component,
                  label::AbstractString, scaling_factor::Union{String, Float64}=1.0)

Add a forecast to a system from a DataFrames.DataFrame.

See [`TimeseriesFileMetadata`](@ref) for description of scaling_factor.
"""
function add_forecast!(sys::System, df::DataFrames.DataFrame, component::Component,
                       label::AbstractString, scaling_factor::Union{String, Float64}=1.0;
                       timestamp=:timestamp)
    timeseries = TimeSeries.TimeArray(df; timestamp=timestamp)
    add_forecast!(sys, timeseries, component, label, scaling_factor)
end

function _add_forecast!(sys::System, component::Component, label::AbstractString,
                        timeseries::TimeSeries.TimeArray, scaling_factor)
    timeseries = _handle_scaling_factor(timeseries, scaling_factor)
    forecast = Deterministic(component, label, timeseries)
    add_forecast!(sys, forecast)
end

function _handle_scaling_factor(timeseries::TimeSeries.TimeArray,
                                scaling_factor::Union{String, Float64})
    if scaling_factor isa String
        if lowercase(scaling_factor) == "max"
            max_value = maximum(TimeSeries.values(timeseries))
            timeseries = timeseries ./ max_value
            @debug "Normalize by max value" max_value
        else
            throw(DataFormatError("invalid scaling_factor=scaling_factor"))
        end
    elseif scaling_factor != 1.0
        timeseries = timeseries ./ scaling_factor
        @debug "Normalize by custom scaling factor" scaling_factor
    else
        @debug "forecast is already normalized"
    end

    return timeseries
end

function _add_forecasts!(sys::System, forecast_infos::ForecastInfos, resolution)
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
