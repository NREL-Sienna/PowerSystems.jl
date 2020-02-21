#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Area <: AggregationTopology
        name::String
        internal::InfrastructureSystemsInternal
    end

A geographic area.

# Arguments
- `name::String`: area name
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Area <: AggregationTopology
    "area name"
    name::String
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Area(name, )
    Area(name, InfrastructureSystemsInternal(), )
end

function Area(; name, )
    Area(name, )
end

# Constructor for demo purposes; non-functional.
function Area(::Nothing)
    Area(;
        name="init",
    )
end

"""Get Area name."""
InfrastructureSystems.get_name(value::Area) = value.name
"""Get Area internal."""
get_internal(value::Area) = value.internal
