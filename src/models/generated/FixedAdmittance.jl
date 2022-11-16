#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct FixedAdmittance <: ElectricLoad
        name::String
        available::Bool
        bus::Bus
        Y::Complex{Float64}
        dynamic_injector::Union{Nothing, DynamicInjection}
        services::Vector{Service}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `Y::Complex{Float64}`: System per-unit value
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection model for admittance
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct FixedAdmittance <: ElectricLoad
    name::String
    available::Bool
    bus::Bus
    "System per-unit value"
    Y::Complex{Float64}
    "corresponding dynamic injection model for admittance"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal time_series storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function FixedAdmittance(name, available, bus, Y, dynamic_injector=nothing, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    FixedAdmittance(name, available, bus, Y, dynamic_injector, services, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function FixedAdmittance(; name, available, bus, Y, dynamic_injector=nothing, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    FixedAdmittance(name, available, bus, Y, dynamic_injector, services, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function FixedAdmittance(::Nothing)
    FixedAdmittance(;
        name="init",
        available=false,
        bus=Bus(nothing),
        Y=0.0,
        dynamic_injector=nothing,
        services=Device[],
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`FixedAdmittance`](@ref) `name`."""
get_name(value::FixedAdmittance) = value.name
"""Get [`FixedAdmittance`](@ref) `available`."""
get_available(value::FixedAdmittance) = value.available
"""Get [`FixedAdmittance`](@ref) `bus`."""
get_bus(value::FixedAdmittance) = value.bus
"""Get [`FixedAdmittance`](@ref) `Y`."""
get_Y(value::FixedAdmittance) = value.Y
"""Get [`FixedAdmittance`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::FixedAdmittance) = value.dynamic_injector
"""Get [`FixedAdmittance`](@ref) `services`."""
get_services(value::FixedAdmittance) = value.services
"""Get [`FixedAdmittance`](@ref) `ext`."""
get_ext(value::FixedAdmittance) = value.ext
"""Get [`FixedAdmittance`](@ref) `time_series_container`."""
get_time_series_container(value::FixedAdmittance) = value.time_series_container
"""Get [`FixedAdmittance`](@ref) `internal`."""
get_internal(value::FixedAdmittance) = value.internal

"""Set [`FixedAdmittance`](@ref) `available`."""
set_available!(value::FixedAdmittance, val) = value.available = val
"""Set [`FixedAdmittance`](@ref) `bus`."""
set_bus!(value::FixedAdmittance, val) = value.bus = val
"""Set [`FixedAdmittance`](@ref) `Y`."""
set_Y!(value::FixedAdmittance, val) = value.Y = val
"""Set [`FixedAdmittance`](@ref) `services`."""
set_services!(value::FixedAdmittance, val) = value.services = val
"""Set [`FixedAdmittance`](@ref) `ext`."""
set_ext!(value::FixedAdmittance, val) = value.ext = val
"""Set [`FixedAdmittance`](@ref) `time_series_container`."""
set_time_series_container!(value::FixedAdmittance, val) = value.time_series_container = val
