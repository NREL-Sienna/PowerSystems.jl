abstract type StaticInjection <: Device end
supports_services(d::Device) = true
get_dynamic_injector(d::StaticInjection) = nothing
