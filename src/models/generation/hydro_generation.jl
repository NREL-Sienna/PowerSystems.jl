abstract type
    HydroGen <: Generator
end


struct TechHydro <: TechnicalParams
    installedcapacity::Float64
    activepower::Float64 # [MW]
    activepowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}} # [MW]
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing} # [MVAr]
    ramplimits::Union{NamedTuple{(:up, :down),Tuple{Float64,Float64}},Nothing} #MW/Hr
    timelimits::Union{NamedTuple{(:up, :down),Tuple{Float64,Float64}},Nothing} # Hrs
    internal::PowerSystemInternal
end

function TechHydro(installedcapacity,
                   activepower,
                   activepowerlimits,
                   reactivepower,
                   reactivepowerlimits,
                   ramplimits,
                   timelimits)
    return TechHydro(installedcapacity,
                     activepower,
                     PowerSystems.orderedlimits(activepowerlimits, "Real Power"),
                     reactivepower,
                     PowerSystems.orderedlimits(reactivepowerlimits, "Reactive Power"),
                     ramplimits,
                     timelimits,
                     PowerSystemInternal())
end

TechHydro(;installedcapacity = 0.0,
          activepower = 0.0,
          activepowerlimits = (min = 0.0, max = 0.0),
          reactivepower = nothing,
          reactivepowerlimits = nothing,
          ramplimits = nothing,
          timelimits = nothing
        ) = TechHydro(installedcapacity, activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)


struct EconHydro <: TechnicalParams
    curtailpenalty::Float64 # [$/MWh]
    variablecost::Union{Float64,Nothing} # [$/MWh]
    internal::PowerSystemInternal
end

function EconHydro(curtailpenalty, variablecost)
    return EconHydro(curtailpenalty, variablecost, PowerSystemInternal())
end

EconHydro(; cost = 0.0, curtailcost = 0.0) = EconHydro(cost, curtailcost)

struct HydroFix <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    internal::PowerSystemInternal

    function HydroFix(name, available, bus, tech, internal=PowerSystemInternal())
        new(name, available, bus, tech, internal)
    end
end

HydroFix(; name="init",
        status = false,
        bus = Bus(),
        tech = TechHydro()) = HydroFix(name, status, bus, tech)


struct HydroCurtailment <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    econ::Union{EconHydro,Nothing}
    internal::PowerSystemInternal
end

function HydroCurtailment(name, available, bus, tech, econ)
    return HydroCurtailment(name, available, bus, tech, econ, PowerSystemInternal())
end

function HydroCurtailment(name::String, status::Bool, bus::Bus, tech::TechHydro, curtailcost::Float64)
    econ = EconHydro(curtailcost, nothing)
    return HydroCurtailment(name, status, bus, tech, econ)
end

HydroCurtailment(; name = "init",
                status = false,
                bus= Bus(),
                tech = TechHydro(),
                curtailcost = 0.0) = HydroCurtailment(name, status, bus, tech, curtailcost)


struct HydroStorage <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    econ::Union{EconHydro,Nothing}
    storagecapacity::Float64 #[m^3]
    internal::PowerSystemInternal
end

function HydroStorage(name, available, bus, tech, econ, storagecapacity)
    return HydroStorage(name, available, bus, tech, econ, storagecapacity,
                        PowerSystemInternal())
end

HydroStorage(; name = "init",
                status = false,
                bus= Bus(),
                tech = TechHydro(),
                econ = EconHydro(),
                storagecapacity = 0.0) = HydroStorage(name, status, bus, tech, econ, storagecapacity)
