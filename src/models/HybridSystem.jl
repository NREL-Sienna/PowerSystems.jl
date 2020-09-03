"""
Representation of a Hybrid System that collects renewable generation, load, thermal generation
and storage
"""
mutable struct HybridSystem{
    T <: ThermalGen,
    L <: ElectricLoad,
    S <: Storage,
    R <: RenewableGen,
} <: StaticInjection
    name::String
    available::Bool
    status::Bool
    bus::Bus
    active_power::Float64
    reactive_power::Float64
    thermal_unit::T
    electric_load::L
    storage::S
    renewable_unit::R
    # PCC Data
    "Thermal limited MVA Power Output of the unit. <= Capacity"
    pcc_impedance::ComplexF64
    rating::Float64
    input_active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    output_active_power_limits::NamedTuple{(:min, :max), Tuple{Float64, Float64}}
    reactive_power_limits::Union{Nothing, Min_Max}
    base_power::Float64
    operation_cost::OperationalCost
    "corresponding dynamic injection device"
    services::Vector{Service}
    dynamic_injector::Union{Nothing, DynamicInjection}
    ext::Dict{String, Any}
    "internal forecast storage"
    forecasts::InfrastructureSystems.Forecasts
    "power system internal reference, do not modify"
    internal::InfrastructureSystemsInternal
end

function HybridSystem(;
    name,
    available,
    status,
    bus,
    active_power,
    reactive_power,
    thermal_unit::T,
    electric_load::L,
    storage::S,
    renewable_unit::R,
    pcc_impedance,
    rating,
    input_active_power_limits,
    output_active_power_limits,
    reactive_power_limits,
    base_power,
    operation_cost,
    services = Service[],
    dynamic_injector = nothing,
    ext = Dict{String, Any}(),
    forecasts = InfrastructureSystems.Forecasts(),
    internal = InfrastructureSystemsInternal(),
) where {T <: ThermalGen, L <: ElectricLoad, S <: Storage, R <: RenewableGen}

    return HybridSystem{T, L, S, R}(
        name,
        available,
        status,
        bus,
        active_power,
        reactive_power,
        thermal_unit::T,
        electric_load::L,
        storage::S,
        renewable_unit::R,
        pcc_impedance,
        rating,
        input_active_power_limits,
        output_active_power_limits,
        reactive_power_limits,
        base_power,
        operation_cost,
        services,
        dynamic_injector,
        ext,
        forecasts,
        internal,
    )

end

IS.get_name(value::HybridSystem) = IS.get_name(value.device)
function set_unit_system!(value::HybridSystem, settings::SystemUnitsSettings)
    value.thermal_unit.units_info = settings
    value.electric_load.units_info = settings
    value.storage.units_info = settings
    value.renewable_unit.units_info = settings
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
get_thermal(value::HybridSystem) = value.thermal_unit
"""Get [`HybridSystem`](@ref) load"""
get_load(value::HybridSystem) = value.electric_load
"""Get [`HybridSystem`](@ref) storage unit"""
get_storage(value::HybridSystem) = value.storage
"""Get [`HybridSystem`](@ref) renewable unit"""
get_renewable(value::HybridSystem) = value.renewable_unit
"""Get [`HybridSystem`](@ref) `rating`."""
get_rating(value::HybridSystem) = get_value(value, value.rating)
"""get [`HybridSystem`](@ref) PCC impedance"""
get_pcc_impedance(value::HybridSystem) = value.pcc_impedance
"""Get [`HybridSystem`](@ref) `input_active_power_limits`."""
get_input_active_power_limits(value::HybridSystem) = get_value(value, value.input_active_power_limits)
"""Get [`HybridSystem`](@ref) `output_active_power_limits`."""
get_output_active_power_limits(value::HybridSystem) = get_value(value, value.output_active_power_limits)
"""Get [`HybridSystem`](@ref) `reactive_power_limits`."""
get_reactive_power_limits(value::HybridSystem) = get_value(value, value.reactive_power_limits
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
IS.get_forecasts(value::HybridSystem) = value.forecasts


InfrastructureSystems.set_name!(value::HybridSystem, val) = value.name = val
"""Set [`HybridSystem`](@ref) `available`."""
set_available!(value::HybridSystem, val) = value.available = val
"""Get [`HybridSystem`](@ref) `status`."""
get_status(value::HybridSystem) = value.status
"""Set [`HybridSystem`](@ref) `bus`."""
set_bus!(value::HybridSystem, val) = value.bus = val
"""Set [`HybridSystem`](@ref) `rating`."""
set_rating!(value::HybridSystem, val) = value.rating = val
"""Set [`HybridSystem`](@ref) `active_power`."""
set_active_power!(value::HybridSystem, val) = value.active_power = val
"""Set [`HybridSystem`](@ref) `reactive_power`."""
set_reactive_power!(value::HybridSystem, val) = value.reactive_power = val
"""Set [`HybridSystem`](@ref) `rating`."""
set_rating!(value::HybridSystem, val) = value.rating = val
"""set [`HybridSystem`](@ref) pcc impedance"""
set_pcc_impedance(value::HybridSystem, val) = value.pcc_impedance = val
"""Set [`HybridSystem`](@ref) `input_active_power_limits`."""
set_input_active_power_limits!(value::HybridSystem, val) = value.input_active_power_limits = val
"""Set [`HybridSystem`](@ref) `output_active_power_limits`."""
set_output_active_power_limits!(value::HybridSystem, val) = value.output_active_power_limits = val
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
InfrastructureSystems.set_forecasts!(value::HybridSystem, val) = value.forecasts = val
