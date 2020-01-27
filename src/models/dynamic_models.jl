abstract type DynamicComponent <: DeviceParameter end
abstract type DynamicInjection <: Device end
supports_services(d::DynamicInjection) = false

function get_dynamic_components(device::T) where T <: DynamicInjection
    components_set = Set()
    for field in fieldnames(T)
        if fieldtype(T, field) <: DynamicComponent
            push!(components_set, getfield(device, field))
        end
    end
    return components_set
end
