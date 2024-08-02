#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct FixedAdmittance <: ElectricLoad
        name::String
        available::Bool
        bus::ACBus
        Y::Complex{Float64}
        dynamic_injector::Union{Nothing, DynamicInjection}
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A fixed admittance.

Most often used in dynamics or AC power flow studies as a source of reactive power

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `bus::ACBus`: Bus that this component is connected to
- `Y::Complex{Float64}`: Fixed admittance in p.u. ([`SYSTEM_BASE`](@ref per_unit))
- `dynamic_injector::Union{Nothing, DynamicInjection}`: (default: `nothing`) corresponding dynamic injection model for admittance
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct FixedAdmittance <: ElectricLoad
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Bus that this component is connected to"
    bus::ACBus
    "Fixed admittance in p.u. ([`SYSTEM_BASE`](@ref per_unit))"
    Y::Complex{Float64}
    "corresponding dynamic injection model for admittance"
    dynamic_injector::Union{Nothing, DynamicInjection}
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function FixedAdmittance(name, available, bus, Y, dynamic_injector=nothing, services=Device[], ext=Dict{String, Any}(), )
    FixedAdmittance(name, available, bus, Y, dynamic_injector, services, ext, InfrastructureSystemsInternal(), )
end

function FixedAdmittance(; name, available, bus, Y, dynamic_injector=nothing, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    FixedAdmittance(name, available, bus, Y, dynamic_injector, services, ext, internal, )
end

# Constructor for demo purposes; non-functional.
function FixedAdmittance(::Nothing)
    FixedAdmittance(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        Y=0.0,
        dynamic_injector=nothing,
        services=Device[],
        ext=Dict{String, Any}(),
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
