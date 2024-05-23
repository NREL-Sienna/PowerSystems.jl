"""
Supertype for all system services

Services (or ancillary services) include additional requirements and support
to ensure reliable electricity service to customers. Common services are
reserve products to be able to respond quickly to unexpected disturbances,
such as the sudden loss of a transmission line or generator.
"""
abstract type Service <: Component end

supports_time_series(::Service) = true
supports_supplemental_attributes(::Service) = true
