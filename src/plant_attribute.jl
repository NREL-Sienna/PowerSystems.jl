abstract type PowerPlant <: SupplementalAttribute end

struct ThermalPowerPlant <: PowerPlant
    name::String
    shaft_map::Dict{Int, String}
end

struct CombinedCycleBlock <: PowerPlant
    name::String
    configuration::CombinedCycleConfiguration
end

struct HydroPowerPlant <: PowerPlant
    name::String
    penstock_map::Dict{Int, String}
end

struct PumpedHydroPowerPlant <: PowerPlant
    name::String
    penstock_map::Dict{Int, String}
end
