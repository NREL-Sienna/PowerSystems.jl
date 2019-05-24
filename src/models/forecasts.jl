abstract type Forecast <: PowerSystemType end

const Forecasts = Vector{<:Forecast}

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

function _add_forecast!(data::ForecastsByType, forecast::T) where T <: Forecast
    key = ForecastKey(forecast.initial_time, T)
    if !haskey(data, key)
        data[key] = Vector{T}()
    end

    push!(data[key], forecast)
end

"""Container for forecasts and their metadata. Implementation detail that is not exported.
Functions to access the data should go through the System."""
struct SystemForecasts
    data::ForecastsByType
    initial_time::Dates.DateTime
    resolution::Dates.Period
    horizon::Int64
    interval::Dates.Period
end

"""Constructs SystemForecasts from the flat vector of forecasts resulting from parsing."""
function SystemForecasts(forecasts::Forecasts)
    forecasts_by_type = ForecastsByType()
    initial_time = Dates.DateTime(Dates.Second(0))
    resolution = Dates.Period(Dates.Second(0))
    initialized = false
    horizon::Int64 = 0

    for forecast in forecasts
        if !initialized
            initial_time = forecast.initial_time
            resolution = forecast.resolution
            horizon = length(forecast)
            initialized = true
        else
            if forecast.resolution != resolution
                throw(DataFormatError("found multiple resolution values in forecasts"))
                continue
            end

            cur_horizon = length(forecast)
            if cur_horizon != horizon
                msg = "found multiple horizons in forecasts: $horizon, $cur_horizon"
                throw(DataFormatError(msg))
            end
        end

        _add_forecast!(forecasts_by_type, forecast)
    end

    initial_times = _get_forecast_initial_times(forecasts_by_type)
    if length(initial_times) == 1
        # TODO this needs work
        interval = resolution
    elseif length(initial_times) > 1
        # TODO is this correct?
        interval = initial_times[2] - initial_times[1]
    else
        @error "no forecasts detected" forecasts maxlog=1
        interval = Dates.Day(1)  # TODO
        #throw(DataFormatError("no forecasts detected"))
    end

    return SystemForecasts(forecasts_by_type, initial_time, resolution, horizon, interval)
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
        println(io, "Initial Time $initial_time")
        println(io, "--------------------------------")

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
        forecast_type = getfield(PowerSystems, Symbol(type_str))
        parameter_types = [getfield(PowerSystems, Symbol(x)) for x in params]
        if length(parameter_types) == 1
            forecast_type = forecast_type{parameter_types[1]}
        elseif length(parameter_types) != 0
            @assert false
        end

        key = ForecastKey(initial_time, forecast_type)

        forecasts.data[key] = Vector{forecast_type}()
        for forecast in getfield(data.data, symbol)
            if forecast_type <: Deterministic
                push!(forecasts.data[key],
                      convert_type(Deterministic, forecast, components, parameter_types))
            else
                push!(forecasts.data[issue_time], convert_type(forecast_type))
            end
        end
    end
end

function Base.length(forecast::Forecast)
    return length(forecast.data)
end

"""
    Deterministic
        A deterministic forecast for a particular data field in a PowerSystemDevice.

"""
struct Deterministic{T <: Component} <: Forecast
    component::T                        # component
    label::String                       # label of component parameter forecasted
    resolution::Dates.Period            # resolution
    initial_time::Dates.DateTime         # forecast availability time
    data::TimeSeries.TimeArray          # TimeStamp - scalingfactor
    internal::PowerSystemInternal
end

function Deterministic(component, label, resolution, initial_time, data,)
    return Deterministic(component, label, resolution, initial_time, data,
                         PowerSystemInternal())
end

function Deterministic(component::Component,
                       label::String,
                       resolution::Dates.Period,
                       initial_time::Dates.DateTime,
                       time_steps::Int)
    data = TimeSeries.TimeArray(initial_time:Dates.Hour(1):initial_time+resolution*(time_steps-1),
                                ones(time_steps))
    return Deterministic(component, label, resolution, initial_time, data)
end

function Deterministic(component::Component, label::String, data::TimeSeries.TimeArray)
    resolution = getresolution(data)
    initial_time = TimeSeries.timestamp(data)[1]
    Deterministic(component, label, resolution, initial_time, data)
end

# Refer to docstrings in services.jl.

function JSON2.write(io::IO, forecast::Deterministic)
    return JSON2.write(io, encode_for_json(forecast))
end

function JSON2.write(forecast::Deterministic)
    return JSON2.write(encode_for_json(forecast))
end

function encode_for_json(forecast::Deterministic)
    fields = fieldnames(Deterministic)
    vals = []

    for name in fields
        val = getfield(forecast, name)
        if val isa Component
            push!(vals, get_uuid(val))
        else
            push!(vals, val)
        end
    end

    return NamedTuple{fields}(vals)
end

"""Creates a Deterministic object by decoding the data that was in JSON. This data stores
the values for the field contributingdevices as UUIDs, so this will lookup each device in
devices.
"""
function convert_type(
                      ::Type{T},
                      data::NamedTuple,
                      components::LazyDictFromIterator,
                      parameter_types::Vector{DataType},
                     ) where T <: Deterministic
    @debug T data
    values = []
    component_type = nothing

    for (fieldname, fieldtype)  in zip(fieldnames(T), fieldtypes(T))
        val = getfield(data, fieldname)
        if fieldtype <: Component
            uuid = Base.UUID(val.value)
            component = get(components, uuid)

            if isnothing(component)
                throw(DataFormatError("failed to find $uuid"))
            end

            component_type = typeof(component)
            @assert length(parameter_types) == 1
            @assert component_type == parameter_types[1]
            push!(values, component)
        else
            obj = convert_type(fieldtype, val)
            push!(values, obj)
        end
    end

    @assert !isnothing(component_type)

    return T{component_type}(values...)
end

function convert_type(::Type{T}, data::Any) where T <: Deterministic
    error("This form of convert_type is not supported for Deterministic")
end

#= These are currently unused and need to be fixed.
struct Scenarios <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initial_time::Dates.DateTime
    scenarioquantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
    internal::PowerSystemInternal
end

function Scenarios(horizon, resolution, interval, initial_time, scenarioquantity, data)
    return Scenarios(horizon, resolution, interval, initial_time, scenarioquantity, data,
                     PowerSystemInternal())
end

struct Probabilistic <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initial_time::Dates.DateTime
    percentilequantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
    internal::PowerSystemInternal
end

function Probabilistic(horizon, resolution, interval, initial_time, percentilequantity, data)
    return Probabilistic(horizon, resolution, interval, initial_time, percentilequantity,
                         data, PowerSystemInternal())
end
=#
