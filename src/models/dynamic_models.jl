"""
Abstract type for all components used to compose a [`DynamicInjection`](@ref) device
"""
abstract type DynamicComponent <: DeviceParameter end

"""
Abstract type for all [Dynamic Devices](@ref)

A [dynamic](@ref D) [injection](@ref I) is the continuous time response of a generator,
typically modeled with differential equations. 
    
`DynamicInjection` components can added on to [`StaticInjection`](@ref) components,
which together define all the information needed to model the device in a dynamic
simulation.
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

# `states` and `n_states` are fixed structural properties of dynamic components, marked
# `exclude_setter` ("Do not modify") in the struct descriptors so no per-struct setters are
# generated. The struct generator still exports the public `set_states!`/`set_n_states!`
# names, so define them here to reject mutation rather than leave the exports undefined.
set_states!(::Union{DynamicComponent, DynamicInjection}, ::Any) = throw(
    ArgumentError("`states` is a fixed property of dynamic components and cannot be set"),
)
set_n_states!(::Union{DynamicComponent, DynamicInjection}, ::Any) = throw(
    ArgumentError("`n_states` is a fixed property of dynamic components and cannot be set"),
)

"""
    Default implementation of get_state_types for dynamic components. Assumes all states are
    Differential
"""
function get_states_types(d::DynamicComponent)
    return fill(StateTypes.Differential, get_n_states(d))
end

function get_frequency_droop(::V) where {V <: DynamicInjection}
    throw(
        ArgumentError(
            "get_frequency_droop not implemented for type $V.",
        ),
    )
end
