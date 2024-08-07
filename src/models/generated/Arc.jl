#=
This file is auto-generated. Do not edit.
=#

#! format: off

"""
    mutable struct Arc <: Topology
        from::Bus
        to::Bus
        internal::InfrastructureSystemsInternal
    end

A topological directed edge connecting two buses.

Arcs are used to define the `from` and `to` buses when defining a line or transformer

# Arguments
- `from::Bus`: The initial bus
- `to::Bus`: The terminal bus
- `internal::InfrastructureSystemsInternal`: (**Do not modify.**) PowerSystems.jl internal reference
"""
mutable struct Arc <: Topology
    "The initial bus"
    from::Bus
    "The terminal bus"
    to::Bus
    "(**Do not modify.**) PowerSystems.jl internal reference"
    internal::InfrastructureSystemsInternal
end

function Arc(from, to, )
    Arc(from, to, InfrastructureSystemsInternal(), )
end

function Arc(; from, to, internal=InfrastructureSystemsInternal(), )
    Arc(from, to, internal, )
end

# Constructor for demo purposes; non-functional.
function Arc(::Nothing)
    Arc(;
        from=ACBus(nothing),
        to=ACBus(nothing),
    )
end

"""Get [`Arc`](@ref) `from`."""
get_from(value::Arc) = value.from
"""Get [`Arc`](@ref) `to`."""
get_to(value::Arc) = value.to
"""Get [`Arc`](@ref) `internal`."""
get_internal(value::Arc) = value.internal

"""Set [`Arc`](@ref) `from`."""
set_from!(value::Arc, val) = value.from = val
"""Set [`Arc`](@ref) `to`."""
set_to!(value::Arc, val) = value.to = val

get_name(arc::Arc) = (get_name ∘ get_from)(arc) * " -> " * (get_name ∘ get_to)(arc)
