#=
This file is auto-generated. Do not edit.
=#

"""A topological Arch."""
mutable struct Arch <: Topology
    from::Bus
    to::Bus
    internal::PowerSystems.PowerSystemInternal
end

function Arch(from, to, )
    Arch(from, to, PowerSystemInternal())
end

function Arch(; from, to, )
    Arch(from, to, )
end


"""Get Arch from."""
get_from(value::Arch) = value.from
"""Get Arch to."""
get_to(value::Arch) = value.to
"""Get Arch internal."""
get_internal(value::Arch) = value.internal
