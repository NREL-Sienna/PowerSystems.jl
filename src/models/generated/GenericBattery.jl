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
        machine_basepower::Float64
        services::Vector{Service}
        dynamic_injector::Union{Nothing, DynamicInjection}
        ext::Dict{String, Any}
        forecasts::InfrastructureSystems.Forecasts
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
- `machine_basepower::Float64`: Base power of the unit in MVA, validation range: (0, nothing), action if invalid: warn
- `services::Vector{Service}`: Services that this device contributes to
- `dynamic_injector::Union{Nothing, DynamicInjection}`: corresponding dynamic injection device
- `ext::Dict{String, Any}`
- `forecasts::InfrastructureSystems.Forecasts`: internal forecast storage
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
    "Base power of the unit in MVA"
    machine_basepower::Float64
    "Services that this device contributes to"
    services::Vector{Service}
    "corresponding dynamic injection device"
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function GenericBattery(name, available, bus, primemover, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, machine_basepower, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    GenericBattery(name, available, bus, primemover, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, machine_basepower, services, dynamic_injector, ext, forecasts, InfrastructureSystemsInternal(), )
end

function GenericBattery(; name, available, bus, primemover, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, machine_basepower, services=Device[], dynamic_injector=nothing, ext=Dict{String, Any}(), forecasts=InfrastructureSystems.Forecasts(), )
    GenericBattery(name, available, bus, primemover, energy, capacity, rating, activepower, inputactivepowerlimits, outputactivepowerlimits, efficiency, reactivepower, reactivepowerlimits, machine_basepower, services, dynamic_injector, ext, forecasts, )
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
        machine_basepower=0.0,
        services=Device[],
        dynamic_injector=nothing,
        ext=Dict{String, Any}(),
        forecasts=InfrastructureSystems.Forecasts(),
    )
end


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
"""Get GenericBattery machine_basepower."""
get_machine_basepower(value::GenericBattery) = value.machine_basepower
"""Get GenericBattery services."""
get_services(value::GenericBattery) = value.services
"""Get GenericBattery dynamic_injector."""
get_dynamic_injector(value::GenericBattery) = value.dynamic_injector
"""Get GenericBattery ext."""
get_ext(value::GenericBattery) = value.ext

InfrastructureSystems.get_forecasts(value::GenericBattery) = value.forecasts
"""Get GenericBattery internal."""
get_internal(value::GenericBattery) = value.internal


InfrastructureSystems.set_name!(value::GenericBattery, val::String) = value.name = val
"""Set GenericBattery available."""
set_available!(value::GenericBattery, val::Bool) = value.available = val
"""Set GenericBattery bus."""
set_bus!(value::GenericBattery, val::Bus) = value.bus = val
"""Set GenericBattery primemover."""
set_primemover!(value::GenericBattery, val::PrimeMovers.PrimeMover) = value.primemover = val
"""Set GenericBattery energy."""
set_energy!(value::GenericBattery, val::Float64) = value.energy = val
"""Set GenericBattery capacity."""
set_capacity!(value::GenericBattery, val::Min_Max) = value.capacity = val
"""Set GenericBattery rating."""
set_rating!(value::GenericBattery, val::Float64) = value.rating = val
"""Set GenericBattery activepower."""
set_activepower!(value::GenericBattery, val::Float64) = value.activepower = val
"""Set GenericBattery inputactivepowerlimits."""
set_inputactivepowerlimits!(value::GenericBattery, val::Min_Max) = value.inputactivepowerlimits = val
"""Set GenericBattery outputactivepowerlimits."""
set_outputactivepowerlimits!(value::GenericBattery, val::Min_Max) = value.outputactivepowerlimits = val
"""Set GenericBattery efficiency."""
set_efficiency!(value::GenericBattery, val::NamedTuple{(:in, :out), Tuple{Float64, Float64}}) = value.efficiency = val
"""Set GenericBattery reactivepower."""
set_reactivepower!(value::GenericBattery, val::Float64) = value.reactivepower = val
"""Set GenericBattery reactivepowerlimits."""
set_reactivepowerlimits!(value::GenericBattery, val::Union{Nothing, Min_Max}) = value.reactivepowerlimits = val
"""Set GenericBattery machine_basepower."""
set_machine_basepower!(value::GenericBattery, val::Float64) = value.machine_basepower = val
"""Set GenericBattery services."""
set_services!(value::GenericBattery, val::Vector{Service}) = value.services = val
"""Set GenericBattery ext."""
set_ext!(value::GenericBattery, val::Dict{String, Any}) = value.ext = val

InfrastructureSystems.set_forecasts!(value::GenericBattery, val::InfrastructureSystems.Forecasts) = value.forecasts = val
"""Set GenericBattery internal."""
set_internal!(value::GenericBattery, val::InfrastructureSystemsInternal) = value.internal = val
