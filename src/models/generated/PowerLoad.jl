#=
This file is auto-generated. Do not edit.
=#


mutable struct PowerLoad <: StaticLoad
    name::String
    available::Bool
    bus::Bus
    maxactivepower::Float64
    maxreactivepower::Float64
    internal::PowerSystems.PowerSystemInternal
end

function PowerLoad(name, available, bus, maxactivepower, maxreactivepower, )
    PowerLoad(name, available, bus, maxactivepower, maxreactivepower, PowerSystemInternal())
end

function PowerLoad(; name, available, bus, maxactivepower, maxreactivepower, )
    PowerLoad(name, available, bus, maxactivepower, maxreactivepower, )
end

# Constructor for demo purposes; non-functional.

function PowerLoad(::Nothing)
    PowerLoad(;
        name="init",
        available=false,
        bus=Bus(nothing),
        maxactivepower=0.0,
        maxreactivepower=0.0,
    )
end

"""Get PowerLoad name."""
get_name(value::PowerLoad) = value.name
"""Get PowerLoad available."""
get_available(value::PowerLoad) = value.available
"""Get PowerLoad bus."""
get_bus(value::PowerLoad) = value.bus
"""Get PowerLoad maxactivepower."""
get_maxactivepower(value::PowerLoad) = value.maxactivepower
"""Get PowerLoad maxreactivepower."""
get_maxreactivepower(value::PowerLoad) = value.maxreactivepower
"""Get PowerLoad internal."""
get_internal(value::PowerLoad) = value.internal
