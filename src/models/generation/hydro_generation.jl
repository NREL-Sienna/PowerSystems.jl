abstract type
    HydroGen <: Generator
end

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
        scalingfactor = TimeArray(today(),ones(1))) = HydroFix(name, status, bus, tech, scalingfactor)


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
                scalingfactor = TimeArray(today(),ones(1))) = HydroCurtailment(name, status, bus, tech, curtailcost, scalingfactor)


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
                scalingfactor = TimeArray(today(),ones(1))) = HydroStorage(name, status, bus, tech, econ, storagecapacity, scalingfactor)