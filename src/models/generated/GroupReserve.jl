#=
This file was not auto-generated.
=#
"""
    mutable struct StaticGroupReserve <: Service
        name::String
        available::Bool
        requirement::Float64
        ext::Dict{String, Any}
        internal::InfrastructureSystemsInternal
    end

Data Structure for a group reserve product for system simulations.

# Arguments
- `name::String`
- `available::Bool`
- `requirement::Float64`: the static value of required reserves in system p.u., validation range: (0, nothing), action if invalid: error
- `ext::Dict{String, Any}`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct StaticGroupReserve <: Service
    name::String
    available::Bool
    "the static value of required reserves in system p.u."
    requirement::Float64
    ext::Dict{String, Any}
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function StaticGroupReserve(name, available,  requirement, ext=Dict{String, Any}(), )
    StaticGroupReserve(name, available,  requirement, ext, InfrastructureSystemsInternal(), )
end

function StaticGroupReserve(; name, available,  requirement, ext=Dict{String, Any}(), )
    StaticGroupReserve(name, available,  requirement, ext, )
end

# Constructor for demo purposes; non-functional.
function StaticGroupReserve(::Nothing)
    StaticGroupReserve(;
        name="init",
        available=false,
        requirement=0.0,
        ext=Dict{String, Any}(),
    )
end


InfrastructureSystems.get_name(value::StaticGroupReserve) = value.name
"""Get StaticGroupReserve available."""
get_available(value::StaticGroupReserve) = value.available
"""Get StaticGroupReserve requirement."""
get_requirement(value::StaticGroupReserve) = value.requirement
"""Get StaticGroupReserve ext."""
get_ext(value::StaticGroupReserve) = value.ext
"""Get StaticGroupReserve internal."""
get_internal(value::StaticGroupReserve) = value.internal


InfrastructureSystems.set_name!(value::StaticGroupReserve, val::String) = value.name = val
"""Set StaticGroupReserve available."""
set_available!(value::StaticGroupReserve, val::Bool) = value.available = val
"""Set StaticGroupReserve requirement."""
set_requirement!(value::StaticGroupReserve, val::Float64) = value.requirement = val
"""Set StaticGroupReserve ext."""
set_ext!(value::StaticGroupReserve, val::Dict{String, Any}) = value.ext = val
"""Set StaticGroupReserve internal."""
set_internal!(value::StaticGroupReserve, val::InfrastructureSystemsInternal) = value.internal = val
