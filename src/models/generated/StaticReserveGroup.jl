#=
This file was not auto-generated.
=#
"""
    mutable struct StaticReserveGroup <: Service
        name::String
        available::Bool
        requirement::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
        contributing_services::Vector{<:PSY.Service}
    end

Data Structure for a group reserve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: (0, nothing), action if invalid: error
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
- `contributing_services::Vector{<:PSY.Service}`: Services that contribute for this requirement constraint
"""
mutable struct StaticReserveGroup <: Service
    name::String
    available::Bool
    "the static value of required reserves in system p.u."
    requirement::Float64
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
    contributing_services::Vector{<:PSY.Service}
end

function StaticReserveGroup(name, available,  requirement, ext=Dict{String, Any}(), contributing_services=Vector{<:PSY.Service}(), )
    StaticReserveGroup(name, available,  requirement, ext, InfrastructureSystemsInternal(), contributing_services, )
end

function StaticReserveGroup(; name, available,  requirement, ext=Dict{String, Any}(), contributing_services=Vector{<:PSY.Service}(), )
    StaticReserveGroup(name, available,  requirement, ext, contributing_services)
end

# Constructor for demo purposes; non-functional.
function StaticReserveGroup(::Nothing)
    StaticReserveGroup(;
        name="init",
        available=false,
        requirement=0.0,
        ext=Dict{String, Any}(),
        contributing_services=Vector{<:PSY.Service}(),
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
"""Get StaticReserveGroup contributing_devices."""
get_contributing_devices(value::StaticReserveGroup) = value.contributing_devices

"""
Return a vector of services contributing to the group service.
"""
function _get_contributing_devices(sys::System, service::T) where {T <: StaticReserveGroup}
    return get_contributing_devices(service)
end

InfrastructureSystems.set_name!(value::StaticReserveGroup, val::String) = value.name = val
"""Set StaticReserveGroup available."""
set_available!(value::StaticReserveGroup, val::Bool) = value.available = val
"""Set StaticReserveGroup requirement."""
set_requirement!(value::StaticReserveGroup, val::Float64) = value.requirement = val
"""Set StaticReserveGroup ext."""
set_ext!(value::StaticReserveGroup, val::Dict{String, Any}) = value.ext = val
"""Set StaticReserveGroup internal."""
set_internal!(value::StaticReserveGroup, val::InfrastructureSystemsInternal) = value.internal = val
"""Set StaticReserveGroup contributing_devices."""
set_contributing_devices(value::StaticReserveGroup,val::Vector{<:PSY.Service}) = value.contributing_devices = val