"""
This function add a service to the component without checking if the component and the service are attached to the same system
"""
function add_service_internal!(device::Device, service::Service)
    services = get_services(device)
    for _service in services
        if IS.get_uuid(service) == IS.get_uuid(_service)
            throw(
                ArgumentError(
                    "service $(get_name(service)) is already attached to $(get_name(device))",
                ),
            )
        end
    end

    push!(services, service)
    @debug "Add $service to $(get_name(device))" _group = IS.LOG_GROUP_SYSTEM
end

function add_service_internal!(device::Device, service::AGC)
    device_bus_area = get_area(get_bus(device))
    service_area = get_area(service)
    if isnothing(device_bus_area) ||
       !(IS.get_uuid(device_bus_area) == IS.get_uuid(service_area))
        throw(
            IS.ConflictingInputsError(
                "Device $(get_name(device)) is not located in the regulation control area",
            ),
        )
    end

    services = get_services(device)
    for _service in services
        if IS.get_uuid(service) == IS.get_uuid(_service)
            throw(
                ArgumentError(
                    "service $(get_name(service)) is already attached to $(get_name(device))",
                ),
            )
        end
    end

    push!(services, service)
    @debug "Add $service to $(get_name(device))" _group = IS.LOG_GROUP_SYSTEM
end

"""
Remove a service from a device.

Throws ArgumentError if the service is not attached to the device.
"""
function remove_service!(device::Device, service::Service)
    if !_remove_service!(device, service)
        throw(
            ArgumentError(
                "service $(get_name(service)) was not attached to $(get_name(device))",
            ),
        )
    end
end

"""
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
Return true if a service with type T is attached to the device.
"""
function has_service(device::Device, ::Type{T}) where {T <: Service}
    for _service in get_services(device)
        if isa(_service, T)
            return true
        end
    end

    return false
end

has_service(T::Type{<:Service}, device::Device) = has_service(device, T)

"""
Remove service from device if it is attached.
"""
function _remove_service!(device::Device, service::Service)
    removed = false
    services = get_services(device)

    # The expectation is that there won't be many services in each device, and so
    # a faster lookup method is not needed.
    for (i, _service) in enumerate(services)
        if IS.get_uuid(_service) == IS.get_uuid(service)
            deleteat!(services, i)
            removed = true
            @debug "Removed service $(get_name(service)) from $(get_name(device))" _group =
                IS.LOG_GROUP_SYSTEM
            break
        end
    end

    return removed
end

"""
Remove all services attached to the device.
"""
function clear_services!(device::Device)
    services = get_services(device)
    empty!(services)
    return
end
