isdefined(Base, :__precompile__) && __precompile__()

"""
Module for constructing self-contained power system objects.
"""
module PowerSystems

#################################################################################
# Exports

export System
export Bus
export LoadZones

export PowerSystemType
export Component
export ComponentIterator
export Device
export Branch
export Injection
export ACBranch
export Line
export MonitoredLine
export DCBranch
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
export HydroDispatch
export HydroStorage
export TechHydro
export EconHydro

export RenewableGen
export TechRenewable
export EconRenewable
export RenewableFix
export RenewableDispatch

export ThermalGen
export TechThermal
export EconThermal
export ThermalStandard

export ElectricLoad
export StaticLoad
export PowerLoad
export PowerLoadPF
export FixedAdmittance
export EconLoad
export ControllableLoad
export InterruptibleLoad

export Storage
export GenericBattery

export Service
export Reserve
export ProportionalReserve
export StaticReserve
export Transfer

export PTDF
export build_ybus

export parsestandardfiles
export parse_file
export ps_dict2ps_struct
export add_forecasts!
export remove_forecast!
export get_forecast_initial_times
export get_forecasts
export get_forecasts_horizon
export get_forecasts_initial_time
export get_forecasts_interval
export get_forecasts_resolution
export iterate_forecasts
export read_data_files
export validate
export add_component!
export get_components
export iterate_components
export to_json
export from_json

#################################################################################
# Imports

import SparseArrays
import LinearAlgebra: LAPACK.getri!
import LinearAlgebra: LAPACK.getrf!
import LinearAlgebra: BLAS.gemm
import LinearAlgebra
import Dates
import TimeSeries
import DataFrames
import JSON
import JSON2
import CSV
import YAML
import UUIDs

#################################################################################
# Includes

"""
Supertype for all PowerSystems types.
All subtypes must include a PowerSystemInternal member.
Subtypes should call PowerSystemInternal() by default, but also must provide a constructor
that allows existing values to be deserialized.
"""
abstract type PowerSystemType end

abstract type Component <: PowerSystemType end
# supertype for "devices" (bus, line, etc.)
abstract type Device <: Component end
abstract type Injection <: Device end
# supertype for generation technologies (thermal, renewable, etc.)
abstract type TechnicalParams <: PowerSystemType end

include("common.jl")
include("internal.jl")

# Include utilities
include("utils/utils.jl")
include("utils/logging.jl")
include("utils/flattened_vectors_iterator.jl")
include("utils/lazy_dict_from_iterator.jl")
include("utils/IO/base_checks.jl")

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

#Data Checks
include("utils/IO/system_checks.jl")
include("utils/IO/branchdata_checks.jl")

# Definitions of PowerSystem
include("base.jl")

# Include Parsing files
include("parsers/pm_io.jl")
include("parsers/im_io.jl")
include("parsers/dict_to_struct.jl")
include("parsers/standardfiles_parser.jl")
include("parsers/cdm_parser.jl")
include("parsers/forecast_parser.jl")
include("parsers/pm2ps_parser.jl")

# validation of System
include("validation/powersystem.jl")

# Better printing
include("utils/print.jl")
include("utils/lodf_calculations.jl")

include("models/serialization.jl")

# Download test data
include("utils/data.jl")
import .UtilsData: TestData

end # module
