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

function Base.summary(io::IO, forecasts::SystemForecasts)
    counts = Dict{String, Int}()
    rows = []

    println(io, "Forecasts")
    println(io, "=========")
    println(io, "Resolution: $(forecasts.resolution)")
    println(io, "Horizon: $(forecasts.horizon)")
    println(io, "Interval: $(forecasts.interval)\n")
    println(io, "---------------------------------")
    initial_times = _get_forecast_initial_times(forecasts.data)
    for initial_time in initial_times
        for (key, values) in forecasts.data
            if key.initial_time != initial_time
                continue
            end

            type_str = strip_module_names(string(key.forecast_type))
            counts[type_str] = length(values)
            parents = [strip_module_names(string(x)) for x in supertypes(key.forecast_type)]
            row = (ConcreteType=type_str,
                   SuperTypes=join(parents, " <: "),
                   Count=length(values))
            push!(rows, row)
        end
        println(io, "Initial Time: $initial_time")
        println(io, "---------------------------------")

        sort!(rows, by = x -> x.ConcreteType)

        df = DataFrames.DataFrame(rows)
        Base.show(io, df)
        println(io, "\n")
    end
end

"""Converts forecast JSON data to SystemForecasts. This version builds onto the passed dict
instead of returning an object because ConcreteSystem is immutable.
"""
function convert_type!(
                       forecasts::SystemForecasts,
                       data::NamedTuple,
                       components::LazyDictFromIterator,
                      ) where T <: Forecast
    for field in (:initial_time, :resolution, :horizon, :interval)
        field_type = fieldtype(typeof(forecasts), field)
        setfield!(forecasts, field, convert_type(field_type, getproperty(data, field)))
    end

    for symbol in propertynames(data.data)
        key_str = string(symbol)
        # Looks like this:
        # "PowerSystems.ForecastKey(2020-01-01T00:00:00, Deterministic{RenewableFix})"
        index_start_time = findfirst("(", key_str).start + 1
        index_end_time = findfirst(",", key_str).start - 1
        index_start_type = index_end_time + 3
        index_end_type = findfirst(")", key_str).start - 1

        initial_time_str = key_str[index_start_time:index_end_time]
        initial_time = Dates.DateTime(initial_time_str)

        forecast_type_str = key_str[index_start_type:index_end_type]
        type_str, params = separate_type_and_parameter_types(forecast_type_str)
        forecast_base_type = getfield(PowerSystems, Symbol(type_str))
        parameter_types = [getfield(PowerSystems, Symbol(x)) for x in params]
        if length(parameter_types) == 1
            forecast_type = forecast_base_type{parameter_types[1]}
        elseif length(parameter_types) == 0
            forecast_type = forecast_base_type
        else
            @assert false
        end

        key = ForecastKey(initial_time, forecast_type)

        forecasts.data[key] = Vector{forecast_type}()
        for forecast in getfield(data.data, symbol)
            push!(forecasts.data[key],
                  convert_type(forecast_base_type, forecast, components, parameter_types))
        end
    end
end

function Base.length(forecast::Forecast)
    return length(forecast.data)
end

function get_horizon(forecast::Forecast)
    return length(forecast)
end
