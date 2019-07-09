#=
This file is auto-generated. Do not edit.
=#


mutable struct GenericBattery <: Storage
    name::String
    available::Bool
    bus::Bus
    energy::Float64  # State of Charge of the Battery p.u.-hr
    capacity::NamedTuple{(:min, :max), Tuple{Float64, Float64}}  # Maximum and Minimum storage capacity in p.u.-hr
    rating::Float64
    activepower::Float64
    inputactivepowerlimits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    outputactivepowerlimits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}
    reactivepower::Float64
    reactivepowerlimits::Union{Nothing, NamedTuple{(:min, :max), Tuple{Float64, Float64}}}
    internal::PowerSystems.PowerSystemInternal
end

function GenericBattery(name, available, bus, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, )
    GenericBattery(name, available, bus, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, PowerSystemInternal())
end

function GenericBattery(; name, available, bus, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, )
    GenericBattery(name, available, bus, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, )
end

# Constructor for demo purposes; non-functional.

function GenericBattery(::Nothing)
    GenericBattery(;
        name="init",
        available=false,
        bus=Bus(nothing),
        energy=0.0,
        capacity=(min=0.0, max=0.0),
        rating=0.0,
        activepower=0.0,
        inputactivepowerlimits=(min=0.0, max=0.0),
        outputactivepowerlimits=(min=0.0, max=0.0),
        efficiency=(in=0.0, out=0.0),
        reactivepower=0.0,
        reactivepowerlimits=(min=0.0, max=0.0),
    )
end

"""Get GenericBattery name."""
get_name(value::GenericBattery) = value.name
"""Get GenericBattery available."""
get_available(value::GenericBattery) = value.available
"""Get GenericBattery bus."""
get_bus(value::GenericBattery) = value.bus
"""Get GenericBattery energy."""
get_energy(value::GenericBattery) = value.energy
"""Get GenericBattery capacity."""
get_capacity(value::GenericBattery) = value.capacity
"""Get GenericBattery rating."""
get_rating(value::GenericBattery) = value.rating
"""Get GenericBattery activepower."""
get_activepower(value::GenericBattery) = value.activepower
"""Get GenericBattery inputactivepowerlimits."""
get_inputactivepowerlimits(value::GenericBattery) = value.inputactivepowerlimits
"""Get GenericBattery outputactivepowerlimits."""
get_outputactivepowerlimits(value::GenericBattery) = value.outputactivepowerlimits
"""Get GenericBattery efficiency."""
get_efficiency(value::GenericBattery) = value.efficiency
"""Get GenericBattery reactivepower."""
get_reactivepower(value::GenericBattery) = value.reactivepower
"""Get GenericBattery reactivepowerlimits."""
get_reactivepowerlimits(value::GenericBattery) = value.reactivepowerlimits
"""Get GenericBattery internal."""
get_internal(value::GenericBattery) = value.internal
