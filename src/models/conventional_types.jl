export generator_tech  
export generator_econ  
export ng_generator
export thermal_generation

abstract type 
    thermal_generation
end

struct generator_tech 
    RealPower::Float64 # [MW]
    ReactivePower::Nullable{Float64} # [MVAr]
    MaxRealPower::Float64 # [MW]
    MinRealPower::Float64 # [MW]
    MaxReactivePower::Nullable{Float64} # [MVAr]
    MinReactivePower::Nullable{Float64} # [MVAr]
    MaxRampUP::Nullable{Float64}
    MaxRampDN::Nullable{Float64}
    MinUPTime::Nullable{Float64}
    MinDNTime::Nullable{Float64}
end

struct generator_econ
    InstalledCapacity::Float64 # [MW]
    VariableCost::Union{Array{Tuple{Float64,Float64}},Function} # [$/MWh]
    FixedCost::Float64         # [$/h] 
    AnualCapacityFactor::Nullable{Float64} #[0-1]
    Fuel::String     #[Gas, wind, solar, hydro, ...]
    CostFunction::Function 
end

struct ng_generator <: thermal_generation
    Name::String
    bus::bus
    TechnicalParameters::Nullable{generator_tech}
    EconomicParameters::Nullable{generator_econ}
end