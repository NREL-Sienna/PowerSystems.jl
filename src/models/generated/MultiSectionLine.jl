#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct MultiSectionLine <: ACTransmission
        name::String
        available::Bool
        arc::Arc
        section_number::Int
        id::String
        services::Vector{Service}
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

A multi-section line grouping representation 

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations
- `arc::Arc`: An [`Arc`](@ref) defining this line `from` a bus `to` another bus
- `section_number::Int`: Number of sections to consider in the multisection line
- `id::String`: (default: `1`) Multisection line grouping identifier, with a '&' as a first character
- `services::Vector{Service}`: (default: `Device[]`) Services that this device contributes to
- `ext::Dict{String, Any}`: (default: `Dict{String, Any}()`) An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude.
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct MultiSectionLine <: ACTransmission
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name"
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations"
    available::Bool
    "An [`Arc`](@ref) defining this line `from` a bus `to` another bus"
    arc::Arc
    "Number of sections to consider in the multisection line"
    section_number::Int
    "Multisection line grouping identifier, with a '&' as a first character"
    id::String
    "Services that this device contributes to"
    services::Vector{Service}
    "An [*ext*ra dictionary](@ref additional_fields) for users to add metadata that are not used in simulation, such as latitude and longitude."
    ext::Dict{String, Any}
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function MultiSectionLine(name, available, arc, section_number, id=1, services=Device[], ext=Dict{String, Any}(), )
    MultiSectionLine(name, available, arc, section_number, id, services, ext, InfrastructureSystemsInternal(), )
end

function MultiSectionLine(; name, available, arc, section_number, id=1, services=Device[], ext=Dict{String, Any}(), internal=InfrastructureSystemsInternal(), )
    MultiSectionLine(name, available, arc, section_number, id, services, ext, internal, )
end

"""Get [`MultiSectionLine`](@ref) `name`."""
get_name(value::MultiSectionLine) = value.name
"""Get [`MultiSectionLine`](@ref) `available`."""
get_available(value::MultiSectionLine) = value.available
"""Get [`MultiSectionLine`](@ref) `arc`."""
get_arc(value::MultiSectionLine) = value.arc
"""Get [`MultiSectionLine`](@ref) `section_number`."""
get_section_number(value::MultiSectionLine) = value.section_number
"""Get [`MultiSectionLine`](@ref) `id`."""
get_id(value::MultiSectionLine) = value.id
"""Get [`MultiSectionLine`](@ref) `services`."""
get_services(value::MultiSectionLine) = value.services
"""Get [`MultiSectionLine`](@ref) `ext`."""
get_ext(value::MultiSectionLine) = value.ext
"""Get [`MultiSectionLine`](@ref) `internal`."""
get_internal(value::MultiSectionLine) = value.internal

"""Set [`MultiSectionLine`](@ref) `available`."""
set_available!(value::MultiSectionLine, val) = value.available = val
"""Set [`MultiSectionLine`](@ref) `arc`."""
set_arc!(value::MultiSectionLine, val) = value.arc = val
"""Set [`MultiSectionLine`](@ref) `section_number`."""
set_section_number!(value::MultiSectionLine, val) = value.section_number = val
"""Set [`MultiSectionLine`](@ref) `id`."""
set_id!(value::MultiSectionLine, val) = value.id = val
"""Set [`MultiSectionLine`](@ref) `services`."""
set_services!(value::MultiSectionLine, val) = value.services = val
"""Set [`MultiSectionLine`](@ref) `ext`."""
set_ext!(value::MultiSectionLine, val) = value.ext = val
