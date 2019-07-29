
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
    colnames = [Symbol(x) for x in data.colnames]
    dim2 = length(colnames)
    dim1 = Int(length(data.values) / dim2)
    meta = data.meta

    for i in eachindex(data.values)
        data.values[i] = Float64(data.values[i])
    end

    if length(colnames) > 1
        vals = reshape(data.values, dim1, dim2)
    else
        vals = data.values
    end

    return TimeSeries.TimeArray(timestamp, vals, colnames, meta)
end

"""Enables JSON deserialization of Dates.Period.
The default implementation fails because the field is defined as abstract.
Encode the type when serializing so that the correct value can be deserialized.
"""
function JSON2.write(resolution::Dates.Period)
    return JSON2.write(encode_for_json(resolution))
end

function JSON2.write(io::IO, resolution::Dates.Period)
    return JSON2.write(io, encode_for_json(resolution))
end

function encode_for_json(resolution::Dates.Period)
    return (value=resolution.value,
            unit=strip_module_names(string(typeof(resolution))))
end

function JSON2.read(io::IO, ::Type{T}) where {T <: Dates.Period}
    data = JSON2.read(io)
    return getfield(Dates, Symbol(data.unit))(data.value)
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

"""The next set of methods fix serialization for Complex numbers."""

function JSON2.write(value::Complex)
    return JSON2.write(encode_for_json(value))
end

function JSON2.write(io::IO, value::Complex)
    return JSON2.write(io, encode_for_json(value))
end

function JSON2.read(io::IO, ::Type{Complex})
    data = JSON2.read(io)
    return Complex(data.real, data.imag)
end

function encode_for_json(value::Complex)
    return (real=real(value), imag=imag(value))
end

"""Enables deserialization of VariableCost. The default implementation can't figure out the
variable Union.
"""
function JSON2.read(io::IO, ::Type{VariableCost})
    data = JSON2.read(io)
    if data.cost isa Real
        return VariableCost(Float64(data.cost))
    elseif data.cost[1] isa Array
        variable = Vector{Tuple{Float64, Float64}}()
        for array in data.cost
            push!(variable, Tuple{Float64, Float64}(array))
        end
    else
        @assert data.cost isa Tuple || data.cost isa Array
        variable = Tuple{Float64, Float64}(data.cost)
    end

    return VariableCost(variable)
end

# Refer to docstrings in services.jl.

function JSON2.write(io::IO, forecast::Forecast)
    return JSON2.write(io, encode_for_json(forecast))
end

function JSON2.write(forecast::Forecast)
    return JSON2.write(encode_for_json(forecast))
end

function encode_for_json(forecast::T) where T <: Forecast
    fields = fieldnames(T)
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

"""Creates a Forecast object by decoding the data that was in JSON. This data stores
the values for the field contributingdevices as UUIDs, so this will lookup each device in
devices.
"""
function convert_type(
                      ::Type{T},
                      data::NamedTuple,
                      components::LazyDictFromIterator,
                      parameter_types::Vector{DataType},
                     ) where T <: Forecast
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

function convert_type(::Type{T}, data::Any) where T <: Forecast
    error("This form of convert_type is not supported for Forecast")
end

"""Return a Tuple of type and parameter types for cases where a parametric type has been
encoded as a string. If the type is not parameterized then just return the type.
"""
function separate_type_and_parameter_types(name::String)
    parameters = Vector{String}()
    index_start_brace = findfirst("{", name)
    if isnothing(index_start_brace)
        type_str = name
    else
        type_str = name[1: index_start_brace.start - 1]
        index_close_brace = findfirst("}", name)
        @assert index_start_brace.start < index_close_brace.start
        for x in split(name[index_start_brace.start + 1: index_close_brace.start - 1], ",")
            push!(parameters, strip(x))
        end
    end

    return (type_str, parameters)
end
