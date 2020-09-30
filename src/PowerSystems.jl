isdefined(Base, :__precompile__) && __precompile__()

"""
Module for constructing self-contained power system objects.
"""
module PowerSystems

#################################################################################
# Exports

export System
export Topology
export Bus
export Arc
export AggregationTopology
export Area
export LoadZone
export get_aggregation_topology_accessor

export Component
export Device
export get_max_active_power
export get_max_reactive_power
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
export VariableCost
export MultiStartCost
export MarketBidCost
export get_slopes
export get_breakpoint_upperbounds

export Generator
export HydroGen
export HydroDispatch
export HydroEnergyReservoir
export HydroPumpedStorage

export RenewableGen
export RenewableFix
export RenewableDispatch

export ThermalGen
export ThermalStandard
export ThermalMultiStart

export ElectricLoad
export StaticLoad
export PowerLoad
export PowerLoadPF
export FixedAdmittance
export ControllableLoad
export InterruptibleLoad

export Storage
export GenericBattery

export DynamicInjection
export DynamicGenerator
export DynamicInverter
export DynamicBranch
export RegulationDevice

#AVR Exports
export AVR
export AVRFixed
export AVRSimple
export AVRTypeI
export AVRTypeII
export IEEET1
export ESDC1A
export ESDC2A
export ESAC1A
export ESAC6A
export EXAC1
export EXAC1A
export EXAC2
export EXPIC1
export ESST1A
export ESST4B
export SCRX

#Machine Exports
export Machine
export BaseMachine
export RoundRotorMachine
export SalientPoleMachine
export RoundRotorQuadratic
export SalientPoleQuadratic
export RoundRotorExponential
export SalientPoleExponential
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
export PSSSimple
export IEEEST

#Shaft Exports
export Shaft
export SingleMass
export FiveMassShaft

#TG Exports
export TurbineGov
export TGFixed
export TGTypeI
export TGTypeII
export GasTG
export GeneralGovModel
export HydroTurbineGov
export IEEETurbineGov1
export SteamTurbineGov1

# Converter Exports
export Converter
export AverageConverter

# DC Source Exports
export DCSource
export FixedDCSource
export ZeroOrderBESS

# Filter Exports
export Filter
export LCLFilter
export LCFilter

# FrequencyEstimator Exports
export FrequencyEstimator
export KauraPLL

# Outer Control Exports
export OuterControl
export VirtualInertia
export ReactivePowerDroop

# InnerControl Export
export InnerControl
export CurrentControl

export Source

export Service
export Reserve
export ReserveDirection
export ReserveUp
export ReserveDown
export StaticReserve
export VariableReserve
export AGC
export ReserveDemandCurve
export Transfer
export StaticReserveGroup
export StaticReserveNonSpinning
export VariableReserveNonSpinning

export PTDF
export Ybus
export LODF
export GeneratorCostModels
export AngleUnits
export BusTypes
export LoadModels
export PrimeMovers
export ThermalFuels
export StateTypes

export TimeSeriesData
export Deterministic
export Probabilistic
export Scenarios
export NormalizationFactor
export NormalizationTypes

export get_dynamic_components

export solve_powerflow!
export solve_powerflow

export parse_file
export add_time_series!
export remove_time_series!
export clear_time_series!
export copy_time_series!
export add_component!
export remove_component!
export remove_components!
export clear_components!
export add_service!
export remove_service!
export clear_services!
export get_services
export has_service
export has_time_series
export get_buses
export get_components_in_aggregation_topology
export get_aggregation_topology_mapping
export get_contributing_devices
export get_contributing_device_mapping
export ServiceContributingDevices
export ServiceContributingDevicesKey
export ServiceContributingDevicesMapping
export are_time_series_contiguous
export generate_initial_times
export get_component
export get_components
export get_components_by_name
export get_available_components
export get_time_series
export get_time_series_array
export get_time_series_horizon
export get_time_series_initial_time
export get_time_series_initial_times
export get_time_series_interval
export get_time_series_labels
export get_time_series_resolution
export get_time_series_timestamps
export get_time_series_values
export get_horizon
export get_initial_time
export get_resolution
export get_data
export iterate_components
export get_time_series_multiple
export make_time_series
export get_bus_numbers
export get_name
export get_base_power
export get_frequency
export set_units_base_system!
export to_json
export from_json
export serialize
export deserialize
export check_time_series_consistency
export validate_time_series_consistency
export clear_ext!
export convert_component!
export set_area!
export set_load_zone!
export TamuSystem
export PowerModelsData
export add_dyn_injectors!
export set_dynamic_injector!
export get_machine
export get_shaft
export get_avr
export get_prime_mover
export get_pss
export get_converter
export get_outer_control
export get_inner_control
export get_dc_source
export get_freq_estimator
export get_filter
export get_V_ref
export get_P_ref
export get_saturation_coeffs
export set_droop!
export set_participation_factor!
export set_inertia!
export set_reserve_limit_up!
export set_reserve_limit_dn!
export set_cost!
export get_droop
export get_inertia
export get_reserve_limit_up
export get_reserve_limit_dn
export get_participation_factor
export get_cost
export get_units_base

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
import JSON3
import CSV
import YAML
import UUIDs
import Base.to_index
import NLsolve
import InteractiveUtils

import InfrastructureSystems
import InfrastructureSystems:
    Components,
    Deterministic,
    Probabilistic,
    TimeSeriesData,
    Scenarios,
    InfrastructureSystemsComponent,
    InfrastructureSystemsType,
    InfrastructureSystemsInternal,
    DeviceParameter,
    FlattenIteratorWrapper,
    LazyDictFromIterator,
    DataFormatError,
    InvalidRange,
    InvalidValue,
    get_data,
    get_horizon,
    get_initial_time,
    get_resolution,
    get_name,
    to_json,
    from_json,
    serialize,
    deserialize,
    get_time_series_multiple,
    NormalizationFactor,
    NormalizationTypes,
    UnitSystem,
    SystemUnitsSettings

const IS = InfrastructureSystems

#################################################################################

using DocStringExtensions

@template (FUNCTIONS, METHODS) = """
                                 $(TYPEDSIGNATURES)
                                 $(DOCSTRING)
                                 """

#################################################################################
# Includes

"""
Supertype for all PowerSystems components.
All subtypes must include a InfrastructureSystemsInternal member.
Subtypes should call InfrastructureSystemsInternal() by default, but also must
provide a constructor that allows existing values to be deserialized.
"""
abstract type Component <: IS.InfrastructureSystemsComponent end
# supertype for "devices" (bus, line, etc.)
abstract type Device <: Component end

include("common.jl")
include("models/static_models.jl")
include("models/dynamic_models.jl")
include("models/injection.jl")

# Include utilities
include("utils/IO/base_checks.jl")

# PowerSystems models
include("models/topological_elements.jl")
include("models/branches.jl")
include("models/operational_cost.jl")
#include("models/network.jl")

# Static types
include("models/services.jl")
include("models/reserves.jl")
include("models/generation.jl")
include("models/storage.jl")
include("models/loads.jl")
include("models/dynamic_generator_components.jl")
include("models/dynamic_inverter_components.jl")
include("models/OuterControl.jl")

# Include all auto-generated structs.
include("models/generated/includes.jl")
include("models/regulation_device.jl")

#Methods for devices
include("models/components.jl")
include("models/devices.jl")

# Dynamic Composed types
include("models/dynamic_generator.jl")
include("models/dynamic_inverter.jl")
include("models/dynamic_machines.jl")
include("models/RoundRotorExponential.jl")
include("models/RoundRotorQuadratic.jl")
include("models/SalientPoleExponential.jl")
include("models/SalientPoleQuadratic.jl")
include("models/dynamic_branch.jl")

include("models/supplemental_constructors.jl")
include("models/supplemental_accessors.jl")

# Definitions of PowerSystem
include("base.jl")

#Data Checks
include("utils/IO/system_checks.jl")
include("utils/IO/branchdata_checks.jl")

# network calculations
include("utils/network_calculations/common.jl")
include("utils/network_calculations/ybus_calculations.jl")
include("utils/network_calculations/ptdf_calculations.jl")
include("utils/network_calculations/lodf_calculations.jl")

#PowerFlow
include("utils/power_flow.jl")

#Conversions
include("utils/conversion.jl")

# Include Parsing files
include("parsers/common.jl")
include("parsers/enums.jl")
include("parsers/pm_io.jl")
include("parsers/im_io.jl")
include("parsers/power_system_table_data.jl")
include("parsers/power_models_data.jl")
include("parsers/psse_dynamic_data.jl")
include("parsers/TAMU_data.jl")

# Better printing
include("utils/print.jl")

include("models/serialization.jl")

# Download test data
include("utils/data.jl")
import .UtilsData: TestData

end # module
