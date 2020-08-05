#=
This file is auto-generated. Do not edit.
=#
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
- `name::String`
- `available::Bool`
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: (0, nothing), action if invalid: error
- `ext::Dict{String, Any}`
- `contributing_services::Vector{Service}`: Services that contribute for this requirement constraint
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct StaticReserveGroup{T <: ReserveDirection} <: Service
    name::String
    available::Bool
    "the static value of required reserves in system p.u."
    requirement::Float64
    ext::Dict{String, Any}
    "Services that contribute for this requirement constraint"
    contributing_services::Vector{Service}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function StaticReserveGroup{T}(name, available, requirement, ext=Dict{String, Any}(), contributing_services=Vector{Service}(), ) where T <: ReserveDirection
    StaticReserveGroup{T}(name, available, requirement, ext, contributing_services, InfrastructureSystemsInternal(), )
end

function StaticReserveGroup{T}(; name, available, requirement, ext=Dict{String, Any}(), contributing_services=Vector{Service}(), ) where T <: ReserveDirection
    StaticReserveGroup{T}(name, available, requirement, ext, contributing_services, )
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


InfrastructureSystems.get_name(value::StaticReserveGroup) = value.name
"""Get StaticReserveGroup available."""
get_available(value::StaticReserveGroup) = value.available
"""Get StaticReserveGroup requirement."""
get_requirement(value::StaticReserveGroup) = value.requirement
"""Get StaticReserveGroup ext."""
get_ext(value::StaticReserveGroup) = value.ext
"""Get StaticReserveGroup contributing_services."""
get_contributing_services(value::StaticReserveGroup) = value.contributing_services
"""Get StaticReserveGroup internal."""
get_internal(value::StaticReserveGroup) = value.internal


InfrastructureSystems.set_name!(value::StaticReserveGroup, val) = value.name = val
"""Set StaticReserveGroup available."""
set_available!(value::StaticReserveGroup, val) = value.available = val
"""Set StaticReserveGroup requirement."""
set_requirement!(value::StaticReserveGroup, val) = value.requirement = val
"""Set StaticReserveGroup ext."""
set_ext!(value::StaticReserveGroup, val) = value.ext = val
"""Set StaticReserveGroup internal."""
set_internal!(value::StaticReserveGroup, val) = value.internal = val
