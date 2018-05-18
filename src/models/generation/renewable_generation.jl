export RenewableGen
export TechRenewable
export EconRenewable
export RenewableFix
export RenewableCurtailment

abstract type
    RenewableGen <: Generator
end

struct TechRenewable
    installedcapacity::Float64 # [MW]
    reactivepowerlimits::Union{@NT(min::Float64, max::Float64),Nothing}
    powerfactor::Union{Float64,Nothing}
end

TechRenewable(; InstalledCapacity = 0, reactivepowerlimits = nothing, powerfactor = nothing) = TechRenewable(InstalledCapacity, reactivepowerlimits, powerfactor)

struct EconRenewable
    curtailcost::Float64 # [$/MWh]
    interruptioncost::Union{Float64,Nothing} # [$]
end

EconRenewable(; curtailcost = 0.0, interruptioncost = nothing) = EconRenewable(curtailcost, interruptioncost)

struct RenewableFix <: RenewableGen
    name::String
    status::Bool
    bus::Bus
    tech::TechRenewable
    scalingfactor::TimeSeries.TimeArray
    function RenewableFix(name, status, bus, installedcapacity::Float64, scalingfactor)
        tech = TechRenewable(installedcapacity, nothing, 1.0)
        new(name, status, bus, tech, scalingfactor)
    end
end

RenewableFix(; name="init",
        status = false,
        bus = Bus(),
        installedcapacity = 0.0,
        scalingfactor = TimeSeries.TimeArray(today(), [1.0])) = RenewableFix(name, status, bus, installedcapacity, scalingfactor)

struct RenewableCurtailment <: RenewableGen
    name::String
    status::Bool
    bus::Bus
    tech::TechRenewable
    econ::Union{EconRenewable,Nothing}
    scalingfactor::TimeSeries.TimeArray
    function RenewableCurtailment(name, status, bus, installedcapacity::Float64, econ, scalingfactor)
        tech = TechRenewable(installedcapacity, nothing, 1.0)
        new(name, status, bus, tech, econ, scalingfactor)
    end
end

RenewableCurtailment(; name = "init",
                status = false,
                bus= Bus(),
                tech = TechRenewable(),
                econ = EconRenewable(),
                scalingfactor = TimeSeries.TimeArray(today(), [1.0])) = RenewableCurtailment(name, status, bus, tech, econ, scalingfactor)

struct ReReactiveDispatch <: RenewableGen
    name::String
    status::Bool
    bus::Bus
    tech::TechRenewable
    econ::Union{EconRenewable,Nothing}
    scalingfactor::TimeSeries.TimeArray
end
