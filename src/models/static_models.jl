"""Abstract type of Devices that inject current/power """
abstract type StaticInjection <: Device end

function supports_services(::T) where {T <: Device}
    return true
end

function get_services(::Device)
    return Vector{Service}()
end

get_dynamic_injector(d::StaticInjection) = nothing
