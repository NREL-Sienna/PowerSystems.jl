"""
Abstract type for devices that [inject](@ref I) power or current

A [static](@ref S) injection is a steady state injection, such as modeling
the output power of a generator held constant over a five-minute period.

Many `StaticInjection` models can accept a [`DynamicInjection`](@ref) model
as an optional add-on for conducting [dynamic](@ref D) simulations.
"""
abstract type StaticInjection <: Device end

function supports_services(::T) where {T <: Device}
    return false
end

function supports_services(::T) where {T <: StaticInjection}
    return true
end

function get_services(device::Device)
    if !supports_services(device)
        error(ArgumentError(
            "Device $(get_name(device)) does not support services",
        ))
    end
    return Vector{Service}()
end

get_dynamic_injector(d::StaticInjection) = nothing
