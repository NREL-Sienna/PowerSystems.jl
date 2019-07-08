#=
This file is auto-generated. Do not edit.
=#


mutable struct LoadZones <: Topology
    number::Int64
    name::String
    buses::Vector{Bus}
    maxactivepower::Float64
    maxreactivepower::Float64
    internal::PowerSystems.PowerSystemInternal
end

function LoadZones(number, name, buses, maxactivepower, maxreactivepower, )
    LoadZones(number, name, buses, maxactivepower, maxreactivepower, PowerSystemInternal())
end

function LoadZones(; number, name, buses, maxactivepower, maxreactivepower, )
    LoadZones(number, name, buses, maxactivepower, maxreactivepower, )
end

# Constructor for demo purposes; non-functional.

function LoadZones(::Nothing)
    LoadZones(;
        number=0,
        name="init",
        buses=[Bus(nothing)],
        maxactivepower=0.0,
        maxreactivepower=0.0,
    )
end

"""Get LoadZones number."""
get_number(value::LoadZones) = value.number
"""Get LoadZones name."""
get_name(value::LoadZones) = value.name
"""Get LoadZones buses."""
get_buses(value::LoadZones) = value.buses
"""Get LoadZones maxactivepower."""
get_maxactivepower(value::LoadZones) = value.maxactivepower
"""Get LoadZones maxreactivepower."""
get_maxreactivepower(value::LoadZones) = value.maxreactivepower
"""Get LoadZones internal."""
get_internal(value::LoadZones) = value.internal
