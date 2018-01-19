export Thermalgen
export Techgen  
export Econgen  

struct Techgen 
    realpower::Float64 # [MW]
    reactivepower::Nullable{Float64} # [MVAr]
    maxrealpower::Float64 # [MW]
    minrealpower::Float64 # [MW]
    maxreactivepower::Nullable{Float64} # [MVAr]
    minreactivepower::Nullable{Float64} # [MVAr]
    maxrampup::Nullable{Float64} # [MW/hr]
    maxrampdn::Nullable{Float64} # [MW/hr]
    minuptime::Nullable{Float64} #[hours]
    mindntime::Nullable{Float64} #[hours]
end

generator_tech(RealPower::Float64, ) = generator_tech(RealPower, Nullable{Float64}(),  )

struct Econgen
    capacity::Float64 # [MW]
    variablecost::Union{Float64,Array{Tuple{Float64,Float64}},Function} # [$/MWh]
    fixedcost::Float64         # [$/h] 
    startupcost::Nullable{Float64} # [$]
    shutdncost::Nullable{Float64} # [$]
    anualcapacityfactor::Nullable{Float64} # [0-1] 
end

struct Thermalgen
    Name::String
    Status::Bool
    bus::bus
    tech::Nullable{Techgen}
    econ::Nullable{Econgen}
end