abstract type
    RenewableGen <: Generator
end

struct TechRenewable
    installedcapacity::Float64 # [MW]
    reactivepowerlimits::Union{@NT(min::Float64, max::Float64),Nothing} # [MVar]
    powerfactor::Union{Float64,Nothing} # [-1. -1]
end

TechRenewable(; InstalledCapacity = 0, reactivepowerlimits = nothing, powerfactor = nothing) = TechRenewable(InstalledCapacity, reactivepowerlimits, powerfactor)

struct EconRenewable
    curtailpenalty::Float64 # [$/MWh]
    variablecost::Union{Float64,Nothing} # [$/MWh]
end

EconRenewable(; curtailcost = 0.0, variablecost = nothing) = EconRenewable(curtailcost, variablecost)

struct RenewableFix <: RenewableGen
    name::String
    available::Bool
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
        scalingfactor = TimeArray(today(),ones(1))) = RenewableFix(name, status, bus, installedcapacity, scalingfactor)

struct RenewableCurtailment <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    tech::TechRenewable
    econ::Union{EconRenewable,Nothing}
    scalingfactor::TimeSeries.TimeArray # [0-1]
end

function RenewableCurtailment(name::String, status::Bool, bus::Bus, installedcapacity::Float64, econ::Union{EconRenewable,Nothing}, scalingfactor::TimeSeries.TimeArray)
    tech = TechRenewable(installedcapacity, nothing, 1.0)
    return RenewableCurtailment(name, status, bus, tech, econ, scalingfactor)
end

RenewableCurtailment(; name = "init",
                status = false,
                bus= Bus(),
                installedcapacity = 0.0,
                econ = EconRenewable(),
                scalingfactor =  TimeArray(today(),ones(1))) = RenewableCurtailment(name, status, bus, installedcapacity, econ, scalingfactor)

struct RenewableFullDispatch <: RenewableGen
    name::String
    available::Bool
    bus::Bus
    tech::TechRenewable
    econ::Union{EconRenewable,Nothing}
    scalingfactor::TimeSeries.TimeArray # [0-1]
end
