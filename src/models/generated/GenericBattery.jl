#=
This file is auto-generated. Do not edit.
=#
"""
    mutable struct GenericBattery <: Storage
        name::String
        available::Bool
        bus::Bus
        primemover::PrimeMovers.PrimeMover
        energy::Float64
        capacity::Min_Max
        rating::Float64
        activepower::Float64
        inputactivepowerlimits::Min_Max
        outputactivepowerlimits::Min_Max
        efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}
        reactivepower::Float64
        reactivepowerlimits::Union{Nothing, Min_Max}
        services::Vector{Service}
        ext::Dict{String, Any}
        _forecasts::InfrastructureSystems.Forecasts
        internal::InfrastructureSystemsInternal
    end

Data structure for a generic battery

# Arguments
- `name::String`
- `available::Bool`
- `bus::Bus`
- `primemover::PrimeMovers.PrimeMover`: PrimeMover Technology according to EIA 923
- `energy::Float64`: State of Charge of the Battery p.u.-hr, validation range: (0, nothing), action if invalid: error
- `capacity::Min_Max`: Maximum and Minimum storage capacity in p.u.-hr, validation range: (0, nothing), action if invalid: error
- `rating::Float64`
- `activepower::Float64`
- `inputactivepowerlimits::Min_Max`, validation range: (0, nothing), action if invalid: error
- `outputactivepowerlimits::Min_Max`, validation range: (0, nothing), action if invalid: error
- `efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}`, validation range: (0, 1), action if invalid: warn
- `reactivepower::Float64`, validation range: reactivepowerlimits, action if invalid: warn
- `reactivepowerlimits::Union{Nothing, Min_Max}`
- `services::Vector{Service}`: Services that this device contributes to
- `ext::Dict{String, Any}`
- `_forecasts::InfrastructureSystems.Forecasts`
- `internal::InfrastructureSystemsInternal`: power system internal reference, do not modify
"""
mutable struct GenericBattery <: Storage
    name::String
    available::Bool
    bus::Bus
    "PrimeMover Technology according to EIA 923"
    primemover::PrimeMovers.PrimeMover
    "State of Charge of the Battery p.u.-hr"
    energy::Float64
    "Maximum and Minimum storage capacity in p.u.-hr"
    capacity::Min_Max
    rating::Float64
    activepower::Float64
    inputactivepowerlimits::Min_Max
    outputactivepowerlimits::Min_Max
    efficiency::NamedTuple{(:in, :out), Tuple{Float64, Float64}}
    reactivepower::Float64
    reactivepowerlimits::Union{Nothing, Min_Max}
    "Services that this device contributes to"
    services::Vector{Service}
    ext::Dict{String, Any}
    _forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function GenericBattery(name, available, bus, primemover, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, services=Device[], ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    GenericBattery(name, available, bus, primemover, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, services, ext, _forecasts, InfrastructureSystemsInternal(), )
end

function GenericBattery(; name, available, bus, primemover, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, services=Device[], ext=Dict{String, Any}(), _forecasts=InfrastructureSystems.Forecasts(), )
    GenericBattery(name, available, bus, primemover, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, services, ext, _forecasts, )
end

# Constructor for demo purposes; non-functional.
function GenericBattery(::Nothing)
    GenericBattery(;
        name="init",
        available=false,
        bus=Bus(nothing),
        primemover=PrimeMovers.BA,
        energy=0.0,
        capacity=(min=0.0, max=0.0),
        rating=0.0,
        activepower=0.0,
        inputactivepowerlimits=(min=0.0, max=0.0),
        outputactivepowerlimits=(min=0.0, max=0.0),
        efficiency=(in=0.0, out=0.0),
        reactivepower=0.0,
        reactivepowerlimits=(min=0.0, max=0.0),
        services=Device[],
        ext=Dict{String, Any}(),
        _forecasts=InfrastructureSystems.Forecasts(),
    )
end

"""Get GenericBattery name."""
InfrastructureSystems.get_name(value::GenericBattery) = value.name
"""Get GenericBattery available."""
get_available(value::GenericBattery) = value.available
"""Get GenericBattery bus."""
get_bus(value::GenericBattery) = value.bus
"""Get GenericBattery primemover."""
get_primemover(value::GenericBattery) = value.primemover
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
"""Get GenericBattery services."""
get_services(value::GenericBattery) = value.services
"""Get GenericBattery ext."""
get_ext(value::GenericBattery) = value.ext
"""Get GenericBattery _forecasts."""
get__forecasts(value::GenericBattery) = value._forecasts
"""Get GenericBattery internal."""
get_internal(value::GenericBattery) = value.internal
