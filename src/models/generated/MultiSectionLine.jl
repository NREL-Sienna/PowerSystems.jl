#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct MultiSectionLine <: ACTransmission
        name::String
        available::Bool
        id::String
        arc::Arc
        active_power_flow::Float64
        reactive_power_flow::Float64
        dummy_buses::Dict{String, Int}
        section_number::Int
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A multi-section line grouping representation 

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `id::String`: (default: `&1`) Multisection line grouping identifier, with a '&' as a first character
- `arc::Arc`: An [`Arc`](@ref) defining this line `from` a bus `to` another bus
- `active_power_flow::Float64`: Initial condition of active power flow on the line (MW)
- `reactive_power_flow::Float64`: Initial condition of reactive power flow on the line (MVAR)
- `dummy_buses::Dict{String, Int}`: (default: `Dict{String, Int}()`) Dictionary mapping the dummy bus DUMi string to its respective bus number. Each dummy bus connected between exactly two branches.
- `section_number::Int`: Number of sections to consider in the multisection line
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct MultiSectionLine <: ACTransmission
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "Multisection line grouping identifier, with a '&' as a first character"
    id::String
    "An [`Arc`](@ref) defining this line `from` a bus `to` another bus"
    arc::Arc
    "Initial condition of active power flow on the line (MW)"
    active_power_flow::Float64
    "Initial condition of reactive power flow on the line (MVAR)"
    reactive_power_flow::Float64
    "Dictionary mapping the dummy bus DUMi string to its respective bus number. Each dummy bus connected between exactly two branches."
    dummy_buses::Dict{String, Int}
    "Number of sections to consider in the multisection line"
    section_number::Int
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function MultiSectionLine(name, available, id=&amp;1, arc, active_power_flow, reactive_power_flow, dummy_buses=Dict{String, Int}(), section_number, services=Device[], ext=Dict{String, Any}(), )
    MultiSectionLine(name, available, id, arc, active_power_flow, reactive_power_flow, dummy_buses, section_number, services, ext, InfrastructureSystemsInternal(), )
end

function MultiSectionLine(; name, available, id=&1, arc, active_power_flow, reactive_power_flow, dummy_buses=Dict{String, Int}(), section_number, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    MultiSectionLine(name, available, id, arc, active_power_flow, reactive_power_flow, dummy_buses, section_number, services, ext, internal, )
end

"""Get [`MultiSectionLine`](@ref) `name`."""
get_name(value::MultiSectionLine) = value.name
"""Get [`MultiSectionLine`](@ref) `available`."""
get_available(value::MultiSectionLine) = value.available
"""Get [`MultiSectionLine`](@ref) `id`."""
get_id(value::MultiSectionLine) = value.id
"""Get [`MultiSectionLine`](@ref) `arc`."""
get_arc(value::MultiSectionLine) = value.arc
"""Get [`MultiSectionLine`](@ref) `active_power_flow`."""
get_active_power_flow(value::MultiSectionLine) = get_value(value, value.active_power_flow)
"""Get [`MultiSectionLine`](@ref) `reactive_power_flow`."""
get_reactive_power_flow(value::MultiSectionLine) = get_value(value, value.reactive_power_flow)
"""Get [`MultiSectionLine`](@ref) `dummy_buses`."""
get_dummy_buses(value::MultiSectionLine) = value.dummy_buses
"""Get [`MultiSectionLine`](@ref) `section_number`."""
get_section_number(value::MultiSectionLine) = value.section_number
"""Get [`MultiSectionLine`](@ref) `services`."""
get_services(value::MultiSectionLine) = value.services
"""Get [`MultiSectionLine`](@ref) `ext`."""
get_ext(value::MultiSectionLine) = value.ext
"""Get [`MultiSectionLine`](@ref) `internal`."""
get_internal(value::MultiSectionLine) = value.internal

"""Set [`MultiSectionLine`](@ref) `available`."""
set_available!(value::MultiSectionLine, val) = value.available = val
"""Set [`MultiSectionLine`](@ref) `id`."""
set_id!(value::MultiSectionLine, val) = value.id = val
"""Set [`MultiSectionLine`](@ref) `arc`."""
set_arc!(value::MultiSectionLine, val) = value.arc = val
"""Set [`MultiSectionLine`](@ref) `active_power_flow`."""
set_active_power_flow!(value::MultiSectionLine, val) = value.active_power_flow = set_value(value, val)
"""Set [`MultiSectionLine`](@ref) `reactive_power_flow`."""
set_reactive_power_flow!(value::MultiSectionLine, val) = value.reactive_power_flow = set_value(value, val)
"""Set [`MultiSectionLine`](@ref) `dummy_buses`."""
set_dummy_buses!(value::MultiSectionLine, val) = value.dummy_buses = val
"""Set [`MultiSectionLine`](@ref) `section_number`."""
set_section_number!(value::MultiSectionLine, val) = value.section_number = val
"""Set [`MultiSectionLine`](@ref) `services`."""
set_services!(value::MultiSectionLine, val) = value.services = val
"""Set [`MultiSectionLine`](@ref) `ext`."""
set_ext!(value::MultiSectionLine, val) = value.ext = val
