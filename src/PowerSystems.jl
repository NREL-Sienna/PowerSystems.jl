isdefined(Base, :__precompile__) && __precompile__()

"""
Module for constructing self-contained power system objects.
"""
module PowerSystems

#################################################################################
# Exports

export System
export Bus
export Arc
export LoadZones

export PowerSystemType
export Component
export Device
export Branch
export StaticInjection
export ACBranch
export Line
export MonitoredLine
export DCBranch
export HVDCLine
export VSCDCLine
export Transformer2W
export TapTransformer
export PhaseShiftingTransformer

export ThreePartCost
export TwoPartCost

export Generator
export HydroGen
export HydroFix
export HydroDispatch
export HydroStorage
export TechHydro

export RenewableGen
export TechRenewable
export RenewableFix
export RenewableDispatch

export ThermalGen
export TechThermal
export ThermalStandard

export ElectricLoad
export StaticLoad
export PowerLoad
export PowerLoadPF
export FixedAdmittance
export ControllableLoad
export InterruptibleLoad

export Storage
export GenericBattery

export DynamicGenerator
#AVR Exports
export AVR
export AVRFixed
export AVRSimple
export AVRTypeI
export AVRTypeII

#Machine Exports
export Machine
export BaseMachine
export OneDOneQMachine
export MarconatoMachine
export SimpleMarconatoMachine
export AndersonFouadMachine
export SimpleAFMachine
export FullMachine
export SimpleFullMachine

#PSS Exports
export PSS
export PSSFixed
export PSSFixed

#Shaft Exports
export SingleMass
export FiveMassShaft

#TG Exports
export TurbineGov
export TGFixed
export TGTypeI
export TGTypeII

#=
export DynamicInverter
# Converter Exports
export Converter
export AvgCnvFixedDC

# DC Source Exports
export DCSource
export FixedDCSource

# Filter Exports
export Filter
export LCLFilter

# FrequencyEstimator Exports
export FrequencyEstimator
export PLL

# Outer Control Exports
export OuterControl
export VirtualInertiaQdroop
export VirtualInertia
export ReactivePowerDroop

# VSControl Export
export VSControl
export CombinedVIwithVZ
=#


export Service
export Reserve
export StaticReserve
export VariableReserve
export Transfer

export PTDF
export Ybus
export LODF
export GeneratorCostModel
export BusType

export Forecast
export Deterministic
export Probabilistic
export ScenarioBased

export make_pf
export solve_powerflow!

export parse_standard_files
export parse_file
export add_forecasts!
export add_forecast!
export remove_forecast!
export clear_forecasts!
export add_component!
export remove_component!
export remove_components!
export clear_components!
export are_forecasts_contiguous
export generate_initial_times
export get_component
export get_components
export get_components_by_name
export get_forecast_labels
export get_forecast_initial_times
export get_forecast_keys
export get_forecast
export get_forecast_values
export get_forecasts_horizon
export get_forecasts_initial_time
export get_forecasts_interval
export get_forecasts_resolution
export get_horizon
export get_initial_time
export get_resolution
export get_data
export iterate_components
export iterate_forecasts
export make_forecasts
export get_bus_numbers
export get_name
export to_json
export check_forecast_consistency
export validate_forecast_consistency

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
import Base.to_index

import InfrastructureSystems
import InfrastructureSystems: Components, Deterministic, Probabilistic, Forecast,
    ScenarioBased, InfrastructureSystemsType, InfrastructureSystemsInternal,
    FlattenIteratorWrapper, LazyDictFromIterator, DataFormatError, InvalidRange,
    InvalidValue

const IS = InfrastructureSystems

#################################################################################
# Includes

"""
Supertype for all PowerSystems types.
All subtypes must include a InfrastructureSystemsInternal member.
Subtypes should call InfrastructureSystemsInternal() by default, but also must
provide a constructor that allows existing values to be deserialized.
"""
abstract type PowerSystemType <: IS.InfrastructureSystemsType end

abstract type Component <: PowerSystemType end
# supertype for "devices" (bus, line, etc.)
abstract type Device <: Component end
abstract type StaticInjection <: Device end
abstract type DynamicInjection <: Device end
abstract type DeviceParameter <: PowerSystemType end
abstract type DynamicComponent <: DeviceParameter end

include("common.jl")

# Include utilities
include("utils/IO/base_checks.jl")

# PowerSystems models
include("models/topological_elements.jl")
include("models/branches.jl")
include("models/operational_cost.jl")
#include("models/network.jl")

# Static types
include("models/generation.jl")
include("models/storage.jl")
include("models/loads.jl")
include("models/services.jl")
include("models/dynamic_generator_components.jl")

# Include all auto-generated structs.
include("models/generated/includes.jl")
include("models/supplemental_constructors.jl")

# Dynamic Composed types
include("models/dynamic_generator.jl")
#include("models/dynamic_inverter.jl")

# Definitions of PowerSystem
include("base.jl")

#Interfacing with Forecasts
include("forecasts.jl")

#Data Checks
include("utils/IO/system_checks.jl")
include("utils/IO/branchdata_checks.jl")

# network calculations
include("utils/network_calculations/common.jl")
include("utils/network_calculations/ybus_calculations.jl")
include("utils/network_calculations/ptdf_calculations.jl")
include("utils/network_calculations/lodf_calculations.jl")

#PowerFlow
include("utils/power_flow/make_pf.jl")
include("utils/power_flow/power_flow.jl")

# Include Parsing files
include("parsers/common.jl")
include("parsers/enums.jl")
include("parsers/pm_io.jl")
include("parsers/im_io.jl")
include("parsers/standardfiles_parser.jl")
include("parsers/forecast_parser.jl")
include("parsers/power_system_table_data.jl")
include("parsers/pm2ps_parser.jl")

# Better printing
include("utils/print.jl")

include("models/serialization.jl")

# Download test data
include("utils/data.jl")
import .UtilsData: TestData

end # module
