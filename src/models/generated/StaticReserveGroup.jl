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

Data Structure for a group reserve product for system simulations.

# Arguments
- `name::String`: Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name.
- `available::Bool`: Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon.
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: `(0, nothing)`, action if invalid: `error`
- `ext::Dict{String, Any}`: An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref).
- `contributing_services::Vector{Service}`: Services that contribute for this requirement constraint
- `internal::InfrastructureSystemsInternal`: PowerSystems.jl internal reference. **Do not modify.**
"""
mutable struct StaticReserveGroup{T <: ReserveDirection} <: Service
    "Name of the component. Components of the same type (e.g., `PowerLoad`) must have unique names, but components of different types (e.g., `PowerLoad` and `ACBus`) can have the same name."
    name::String
    "Indicator of whether the component is connected and online (`true`) or disconnected, offline, or down (`false`). For example, a time-series of availability can be attached here to include planned or un-planned outages over a simulation horizon."
    available::Bool
    "the static value of required reserves in system p.u."
    requirement::Float64
    "An empty *ext*ra dictionary for users to add metadata that are not used in simulation, such as latitude and longitude. See [Adding additional fields](@ref)."
    ext::Dict{String, Any}
    "Services that contribute for this requirement constraint"
    contributing_services::Vector{Service}
    "PowerSystems.jl internal reference. **Do not modify.**"
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
