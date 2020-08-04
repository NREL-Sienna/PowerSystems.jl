#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct StaticReserveGroup{T <: ReserveDirection} <: Service
        name::String
        available::Bool
        requirement::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
        contributing_services::Vector{<:Service}
    end

Data Structure for a group reserve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: (0, nothing), action if invalid: error
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
- `contributing_services::Vector{<:Service}`: Services that contribute for this requirement constraint
"""
mutable struct StaticReserveGroup{T <: ReserveDirection} <: Service
    name::String
    available::Bool
    "the static value of required reserves in system p.u."
    requirement::Float64
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
    "Services that contribute for this requirement constraint"
    contributing_services::Vector{<:Service}
end

function StaticReserveGroup{T}(name, available, requirement, ext=Dict{String, Any}(), contributing_services=Vector{&lt;:Service}(), ) where T <: ReserveDirection
    StaticReserveGroup{T}(name, available, requirement, ext, contributing_services, InfrastructureSystemsInternal(), )
end

function StaticReserveGroup{T}(; name, available, requirement, ext=Dict{String, Any}(), contributing_services=Vector{&lt;:Service}(), ) where T <: ReserveDirection
    StaticReserveGroup{T}(name, available, requirement, ext, contributing_services, )
end

# Constructor for demo purposes; non-functional.
function StaticReserveGroup{T}(::Nothing) where T <: ReserveDirection
    StaticReserveGroup{T}(;
        name="init",
        available=false,
        requirement=0.0,
        ext=Dict{String, Any}(),
        contributing_services=Vector{&lt;:Service}(),
    )
end


InfrastructureSystems.get_name(value::StaticReserveGroup) = value.name
"""Get StaticReserveGroup available."""
get_available(value::StaticReserveGroup) = value.available
"""Get StaticReserveGroup requirement."""
get_requirement(value::StaticReserveGroup) = value.requirement
"""Get StaticReserveGroup ext."""
get_ext(value::StaticReserveGroup) = value.ext
"""Get StaticReserveGroup internal."""
get_internal(value::StaticReserveGroup) = value.internal
"""Get StaticReserveGroup contributing_services."""
get_contributing_services(value::StaticReserveGroup) = value.contributing_services


InfrastructureSystems.set_name!(value::StaticReserveGroup, val::String) = value.name = val
"""Set StaticReserveGroup available."""
set_available!(value::StaticReserveGroup, val::Bool) = value.available = val
"""Set StaticReserveGroup requirement."""
set_requirement!(value::StaticReserveGroup, val::Float64) = value.requirement = val
"""Set StaticReserveGroup ext."""
set_ext!(value::StaticReserveGroup, val::Dict{String, Any}) = value.ext = val
"""Set StaticReserveGroup internal."""
set_internal!(value::StaticReserveGroup, val::InfrastructureSystemsInternal) = value.internal = val
"""Set StaticReserveGroup contributing_services."""
set_contributing_services!(value::StaticReserveGroup, val::Vector{&lt;:Service}) = value.contributing_services = val
