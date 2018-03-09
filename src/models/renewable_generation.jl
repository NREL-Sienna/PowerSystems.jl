export RenewableGen
export TechRE
export EconRE

abstract type 
    RenewableGen 
end

struct TechRE
    installedcapacity::Real # [MW]
    reactivepowerlimits::Union{Tuple{Real,Real},Missing}
    powerfactor::Union{Real,Missing}
end

TechRE(; installedcapacitys = 0, reactivepowerlimits = missing, powerfactor = missing) = TechRE(installedcapacitys, reactivepowerlimits, powerfactor)

struct EconRE
    curtailcost::Real # [$/MWh]
    interruptioncost::Union{Real,Missing} # [$]
end

EconRE(; curtailcost = 0.0, interruptioncost = missing) = EconRE(curtailcost, interruptioncost)

struct ReFix <: RenewableGen
    name::String
    status::Bool
    bus::Bus
    tech::TechRE
    scalingfactor::TimeSeries.TimeArray
    function ReFix(name, status, bus, installedcapacity::Real, scalingfactor)
        tech = TechRE(installedcapacity, Missing, 1.0)      
        new(name, status, bus, tech, scalingfactor)
    end
end

ReFix(; name="init", 
        status = false, 
        bus = Bus(), 
        installedcapacity = 0.0, 
        scalingfactor = TimeSeries.TimeArray(today(), [1.0])) = ReFix(name, status, bus, installedcapacity, scalingfactor)

struct ReCurtailment <: RenewableGen
    name::String
    status::Bool
    bus::Bus
    tech::TechRE
    econ::Union{EconRE,Missing}
    scalingfactor::TimeSeries.TimeArray 
    function ReCurtailment(name, status, bus, installedcapacity::Real, scalingfactor)
        tech = TechRE(installedcapacity, Missing, 1.0)      
        new(name, status, bus, tech, scalingfactor)
    end
end

ReCurtailment(; name = "init", 
                status = false, 
                bus= Bus(), 
                tech = TechRE(),
                econ = EconRE(),
                scalingfactor = TimeSeries.TimeArray(today(), [1.0])) = ReCurtailment(name, status, bus, tech, econ, scalingfactor)

struct ReReactiveDispatch <: RenewableGen
    name::String
    status::Bool
    bus::Bus
    tech::TechRE
    econ::Union{EconRE,Missing}
    scalingfactor::TimeSeries.TimeArray
end