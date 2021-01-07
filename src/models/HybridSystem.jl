"""
Representation of a Hybrid System that collects renewable generation, load, thermal generation
and storage.

Each generator is a data structure that is defined by the following components:

- [ThermalGen](@ref PowerSystems.ThermalGen)
- [Load](@ref PowerSystems.ElectricLoad)
- [Storage](@ref PowerSystems.Storage)
- [RenewableGen](@ref PowerSystems.RenewableGen)
"""
mutable struct HybridSystem <: StaticInjection
    name::String
    available::Bool
    status::Bool
    bus::Bus
    active_power::Float64
    reactive_power::Float64
    base_power::Float64
    operation_cost::OperationalCost
    thermal_unit::Union{Nothing, ThermalGen}
    electric_load::Union{Nothing, ElectricLoad}
    storage::Union{Nothing, Storage}
    renewable_unit::Union{Nothing, RenewableGen}
    # interconnection Data
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    interconnection_impedance::Union{Nothing, ComplexF64}
    interconnection_rating::Union{Nothing, Float64}
    input_active_power_limits::Union{Nothing, Min_Max}
    output_active_power_limits::Union{Nothing, Min_Max}
    reactive_power_limits::Union{Nothing, Min_Max}
    "corresponding dynamic injection device"
    services::Vector{Service}
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal forecast storage"
    time_series_container::InfrastructureSystems.TimeSeriesContainer
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HybridSystem(;
    name = "init",
    available = false,
    status = false,
    bus = Bus(nothing),
    active_power = 0.0,
    reactive_power = 0.0,
    base_power = 100.0,
    operation_cost = TwoPartCost(nothing),
    thermal_unit = nothing,
    electric_load = nothing,
    storage = nothing,
    renewable_unit = nothing,
    interconnection_impedance = nothing,
    interconnection_rating = nothing,
    input_active_power_limits = nothing,
    output_active_power_limits = nothing,
    reactive_power_limits = nothing,
    services = Service[],
    dynamic_injector = nothing,
    ext = Dict{String, Any}(),
    time_series_container = InfrastructureSystems.TimeSeriesContainer(),
    internal = InfrastructureSystemsInternal(),
)
    return HybridSystem(
        name,
        available,
        status,
        bus,
        active_power,
        reactive_power,
        base_power,
        operation_cost,
        thermal_unit,
        electric_load,
        storage,
        renewable_unit,
        interconnection_impedance,
        interconnection_rating,
        input_active_power_limits,
        output_active_power_limits,
        reactive_power_limits,
        services,
        dynamic_injector,
        ext,
        time_series_container,
        internal,
    )
end

# Constructor for demo purposes; non-functional.
function HybridSystem(::Nothing)
    HybridSystem(;
        name = "init",
        available = false,
        status = false,
        bus = Bus(nothing),
        active_power = 0.0,
        reactive_power = 0.0,
        base_power = 100.0,
        operation_cost = TwoPartCost(nothing),
        thermal_unit = ThermalStandard(nothing),
        electric_load = PowerLoad(nothing),
        storage = GenericBattery(nothing),
        renewable_unit = RenewableDispatch(nothing),
        interconnection_impedance = nothing,
        interconnection_rating = nothing,
        input_active_power_limits = nothing,
        output_active_power_limits = nothing,
        reactive_power_limits = nothing,
        services = Service[],
        dynamic_injector = nothing,
        ext = Dict{String, Any}(),
        time_series_container = InfrastructureSystems.TimeSeriesContainer(),
        internal = InfrastructureSystemsInternal(),
    )
end

IS.get_name(value::HybridSystem) = value.name
function set_units_setting!(value::HybridSystem, settings::SystemUnitsSettings)
    value.internal.units_info = settings
    value.thermal_unit.internal.units_info = settings
    value.electric_load.internal.units_info = settings
    value.storage.internal.units_info = settings
    value.renewable_unit.internal.units_info = settings
    return
end

"""Get [`HybridSystem`](@ref) `available`."""
get_available(value::HybridSystem) = value.available
"""Get [`HybridSystem`](@ref) `status`."""
get_status(value::HybridSystem) = value.status
"""Get [`HybridSystem`](@ref) `bus`."""
get_bus(value::HybridSystem) = value.bus
"""Get [`HybridSystem`](@ref) `active_power`."""
get_active_power(value::HybridSystem) = get_value(value, value.active_power)
"""Get [`HybridSystem`](@ref) `reactive_power`."""
get_reactive_power(value::HybridSystem) = get_value(value, value.reactive_power)
"""Get [`HybridSystem`](@ref) thermal unit"""
get_thermal_unit(value::HybridSystem) = value.thermal_unit
"""Get [`HybridSystem`](@ref) load"""
get_electric_load(value::HybridSystem) = value.electric_load
"""Get [`HybridSystem`](@ref) storage unit"""
get_storage(value::HybridSystem) = value.storage
"""Get [`HybridSystem`](@ref) renewable unit"""
get_renewable_unit(value::HybridSystem) = value.renewable_unit
"""Get [`HybridSystem`](@ref) `rating`."""
get_interconnection_rating(value::HybridSystem) =
    get_value(value, value.interconnection_rating)
"""get [`HybridSystem`](@ref) interconnection impedance"""
get_interconnection_impedance(value::HybridSystem) = value.interconnection_impedance
"""Get [`HybridSystem`](@ref) `input_active_power_limits`."""
get_input_active_power_limits(value::HybridSystem) =
    get_value(value, value.input_active_power_limits)
"""Get [`HybridSystem`](@ref) `output_active_power_limits`."""
get_output_active_power_limits(value::HybridSystem) =
    get_value(value, value.output_active_power_limits)
"""Get [`HybridSystem`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::HybridSystem) =
    get_value(value, value.reactive_power_limits)
"""Get [`HybridSystem`](@ref) `base_power`."""
get_base_power(value::HybridSystem) = value.base_power
"""Get [`HybridSystem`](@ref) `operation_cost`."""
get_operation_cost(value::HybridSystem) = value.operation_cost
"""Get [`HybridSystem`](@ref) `services`."""
get_services(value::HybridSystem) = value.services
"""Get [`HybridSystem`](@ref) `dynamic_injector`."""
get_dynamic_injector(value::HybridSystem) = value.dynamic_injector
"""Get [`HybridSystem`](@ref) `ext`."""
get_ext(value::HybridSystem) = value.ext

InfrastructureSystems.get_time_series_container(value::HybridSystem) =
    value.time_series_container
"""Get [`HybridSystem`](@ref) `internal`."""
get_internal(value::HybridSystem) = value.internal

InfrastructureSystems.set_name!(value::HybridSystem, val) = value.name = val
"""Set [`HybridSystem`](@ref) `available`."""
set_available!(value::HybridSystem, val) = value.available = val
"""Get [`HybridSystem`](@ref) `status`."""
set_status!(value::HybridSystem, val) = value.status = val
"""Set [`HybridSystem`](@ref) `bus`."""
set_bus!(value::HybridSystem, val) = value.bus = val
"""Set [`HybridSystem`](@ref) `rating`."""
set_interconnection_rating!(value::HybridSystem, val) = value.interconnection_rating = val
"""Set [`HybridSystem`](@ref) `active_power`."""
set_active_power!(value::HybridSystem, val) = value.active_power = val
"""Set [`HybridSystem`](@ref) `reactive_power`."""
set_reactive_power!(value::HybridSystem, val) = value.reactive_power = val
"""Get [`HybridSystem`](@ref) thermal unit"""
set_thermal_unit!(value::HybridSystem, val::ThermalGen) = value.thermal_unit = val
"""Get [`HybridSystem`](@ref) load"""
set_electric_load!(value::HybridSystem, val::ElectricLoad) = value.electric_load = val
"""Get [`HybridSystem`](@ref) storage unit"""
set_storage!(value::HybridSystem, val::Storage) = value.storage = val
"""Get [`HybridSystem`](@ref) renewable unit"""
set_renewable_unit!(value::HybridSystem, val::RenewableGen) = value.renewable_unit = val
"""set [`HybridSystem`](@ref) interconnection impedance"""
set_interconnection_impedance!(value::HybridSystem, val) =
    value.interconnection_impedance = val
"""Set [`HybridSystem`](@ref) `input_active_power_limits`."""
set_input_active_power_limits!(value::HybridSystem, val) =
    value.input_active_power_limits = val
"""Set [`HybridSystem`](@ref) `output_active_power_limits`."""
set_output_active_power_limits!(value::HybridSystem, val) =
    value.output_active_power_limits = val
"""Set [`HybridSystem`](@ref) `reactive_power_limits`."""
set_reactive_power_limits!(value::HybridSystem, val) = value.reactive_power_limits = val
"""Set [`HybridSystem`](@ref) `base_power`."""
set_base_power!(value::HybridSystem, val) = value.base_power = val
"""Set [`HybridSystem`](@ref) `operation_cost`."""
set_operation_cost!(value::HybridSystem, val) = value.operation_cost = val
"""Set [`HybridSystem`](@ref) `services`."""
set_services!(value::HybridSystem, val) = value.services = val
"""Set [`HybridSystem`](@ref) `ext`."""
set_ext!(value::HybridSystem, val) = value.ext = val

InfrastructureSystems.set_time_series_container!(value::HybridSystem, val) =
    value.time_series_container = val

function IS.deserialize(::Type{HybridSystem}, data::Dict, component_cache::Dict)
    error("Deserialization of HybridSystem is not currently supported")
end

function IS.serialize(component::HybridSystem)
    error("Serialization of HybridSystem is not currently supported")
end
