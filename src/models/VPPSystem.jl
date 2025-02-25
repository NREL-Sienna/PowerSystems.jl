# Define VPPSystems struct

mutable struct VPPSystem <: StaticInjectionSubsystem
    name::String
    available::Bool
    status::Bool
    bus::ACBus
    active_power::Float64
    reactive_power::Float64
    base_power::Float64
    operation_cost::MarketBidCost
    storage::Union{Nothing, Storage}
    renewable_unit::Union{Nothing, RenewableGen}
    flexible_load::Union{Nothing, FlexiblePowerLoad}
    services::Vector{Service}
    ext::Dict{String, Any}
    internal::InfrastructureSystemsInternal
end

# Define VPPSystems function that outputs the VPPSystems struct

function VPPSystem(;
    name = "init",
    available = false,
    status = false,
    bus = ACBus(nothing),
    active_power = 0.0,
    reactive_power = 0.0,
    base_power = 100.0,
    operation_cost = MarketBidCost(nothing),
    storage = nothing,
    renewable_unit = nothing,
    flexible_load = nothing,
    services = Service[],
    ext = Dict{String, Any}(),
    internal = IS.InfrastructureSystemsInternal(),
)
    return VPPSystem(
        name,
        available,
        status,
        bus,
        active_power,
        reactive_power,
        base_power,
        operation_cost,
        storage,
        renewable_unit,
        flexible_load,
        services,
        ext,
        internal,
    )
end

# Constructor for demo purposes; non-functional.
function VPPSystem(::Nothing)
    return VPPSystem(;
        name = "init",
        available = false,
        status = false,
        bus = ACBus(nothing),
        active_power = 0.0,
        reactive_power = 0.0,
        base_power = 100.0,
        operation_cost = MarketBidCost(nothing),
        storage = EnergyReservoirStorage(nothing),
        renewable_unit = RenewableDispatch(nothing),
        flexible_load = FlexiblePowerLoad(nothing),
        services = Service[],
        ext = Dict{String, Any}(),
        internal = IS.InfrastructureSystemsInternal(),
    )
end

# Getter functions for VPPSystem struct

get_name(value::VPPSystem) = value.name

function _get_components(value::VPPSystem)
    components =
        [value.storage, value.renewable_unit, value.flexible_load]
    filter!(x -> !isnothing(x), components)
    return components
end

function set_units_setting!(value::VPPSystem, settings::IS.SystemUnitsSettings)
    set_units_info!(get_internal(value), settings)
    for component in _get_components(value)
        set_units_info!(get_internal(component), settings)
    end
    return
end

"""Get [`VPPSystem`](@ref) `available`."""
get_available(value::VPPSystem) = value.available

"""Get [`VPPSystem`](@ref) `status`."""
get_status(value::VPPSystem) = value.status

"""Get [`VPPSystem`](@ref) `bus`."""
get_bus(value::VPPSystem) = value.bus

"""Get [`VPPSystem`](@ref) `active_power`."""
get_active_power(value::VPPSystem) = get_value(value, value.active_power)

"""Get [`VPPSystem`](@ref) `reactive_power`."""
get_reactive_power(value::VPPSystem) = get_value(value, value.reactive_power)

"""Get [`VPPSystem`](@ref) `base_power`."""
get_base_power(value::VPPSystem) = value.base_power

"""Get [`VPPSystem`](@ref) `operation_cost`."""
get_operation_cost(value::VPPSystem) = value.operation_cost

"""Get [`VPPSystem`](@ref) storage unit"""
get_storage(value::VPPSystem) = value.storage

"""Get [`VPPSystem`](@ref) renewable unit"""
get_renewable_unit(value::VPPSystem) = value.renewable_unit

"""Get [`VPPSystem`](@ref) flexible load"""
get_flexible_load(value::VPPSystem) = value.flexible_load

"""Get [`VPPSystem`](@ref) `services`."""
get_services(value::VPPSystem) = value.services

"""Get [`VPPSystem`](@ref) `ext`."""
get_ext(value::VPPSystem) = value.ext

"""Get [`VPPSystem`](@ref) `internal`."""
get_internal(value::VPPSystem) = value.internal

# Setter functions for VPPSystem struct

"""Set [`VPPSystem`](@ref) `name`."""
set_name(value::VPPSystem) = value.name

"""Set [`VPPSystem`](@ref) `available`."""
set_available(value::VPPSystem) = value.available

"""Set [`VPPSystem`](@ref) `status`."""
set_status(value::VPPSystem) = value.status

"""Set [`VPPSystem`](@ref) `bus`."""
set_bus(value::VPPSystem) = value.bus

"""Set [`VPPSystem`](@ref) `active_power`."""
set_active_power(value::VPPSystem) = set_value(value, value.active_power)

"""Set [`VPPSystem`](@ref) `reactive_power`."""
set_reactive_power(value::VPPSystem) = set_value(value, value.reactive_power)

"""Set [`VPPSystem`](@ref) `base_power`."""
set_base_power(value::VPPSystem) = value.base_power

"""Set [`VPPSystem`](@ref) `operation_cost`."""
set_operation_cost(value::VPPSystem) = value.operation_cost

"""Set [`VPPSystem`](@ref) storage unit"""
set_storage(value::VPPSystem) = value.storage

"""Set [`VPPSystem`](@ref) renewable unit"""
set_renewable_unit(value::VPPSystem) = value.renewable_unit

"""Set [`VPPSystem`](@ref) flexible load"""
set_flexible_load(value::VPPSystem) = value.flexible_load

"""Set [`VPPSystem`](@ref) `services`."""
set_services(value::VPPSystem) = value.services

"""Set [`VPPSystem`](@ref) `ext`."""
set_ext(value::VPPSystem) = value.ext

"""Set [`VPPSystem`](@ref) `internal`."""
set_internal(value::VPPSystem) = value.internal

function get_subcomponents(vpp::VPPSystem)
    Channel() do channel
        for field in (:storage, :renewable_unit, :flexible_load)
            subcomponent = getfield(vpp, field)
            if subcomponent !== nothing
                put!(channel, subcomponent)
            end
        end
    end
end

"""Set [`VPPSystem`](@ref) storage unit"""
function set_storage!(vpp::VPPSystem, val::Storage)
    _raise_if_attached_to_system(vpp)
    value.storage = val
    return
end

"""Set [`VPPSystem`](@ref) renewable unit"""
function set_renewable_unit!(vpp::VPPSystem, val::RenewableGen)
    _raise_if_attached_to_system(vpp)
    value.renewable_unit = val
    return
end

"""Set [`VPPSystem`](@ref) flexible load"""
function set_flexible_load!(vpp::VPPSystem, val::FlexiblePowerLoad)
    _raise_if_attached_to_system(vpp)
    value.flexible_load = val
    return
end

function _raise_if_attached_to_system(vpp::VPPSystem)
    if !isnothing(IS.get_time_series_manager(vpp))
        throw(
            ArgumentError(
                "Operation not allowed because the VPPSystem is attached to a system",
            ),
        )
    end
    return
end
