abstract type Forecast <: PowerSystemType end

const Forecasts = Vector{<:Forecast}
const ForecastComponentLabelPair = Tuple{<:Component, String}
const ForecastComponentLabelPairByInitialTime = Dict{Dates.DateTime,
                                                     Set{ForecastComponentLabelPair}}
const UNITIALIZED_DATETIME = Dates.DateTime(Dates.Minute(0))
const UNITIALIZED_PERIOD = Dates.Period(Dates.Minute(0))
const UNITIALIZED_HORIZON = 0


struct ForecastKey
    initial_time::Dates.DateTime
    forecast_type::DataType
end

const ForecastsByType = Dict{ForecastKey, Vector{<:Forecast}}

function _get_forecast_initial_times(data::ForecastsByType)::Vector{Dates.DateTime}
    initial_times = Set{Dates.DateTime}()
    for key in keys(data)
        push!(initial_times, key.initial_time)
    end

    return sort!(Vector{Dates.DateTime}(collect(initial_times)))
end

function _verify_forecasts!(
                            unique_components::ForecastComponentLabelPairByInitialTime,
                            data::ForecastsByType,
                            forecast::T,
                           ) where T <: Forecast
    key = ForecastKey(forecast.initial_time, T)
    component_label = (forecast.component, forecast.label)

    if !haskey(unique_components, forecast.initial_time)
        unique_components[forecast.initial_time] = Set{ForecastComponentLabelPair}()
    end

    if haskey(data, key) && component_label in unique_components[forecast.initial_time]
        throw(DataFormatError(
            "forecast component-label pairs is not unique within forecasts; " *
            "label=$component_label initial_time=$(forecast.initial_time)"
        ))
    end

    push!(unique_components[forecast.initial_time], component_label)
end

function _add_forecast!(data::ForecastsByType, forecast::T) where T <: Forecast
    key = ForecastKey(forecast.initial_time, T)
    if !haskey(data, key)
        data[key] = Vector{T}()
    end

    push!(data[key], forecast)
end

"""Container for forecasts and their metadata. Implementation detail that is not exported.
Functions to access the data should go through the System."""
mutable struct SystemForecasts
    data::ForecastsByType
    initial_time::Dates.DateTime
    resolution::Dates.Period
    horizon::Int64
    interval::Dates.Period
end

function SystemForecasts()
    forecasts_by_type = ForecastsByType()
    initial_time = UNITIALIZED_DATETIME
    resolution = UNITIALIZED_PERIOD
    horizon = UNITIALIZED_HORIZON
    interval = UNITIALIZED_PERIOD

    return SystemForecasts(forecasts_by_type, initial_time, resolution, horizon, interval)
end

function reset_info!(forecasts::SystemForecasts)
    forecasts.initial_time = UNITIALIZED_DATETIME
    forecasts.resolution = UNITIALIZED_PERIOD
    forecasts.horizon = UNITIALIZED_HORIZON
    @info "Reset system forecast information."
end

function is_uninitialized(forecasts::SystemForecasts)
    return forecasts.initial_time == UNITIALIZED_DATETIME &&
           forecasts.resolution == UNITIALIZED_PERIOD &&
           forecasts.horizon == UNITIALIZED_HORIZON
end

function _verify_forecasts(system_forecasts::SystemForecasts, forecasts)
    # Collect all existing component labels.
    unique_components = ForecastComponentLabelPairByInitialTime()
    for (key, existing_forecasts) in system_forecasts.data
        for forecast in existing_forecasts
            if !haskey(unique_components, forecast.initial_time)
                unique_components[forecast.initial_time] = Set{ForecastComponentLabelPair}()
            end

            component_label = (forecast.component, forecast.label)
            push!(unique_components[forecast.initial_time], component_label)
        end
    end

    for forecast in forecasts
        if forecast.resolution != system_forecasts.resolution
            throw(DataFormatError(
                "Forecast resolution $(forecast.resolution) does not match system " *
                "resolution $(system_forecasts.resolution)"
            ))
        end

        if get_horizon(forecast) != system_forecasts.horizon
            throw(DataFormatError(
                "Forecast horizon $(get_horizon(forecast)) does not match system horizon " *
                "$(system_forecasts.horizon)"
            ))
        end

        _verify_forecasts!(unique_components, system_forecasts.data, forecast)
    end
end

function _add_forecasts!(system_forecasts::SystemForecasts, forecasts)
    if length(forecasts) == 0
        return
    end

    if is_uninitialized(system_forecasts)
        # This is the first forecast added.
        forecast = forecasts[1]
        system_forecasts.horizon = get_horizon(forecast)
        system_forecasts.resolution = forecast.resolution
        system_forecasts.initial_time = forecast.initial_time
    end

    # Adding forecasts is all-or-none. Loop once to validate and then again to add them.
    # This will throw if something is invalid.
    _verify_forecasts(system_forecasts, forecasts)

    for forecast in forecasts
        _add_forecast!(system_forecasts.data, forecast)
    end

    set_interval!(system_forecasts)
end

function set_interval!(system_forecasts::SystemForecasts)
    initial_times = _get_forecast_initial_times(system_forecasts.data)
    if length(initial_times) == 1
        # TODO this needs work
        system_forecasts.interval = system_forecasts.resolution
    elseif length(initial_times) > 1
        # TODO is this correct?
        system_forecasts.interval = initial_times[2] - initial_times[1]
    else
        @error "no forecasts detected" forecasts maxlog=1
        system_forecasts.interval = Dates.Day(1)  # TODO
        #throw(DataFormatError("no forecasts detected"))
    end
end

"""Partially constructs SystemForecasts from JSON. Forecasts are not constructed."""
function SystemForecasts(data::NamedTuple)
    initial_time = Dates.DateTime(data.initial_time)
    resolution = JSON2.read(JSON2.write(data.resolution), Dates.Period)
    horizon = data.horizon
    interval = JSON2.read(JSON2.write(data.interval), Dates.Period)

    return SystemForecasts(ForecastsByType(), initial_time, resolution, horizon, interval)
end

function JSON2.write(io::IO, system_forecasts::SystemForecasts)
    return JSON2.write(io, encode_for_json(system_forecasts))
end

function JSON2.write(system_forecasts::SystemForecasts)
    return JSON2.write(encode_for_json(system_forecasts))
end

function encode_for_json(system_forecasts::SystemForecasts)
    # Many forecasts could have references to the same timeseries data, so we want to
    # avoid writing out duplicates.  Here's the flow:
    # 1. Identify duplicates by creating a hash of each.
    # 2. Create one UUID for each unique timeseries.
    # 3. Identify all forecast UUIDs that share each timeseries.
    # 4. Write out a vector of TimeseriesSerializationInfo items.
    # 5. Deserializion can re-create everything from this info.

    hash_to_uuid = Dict{UInt64, Base.UUID}()
    uuid_to_timeseries = Dict{Base.UUID, TimeseriesSerializationInfo}()

    for forecasts in values(system_forecasts.data)
        for forecast in forecasts
            hash_value = hash(forecast.data)
            if !haskey(hash_to_uuid, hash_value)
                uuid = UUIDs.uuid4()
                hash_to_uuid[hash_value] = uuid
                uuid_to_timeseries[uuid] = TimeseriesSerializationInfo(uuid,
                                                                       forecast.data,
                                                                       [get_uuid(forecast)])
            else
                uuid = hash_to_uuid[hash_value]
                push!(uuid_to_timeseries[uuid].forecasts, get_uuid(forecast))
            end
        end
    end

    # This procedure forces us to handle all fields manually, so assert that we have them
    # all covered in case someone adds a field later.
    fields = (:data, :initial_time, :resolution, :horizon, :interval)
    @assert fields == fieldnames(SystemForecasts)

    data = Dict()
    for field in fields
        field == :data && continue
        data[string(field)] = getfield(system_forecasts, field)
    end

    # Make a flat array of forecasts regardless of ForecastKey.
    # Deserialization can re-create the existing structure.
    data["forecasts"] = [x for (k, v) in system_forecasts.data for x in v]

    data["timeseries_infos"] = collect(values(uuid_to_timeseries))
    return data
end

struct TimeseriesSerializationInfo
    timeseries_uuid::Base.UUID
    timeseries::TimeSeries.TimeArray
    forecasts::Vector{Base.UUID}
end

"""Converts forecast JSON data to SystemForecasts."""
function convert_type!(
                       system_forecasts::SystemForecasts,
                       data::NamedTuple,
                       components::LazyDictFromIterator,
                      ) where T <: Forecast
    for field in (:initial_time, :resolution, :horizon, :interval)
        field_type = fieldtype(typeof(system_forecasts), field)
        setfield!(system_forecasts, field, convert_type(field_type,
                                                        getproperty(data, field)))
    end

    forecast_uuid_to_timeseries = Dict{Base.UUID, TimeSeries.TimeArray}()

    for val in data.timeseries_infos
        timeseries_info = convert_type(TimeseriesSerializationInfo, val)
        for forecast_uuid in timeseries_info.forecasts
            @assert !haskey(forecast_uuid_to_timeseries, forecast_uuid)
            forecast_uuid_to_timeseries[forecast_uuid] = timeseries_info.timeseries
        end
    end

    forecasts = Vector{Forecast}()
    for forecast in data.forecasts
        uuid = Base.UUID(forecast.internal.uuid.value)
        if !haskey(forecast_uuid_to_timeseries, uuid)
            throw(DataFormatError("unmatched timeseries UUID: $uuid $forecast"))
        end
        timeseries = forecast_uuid_to_timeseries[uuid]
        forecast_base_type = getfield(PowerSystems, Symbol(forecast.type))
        push!(forecasts, convert_type(forecast_base_type, forecast, components, timeseries))
    end

    _add_forecasts!(system_forecasts, forecasts)
end

function Base.length(forecast::Forecast)
    return get_horizon(forecast)
end

"""
    get_timeseries(forecast::Forecast)

Return the timeseries for the forecast.

Note: timeseries data is stored in TimeSeries.TimeArray objects. TimeArray does not
currently support Base.view, so calling this function results in a memory allocation and
copy. Tracked in https://github.com/JuliaStats/TimeSeries.jl/issues/419.
"""
function get_timeseries(forecast::Forecast)
    full_ts = get_data(forecast)
    start_index = get_start_index(forecast)
    end_index = start_index + get_horizon(forecast) - 1
    return full_ts[start_index:end_index]
end

"""
    make_forecasts(forecast::Forecast, interval::Dates.Period, horizon::Int)

Make a vector of forecasts by incrementing through a forecast by interval and horizon.
"""
function make_forecasts(forecast::F, interval::Dates.Period, horizon::Int) where F <: Forecast
    # TODO: need more test coverage of corner cases.
    resolution = get_resolution(forecast)

    if forecast isa Union{Probabilistic, ScenarioBased}
        # TODO
        throw(InvalidParameter("this function doesn't support Probabilistic yet"))
    end

    if interval < resolution
        throw(InvalidParameter("interval=$interval is smaller than resolution=$resolution"))
    end

    if Dates.Second(interval) % Dates.Second(resolution) != Dates.Second(0)
        throw(InvalidParameter(
            "interval=$interval is not a multiple of resolution=$resolution"))
    end

    if horizon > get_horizon(forecast)
        throw(InvalidParameter(
            "horizon=$horizon is larger than forecast horizon=$(get_horizon(forecast))"))
    end

    interval_as_num = Int(Dates.Second(interval) / Dates.Second(resolution))
    forecasts = Vector{Deterministic}()

    # Index into the TimeArray that backs the master forecast.
    master_forecast_start = get_start_index(forecast)
    master_forecast_end = get_start_index(forecast) + get_horizon(forecast) - 1
    @debug "master indices" master_forecast_start master_forecast_end
    for index in range(master_forecast_start,
                       step=interval_as_num,
                       stop=master_forecast_end)
        start_index = index
        end_index = start_index + horizon - 1
        @debug "new forecast indices" start_index end_index
        if end_index > master_forecast_end
            break
        end

        initial_time = TimeSeries.timestamp(get_data(forecast))[start_index]
        component = get_component(forecast)
        forecast_ = Deterministic(component,
                                 get_label(forecast),
                                 resolution,
                                 initial_time,
                                 get_data(forecast),
                                 start_index,
                                 horizon)
        @info "Created forecast with" initial_time horizon component
        push!(forecasts, forecast_)
    end

    @assert length(forecasts) > 0

    master_end_ts = TimeSeries.timestamp(get_timeseries(forecast))[end]
    last_end_ts = TimeSeries.timestamp(get_timeseries(forecasts[end]))[end]
    if last_end_ts != master_end_ts
        throw(InvalidParameter(
            "insufficient data for forecast splitting $master_end_ts $last_end_ts"))
    end

    return forecasts
end

"""
    make_forecasts(forecast::FlattenIteratorWrapper{T},
                    interval::Dates.Period, horizon::Int) where T <: Forecast

Make a vector of forecasts by incrementing through a vector of forecasts
by interval and horizon.
"""
function make_forecasts(forecast::FlattenIteratorWrapper{T},
                        interval::Dates.Period, horizon::Int) where T <: Forecast

    forecasts = [make_forecasts(f, interval, horizon) for f in forecast]

    return vcat(forecasts...) # FlattenIteratorWrapper(T, forecasts) TODO: Revert to FlattenIteratorWrapper when #297 is addressed
end
