
"""Serializes a PowerSystemType to a JSON file."""
function to_json(obj::T, filename::String) where {T <: PowerSystemType}
    return open(filename, "w") do io
        return to_json(io, obj)
    end

    @info "Serialized $T to $filename"
end

"""Serializes a PowerSystemType to a JSON string."""
function to_json(obj::T)::String where {T <: PowerSystemType}
    return JSON2.write(obj)
end

"""JSON Serializes a PowerSystemType to an IO stream in JSON."""
function to_json(io::IO, obj::T) where {T <: PowerSystemType}
    return JSON2.write(io, obj)
end

"""Deserializes a PowerSystemType from a JSON filename."""
function from_json(::Type{T}, filename::String) where {T <: PowerSystemType}
    return open(filename) do io
        from_json(io, T)
    end
end

"""Deserializes a PowerSystemType from String or IO."""
function from_json(io::Union{IO, String}, ::Type{T}) where {T <: PowerSystemType}
    return JSON2.read(io, T)
end

"""Enables JSON deserialization of TimeSeries.TimeArray.
The default implementation fails because the data field is defined as an AbstractArray.
Deserialization can't determine the actual concrete type.
"""
function JSON2.read(io::IO, ::Type{T}) where {T <: TimeSeries.TimeArray}
    data = JSON2.read(io)
    timestamp = [Dates.DateTime(x) for x in data.timestamp]
    values = [Float64(x) for x in data.values]
    colnames = [Symbol(x) for x in data.colnames]
    meta = data.meta
    return TimeSeries.TimeArray(timestamp, values, colnames, meta)
end

"""Enables JSON deserialization of Dates.Period.
The default implementation fails because the field is defined as abstract. Converts to a
common unit when serializing so that any value can be read back.
"""
function JSON2.write(resolution::Dates.Period)
    return JSON2.write(encode_for_json(resolution))
end

function JSON2.write(io::IO, resolution::Dates.Period)
    return JSON2.write(io, encode_for_json(resolution))
end

# TODO: should this actually be milliseconds? What is the lowest resolution we use?
RESOLUTION_UNITS_FUNC = Dates.Second

function encode_for_json(resolution::Dates.Period)
    return (value=RESOLUTION_UNITS_FUNC(resolution).value,)
end

function JSON2.read(io::IO, ::Type{T}) where {T <: Dates.Period}
    data = JSON2.read(io)
    return RESOLUTION_UNITS_FUNC(data.value)
end

"""
The next few methods fix serialization of UUIDs. The underlying type of a UUID is a UInt128.
JSON2 tries to encode this as a number in JSON. Encoding integers greater than can
be stored in a signed 64-bit integer sometimes does not work - at least when using the
JSON2.@pretty option. The number gets converted to a float in scientific notation, and so
the UUID is truncated and essentially lost. These functions cause JSON2 to encode UUIDs as
strings and then convert them back during deserialization.
"""

function JSON2.write(uuid::Base.UUID)
    return JSON2.write(encode_for_json(uuid))
end

function JSON2.write(io::IO, uuid::Base.UUID)
    return JSON2.write(io, encode_for_json(uuid))
end

function JSON2.read(io::IO, ::Type{Base.UUID})
    data = JSON2.read(io)
    return Base.UUID(data.value)
end

function encode_for_json(uuid::Base.UUID)
    return (value=string(uuid),)
end
