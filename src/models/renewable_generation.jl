export RenewableGen
export TechRE
export EconRE

abstract type 
    RenewableGen 
end

struct TechRE
    realpowerlimit::Real # [MW]
    reactivepowerlimits::Union{Tuple{Real,Real},Missing}
    powerfactor::Union{Real,Missing}
end

TechRE(; realpowerlimits = 0, reactivepowerlimits = missing, powerfactor = missing)

struct EconRE
    curtailcost::Real # [$/MWh]
    interruptioncost::Union{Real,Missing} # [$]
end

struct ReFix <: RenewableGen
    name::String
    status::Bool
    bus::Bus
    tech::TechRE
    scalingfactor::TimeSeries.TimeArray
    function ReFix(name, status, bus, realpowerlimit::Real, scalingfactor)
        tech = TechRE(realpowerlimit, Missing, 1.0)      
        new(name, status, bus, tech, scalingfactor)
    end
end

ReFix(; name="init", 
        status = false, 
        bus = Bus(), 
        realpowerlimit = 0.0, 
        scalingfactor = TimeSeries.TimeArray(today(), [1.0])) = ReFix(name, status, bus, realpowerlimit, scalingfactor)

struct ReCurtailment <: RenewableGen
    name::String
    status::Bool
    bus::Bus
    tech::TechRE
    econ::Union{EconRE,Missing}
    scalingfactor::TimeSeries.TimeArray 
end



struct ReReactiveDispatch <: RenewableGen
    name::String
    status::Bool
    bus::Bus
    tech::TechRE
    econ::Union{EconRE,Missing}
    scalingfactor::TimeSeries.TimeArray
end