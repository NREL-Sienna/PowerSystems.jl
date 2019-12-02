"""
    add_service!(device::Device, service::Service)

Add a service to a device.

Throws ArgumentError if the service is already attached to the device.
"""
function add_service!(device::Device, service::Service)
    services = get_services(device)
    for _service in services
        if IS.get_uuid(service) == IS.get_uuid(_service)
            throw(ArgumentError("service $(get_name(service)) is already attached to $(get_name(device))"))
        end
    end

    push!(services, service)
    @debug "Add $service to $(get_name(device))"
end

"""
    remove_service!(device::Device, service::Service)

Remove a service from a device.

Throws ArgumentError if the service is not attached to the device.
"""
function remove_service!(device::Device, service::Service)
    if !_remove_service!(device, service)
        throw(ArgumentError("service $(get_name(service)) was not attached to $(get_name(device))"))
    end
end

"""
    has_service(device::Device, service::Service)

Return true if the service is attached to the device.
"""
function has_service(device::Device, service::Service)
    for _service in get_services(device)
        if IS.get_uuid(_service) == IS.get_uuid(service)
            return true
        end
    end

    return false
end

"""
    has_service(device::Device, ::Type{T}) where T <:Service

Return true if a service with type T is attached to the device.
"""
function has_service(device::Device, ::Type{T}) where T <:Service
    for _service in get_services(device)
        if isa(_service, T)
            return true
        end
    end

    return false
end


"""
Remove service from device if it is attached.
"""
function _remove_service!(device::Device, service::Service)
    removed = false
    services = get_services(device)

    # The expectation is that there won't be many services in each device, and so
    # a faster lookup method is not needed.
    for (i, _service) in enumerate(services)
        if IS.get_uuid(service) == IS.get_uuid(service)
            deleteat!(services, i)
            removed = true
            @debug "Removed service $(get_name(service)) from $(get_name(device))"
            break
        end
    end

    return removed
end

"""
    clear_services!(device::Device)

Remove all services attached to the device.
"""
function clear_services!(device::Device)
    services = get_services(device)
    empty!(services)
end


# All subtypes of Device define services::Vector{Service}. The values get populated
# with references to existing services. The following functions override JSON encoding to
# replace the devices with their UUIDs. This solves two problems:
#
# 1. The information is redundant, consuming unnecessary space. Also, a user could modify
#    information in the JSON file in one place but not the other, which would be very
#    problematic.
# 2. The services are stored in an vector of abstract types. JSON doesn't provide a
#    way to encode the actual concrete type, so deserialization would have to infer the type.
#    There is no guessing if the UUIDs are stored instead. The deserialization process can
#    replace the references with actual devices.

function JSON2.write(io::IO, device::T) where {T<:Device}
    return JSON2.write(io, encode_for_json(device))
end

function JSON2.write(device::T) where {T<:Device}
    return JSON2.write(encode_for_json(device))
end

"""
Encode composed buses and services as UUIDs.
"""
function encode_for_json(device::T) where {T<:Device}
    fields = fieldnames(T)
    vals = []

    for name in fields
        val = getfield(device, name)
        if val isa Vector{Service}
            push!(vals, IS.get_uuid.(val))
        elseif val isa Bus
            push!(vals, IS.get_uuid(val))
        else
            push!(vals, val)
        end
    end

    return NamedTuple{fields}(vals)
end

"""
Creates a Device object by decoding the data that was in JSON. This data stores the
values for buses and services as UUIDs, so this will lookup each in component_cache.
"""
function IS.convert_type(
    ::Type{T},
    data::NamedTuple,
    component_cache::Dict,
) where {T<:Device}
    @debug "convert_type" T data
    values = []
    for (fieldname, fieldtype) in zip(fieldnames(T), fieldtypes(T))
        val = getfield(data, fieldname)
        if fieldtype <: Vector{Service}
            services = Service[]
            for item in val
                uuid = Base.UUID(item.value)
                service = component_cache[uuid]
                push!(services, service)
            end
            push!(values, services)
        elseif fieldtype <: Bus
            uuid = Base.UUID(val.value)
            bus = component_cache[uuid]
            push!(values, bus)
        elseif fieldtype <: Component
            # Recurse.
            push!(values, IS.convert_type(fieldtype, val, component_cache))
        else
            obj = IS.convert_type(fieldtype, val)
            push!(values, obj)
        end
    end

    return T(values...)
end

function IS.convert_type(::Type{Device}, data::Any)
    error("This form of convert_type is not supported for Devices")
end
