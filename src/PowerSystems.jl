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
export ACBus
export DCBus
export Arc
export AggregationTopology
export Area
export LoadZone
export AreaInterchange
export get_aggregation_topology_accessor
export SupplementalAttribute
export GeographicInfo

export Component
export Device
export get_max_active_power
export get_max_reactive_power
export Branch
export StaticInjection
export StaticInjectionSubsystem
export ACBranch
export Line
export MonitoredLine
export DCBranch
export TwoTerminalHVDCLine
export TwoTerminalVSCDCLine
export TModelHVDCLine
export Transformer2W
export TapTransformer
export PhaseShiftingTransformer

# from IS function_data.jl
export FunctionData
export LinearFunctionData
export QuadraticFunctionData
export PiecewiseLinearData
export PiecewiseStepData
export get_proportional_term
export get_quadratic_term
export get_constant_term
export get_slopes
export get_average_rates
export get_x_lengths
export is_convex
export get_points
export get_x_coords
export get_y_coords

# from IS value_curve.jl, cost_aliases.jl, and production_variable_cost_curve.jl
export ValueCurve
export InputOutputCurve, IncrementalCurve, AverageRateCurve
export LinearCurve, QuadraticCurve
export PiecewisePointCurve, PiecewiseIncrementalCurve, PiecewiseAverageCurve
export ProductionVariableCostCurve, CostCurve, FuelCurve
export get_function_data, get_initial_input, get_input_at_zero
export get_value_curve, get_power_units

export OperationalCost, MarketBidCost, LoadCost, StorageCost
export HydroGenerationCost, RenewableGenerationCost, ThermalGenerationCost
export get_fuel_cost, set_fuel_cost!, get_vom_cost
export is_market_bid_curve, make_market_bid_curve
export get_no_load_cost, set_no_load_cost!, get_start_up, set_start_up!
export set_shut_down!
export get_curtailment_cost
export set_curtailment_cost!
export get_fixed
export set_fixed!
export get_charge_variable_cost, set_charge_variable_cost!
export get_discharge_variable_cost, set_discharge_variable_cost!
export get_energy_shortage_cost, set_energy_shortage_cost!
export get_energy_surplus_cost, set_energy_surplus_cost!

export Generator
export HydroGen
export HydroDispatch
export HydroEnergyReservoir
export HydroPumpedStorage
export InterconnectingConverter

export RenewableGen
export RenewableNonDispatch
export RenewableDispatch

export ThermalGen
export ThermalStandard
export ThermalMultiStart

export ElectricLoad
export StaticLoad
export PowerLoad
export StandardLoad
export FixedAdmittance
export SwitchedAdmittance
export ControllableLoad
export InterruptiblePowerLoad
export ExponentialLoad

export Storage
export EnergyReservoirStorage

export DynamicComponent
export DynamicInjection
export DynamicGenerator

export DynamicInverter
export DynamicBranch
export HybridSystem

export GenericDER
export AggregateDistributedGenerationA
export SingleCageInductionMachine
export SimplifiedSingleCageInductionMachine
export ActiveConstantPowerLoad
export DynamicExponentialLoad

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
export ESAC8B
export EXAC1
export EXAC1A
export EXAC2
export EXPIC1
export ESST1A
export ESST4B
export ST6B
export SCRX
export SEXS
export ST8C

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
export SauerPaiMachine
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
export STAB1
export PSS2A
export PSS2B
export PSS2C
export CSVGN1

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
export DEGOV
export DEGOV1
export PIDGOV
export WPIDHY
export TGSimple

# Converter Exports
export Converter
export AverageConverter
export RenewableEnergyConverterTypeA
export RenewableEnergyVoltageConverterTypeA

# DC Source Exports
export DCSource
export FixedDCSource
export ZeroOrderBESS

# Filter Exports
export Filter
export LCLFilter
export LCFilter
export RLFilter

# FrequencyEstimator Exports
export FrequencyEstimator
export KauraPLL
export ReducedOrderPLL
export FixedFrequency

# Outer Control Exports
export OuterControl
export VirtualInertia
export ReactivePowerDroop
export ActivePowerDroop
export ActivePowerPI
export ReactivePowerPI
export ActiveVirtualOscillator
export ReactiveVirtualOscillator
export ActiveRenewableControllerAB
export ReactiveRenewableControllerAB

# InnerControl Export
export InnerControl
export VoltageModeControl
export CurrentModeControl
export RECurrentControlB

# OutputCurrentLimiters Export
export OutputCurrentLimiter
export MagnitudeOutputCurrentLimiter
export InstantaneousOutputCurrentLimiter
export PriorityOutputCurrentLimiter
export SaturationOutputCurrentLimiter
export HybridOutputCurrentLimiter

export Source
export PeriodicVariableSource

export Contingency

# Outages
export Outage
export GeometricDistributionForcedOutage
export PlannedOutage
export TimeSeriesForcedOutage

export get_mean_time_to_recovery
export get_outage_transition_probability
export get_outage_schedule

export Service
export AbstractReserve
export Reserve
export ReserveNonSpinning
export ReserveDirection
export ReserveUp
export ReserveDown
export ReserveSymmetric
export ConstantReserve
export VariableReserve
export AGC
export ReserveDemandCurve
export ConstantReserveGroup
export ConstantReserveNonSpinning
export VariableReserveNonSpinning
export TransmissionInterface

export AngleUnits
export ACBusTypes
export PrimeMovers
export ThermalFuels
export StorageTech
export StateTypes

# from IS time_series_structs.jl, time_series_cache.jl
export TimeSeriesAssociation
export TimeSeriesKey
export StaticTimeSeriesKey
export ForecastKey
export TimeSeriesCounts
export ForecastCache
export StaticTimeSeriesCache
# from IS time_series_parser.jl
export NormalizationFactor
export NormalizationTypes
# from IS forecasts.jl
export Forecast
export AbstractDeterministic
export TimeSeriesData # abstract_time_series.jl
export StaticTimeSeries # static_time_series.jl
export Deterministic # deterministic.jl
export Probabilistic # Probabilistic.jl
export SingleTimeSeries # Single_Time_Series.jl
export DeterministicSingleTimeSeries # deterministic_single_time_series.jl
export Scenarios # scenarios.jl

export get_dynamic_components

export parse_file
export open_time_series_store!
export add_time_series!
export bulk_add_time_series!
export remove_time_series!
export check_time_series_consistency
export clear_time_series!
export copy_time_series!
export copy_subcomponent_time_series!
export add_component!
export add_components!
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
export is_component_in_aggregation_topology
export get_components_in_aggregation_topology
export get_aggregation_topology_mapping
export get_contributing_devices
export get_contributing_device_mapping
export ServiceContributingDevices
export ServiceContributingDevicesKey
export ServiceContributingDevicesMapping
export get_component
export get_components
export show_components
export get_subcomponents
export get_components_by_name
export get_available_components
export get_existing_device_types
export get_existing_component_types
export get_forecast_horizon
export get_forecast_initial_timestamp
export get_forecast_interval
export get_forecast_window_count
export add_supplemental_attribute!
export remove_supplemental_attribute!
export remove_supplemental_attributes!
export get_supplemental_attribute
export get_supplemental_attributes
export has_supplemental_attributes
export iterate_supplemental_attributes
export get_time_series
export get_time_series_type
export get_time_series_array
export get_time_series_resolutions
export supports_time_series
export supports_supplemental_attributes
export get_time_series_timestamps
export get_time_series_values
export get_time_series_counts
export get_scenario_count
export get_percentiles
export get_next_time_series_array!
export get_next_time
export reset!
export get_horizon
export get_forecast_initial_times
export get_time_series_keys
export show_time_series
export get_resolution
export get_data
export iterate_components
export get_time_series_multiple
export get_variable_cost
export get_incremental_variable_cost, get_decremental_variable_cost
export get_no_load_cost
export get_start_up
export get_shut_down
export get_incremental_offer_curves, set_incremental_offer_curves!
export get_decremental_offer_curves, set_decremental_offer_curves!
export get_incremental_initial_input, set_incremental_initial_input!
export get_decremental_initial_input, set_decremental_initial_input!
export get_ancillary_service_offers, set_ancillary_service_offers!
export get_services_bid
export set_variable_cost!
export set_incremental_variable_cost!, set_decremental_variable_cost!
export set_service_bid!
export iterate_windows
export get_window
export transform_single_time_series!
export sanitize_component!
export validate_component
export validate_component_with_system
export get_compression_settings
export CompressionSettings
export CompressionTypes

# Parsing functions
export create_poly_cost

#export make_time_series
export get_bus_numbers
export get_name
export set_name!
export get_component_uuids
export get_description
export set_description!
export get_base_power
export get_frequency
export set_units_base_system!
export to_json
export from_json
export serialize
export deserialize
export clear_ext!
export convert_component!
export set_area!
export set_load_zone!
export TamuSystem
export PowerModelsData
export PowerSystemTableData
export add_dyn_injectors!
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
export get_units_base
export get_runchecks
export get_thermal_unit
export get_electric_load
export get_storage
export get_renewable_unit
export get_interconnection_rating
export get_interconnection_impedance
export get_from_to_flow_limit
export get_to_from_flow_limit
export get_min_active_power_flow_limit
export get_max_active_power_flow_limit

# Subsystems
export add_subsystem!
export get_subsystems
export get_num_subsystems
export remove_subsystem!
export add_component_to_subsystem!
export get_subsystem_components
export remove_component_from_subsystem!
export remove_component_from_subsystems!
export has_component
export get_assigned_subsystems
export has_subsystems
export is_assigned_to_subsystem
export from_subsystem
export filter_components_by_subsystem!

export set_runchecks!
export check
export check_component
export check_components
export check_sil_values

# From IS logging.jl, generate_struct_files.jl
export configure_logging
export open_file_logger
export make_logging_config_file
export MultiLogger
export LogEventTracker
export StructField
export StructDefinition
export generate_struct_file
export generate_struct_files
export UnitSystem # internal.jl

#################################################################################
# Imports

import Base: @kwdef
import LinearAlgebra
import Unicode: normalize
import Logging
import Dates
import TimeSeries
import DataFrames
import DataStructures: OrderedDict, SortedDict
import JSON3
import CSV
import YAML
import UUIDs
import Base.to_index
import InteractiveUtils
import PrettyTables
import PowerFlowData

import InfrastructureSystems
import InfrastructureSystems:
    Components,
    TimeSeriesData,
    StaticTimeSeries,
    Forecast,
    AbstractDeterministic,
    Deterministic,
    Probabilistic,
    SingleTimeSeries,
    StaticTimeSeriesKey,
    DeterministicSingleTimeSeries,
    ForecastKey,
    Scenarios,
    ForecastCache,
    StaticTimeSeriesCache,
    TimeSeriesKey,
    TimeSeriesCounts,
    TimeSeriesAssociation,
    InfrastructureSystemsComponent,
    InfrastructureSystemsType,
    InfrastructureSystemsInternal,
    SupplementalAttribute,
    DeviceParameter,
    FlattenIteratorWrapper,
    LazyDictFromIterator,
    DataFormatError,
    InvalidRange,
    InvalidValue,
    GeographicInfo,
    copy_time_series!,
    get_count,
    get_data,
    get_horizon,
    get_resolution,
    get_window,
    get_name,
    get_component_uuids,
    get_supplemental_attribute,
    get_supplemental_attributes,
    set_name!,
    get_internal,
    set_internal!,
    iterate_windows,
    get_time_series,
    has_time_series,
    get_time_series_type,
    get_time_series_array,
    get_time_series_timestamps,
    get_time_series_values,
    get_time_series_keys,
    show_time_series,
    get_scenario_count, # Scenario Forecast Exports
    get_percentiles, # Probabilistic Forecast Exports
    get_next_time_series_array!,
    get_next_time,
    reset!,
    has_supplemental_attributes,
    get_units_info,
    set_units_info!,
    to_json,
    from_json,
    serialize,
    deserialize,
    get_time_series_multiple,
    compare_values,
    CompressionSettings,
    CompressionTypes,
    NormalizationFactor,
    NormalizationTypes,
    UnitSystem,
    SystemUnitsSettings,
    open_file_logger,
    make_logging_config_file,
    validate_struct,
    MultiLogger,
    LogEventTracker,
    StructField,
    StructDefinition,
    FunctionData,
    LinearFunctionData,
    QuadraticFunctionData,
    PiecewiseLinearData,
    PiecewiseStepData,
    get_proportional_term,
    get_quadratic_term,
    get_constant_term,
    get_slopes,
    running_sum,
    get_x_lengths,
    is_convex,
    get_points,  # TODO possible rename to disambiguate from geographical information
    get_x_coords,
    get_y_coords,
    get_raw_data_type,
    supports_time_series,
    supports_supplemental_attributes
import InfrastructureSystems:
    ValueCurve,
    InputOutputCurve,
    IncrementalCurve,
    AverageRateCurve,
    LinearCurve,
    QuadraticCurve,
    PiecewisePointCurve,
    PiecewiseIncrementalCurve,
    PiecewiseAverageCurve,
    get_function_data,
    get_initial_input,
    get_input_at_zero,
    get_average_rates,
    ProductionVariableCostCurve,
    CostCurve,
    FuelCurve,
    get_value_curve,
    get_vom_cost,
    get_power_units,
    get_fuel_cost

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

""" Supertype for "devices" (bus, line, etc.) """
abstract type Device <: Component end

supports_time_series(::Device) = true
supports_supplemental_attributes(::Device) = true

# Include utilities
include("utils/logging.jl")
include("utils/IO/base_checks.jl")
include("utils/generate_struct_files.jl")

include("definitions.jl")
include("models/static_models.jl")
include("models/dynamic_models.jl")
include("models/injection.jl")
include("models/static_injection_subsystem.jl")

# PowerSystems models
include("models/topological_elements.jl")
include("models/branches.jl")
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

# Costs
include("models/cost_functions/operational_cost.jl")
include("models/cost_functions/MarketBidCost.jl")
include("models/cost_functions/HydroGenerationCost.jl")
include("models/cost_functions/LoadCost.jl")
include("models/cost_functions/RenewableGenerationCost.jl")
include("models/cost_functions/StorageCost.jl")
include("models/cost_functions/ThermalGenerationCost.jl")

# Include all auto-generated structs.
include("models/generated/includes.jl")
include("models/HybridSystem.jl")

#Methods for devices
include("models/components.jl")
include("models/devices.jl")

# Dynamic Composed types
include("models/dynamic_generator.jl")
include("models/dynamic_inverter.jl")
include("models/dynamic_loads.jl")
include("models/dynamic_machines.jl")
include("models/RoundRotorExponential.jl")
include("models/RoundRotorQuadratic.jl")
include("models/SalientPoleExponential.jl")
include("models/SalientPoleQuadratic.jl")
include("models/dynamic_branch.jl")

include("models/supplemental_constructors.jl")
include("models/supplemental_accessors.jl")

# Supplemental attributes
include("contingencies.jl")
include("outages.jl")

# Definitions of PowerSystem
include("base.jl")
include("subsystems.jl")
include("data_format_conversions.jl")

#Data Checks
include("utils/IO/system_checks.jl")
include("utils/IO/branchdata_checks.jl")

# cost function TimeSeries convertion
include("models/cost_function_timeseries.jl")

#Conversions
include("utils/conversion.jl")

# Include Parsing files
include("parsers/common.jl")
include("parsers/enums.jl")
include("parsers/pm_io.jl")
include("parsers/im_io.jl")
include("parsers/power_system_table_data.jl")
include("parsers/power_models_data.jl")
include("parsers/powerflowdata_data.jl")
include("parsers/psse_dynamic_data.jl")
include("parsers/TAMU_data.jl")

# Better printing
include("utils/print.jl")

include("models/serialization.jl")

#Deprecated
include("deprecated.jl")

end # module
