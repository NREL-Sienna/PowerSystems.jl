"""
Supertype for all system services

Services (or ancillary services) include additional requirements and support
to ensure reliable electricity service to customers. Common services are
reserve products to be able to respond quickly to unexpected disturbances,
such as the sudden loss of a transmission line or generator.
"""
abstract type Service <: Component end

"""
Supertype for reserve products whose requirement is met by a group of contributing services

A reserve group aggregates other [`Service`](@ref) instances: the group carries the
requirement (a constant one for [`ConstantReserveGroup`](@ref), an elastic demand curve for
[`ReserveDemandCurveGroup`](@ref)) while the per-service caps and offers live on the
contributing services themselves.

Group members are set with [`set_contributing_services!`](@ref) and read with
`get_contributing_services`.
"""
abstract type ReserveGroup <: Service end

"""
All PowerSystems [Service](@ref) types support time series. This can be overridden for custom
types that do not support time series.
"""
supports_time_series(::Service) = true

"""
All PowerSystems [Service](@ref) types support supplemental attributes. This can be overridden for 
custom service types that do not support supplemental attributes.
"""
supports_supplemental_attributes(::Service) = true
