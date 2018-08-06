abstract type
    HydroGen <: Generator
end


struct TechHydro
    installedcapacity::Float64
    realpower::Float64 # [MW]
    realpowerlimits::@NT(min::Float64, max::Float64) # [MW]
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{@NT(min::Float64, max::Float64),Nothing} # [MVAr]
    ramplimits::Union{@NT(up::Float64, down::Float64),Nothing} #MW/Hr
    timelimits::Union{@NT(up::Float64, down::Float64),Nothing} # Hrs
    function TechHydro(installedcapacity, realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)
        
        new(installedcapacity, realpower, PowerSystems.orderedlimits(realpowerlimits, "Real Power"), reactivepower, PowerSystems.orderedlimits(reactivepowerlimits, "Reactive Power"), ramplimits, timelimits)

    end
end

TechHydro(;installedcapacity = 0.0,
          realpower = 0.0,
          realpowerlimits = @NT(min = 0.0, max = 0.0),
          reactivepower = nothing,
          reactivepowerlimits = nothing,
          ramplimits = @NT(up=0.0, down=0.0),
          timelimits = nothing
        ) = TechHydro(installedcapacity, realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)


struct EconHydro
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
        scalingfactor = TimeArray(collect(DateTime(today()):Hour(1):DateTime(today()+Day(1))), ones(25))) = HydroFix(name, status, bus, tech, scalingfactor)


struct HydroCurtailment <: HydroGen
    name::String
    available::Bool
    bus::Bus
    tech::TechHydro
    econ::Union{EconHydro,Nothing}
    scalingfactor::TimeSeries.TimeArray # [0-1]
    function HydroCurtailment(name, status, bus, tech, curtailcost::Float64, scalingfactor)
        econ = EconHydro(curtailcost, nothing)
        new(name, status, bus, tech, econ, scalingfactor)
    end
end

HydroCurtailment(; name = "init",
                status = false,
                bus= Bus(),
                tech = TechHydro(),
                curtailcost = 0.0,
                scalingfactor = TimeArray(collect(DateTime(today()):Hour(1):DateTime(today()+Day(1))), ones(25))) = HydroCurtailment(name, status, bus, tech, curtailcost, scalingfactor)


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
                scalingfactor = TimeArray(collect(DateTime(today()):Hour(1):DateTime(today()+Day(1))), ones(25))) = HydroStorage(name, status, bus, tech, econ, storagecapacity, scalingfactor)