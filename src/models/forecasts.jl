abstract type Forecast <: PowerSystemType end

const Forecasts = Vector{<:Forecast}
# This is deprecated because only the legacy System uses it. Parsing code need to change to
# build the new format.
const SystemForecastsDeprecated = Dict{Symbol, Forecasts}
const IssueTime = NamedTuple{(:resolution, :initialtime),
                             Tuple{Dates.Period, Dates.DateTime}}
const SystemForecasts = Dict{IssueTime, Forecasts}

# The default deserialization of SystemForecasts doesn't work for these reasons:
# - IssueTime fails to serialize correctly.
# - Forecasts are abstract types. We need to know what concrete type to create during
#   deserialization.
#
# The code below converts the forecast data to a different format to enable deserialization.

struct _SystemForecastArrayForJSON
    resolution::Dates.Period
    initialtime::Dates.DateTime
    forecasts::Forecasts
    forecast_types::Vector{String}  # Encode the exact type so that deserialization doesn't have
                            # to infer what it is.
end

struct _SystemForecastsForJSON
    forecasts::Vector{_SystemForecastArrayForJSON}
end

function JSON2.write(io::IO, forecasts::SystemForecasts)
    return JSON2.write(io, encode_for_json(forecasts))
end

function JSON2.write(forecasts::SystemForecasts)
    return JSON2.write(encode_for_json(forecasts))
end

function encode_for_json(system_forecasts::SystemForecasts)
    forecasts_for_json = Vector{_SystemForecastArrayForJSON}()
    for (issue_time, forecasts) in system_forecasts
        forecast_types = [strip_module_names(typeof(x)) for x in forecasts]
        push!(forecasts_for_json, _SystemForecastArrayForJSON(issue_time.resolution,
                                                              issue_time.initialtime,
                                                              forecasts,
                                                              forecast_types))
    end

    return _SystemForecastsForJSON(forecasts_for_json)
end

"""Converts forecast JSON data to SystemForecasts. This version builds onto the passed dict
instead of returning an object because ConcreteSystem is immutable.
"""
function convert_type!(
                       forecasts::SystemForecasts,
                       data::NamedTuple,
                       components::LazyDictFromIterator,
                      ) where T <: Forecast
    for array in data.forecasts
        issue_time = IssueTime((JSON2.read(JSON2.write(array.resolution), Dates.Period),
                                JSON2.read(JSON2.write(array.initialtime), Dates.DateTime)))
        forecasts[issue_time] = Vector{Forecast}()
        for (forecast, forecast_type_str) in zip(array.forecasts, array.forecast_types)
            type_str, params = separate_type_and_parameter_types(forecast_type_str)
            forecast_type = getfield(PowerSystems, Symbol(type_str))
            # Deterministic is a parametric type; deal with its parameters.
            parameter_types = [getfield(PowerSystems, Symbol(x)) for x in params]
            if forecast_type <: Deterministic
                push!(forecasts[issue_time],
                      convert_type(Deterministic, forecast, components, parameter_types))
            else
                push!(forecasts[issue_time], convert_type(forecast_type))
            end
        end
    end
end

"""
    get_issue_time(forecast::Forecast)

Get the time designator for the forecast.

"""
function get_issue_time(forecast::Forecast)
    return IssueTime((forecast.resolution, forecast.initialtime))
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
    initialtime::Dates.DateTime         # forecast availability time
    data::TimeSeries.TimeArray          # TimeStamp - scalingfactor
    internal::PowerSystemInternal
end

function Deterministic(component, label, resolution, initialtime, data,)
    return Deterministic(component, label, resolution, initialtime, data,
                         PowerSystemInternal())
end

function Deterministic(component::Component,
                       label::String,
                       resolution::Dates.Period,
                       initialtime::Dates.DateTime,
                       time_steps::Int)
    data = TimeSeries.TimeArray(initialtime:Dates.Hour(1):initialtime+resolution*(time_steps-1),
                                ones(time_steps))
    return Deterministic(component, label, resolution, initialtime, data)
end

function Deterministic(component::Component, label::String, data::TimeSeries.TimeArray)
    resolution = getresolution(data)
    initialtime = TimeSeries.timestamp(data)[1]
    Deterministic(component, label, resolution, initialtime, data)
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

struct Scenarios <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    scenarioquantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
    internal::PowerSystemInternal
end

function Scenarios(horizon, resolution, interval, initialtime, scenarioquantity, data)
    return Scenarios(horizon, resolution, interval, initialtime, scenarioquantity, data,
                     PowerSystemInternal())
end

struct Probabilistic <: Forecast
    horizon::Int
    resolution::Dates.Period
    interval::Dates.Period
    initialtime::Dates.DateTime
    percentilequantity::Int
    data::Dict{Any,Dict{Int,TimeSeries.TimeArray}}
    internal::PowerSystemInternal
end

function Probabilistic(horizon, resolution, interval, initialtime, percentilequantity, data)
    return Probabilistic(horizon, resolution, interval, initialtime, percentilequantity,
                         data, PowerSystemInternal())
end
