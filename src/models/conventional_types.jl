export ThermalGen
export ThermalGen_dyn
export TechGen  
export EconGen  

orderedlimits(limits::Tuple) = limits[2] < limits[1] ? error("Limits not in ascending order") : limits

struct TechGen 
    realpower::Real # [MW]
    realpowerlimits::Tuple{Real,Real}
    reactivepower::Union{Real,Missing} # [MVAr]
    reactivepowerlimits::Union{Tuple{Real,Real},Missing}
    ramplimits::Union{Tuple{Real,Real},Missing}
    timelimits::Union{Tuple{Real,Real},Missing}
    function TechGen(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits) 

        new(realpower, orderedlimits(realpowerlimits), reactivepower, orderedlimits(reactivepowerlimits), ramplimits, timelimits)

    end
end

#define different  constructors depending on the data available. 
# Update to named tuples when Julia 0.7 becomes available 

TechGen(; realpower = 0.0, 
          realpowerlimits = (0.0,0.0), 
          reactivepower = missing,  
          reactivepowerlimits = missing,
          ramplimits = missing,
          timelimits = missing
        ) = TechGen(realpower, realpowerlimits, reactivepower, reactivepowerlimits, ramplimits, timelimits)

struct EconGen{T}
    capacity::Real                       # [MW]
    variablecost::T                         # [$/MWh]
    fixedcost::Real            # [$/h] 
    startupcost::Real          # [$]
    shutdncost::Real           # [$]
    annualcapacityfactor::Union{Real,Missing}  # [0-1] 
end

EconGen(;   capacity = 0.0, 
            variablecost = missing,
            fixedcost = 0.0,
            startupcost = 0.0,
            shutdncost = 0.0,
            annualcapacityfactor = missing
        ) = EconGen(capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor) 

struct ThermalGen
    name::String
    status::Bool
    bus::Bus
    tech::Union{TechGen,Missing}
    econ::Union{EconGen,Missing}
end

ThermalGen(; name = "init",
                status = false,
                bus = Bus(),
                tech = missing,
                econ = missing) = ThermalGen(name, status, bus, tech, econ)


struct ThermalGen_dyn
    name::String
    status::Bool
    bus::Bus
    tech::Union{TechGen,Missing}
    econ::Union{EconGen,Missing}
    dyn::Union{SynchronousMachine,Missing}
end                

ThermalGen_dyn(; name = "init",
                status = false,
                bus = Bus(),
                tech = missing,
                econ = missing,
                dyn=missing) = ThermalGen_dyn(name, status, bus, tech, econ, dyn)