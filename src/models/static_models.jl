abstract type StaticInjection <: Device end
function supports_services(::T) where T <: Device
    return hasfield(T, :services)
end

get_dynamic_injector(d::StaticInjection) = nothing
