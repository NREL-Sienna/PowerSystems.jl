abstract type PowerPlant <: SupplementalAttribute end

struct ThermalPowerPlant <: PowerPlant
    name::String
end

struct CombinedCycleBlock <: PowerPlant
    name::String
    configuration::CombinedCycleConfiguration
end

struct HydroPowerPlant <: PowerPlant
    name::String
    penstock_map::Dict{Int, UUID}
end

struct PumpedHydroPowerPlant <: PowerPlant
    name::String
    penstock_map::Dict{Int, UUID}
end
