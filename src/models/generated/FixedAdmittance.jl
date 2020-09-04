#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct FixedAdmittance <: ElectricLoad
        name::String
        available::Bool
        bus::Bus
        Y::Complex{Float64}
        services::Vector{Service}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `Y::Complex{Float64}`: System per-unit value
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct FixedAdmittance <: ElectricLoad
    name::String
    available::Bool
    bus::Bus
    "System per-unit value"
    Y::Complex{Float64}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function FixedAdmittance(name, available, bus, Y, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    FixedAdmittance(name, available, bus, Y, services, ext, forecasts, InfrastructureSystemsInternal(), )
end

function FixedAdmittance(; name, available, bus, Y, services=Device[], ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    FixedAdmittance(name, available, bus, Y, services, ext, forecasts, )
end

# Constructor for demo purposes; non-functional.
function FixedAdmittance(::Nothing)
    FixedAdmittance(;
        name="init",
        available=false,
        bus=Bus(nothing),
        Y=0.0,
        services=Device[],
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


InfrastructureSystems.get_name(value::FixedAdmittance) = value.name
"""Get [`FixedAdmittance`](@ref) `available`."""
get_available(value::FixedAdmittance) = value.available
"""Get [`FixedAdmittance`](@ref) `bus`."""
get_bus(value::FixedAdmittance) = value.bus
"""Get [`FixedAdmittance`](@ref) `Y`."""
get_Y(value::FixedAdmittance) = value.Y
"""Get [`FixedAdmittance`](@ref) `services`."""
get_services(value::FixedAdmittance) = value.services
"""Get [`FixedAdmittance`](@ref) `ext`."""
get_ext(value::FixedAdmittance) = value.ext

InfrastructureSystems.get_forecasts(value::FixedAdmittance) = value.forecasts
"""Get [`FixedAdmittance`](@ref) `internal`."""
get_internal(value::FixedAdmittance) = value.internal


InfrastructureSystems.set_name!(value::FixedAdmittance, val) = value.name = val
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

InfrastructureSystems.set_forecasts!(value::FixedAdmittance, val) = value.forecasts = val
"""Set [`FixedAdmittance`](@ref) `internal`."""
set_internal!(value::FixedAdmittance, val) = value.internal = val
