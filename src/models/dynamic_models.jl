abstract type DynamicComponent <: DeviceParameter end

"""
Abstract type for all dynamic injection types
"""
abstract type DynamicInjection <: Device end

supports_services(d::DynamicInjection) = false

function get_dynamic_components(device::T) where {T <: DynamicInjection}
    return (
        getfield(device, x) for
        (x, y) in zip(fieldnames(T), fieldtypes(T)) if y <: DynamicComponent
    )
end
