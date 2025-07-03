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

"""
Remove a reservoir from a device.

Throws ArgumentError if the reservoir is not attached to the device.
"""
function remove_reservoir!(device::HydroTurbine, reservoir::HydroReservoir)
    if !_remove_reservoir!(device, reservoir)
        throw(
            ArgumentError(
                "reservoir $(get_name(reservoir)) was not attached to $(get_name(device))",
            ),
        )
    end
end

"""
Return true if the service is attached to the device.
"""
function has_reservoir(device::HydroTurbine, reservoir::HydroReservoir)
    for _reservoir in get_reservoirs(device)
        if IS.get_uuid(_reservoir) == IS.get_uuid(reservoir)
            return true
        end
    end

    return false
end

"""
Return true if any reservoir is attached to the device.
"""
function has_reservoir(turbine::HydroTurbine)
    for _reservoir in get_reservoirs(turbine)
        if isa(_reservoir, HydroReservoir)
            return true
        end
    end

    return false
end

has_reservoir(T::Type{<:HydroReservoir}, device::Device) = has_reservoir(device, T)

"""
Remove service from device if it is attached.
"""
function _remove_reservoir!(device::Device, reservoir::HydroReservoir)
    removed = false
    reservoirs = get_reservoirs(device)

    # The expectation is that there won't be many services in each device, and so
    # a faster lookup method is not needed.
    for (i, _reservoir) in enumerate(reservoirs)
        if IS.get_uuid(_reservoir) == IS.get_uuid(reservoir)
            deleteat!(reservoirs, i)
            removed = true
            @debug "Removed service $(get_name(reservoir)) from $(get_name(device))" _group =
                IS.LOG_GROUP_SYSTEM
            break
        end
    end

    return removed
end

"""
Remove all services attached to the device.
"""
function clear_reservoirs!(device::Device)
    reservoirs = get_reservoirs(device)
    empty!(reservoirs)
    return
end

"""
Check if a device has attribute 'active_power' for active power consumption or generation.
"""
has_active_power(d::Device) = throw(
    IS.NotImplementedError(
        "has_active_power not implemented for this device type: $(typeof(d))!",
    ),
)

"""
Most StaticInjection models have active power consumption or generation, so return true
"""
has_active_power(::StaticInjection) = true

"""
SynchronousCondenser does not have active power consumption / generation, so return false
"""
has_active_power(::SynchronousCondenser) = false

"""
FixedAdmittance does not have active power consumption / generation, so return false
"""
has_active_power(::FixedAdmittance) = false

"""
SwitchedAdmittance does not have active power consumption / generation, so return false
"""
has_active_power(::SwitchedAdmittance) = false
