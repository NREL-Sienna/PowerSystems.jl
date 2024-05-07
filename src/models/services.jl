abstract type Service <: Component end

supports_time_series(::Service) = true
supports_supplemental_attributes(::Service) = true
