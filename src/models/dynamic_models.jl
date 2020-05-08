abstract type DynamicComponent <: DeviceParameter end

"""
Abstract type for all dynamic injection types

Subtypes must implement these methods:
- get_static_component
"""
abstract type DynamicInjection <: Device end

supports_services(d::DynamicInjection) = false

function get_static_component(device::T) where {T <: DynamicInjection}
    error("get_static_component must be implemented for type $T")
end

function get_dynamic_components(device::T) where {T <: DynamicInjection}
    components_set = Set()
    for field in fieldnames(T)
        if fieldtype(T, field) <: DynamicComponent
            push!(components_set, getfield(device, field))
        end
    end
    return components_set
end
