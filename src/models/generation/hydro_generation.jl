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
    function TechHydro(installedcapacity, activepower, activepowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

        new(installedcapacity, activepower, PowerSystems.orderedlimits(activepowerlimits, "Real Power"), reactivepower, PowerSystems.orderedlimits(reactivepowerlimits, "Reactive Power"), ramplimits, timelimits)

    end
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
end

EconHydro(; cost = 0.0, curtailcost = 0.0) = EconHydro(cost, curtailcost)

struct HydroFix <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    scalingfactor::TimeSeries.TimeArray
end

HydroFix(; name="init",
        status = false,
        bus = Bus(),
        tech = TechHydro(),
        scalingfactor = TimeSeries.TimeArray(Dates.today(),ones(1))) = HydroFix(name, status, bus, tech, scalingfactor)


struct HydroCurtailment <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    econ::Union{EconHydro,Nothing}
    scalingfactor::TimeSeries.TimeArray # [0-1]
end

function HydroCurtailment(name, status, bus, tech, curtailcost::Float64, scalingfactor)
    econ = EconHydro(curtailcost, nothing)
    HydroCurtailment(name, status, bus, tech, econ, scalingfactor)
end

HydroCurtailment(; name = "init",
                status = false,
                bus= Bus(),
                tech = TechHydro(),
                curtailcost = 0.0,
                scalingfactor = TimeSeries.TimeArray(Dates.today(),ones(1))) = HydroCurtailment(name, status, bus, tech, curtailcost, scalingfactor)


struct HydroStorage <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    econ::Union{EconHydro,Nothing}
    storagecapacity::Float64 #[m^3]
    scalingfactor::TimeSeries.TimeArray
end

HydroStorage(; name = "init",
                status = false,
                bus= Bus(),
                tech = TechHydro(),
                econ = EconHydro(),
                storagecapacity = 0.0,
                scalingfactor = TimeSeries.TimeArray(Dates.today(),ones(1))) = HydroStorage(name, status, bus, tech, econ, storagecapacity, scalingfactor)
