#isdefined(Base, :__precompile__) && __precompile__()

module PowerSystems

#################################################################################
# Exports

export PowerSystem
export Bus

export Branch
export Network
export Line
export Transformer2W
export TapTransformer
export PhaseShiftingTransformer
export Transformer3W

export Forecast
export Deterministic
export Scenarios
export Probabilistic

export Generator
export Sources

export HydroGen
export HydroFix
export HydroCurtailment
export HydroStorage
export TechHydro
export EconHydro

export RenewableGen
export TechRenewable
export EconRenewable
export RenewableFix
export RenewableCurtailment

export ThermalGen
export TechThermal
export EconThermal
export ThermalDispatch
export ThermalGenSeason

export ElectricLoad
export ShuntElement

export StaticLoad
export ControllableLoad
export InterruptibleLoad

export Storage
export GenericBattery

export ParseStandardFiles
#################################################################################
# Imports

import Base.convert

using TimeSeries
using PowerModels
using DataFrames
using CSV
# This packages will be removed with Julia v0.7
using Compat
using NamedTuples

#################################################################################
# Includes

abstract type PowerSystemDevice end

# Include utilities
include("utils/base_checks.jl")

# PowerSystems models
include("models/topological_elements.jl")
include("models/forecasts.jl")
include("models/branches.jl")
include("models/network.jl")

# Static types
include("models/generation.jl")
include("models/storage.jl")
include("models/loads.jl")

# Include Parsing files
include("parsers/dict_to_struct.jl")
include("parsers/standardfiles_parser.jl")
include("parsers/csv_parser.jl")

# Definitions of PowerSystem
include("utils/system_checks.jl")
include("base.jl")

# Better printing
include("utils/print.jl")

end # module
