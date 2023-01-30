#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct SwitchedAdmittance <: ElectricLoad
        name::String
        available::Bool
        bus::ACBus
        Y::Complex{Float64}
        number_of_steps::Int
        Y_increase::Complex{Float64}
        dynamic_injector::Union{Nothing, DynamicInjection}
        services::Vector{Service}
        ext::Dict{String, Any}
        time_series_container::InfrastructureSystems.TimeSeriesContainer
        internal::InfrastructureSystemsInternal
    end



# Arguments
- `name::String`
- `available::Bool`
- `bus::ACBus`
- `Y::Complex{Float64}`: Initial impedance at N = 0
- `number_of_steps::Int`: Number of steps for adjustable shunt
- `Y_increase::Complex{Float64}`: Admittance increment for each of step increase
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection model for admittance
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `time_series_container::InfrastructureSystems.TimeSeriesContainer`: internal time_series storage
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct SwitchedAdmittance <: ElectricLoad
    name::String
    available::Bool
    bus::ACBus
    "Initial impedance at N = 0"
    Y::Complex{Float64}
    "Number of steps for adjustable shunt"
    number_of_steps::Int
    "Admittance increment for each of step increase"
    Y_increase::Complex{Float64}
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

function SwitchedAdmittance(name, available, bus, Y, number_of_steps=0, Y_increase=0, dynamic_injector=nothing, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), )
    SwitchedAdmittance(name, available, bus, Y, number_of_steps, Y_increase, dynamic_injector, services, ext, time_series_container, InfrastructureSystemsInternal(), )
end

function SwitchedAdmittance(; name, available, bus, Y, number_of_steps=0, Y_increase=0, dynamic_injector=nothing, services=Device[], ext=Dict{String, Any}(), time_series_container=InfrastructureSystems.TimeSeriesContainer(), internal=InfrastructureSystemsInternal(), )
    SwitchedAdmittance(name, available, bus, Y, number_of_steps, Y_increase, dynamic_injector, services, ext, time_series_container, internal, )
end

# Constructor for demo purposes; non-functional.
function SwitchedAdmittance(::Nothing)
    SwitchedAdmittance(;
        name="init",
        available=false,
        bus=ACBus(nothing),
        Y=0.0,
        number_of_steps=0,
        Y_increase=0,
        dynamic_injector=nothing,
        services=Device[],
        ext=Dict{String, Any}(),
        time_series_container=InfrastructureSystems.TimeSeriesContainer(),
    )
end

"""Get [`SwitchedAdmittance`](@ref) `name`."""
get_name(value::SwitchedAdmittance) = value.name
"""Get [`SwitchedAdmittance`](@ref) `available`."""
get_available(value::SwitchedAdmittance) = value.available
"""Get [`SwitchedAdmittance`](@ref) `bus`."""
get_bus(value::SwitchedAdmittance) = value.bus
"""Get [`SwitchedAdmittance`](@ref) `Y`."""
get_Y(value::SwitchedAdmittance) = value.Y
"""Get [`SwitchedAdmittance`](@ref) `number_of_steps`."""
get_number_of_steps(value::SwitchedAdmittance) = value.number_of_steps
"""Get [`SwitchedAdmittance`](@ref) `Y_increase`."""
get_Y_increase(value::SwitchedAdmittance) = value.Y_increase
"""Get [`SwitchedAdmittance`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::SwitchedAdmittance) = value.dynamic_injector
"""Get [`SwitchedAdmittance`](@ref) `services`."""
get_services(value::SwitchedAdmittance) = value.services
"""Get [`SwitchedAdmittance`](@ref) `ext`."""
get_ext(value::SwitchedAdmittance) = value.ext
"""Get [`SwitchedAdmittance`](@ref) `time_series_container`."""
get_time_series_container(value::SwitchedAdmittance) = value.time_series_container
"""Get [`SwitchedAdmittance`](@ref) `internal`."""
get_internal(value::SwitchedAdmittance) = value.internal

"""Set [`SwitchedAdmittance`](@ref) `available`."""
set_available!(value::SwitchedAdmittance, val) = value.available = val
"""Set [`SwitchedAdmittance`](@ref) `bus`."""
set_bus!(value::SwitchedAdmittance, val) = value.bus = val
"""Set [`SwitchedAdmittance`](@ref) `Y`."""
set_Y!(value::SwitchedAdmittance, val) = value.Y = val
"""Set [`SwitchedAdmittance`](@ref) `number_of_steps`."""
set_number_of_steps!(value::SwitchedAdmittance, val) = value.number_of_steps = val
"""Set [`SwitchedAdmittance`](@ref) `Y_increase`."""
set_Y_increase!(value::SwitchedAdmittance, val) = value.Y_increase = val
"""Set [`SwitchedAdmittance`](@ref) `services`."""
set_services!(value::SwitchedAdmittance, val) = value.services = val
"""Set [`SwitchedAdmittance`](@ref) `ext`."""
set_ext!(value::SwitchedAdmittance, val) = value.ext = val
"""Set [`SwitchedAdmittance`](@ref) `time_series_container`."""
set_time_series_container!(value::SwitchedAdmittance, val) = value.time_series_container = val
