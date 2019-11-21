#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct Arc <: Topology
        from::Bus
        to::Bus
        internal::InfrastructureSystemsInternal
    end

A topological Arc.

# Arguments
- `from::Bus`: The initial bus
- `to::Bus`: The terminal bus
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct Arc <: Topology
    "The initial bus"
    from::Bus
    "The terminal bus"
    to::Bus
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function Arc(from, to, )
    Arc(from, to, InfrastructureSystemsInternal())
end

function Arc(; from, to, )
    Arc(from, to, )
end



"""Get Arc from."""
get_from(value::Arc) = value.from
"""Get Arc to."""
get_to(value::Arc) = value.to
"""Get Arc internal."""
get_internal(value::Arc) = value.internal
