#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct StaticReserveGroup{T <: ReserveDirection} <: Service
        name::String
        available::Bool
        requirement::Float64
        ext::Dict{String, Any}
        contributing_services::Vector{Service}
        internal::InfrastructureSystemsInternal
    end

A reserve product met by a group of individual reserves.

The group reserve requirement is added in addition to any individual reserve requirements, and devices that contribute to individual reserves within the group can also contribute to the overarching group reserve requirement. Example: A group of spinning and non-spinning reserves, where online generators providing spinning reserves can also contribute to the non-spinning reserve requirement.

This model has a constant procurement requirement, such as 3% of the system base power at all times. When defining the reserve, the `ReserveDirection` must be specified to define this as a [`ReserveUp`](@ref), [`ReserveDown`](@ref), or [`ReserveSymmetric`](@ref).

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations.
- `requirement::Float64`: the value of required reserves in p.u. ([`SYSTEM_BASE`](@ref per_unit)), validation range: `(0, nothing)`, action if invalid: `error`
- `ext::Dict{String, Any}`: (optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `contributing_services::Vector{Service}`: (optional) Services that contribute to this group requirement. Services must be added for this constraint to have an effect when conducting simulations in [`PowerSimulations.jl`](https://nrel-sienna.github.io/PowerSimulations.jl/latest/).
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference.
"""
mutable struct StaticReserveGroup{T <: ReserveDirection} <: Service
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). Unavailable components are excluded during simulations."
    available::Bool
    "the value of required reserves in p.u. ([`SYSTEM_BASE`](@ref per_unit))"
    requirement::Float64
    "(optional) An *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "(optional) Services that contribute to this group requirement. Services must be added for this constraint to have an effect when conducting simulations in [`PowerSimulations.jl`](https://nrel-sienna.github.io/PowerSimulations.jl/latest/)."
    contributing_services::Vector{Service}
    "(**Do not modify.**) PowerSystems.jl internal reference."
    internal::InfrastructureSystemsInternal
end

function StaticReserveGroup{T}(name, available, requirement, ext=Dict{String, Any}(), contributing_services=Vector{Service}(), ) where T <: ReserveDirection
    StaticReserveGroup{T}(name, available, requirement, ext, contributing_services, InfrastructureSystemsInternal(), )
end

function StaticReserveGroup{T}(; name, available, requirement, ext=Dict{String, Any}(), contributing_services=Vector{Service}(), internal=InfrastructureSystemsInternal(), ) where T <: ReserveDirection
    StaticReserveGroup{T}(name, available, requirement, ext, contributing_services, internal, )
end

# Constructor for demo purposes; non-functional.
function StaticReserveGroup{T}(::Nothing) where T <: ReserveDirection
    StaticReserveGroup{T}(;
        name="init",
        available=false,
        requirement=0.0,
        ext=Dict{String, Any}(),
        contributing_services=Vector{Service}(),
    )
end

"""Get [`StaticReserveGroup`](@ref) `name`."""
get_name(value::StaticReserveGroup) = value.name
"""Get [`StaticReserveGroup`](@ref) `available`."""
get_available(value::StaticReserveGroup) = value.available
"""Get [`StaticReserveGroup`](@ref) `requirement`."""
get_requirement(value::StaticReserveGroup) = get_value(value, value.requirement)
"""Get [`StaticReserveGroup`](@ref) `ext`."""
get_ext(value::StaticReserveGroup) = value.ext
"""Get [`StaticReserveGroup`](@ref) `contributing_services`."""
get_contributing_services(value::StaticReserveGroup) = value.contributing_services
"""Get [`StaticReserveGroup`](@ref) `internal`."""
get_internal(value::StaticReserveGroup) = value.internal

"""Set [`StaticReserveGroup`](@ref) `available`."""
set_available!(value::StaticReserveGroup, val) = value.available = val
"""Set [`StaticReserveGroup`](@ref) `requirement`."""
set_requirement!(value::StaticReserveGroup, val) = value.requirement = set_value(value, val)
"""Set [`StaticReserveGroup`](@ref) `ext`."""
set_ext!(value::StaticReserveGroup, val) = value.ext = val
