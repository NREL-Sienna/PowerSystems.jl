abstract type PowerPlant <: SupplementalAttribute end

"""
Attribute to represent ThermalGeneration power plants with synchronous generation.
For CombinedCyle plants consider using [`CombinedCycleBlock`](@ref) or [`CombinedCycleFractional`](@ref).

The shaft map field is used to represent shared shafts between units.
"""
struct ThermalPowerPlant <: PowerPlant
    name::String
    shaft_map::Dict{Int, String}
end

"""
Attribute to represent combined cycle generation by block configuration.
For aggregate representations consider using [`CombinedCycleFractional`](@ref).
"""
struct CombinedCycleBlock <: PowerPlant
    name::String
    configuration::CombinedCycleConfiguration
end

"""
Attribute for aggregate representations of combined cycle plants.
"""
struct CombinedCycleFractional <: PowerPlant
    name::String
    total_power_allocation::Dict{String, Float64}
    operation_exclusions::Dict{String, Bool}
end

struct HydroPowerPlant <: PowerPlant
    name::String
    penstock_map::Dict{Int, String}
end

struct PumpedHydroPowerPlant <: PowerPlant
    name::String
    penstock_map::Dict{Int, String}
end

struct RenewablePowerPlant <: PowerPlant
    name::String
end
