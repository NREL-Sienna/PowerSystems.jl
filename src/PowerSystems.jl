isdefined(Base, :__precompile__) && __precompile__()

"""
Module for constructing self-contained power system objects.
"""
module PowerSystems

#################################################################################
# Exports

export PowerSystem
export Bus
export LoadZones

export Branch
export Network
export Line
export MonitoredLine
export DCLine
export HVDCLine
export VSCDCLine
export Transformer2W
export TapTransformer
export PhaseShiftingTransformer

export Forecast
export Deterministic
export Scenarios
export Probabilistic

export Generator
export GenClasses

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
export RenewableFullDispatch

export ThermalGen
export TechThermal
export EconThermal
export ThermalDispatch
export ThermalGenSeason

export ElectricLoad
export StaticLoad
export PowerLoad
export PowerLoadPF
export FixedAdmittance
export ControllableLoad
export InterruptibleLoad

export Storage
export GenericBattery

export Service
export Reserve
export ProportionalReserve
export StaticReserve
export Transfer

export BevDemand
export Demand
export Envelope
export FlexibleDemand
export InflexibleDemand
export InterruptibleDemand
export LocatedDemand
export LocatedEnvelope
export MobileDemand
export StationaryInflexibleDemand
export TemporalDemand
export demands
export earliestdemands
export envelope
export lastestdemands

export parsestandardfiles
export parse_file
export ps_dict2ps_struct
export assign_ts_data
export read_data_files

#################################################################################
# Imports

import Base.convert
import SparseArrays
import AxisArrays
import LinearAlgebra: LAPACK.getri!
import LinearAlgebra: LAPACK.getrf!
import LinearAlgebra: BLAS.gemm
import LinearAlgebra
import Dates
import TimeSeries
import DataFrames
import JSON
import CSV

#################################################################################
# Includes

abstract type PowerSystemComponent end
# supertype for "devices" (bus, line, etc.)
abstract type PowerSystemDevice <: PowerSystemComponent end
# supertype for generation technologies (thermal, renewable, etc.)
abstract type TechnicalParams <: PowerSystemComponent end

# Include utilities
include("utils/IO/base_checks.jl")
include("utils/timearray.jl")

# PowerSystems models
include("models/topological_elements.jl")
include("models/forecasts.jl")
include("models/branches.jl")
#include("models/network.jl")

# Static types
include("models/generation.jl")
include("models/storage.jl")
include("models/loads.jl")
include("models/services.jl")
include("models/demand.jl")

# Include Parsing files
include("parsers/pm_io.jl")
include("parsers/im_io.jl")
include("parsers/dict_to_struct.jl")
include("parsers/standardfiles_parser.jl")
include("parsers/cdm_parser.jl")
include("parsers/forecast_parser.jl")
include("parsers/pm2ps_parser.jl")

#Data Checks
include("utils/IO/system_checks.jl")
include("utils/IO/branchdata_checks.jl")

# Definitions of PowerSystem
include("base.jl")

# Better printing
include("utils/print.jl")
include("utils/lodf_calculations.jl")

end # module
