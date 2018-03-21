export ThermalGen
export ThermalGen_dyn
export TechGen  
export EconGen  

struct TechGen
    realpower::Real # [MW]
    realpowerlimits::NamedTuple
    reactivepower::Union{Real,Nothing} # [MVAr]
    reactivepowerlimits::Union{NamedTuple,Nothing}
    ramplimits::Union{NamedTuple,Nothing}
    timelimits::Union{NamedTuple,Nothing}
    function TechGen(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits) 

        new(realpower, orderedlimits(realpowerlimits), reactivepower, orderedlimits(reactivepowerlimits), ramplimits, timelimits)

    end
end

#define different  constructors depending on the data available. 
# Update to named tuples when Julia 0.7 becomes available 

TechGen(; realpower = 0.0, 
          realpowerlimits = (0.0,0.0), 
          reactivepower = nothing,  
          reactivepowerlimits = nothing,
          ramplimits = nothing,
          timelimits = nothing
        ) = TechGen(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

struct EconGen{T}
    capacity::Real                       # [MW]
    variablecost::T                         # [$/MWh]
    fixedcost::Real            # [$/h] 
    startupcost::Real          # [$]
    shutdncost::Real           # [$]
    annualcapacityfactor::Union{Real,Nothing}  # [0-1] 
end

EconGen(;   capacity = 0.0, 
            variablecost = nothing,
            fixedcost = 0.0,
            startupcost = 0.0,
            shutdncost = 0.0,
            annualcapacityfactor = nothing
        ) = EconGen(capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor) 

struct ThermalGen <: Generator
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


struct ThermalGen_dyn <: Generator
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