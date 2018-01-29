export ThermalGen
export TechGen  
export EconGen  

orderedlimits(limits::Tuple) = limits[2] < limits[1] ? error("Limits not in ascending order") : limits

struct TechGen 
    realpower::Real # [MW]
    realpowerlims::Tuple{Real,Real}
    reactivepower::Nullable{Real} # [MVAr]
    reactivepowerlims::Nullable{Tuple{Real,Real}}
    ramplims::Nullable{Tuple{Real,Real}}
    timelimits::Nullable{Tuple{Real,Real}}
    function TechGen(realpower, realpowerlimits, reactivepower, reactivepowerlims, ramplims, timelimits) 

        new(realpower, orderedlimits(realpowerlimits), reactivepower, orderedlimits(reactivepowerlims), ramplims, timelimits)

    end
end

#define different  constructors depending on the data available. 
# Update to named tuples when Julia 0.7 becomes available 

TechGen(; realpower = 0.0, 
          realpowerlimits = (0.0,0.0), 
          reactivepower = Nullable{Real}(),  
          reactivepowerlims = Nullable{Tuple{Real,Real}}(),
          ramplims = Nullable{Tuple{Real,Real}}(),
          timelimits = Nullable{Tuple{Real,Real}}()
        ) = TechGen(realpower, realpowerlimits, reactivepower, reactivepowerlims, ramplims, timelimits)

struct EconGen{T}
    capacity::Real                       # [MW]
    variablecost::T                         # [$/MWh]
    fixedcost::Real            # [$/h] 
    startupcost::Real          # [$]
    shutdncost::Real           # [$]
    annualcapacityfactor::Nullable{Real}  # [0-1] 
end

EconGen(;   capacity = 0.0, 
            variablecost = Nullable(),
            fixedcost = 0.0,
            startupcost = 0.0,
            shutdncost = 0.0,
            annualcapacityfactor = Nullable{Real}()
        ) = EconGen(capacity, variablecost, fixedcost, startupcost, shutdncost, annualcapacityfactor) 

struct ThermalGen
    Name::String
    Status::Bool
    bus::Bus
    tech::Nullable{TechGen}
    econ::Nullable{EconGen}
end