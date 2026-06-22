"""
Abstract type for devices that [inject](@ref I) power or current.

A [static](@ref S) injection is a steady state injection, such as modeling
the output power of a generator held constant over a five-minute period.

Many `StaticInjection` models can accept a [`DynamicInjection`](@ref) model
as an optional add-on for conducting [dynamic](@ref D) simulations.

Subtypes: [`Generator`](@ref), [`ElectricLoad`](@ref), [`Storage`](@ref),
[`StaticInjectionSubsystem`](@ref)

See also: [`Device`](@ref)
"""
abstract type StaticInjection <: Device end

"""
Return false since most devices do not support services by default.

# Arguments
- `device::`[`Device`](@ref): The device.

See also: [`supports_services` for `StaticInjection`](@ref supports_services(::StaticInjection)),
[`supports_services` for `ACBranch`](@ref supports_services(::ACBranch)),
[`supports_services` for `HydroReservoir`](@ref supports_services(::HydroReservoir)),
[`supports_services` for `DynamicInjection`](@ref supports_services(::DynamicInjection))
"""
function supports_services(::Device)
    return false
end

"""
Return true since static injection devices support services.

# Arguments
- `device::`[`StaticInjection`](@ref): The device.

See also: [`supports_services` for `Device`](@ref supports_services(::Device)),
[`supports_services` for `ACBranch`](@ref supports_services(::ACBranch)),
[`supports_services` for `HydroReservoir`](@ref supports_services(::HydroReservoir)),
[`supports_services` for `DynamicInjection`](@ref supports_services(::DynamicInjection))
"""
function supports_services(::StaticInjection)
    return true
end

"""
Return the services attached to a device.

Throws an error for devices that do not support services
(see [`supports_services`](@ref supports_services(::Device))).

# Arguments
- `device::`[`Device`](@ref): The device.

See also: [`add_service!`](@ref), [`remove_service!`](@ref), [`has_service`](@ref)
"""
function get_services(device::Device)
    if !supports_services(device)
        error(ArgumentError(
            "Device $(get_name(device)) does not support services",
        ))
    end
    return Vector{Service}()
end

"""
Return `true` if the device has active power as a controllable parameter.
"""
supports_active_power(::StaticInjection) = true

"""
Return `true` if the device has reactive power as a controllable parameter.
"""
supports_reactive_power(::StaticInjection) = true

"""
Return `true` if the device can control voltage at its connected bus.
"""
supports_voltage_control(::StaticInjection) = false

"""
Return the [`DynamicInjection`](@ref) component attached to this [`StaticInjection`](@ref)
device, or `nothing` if none is attached.
"""
get_dynamic_injector(d::StaticInjection) = nothing

"""
Return the frequency droop of the device's [`DynamicInjection`](@ref) model.

Throws `ArgumentError` if no dynamic injector is attached.

# Arguments
- `static_injector::`[`StaticInjection`](@ref): The static injection device.

See also: [`get_frequency_droop` for `DynamicGenerator`](@ref get_frequency_droop(::DynamicGenerator)),
[`get_frequency_droop` for `DynamicInjection`](@ref get_frequency_droop(::V) where {V <: DynamicInjection})
"""
function get_frequency_droop(static_injector::StaticInjection)
    dynamic_injector = get_dynamic_injector(static_injector)
    if isnothing(dynamic_injector)
        throw(
            ArgumentError(
                "cannot get frequency droop for $(summary(static_injector)) because it does not have dynamic data.",
            ),
        )
    end
    return get_frequency_droop(dynamic_injector)
end
