"""
Abstract type for all components used to compose a [`DynamicInjection`](@ref) device
"""
abstract type DynamicComponent <: DeviceParameter end

"""
Abstract type for all dynamic injection types
"""
abstract type DynamicInjection <: Device end

"""
Return all the dynamic components of a [`DynamicInjection`](@ref) device
"""
function get_dynamic_components(device::T) where {T <: DynamicInjection}
    return (
        getfield(device, x) for
        (x, y) in zip(fieldnames(T), fieldtypes(T)) if y <: DynamicComponent
    )
end

supports_services(::DynamicInjection) = false
get_states(::DynamicInjection) = Vector{Symbol}()
function get_states_types(d::DynamicComponent)
    return fill(StateTypes.Differential, get_n_states(d))
end
