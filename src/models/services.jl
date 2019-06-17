
abstract type Service <: Component end
abstract type Reserve <: Service end

"""
All subtypes of Service define contributingdevices::Vector{Device}. The values get populated
with references to existing devices. The following functions override JSON encoding to
replace the devices with their UUIDs. This solves two problems:

1. The information is redundant, consuming unnecessary space. Also, a user could modify
   information in the JSON file in one place but not the other, which would be very
   problematic.
2. The contributingdevices are stored in an vector of abstract types. JSON doesn't provide a
   way to encode the actual concrete type, so deserialization would have to infer the type.
   There is no guessing if the UUIDs are stored instead. The deserialization process can
   replace the references with actual devices.

These functions could be re-defined to accept subtypes of Component or PowerSystemType.
This is the minimum amount needed for now.
"""

function JSON2.write(io::IO, service::T) where T <: Service
    return JSON2.write(io, encode_for_json(service))
end

function JSON2.write(service::T) where T <: Service
    return JSON2.write(encode_for_json(service))
end

function encode_for_json(service::T) where T <: Service
    fields = fieldnames(T)
    vals = []

    for name in fields
        val = getfield(service, name)
        if val isa Vector{<:Device}
            push!(vals, get_uuid.(val))
        else
            push!(vals, val)
        end
    end

    return NamedTuple{fields}(vals)
end

"""Creates a Service object by decoding the data that was in JSON. This data stores the
values for the field contributingdevices as UUIDs, so this will lookup each device in
devices.
"""
function convert_type(
                      ::Type{T},
                      data::NamedTuple,
                      devices::LazyDictFromIterator,
                     ) where T <: Service
    @debug T data
    values = []
    for (fieldname, fieldtype)  in zip(fieldnames(T), fieldtypes(T))
        val = getfield(data, fieldname)
        if fieldtype <: Vector{<:Device}
            real_devices = []
            for item in val
                uuid = Base.UUID(item.value)
                service = get(devices, uuid)
                if isnothing(service)
                    throw(DataFormatError("failed to find $uuid"))
                end
                push!(real_devices, service)
            end
            push!(values, real_devices)
        else
            obj = convert_type(fieldtype, val)
            push!(values, obj)
        end
    end

    return T(values...)
end

function convert_type(::Type{T}, data::Any) where T <: Service
    error("This form of convert_type is not supported for Services")
end
