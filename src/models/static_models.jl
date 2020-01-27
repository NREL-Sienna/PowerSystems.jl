abstract type StaticInjection <: Device end
supports_services(d::Device) = true
