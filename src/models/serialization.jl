
"""Serializes a PowerSystemType to a JSON file."""
function to_json(obj::T, filename::String) where {T <: PowerSystemType}
    return open(filename, "w") do io
        return to_json(io, obj)
    end

    @info "Serialized $T to $filename"
end

"""Serializes a PowerSystemType to a JSON string."""
function to_json(obj::T)::String where {T <: PowerSystemType}
    if T == ConcreteSystem
        _handle_system_data(obj)
    end

    return JSON2.write(obj)
end

"""JSON Serializes a PowerSystemType to an IO stream in JSON."""
function to_json(io::IO, obj::T) where {T <: PowerSystemType}
    if T == ConcreteSystem
        _handle_system_data(obj)
    end

    return JSON2.write(io, obj)
end

function _handle_system_data(sys::ConcreteSystem)
    for component in get_mixed_components(ThermalGen, sys)
        # TODO: convert variablecost to serializable data.
        # Refer to GitHub issue #198.
        if component.econ.variablecost isa Function
            error("Serializing when variablecost is a Function is not yet supported")
        end
    end
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

"""Enables JSON deserialization of TimeSeries.TimeArray."""
function JSON2.read(io::IO, ::Type{T}) where {T <: TimeSeries.TimeArray}
    data = JSON2.read(io)
    timestamp = [Dates.DateTime(x) for x in data.timestamp]
    values = [Float64(x) for x in data.values]
    colnames = [Symbol(x) for x in data.colnames]
    meta = data.meta
    return TimeSeries.TimeArray(timestamp, values, colnames, meta)
end

