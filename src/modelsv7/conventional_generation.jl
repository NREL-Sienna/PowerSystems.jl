export ThermalGen
export TechGen
export EconGen

abstract type
    Thermal <: Generator
end

struct TechGen
    realpower::Float64 # [MW]
    realpowerlimits::NamedTuple{(:min, :max),Tuple{Float64,Float64}}
    reactivepower::Union{Float64,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing}
    ramplimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing}
    timelimits::Union{NamedTuple{(:min, :max),Tuple{Float64,Float64}},Nothing}
    function TechGen(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

        new(realpower, PowerSystems.orderedlimits(realpowerlimits, "Real Power"), reactivepower, PowerSystems.orderedlimits(reactivepowerlimits, "Reactive Power"), ramplimits, timelimits)

    end
end

#define different  constructors depending on the data available.
# Update to named tuples when Julia 0.7 becomes available

TechGen(; realpower = 0.0,
          realpowerlimits = (min = 0.0, max = 0.0),
          reactivepower = nothing,
          reactivepowerlimits = nothing,
          ramplimits = nothing,
          timelimits = nothing
        ) = TechGen(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

struct EconGen{T}
    capacity::Float64                       # [MW]
    variablecost::T                         # [$/MWh]
    fixedcost::Float64            # [$/h]
    startupcost::Float64          # [$]
    shutdncost::Float64           # [$]
    annualcapacityfactor::Union{Float64,Nothing}  # [0-1]
end

EconGen(;   capacity = 0.0,
            variablecost = nothing,
            fixedcost = 0.0,
            startupcost = 0.0,
            shutdncost = 0.0,
            annualcapacityfactor = nothing
        ) = EconGen(capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor)

struct ThermalGen <: Thermal
    name::String
    status::Bool
    bus::Bus
    tech::Union{TechGen,Nothing}
    econ::Union{EconGen,Nothing}
end

ThermalGen(; name = "init",
                status = false,
                bus = Bus(),
                tech = nothing,
                econ = nothing) = ThermalGen(name, status, bus, tech, econ)

struct ThermalGenSeaon <: Thermal
    name::String
    status::Bool
    bus::Bus
    tech::Union{TechGen,Nothing}
    econ::Union{EconGen,Nothing}
    scalingfactor::TimeSeries.TimeArray
end

ThermalGenSeason(; name = "init",
                status = false,
                bus = Bus(),
                tech = nothing,
                econ = nothing,
                scalingfactor = TimeSeries.TimeArray(today(), [1.0])) = ThermalGenSeason(name, status, bus, tech, econ, scalingfactor)

#=
                struct ThermalGen_dyn <: Thermal
    name::String
    status::Bool
    bus::Bus
    tech::Union{TechGen,Nothing}
    econ::Union{EconGen,Nothing}
    dyn::Union{DynamicsGenerator,Nothing}
end

ThermalGen_dyn(; name = "init",
                status = false,
                bus = Bus(),
                tech = nothing,
                econ = nothing,
                dyn=nothing) = ThermalGen_dyn(name, status, bus, tech, econ, dyn)
=#
