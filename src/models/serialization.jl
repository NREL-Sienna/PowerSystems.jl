
# Enables deserialization of VariableCost. The default implementation can't figure out the
# variable Union.

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

# Enables serialization for AGC. Stores Area as a UUID.

function JSON2.write(io::IO, service::AGC)
    return JSON2.write(io, encode_for_json(service))
end

function JSON2.write(service::AGC)
    return JSON2.write(encode_for_json(service))
end

function encode_for_json(service::AGC)
    fields = fieldnames(AGC)
    vals = []

    for name in fields
        val = getfield(service, name)
        if val isa Area
            push!(vals, IS.get_uuid(val))
        else
            push!(vals, val)
        end
    end

    return NamedTuple{fields}(vals)
end

"""
Create an AGC object by decoding the data that was in JSON. This data stores the
value for the Area as a UUID, so this will lookup each device in devices.
"""
function IS.convert_type(::Type{AGC}, data::NamedTuple, devices::Dict)
    values = []
    for (fieldname, fieldtype) in zip(fieldnames(AGC), fieldtypes(AGC))
        val = getfield(data, fieldname)
        if fieldtype <: Union{Nothing, Area}
            if !isnothing(val)
                uuid = Base.UUID(val.value)
                val = devices[uuid]
            end
            push!(values, val)
        else
            obj = IS.convert_type(fieldtype, val)
            push!(values, obj)
        end
    end

    return AGC(values...)
end

function IS.convert_type(::Type{AGC}, data::Any)
    error("This form of convert_type is not supported for Services")
end
