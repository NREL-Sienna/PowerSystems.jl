abstract type Forecast <: PowerSystemType end

const Forecasts = Vector{<:Forecast}
# This is deprecated because only the legacy System uses it. Parsing code need to change to
# build the new format.
const SystemForecastsDeprecated = Dict{Symbol, Forecasts}
const IssueTime = NamedTuple{(:resolution, :initialtime),
                             Tuple{Dates.Period, Dates.DateTime}}
const SystemForecasts = Dict{IssueTime, Forecasts}

function get_issue_time(forecast::Forecast)
    return IssueTime((forecast.resolution, forecast.initialtime))
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
