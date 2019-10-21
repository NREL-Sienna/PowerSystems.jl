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

export Service
export Reserve
export ProportionalReserve
export StaticReserve
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

export BevDemand
export ChargingSegment
export ChargingPlan
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
export aligntimes
export batterylevels
export chargeamounts
export chargelevels
export chargerates
export consumptionamounts
export consumptionrates
export demands
export durations
export earliestdemands
export envelope
export greedydemands
export latestdemands
export loads
export locateddemand
export locations
export maxchargerates
export populate_BEV_demand
export shortfall
export verify
export verifybattery
export verifylimits

export parse_standard_files
export parse_file
export add_forecasts!
export add_forecast!
export remove_forecast!
export clear_forecasts!
export add_component!
export remove_component!
export remove_components!
export get_component
export get_components
export get_components_by_name
export get_component_forecasts
export get_forecast_initial_times
export get_forecasts
export get_forecasts_horizon
export get_forecasts_initial_time
export get_forecasts_interval
export get_forecasts_resolution
export get_forecast_component_name
export get_forecast_value
export get_horizon
export get_timeseries
export get_data
export iterate_components
export iterate_forecasts
export make_forecasts
export split_forecasts!
export get_name
export to_json

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
abstract type Injection <: Device end
# supertype for generation technologies (thermal, renewable, etc.)
abstract type TechnicalParams <: PowerSystemType end

include("common.jl")

# Include utilities
include("utils/IO/base_checks.jl")
include("utils/timearray.jl")

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
include("models/demand.jl")

# Include all auto-generated structs.
include("models/generated/includes.jl")
include("models/supplemental_constructors.jl")

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
